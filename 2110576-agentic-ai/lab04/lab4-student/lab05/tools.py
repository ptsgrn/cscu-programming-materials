"""tool.py: the team's program. Runs on the server, where the workbooks are.

The agent calls it as   ./wall <command> [arguments]   and receives exactly what this file prints to
standard output. Standard error stays on the server (the Operator reads it with team/errors).

------------------------------------------------------------------------------------------------
THE CONFIDENTIALITY CONTRACT
------------------------------------------------------------------------------------------------
Everything this file prints is built from exactly three kinds of thing:

  1. literal text written in this file,
  2. integers and scores computed by aggregating over rows,
  3. values from a closed vocabulary defined in this file (centre codes, medal classes, roles).

No cell of a workbook is ever copied to standard output. Contestant identity is read, hashed with a
salt that is new on every run, and dropped; the hash is used only to decide whether two rows are the
same person, and only counts of hashes are printed.

Four independent layers stand between a workbook and the reply:

  L1  Column policy is DEFAULT DENY. A column is used for output only if this file recognised it as
      a centre, a medal or a score column. Every other text column -- including every column whose
      role this file could not work out -- is classified as identifying and is never read into any
      value that can reach standard output.
  L2  Closed vocabulary. A centre becomes one of seventeen ASCII codes or it becomes UNPLACED. A
      medal becomes one of a fixed set of classes or it becomes unclassified. The raw label is
      replaced by an opaque token (<label#3 script=thai chars=22>) that carries no text.
  L3  The local model is used only as a classifier. It is never shown an identity column, and its
      words are never printed: its reply is accepted only if it is one of the enum values this file
      offered it, and otherwise it is discarded.
  L4  The output guard. Immediately before printing, the assembled reply is checked. It must be
      printable ASCII, and it must not contain any contestant identity string, or any token of one,
      from any of the twelve workbooks. If the check fails the tool prints a refusal and exits
      non-zero; the reason goes to standard error for the Operator.

Run  ./wall help  for the commands.
"""
import glob
import hashlib
import os
import re
import secrets
import sys
import unicodedata
from collections import Counter, defaultdict

import pandas as pd

import inside

# ================================================================================================
# 0. text helpers
# ================================================================================================

THAI = re.compile(r"[฀-๿]")
SAFE_ASCII = re.compile(r"^[A-Za-z0-9 _.,:;=()\[\]/#+%'\"-]*$")


def nfc(value):
    return unicodedata.normalize("NFC", str(value))


def norm(value):
    """Lower-cased, whitespace-collapsed form, for comparing labels."""
    return re.sub(r"\s+", " ", nfc(value).strip().lower())


def squash(value):
    """Lower-cased with every space and punctuation mark removed, for matching labels."""
    return re.sub(r"[^0-9a-z฀-๿]+", "", norm(value))


def ascii_fold(text):
    """Every run of non-ASCII replaced by a token saying only how long it was.

    For the one place a sentence this file did not write reaches the reply: the local model's answer
    to 'ask'. The model answers about a Thai spreadsheet and often answers in Thai, and a reply that
    is thrown away whole teaches nobody anything. Folding keeps the English and drops the rest,
    which is the part that could carry a name.
    """
    folded = re.sub(r"[^\x20-\x7e\n]+", lambda m: f"<non-ascii:{len(m.group(0))}>", nfc(text))
    return re.sub(r"\n{3,}", "\n\n", folded).strip()


def script_of(value):
    text = nfc(value)
    if THAI.search(text):
        return "thai"
    if re.search(r"[A-Za-z]", text):
        return "latin"
    return "other"


def is_blank(value):
    return value is None or (isinstance(value, float) and pd.isna(value)) or nfc(value).strip() == ""


def as_number(value):
    if is_blank(value):
        return None
    try:
        number = float(nfc(value).replace(",", ""))
    except ValueError:
        return None
    return None if pd.isna(number) else number


def show_number(number):
    if number is None:
        return "undetermined"
    return str(int(number)) if float(number).is_integer() else f"{number:g}"


# ------------------------------------------------------------------------------------------------
# L2: opaque tokens. A label this file could not place is reported as a token, never as its text.
# ------------------------------------------------------------------------------------------------

_TOKENS = {}


def token(value, kind="label"):
    text = nfc(value)
    if text not in _TOKENS:
        _TOKENS[text] = f"<{kind}#{len(_TOKENS) + 1} script={script_of(text)} chars={len(text)}>"
    return _TOKENS[text]


def ascii_or_token(value, kind="label", limit=40):
    """Short, plainly safe ASCII passes through; anything else becomes a token.

    Used for sheet names and header names only -- the two places where text from a workbook is of
    real use to the reader. Everything that passes through here is also checked against the identity
    blocklist first, so a workbook whose header is somebody's name is masked here rather than
    bringing down the whole reply at the output guard.
    """
    text = nfc(value).strip()
    if not text:
        return "(none)"
    if len(text) <= limit and SAFE_ASCII.match(text) and not touches_identity(text):
        return text
    return token(text, kind)


# ================================================================================================
# 1. closed vocabulary: centres
# ================================================================================================
# Each entry: canonical code, exact short codes (as they appear inside a username), distinctive
# substrings. The list is ordered by specificity: PSUPN is tried before PSU because the Pattani
# label contains the Songkla label, KMITL/KMUTNB/KMUTT before anything that matches their shared
# words, SUT before SU.

CENTRES = [
    ("PSUPN", ["psupn", "ptn", "pn", "pnn", "psup"], ["ปัตตานี", "pattani"]),
    ("PSU", ["psu", "psuhy", "hy"], ["สงขลานครินทร์", "หาดใหญ่", "songkla", "hatyai", "hat yai"]),
    ("KMITL", ["kmitl", "kmit", "ldk", "lkb", "itl"], ["ลาดกระบัง", "เจ้าคุณทหาร", "ladkrabang"]),
    ("KMUTNB", ["kmutnb", "knb", "kmutn"], ["พระนครเหนือ", "north bangkok", "northbangkok"]),
    ("KMUTT", ["kmutt", "ktt", "ktb"], ["ธนบุรี", "thonburi"]),
    ("MWIT", ["mwit", "mwt", "mw"], ["มหิดลวิทย", "mahidol wit", "mahidolwit", "wittayanusorn"]),
    ("SSW", ["ssw", "ss", "ssa", "ssb", "ssc", "ss1", "ss2", "ss3", "sw"], ["สามเสน", "samsen"]),
    ("SUT", ["sut"], ["สุรนารี", "suranaree"]),
    ("BUU", ["buu", "bu"], ["บูรพา", "burapha"]),
    ("CMU", ["cmu", "cm"], ["เชียงใหม่", "chiang mai", "chiangmai"]),
    ("KKU", ["kku", "kk"], ["ขอนแก่น", "khon kaen", "khonkaen"]),
    ("KU", ["ku", "kus", "ksu"], ["เกษตร", "kasetsart"]),
    ("NU", ["nu", "nuu"], ["นเรศวร", "naresuan"]),
    ("SU", ["su", "suu"], ["ศิลปากร", "silpakorn"]),
    ("TU", ["tu", "tuu", "tus"], ["ธรรมศาสตร์", "thammasat"]),
    ("UBU", ["ubu", "ub"], ["อุบล", "ubon"]),
    ("WU", ["wu", "wuu"], ["วลัยลักษณ์", "walailak"]),
]

# The full names, for the model prompts only. A code such as "brp" is unguessable from the letters
# BUU alone but obvious beside "Burapha University".
CENTRE_NAMES = {
    "BUU": "Burapha University (มหาวิทยาลัยบูรพา)",
    "CMU": "Chiang Mai University (มหาวิทยาลัยเชียงใหม่)",
    "KKU": "Khon Kaen University (มหาวิทยาลัยขอนแก่น)",
    "KMITL": "King Mongkut's Institute of Technology Ladkrabang (สถาบันเทคโนโลยีพระจอมเกล้าเจ้าคุณทหารลาดกระบัง)",
    "KMUTNB": "King Mongkut's University of Technology North Bangkok (มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ)",
    "KMUTT": "King Mongkut's University of Technology Thonburi (มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าธนบุรี)",
    "KU": "Kasetsart University (มหาวิทยาลัยเกษตรศาสตร์)",
    "MWIT": "Mahidol Wittayanusorn School (โรงเรียนมหิดลวิทยานุสรณ์)",
    "NU": "Naresuan University (มหาวิทยาลัยนเรศวร)",
    "PSU": "Prince of Songkla University, Hat Yai (มหาวิทยาลัยสงขลานครินทร์ หาดใหญ่)",
    "PSUPN": "Prince of Songkla University, Pattani (มหาวิทยาลัยสงขลานครินทร์ วิทยาเขตปัตตานี)",
    "SSW": "Samsen Wittayalai School (โรงเรียนสามเสนวิทยาลัย), all sub-centres",
    "SU": "Silpakorn University (มหาวิทยาลัยศิลปากร)",
    "SUT": "Suranaree University of Technology (มหาวิทยาลัยเทคโนโลยีสุรนารี)",
    "TU": "Thammasat University (มหาวิทยาลัยธรรมศาสตร์)",
    "UBU": "Ubon Ratchathani University (มหาวิทยาลัยอุบลราชธานี)",
    "WU": "Walailak University (มหาวิทยาลัยวลัยลักษณ์)",
}

CENTRE_CODES = [code for code, _, _ in CENTRES]
CENTRE_ORDER = sorted(CENTRE_CODES)
_BY_SHORT = {short: code for code, shorts, _ in CENTRES for short in shorts}


def centre_from_label(label):
    """A centre label -> one of the seventeen codes, or None."""
    if is_blank(label):
        return None
    flat = squash(label)
    if not flat:
        return None
    if flat.upper() in CENTRE_CODES:
        return flat.upper()
    if flat in _BY_SHORT:
        return _BY_SHORT[flat]
    for code, _, marks in CENTRES:
        for mark in marks:
            if squash(mark) and squash(mark) in flat:
                return code
    return None


_LEARNED_CODES = {}


def username_stem(username):
    """The letters in a username, with the contestant's number taken off.

    MWIT07 -> mwit, c1kku -> kku. What is left is a centre abbreviation, which names an
    organisation and not a person; it is never printed, only looked up.
    """
    if is_blank(username):
        return None
    flat = squash(username)
    # The c1kku form is tried first: a pattern that allows letters after the digits would match it
    # too and come away with the leading "c", which names no centre at all.
    for pattern in (r"^c?\d+([a-z]+)$", r"^([a-z]+)\d+$", r"^([a-z]+)\d+[a-z]+$"):
        match = re.match(pattern, flat)
        if match:
            return match.group(1)
    return flat if flat.isalpha() and 2 <= len(flat) <= 8 else None


def centre_from_username(username):
    """The centre encoded in a username: MWIT07, c1kku, KKU-03 all name their centre."""
    if is_blank(username):
        return None
    stem = username_stem(username)
    if not stem:
        return None
    if stem in _BY_SHORT:
        return _BY_SHORT[stem]
    if stem.upper() in CENTRE_CODES:
        return stem.upper()
    return _LEARNED_CODES.get(stem)


# ================================================================================================
# 2. closed vocabulary: medals
# ================================================================================================

GOLD, SILVER, BRONZE = "gold", "silver", "bronze"
STRICT = (GOLD, SILVER, BRONZE)
EQUIV = {GOLD: "equivalent_gold", SILVER: "equivalent_silver", BRONZE: "equivalent_bronze"}
NONE = "not_a_medal"
MEDAL_CLASSES = list(STRICT) + list(EQUIV.values()) + [NONE]

_EQUIV_MARKS = ["เทียบเท่า", "equivalent", "equiv"]
# bronze first: the Thai word for bronze contains the Thai word for gold.
_MEDAL_MARKS = [
    (BRONZE, ["ทองแดง", "bronze"]),
    (GOLD, ["ทอง", "gold"]),
    (SILVER, ["เงิน", "silver"]),
]
_NOT_A_MEDAL = [
    "ขาดสอบ",          # absent
    "สสวท",                      # IPST student (competes, is not awarded)
    "ไม่ได้",          # did not get
    "ไม่มี",                # none
    "absent", "none", "nomedal", "no", "nil", "-", "x", "na", "n/a",
    # A summary block is headed by its own total; that word is a row label, not a medal.
    "total", "sum", "all", "รวม", "ทั้งหมด",
]


def medal_from_label(label):
    """A medal label -> one of MEDAL_CLASSES, or None if this file does not recognise it."""
    if is_blank(label):
        return NONE
    flat = squash(label)
    if not flat:
        return NONE
    for mark in _NOT_A_MEDAL:
        if squash(mark) and flat == squash(mark):
            return NONE
    equivalent = any(squash(mark) in flat for mark in _EQUIV_MARKS)
    for medal, marks in _MEDAL_MARKS:
        if any(squash(mark) in flat for mark in marks):
            return EQUIV[medal] if equivalent else medal
    for mark in _NOT_A_MEDAL:
        if squash(mark) and squash(mark) in flat:
            return NONE
    return None


# ================================================================================================
# 3. header vocabulary and the default-deny column policy
# ================================================================================================

H_USERNAME = {"username", "usernames", "userid", "loginname", "login", "account", "รหัส",
              "รหัสผู้เข้าแข่งขัน", "contestantid", "handle"}
H_NAME = {"user", "name", "fullname", "firstname", "lastname", "surname", "contestant", "student",
          "ชื่อ", "ชื่อนามสกุล", "ชื่อสกุล",
          "นามสกุล", "ชื่อนักเรียน"}
H_CENTRE = {"team", "centre", "center", "school", "university", "group", "ศูนย์", "ศูนย์สอวน",
            "ชื่อศูนย์", "ชื่อศูนย์สอวน", "สังกัด",
            "โรงเรียน", "มหาวิทยาลัย"}
H_MEDAL = {"medal", "medals", "award", "awards", "result", "เหรียญ", "รางวัล",
           "เหรียญรางวัล", "ผล", "ประเภทเหรียญ"}
H_SCORE = [
    {"total", "grandtotal", "totalscore", "รวม", "คะแนนรวม", "รวมคะแนน", "ผลรวม"},
    {"sum"},
    {"score", "คะแนน", "points", "point"},
]
H_COUNT = {"count", "จำนวน", "จำนวนที่ได้เหรียญ", "number", "amount"}
H_MIN = {"minimum", "min", "cutoff", "ต่ำสุด", "คะแนนต่ำสุด"}
H_TARGET = {"เป้า", "target", "quota", "โควตา"}

USERNAME_SHAPE = re.compile(r"^[A-Za-z][A-Za-z0-9_.\-]{1,15}$")

ROLE_USERNAME = "username"
ROLE_CENTRE = "centre"
ROLE_MEDAL = "medal"
ROLE_SCORE = "score"
ROLE_NUMBER = "number"
ROLE_EMPTY = "empty"
ROLE_IDENTIFYING = "identifying"   # names, and every text column whose role is not established


def _in(header, vocab):
    flat = squash(header)
    return bool(flat) and flat in {squash(word) for word in vocab}


def _has(header, vocab):
    """A vocabulary word appears inside the header. Short words are not matched this way: 'min'
    would otherwise find itself inside 'minimum', and worse, inside words that mean nothing like it.
    """
    flat = squash(header)
    return bool(flat) and any(len(squash(word)) >= 3 and squash(word) in flat for word in vocab)


def classify_column(header, series):
    """The role of one column. Default deny: anything unresolved is 'identifying'."""
    values = [v for v in series if not is_blank(v)]
    if not values:
        return ROLE_EMPTY, 0.0                      # nothing in the column, so nothing to protect
    numbers = [as_number(v) for v in values]
    numeric_share = sum(1 for n in numbers if n is not None) / len(values)
    # "จำนวนที่ได้เหรียญ" (how many got a medal) and "เป้าจำนวนเหรียญ" (the medal target) both
    # contain the word for medal but hold counts, not labels; a tally column is not a label column.
    tally = _has(header, H_COUNT) or _has(header, H_TARGET) or numeric_share >= 0.5

    if _in(header, H_NAME):
        return ROLE_IDENTIFYING, 1.0
    if _in(header, H_USERNAME):
        return ROLE_USERNAME, 1.0
    if not tally and (_in(header, H_CENTRE) or _has(header, H_CENTRE)):
        return ROLE_CENTRE, 1.0
    if not tally and (_in(header, H_MEDAL) or _has(header, H_MEDAL)):
        return ROLE_MEDAL, 1.0
    for rank, group in enumerate(H_SCORE):
        if _in(header, group) and numeric_share >= 0.8 and not _has(header, H_TARGET):
            return ROLE_SCORE, 1.0 - rank * 0.1

    if numeric_share >= 0.9:
        return ROLE_NUMBER, numeric_share

    # No usable header. Fall back to the values, but only towards the two closed vocabularies.
    distinct = len({norm(v) for v in values})
    if distinct <= 30:
        # Half is enough. A centre column carries spellings this file has never seen, and demanding
        # that most of them be recognised throws away the whole column over the few that are not --
        # which then shows up as fifty medals nobody can place.
        placed = sum(1 for v in values if centre_from_label(v))
        if placed / len(values) >= 0.5:
            return ROLE_CENTRE, placed / len(values)
    if distinct <= 14:
        # A real medal column is mostly "no medal": in a field of ninety-five, fifty rows say
        # nothing at all and a dash or a blank is the commonest entry. Asking for a majority of
        # medals would reject the column that matters and accept the three-cell summary block
        # beside it. Ask instead that every value be a word about medals, and that a few be medals.
        classes = [medal_from_label(v) for v in values]
        strict = sum(1 for c in classes if c in STRICT)
        known = sum(1 for c in classes if c is not None)
        if strict >= 3 and known / len(values) >= 0.85:
            return ROLE_MEDAL, 0.5 + 0.4 * strict / len(values)
    if distinct >= 0.9 * len(values) and all(USERNAME_SHAPE.match(nfc(v).strip() or " ") for v in values):
        if sum(1 for v in values if centre_from_username(v)) / len(values) >= 0.7:
            return ROLE_USERNAME, 0.8

    return ROLE_IDENTIFYING, 0.0


# ================================================================================================
# 4. reading a workbook
# ================================================================================================

SALT = secrets.token_bytes(32)          # new on every run; hashes cannot be compared between runs
_HONORIFICS = ["นาย", "นางสาว", "นาง", "เด็กชาย",
               "เด็กหญิง", "ด.ช.", "ด.ญ.", "น.ส.",
               "mr.", "mr", "ms.", "ms", "miss", "mrs.", "mrs", "master"]


def identity_key(value):
    """A salted hash of one contestant identity string. The string itself is dropped here."""
    if is_blank(value):
        return None
    text = norm(value)
    for _ in range(2):
        for honorific in _HONORIFICS:
            if text.startswith(honorific):
                text = text[len(honorific):].strip()
                break
    flat = squash(text)
    if not flat:
        return None
    return hashlib.sha256(SALT + flat.encode("utf-8")).hexdigest()


def _header_row(raw):
    best, best_score = 0, -1.0
    vocab = set()
    for group in (H_USERNAME, H_NAME, H_CENTRE, H_MEDAL, H_COUNT, H_MIN, *H_SCORE):
        vocab |= group
    for row in range(min(8, len(raw))):
        cells = [nfc(v).strip() for v in raw.iloc[row] if not is_blank(v)]
        if not cells:
            continue
        score = 0.0
        for cell in cells:
            if as_number(cell) is not None:
                score -= 1.0
            elif _in(cell, vocab):
                score += 3.0
            elif len(cell) <= 24:
                score += 0.5
        if score > best_score:
            best, best_score = row, score
    return best


class Sheet:
    def __init__(self, label, index, raw, header_row):
        self.label = label
        self.index = index
        self.raw = raw
        self.header_row = header_row
        headers = [nfc(v).strip() if not is_blank(v) else "" for v in raw.iloc[header_row]]
        body = raw.iloc[header_row + 1:].reset_index(drop=True)
        self.headers = headers
        self.body = body
        self.roles = []
        for position in range(len(headers)):
            role, confidence = classify_column(headers[position], list(body.iloc[:, position]))
            self.roles.append((role, confidence))

    def filled(self, position):
        return sum(1 for value in self.body.iloc[:, position] if not is_blank(value))

    def medal_cells(self, position):
        return sum(1 for value in self.body.iloc[:, position]
                   if not is_blank(value) and medal_from_label(value) in STRICT)

    def centre_cells(self, position):
        return sum(1 for value in self.body.iloc[:, position]
                   if not is_blank(value) and centre_from_label(value))

    def pick(self, role):
        """The best column for a role.

        For medals and centres, the best column is the one that actually holds the most of them,
        not the most confidently typed one. The tie-break matters: a workbook often carries a small
        summary block -- three cells reading gold, silver, bronze -- off to one side, and that block
        must never be mistaken for the medal column. Forty medals beat three every time.
        """
        candidates = [position for position, (found, _) in enumerate(self.roles) if found == role]
        if not candidates:
            return None
        if role == ROLE_MEDAL:
            return max(candidates, key=lambda p: (self.medal_cells(p), self.roles[p][1]))
        if role == ROLE_CENTRE:
            return max(candidates, key=lambda p: (self.centre_cells(p), self.roles[p][1], self.filled(p)))
        return max(candidates, key=lambda position: (self.roles[position][1], self.filled(position)))

    def pick_score(self):
        candidates = [(confidence, position) for position, (role, confidence) in enumerate(self.roles) if role == ROLE_SCORE]
        if not candidates:
            # No header said "total". Take the numeric column with the largest values: in these
            # workbooks the grand total is always the largest of the per-problem columns.
            numeric = [position for position, (role, _) in enumerate(self.roles) if role == ROLE_NUMBER]
            if not numeric:
                return None
            def peak(position):
                values = [as_number(v) for v in self.body.iloc[:, position]]
                values = [v for v in values if v is not None]
                return max(values) if values else -1
            return max(numeric, key=peak)
        top = max(c for c, _ in candidates)
        tied = [position for confidence, position in candidates if confidence == top]
        def peak(position):
            values = [as_number(v) for v in self.body.iloc[:, position]]
            values = [v for v in values if v is not None]
            return max(values) if values else -1
        return max(tied, key=peak)

    def identity_column(self):
        for position, header in enumerate(self.headers):
            if _in(header, H_NAME):
                return position
        for position, (role, _) in enumerate(self.roles):
            if role == ROLE_IDENTIFYING:
                return position
        return None

    def quality(self):
        rows = len(self.body)
        has_identity = self.identity_column() is not None or self.pick(ROLE_USERNAME) is not None
        return (4 * has_identity + 5 * (self.pick(ROLE_MEDAL) is not None)
                + 2 * (self.pick_score() is not None) + min(rows, 500) / 1000.0)


class Row:
    __slots__ = ("key", "centre", "centre_label", "medal", "medal_label", "score", "stem")


class Book:
    """One workbook, read down to the few facts the report needs."""

    def __init__(self, filename):
        self.file = os.path.basename(filename)
        match = re.search(r"(\d+)", self.file)
        self.year = int(match.group(1)) if match else None
        self.ok = False
        self.problem = None
        self.sheet = None
        self.rows = []
        self.unclassified_medals = Counter()
        self.unplaced_centres = Counter()
        self.identity_seen = 0
        self.identity_missing = 0
        self.declared = {}
        self.declared_rejected = None
        self.summary_block = None
        try:
            self._read()
        except FileNotFoundError:
            self.problem = "the workbook is not on the server"
        except Exception as error:                                  # noqa: BLE001
            print(f"[tool] {self.file}: {type(error).__name__}: {error}", file=sys.stderr)
            self.problem = f"the workbook could not be read ({type(error).__name__})"

    # -- reading ---------------------------------------------------------------------------------

    def _read(self):
        raws = pd.read_excel(inside.path(self.file), sheet_name=None, header=None)
        sheets = []
        for index, (label, raw) in enumerate(raws.items()):
            if raw.empty:
                continue
            sheets.append(Sheet(label, index, raw, _header_row(raw)))
        if not sheets:
            self.problem = "the workbook has no sheet with rows in it"
            return
        self.all_sheets = sheets
        self.sheet = max(sheets, key=lambda s: s.quality())

        sheet = self.sheet
        self.column_username = sheet.pick(ROLE_USERNAME)
        self.column_centre = sheet.pick(ROLE_CENTRE)
        self.column_medal = sheet.pick(ROLE_MEDAL)
        self.column_score = sheet.pick_score()
        self.column_identity = sheet.identity_column()

        # A medal column says something about most of the field. A column holding three cells that
        # read gold, silver, bronze is the workbook's own summary block standing in the margin, and
        # reading it as a medal column would award three medals in the year and call it a day.
        self.summary_block = None
        if self.column_medal is not None and sheet.medal_cells(self.column_medal) < 8:
            self.summary_block = self.column_medal
            self.column_medal = None

        anchor = self.column_identity if self.column_identity is not None else self.column_username
        if anchor is None:
            self.problem = "no sheet in the workbook has one row per contestant"
            return

        for _, raw_row in sheet.body.iterrows():
            if is_blank(raw_row.iloc[anchor]):
                continue
            row = Row()
            identity = raw_row.iloc[self.column_identity] if self.column_identity is not None else None
            row.key = identity_key(identity)
            del identity                                   # the identity string ends its life here
            if row.key:
                self.identity_seen += 1
            else:
                self.identity_missing += 1

            row.centre = row.centre_label = None
            if self.column_centre is not None and not is_blank(raw_row.iloc[self.column_centre]):
                label = raw_row.iloc[self.column_centre]
                row.centre = centre_from_label(label)
                if row.centre is None:
                    row.centre_label = token(label, "centre-label")
                    self.unplaced_centres[row.centre_label] += 1
            row.stem = None
            if self.column_username is not None:
                row.stem = username_stem(raw_row.iloc[self.column_username])
            if row.centre is None:
                row.centre = centre_from_username(raw_row.iloc[self.column_username]) \
                    if self.column_username is not None else None

            row.medal, row.medal_label = NONE, None
            if self.column_medal is not None:
                label = raw_row.iloc[self.column_medal]
                found = medal_from_label(label)
                if found is None:
                    row.medal_label = token(label, "medal-label")
                    self.unclassified_medals[row.medal_label] += 1
                else:
                    row.medal = found

            row.score = as_number(raw_row.iloc[self.column_score]) if self.column_score is not None else None
            self.rows.append(row)

        if not self.rows:
            self.problem = "the sheet has headers but no contestant rows"
            return
        self._read_declared()
        self._check_declared()
        self._derive_medals()
        self.ok = True

    def _read_declared(self):
        """The workbook's own summary block, if it has one. Reported as 'declared', never merged
        with the computed numbers: it is what the workbook says, not what this file counted.

        Only columns already recognised as columns of medal labels are scanned. A name column must
        not be scanned: Thai given names contain the syllable that spells 'gold', so a loose scan
        would read a contestant's row and let a personal score reach the reply as a 'cutoff'.
        """
        raw = self.sheet.raw
        for column in range(raw.shape[1]):
            if column == self.column_medal or column >= len(self.sheet.roles):
                continue
            if self.sheet.roles[column][0] != ROLE_MEDAL:
                continue
            hits = []
            for row in range(len(raw)):
                value = raw.iat[row, column]
                if is_blank(value) or as_number(value) is not None:
                    continue
                found = medal_from_label(value)
                if found in STRICT:
                    hits.append((row, found))
            if not 2 <= len(hits) <= 8:
                continue
            for row, medal in hits:
                numbers = []
                for offset in range(1, 9):
                    if column + offset >= raw.shape[1]:
                        break
                    number = as_number(raw.iat[row, column + offset])
                    if number is not None:
                        numbers.append((column + offset, number))
                if not numbers:
                    continue
                entry = self.declared.setdefault(medal, {})
                entry.setdefault("numbers", numbers)
                entry.setdefault("from_column", column)
                labelled = False
                for position, number in numbers:
                    label = self._column_label(raw, position)
                    if label is None or _has(label, H_TARGET):
                        continue
                    if _in(label, H_COUNT) or _has(label, H_COUNT):
                        entry.setdefault("count", int(number))
                        labelled = True
                    elif _in(label, H_MIN) or _has(label, H_MIN):
                        entry.setdefault("cutoff", number)
                        labelled = True
                if labelled:
                    continue
                # Nothing labelled the columns. A count of medals in a field of a hundred is a small
                # number; a cutoff on a paper marked out of several hundred is not. Anything in
                # between is left alone rather than guessed at.
                small = [n for _, n in numbers if n == int(n) and 0 < n < 60]
                large = [n for _, n in numbers if n >= 100]
                if small:
                    entry.setdefault("count", int(small[0]))
                if large:
                    entry.setdefault("cutoff", large[0])

    def _check_declared(self):
        """Is the declared block a medal tally at all?

        A workbook keeps other little tables beside the results, and a scan that reaches for the
        first small integer will happily read one of them. Three counts that together account for
        seven of ninety-nine contestants are not the medal tally of a competition that awards half
        the field. When the profile is not plausible the numbers are still reported, but as raw
        cells with no claim about what they mean.
        """
        counts = [self.declared.get(medal, {}).get("count") for medal in STRICT]
        if any(count is None for count in counts):
            return
        share = sum(counts) / max(len(self.rows), 1)
        if not 0.10 <= share <= 0.75:
            for medal in STRICT:
                self.declared[medal].pop("count", None)
            self.declared_rejected = f"{sum(counts)} medals in {len(self.rows)} contestants"

    def derive_from_cutoffs(self):
        """Medal counts worked out by applying the declared cutoffs to the score column.

        For the years whose workbook never wrote down who won what, but did write down the score
        each medal started at. Gold is every score at or above the gold cutoff; silver is from the
        silver cutoff up to gold; bronze from the bronze cutoff up to silver. It is arithmetic over
        the rows, so it is a count this tool made, not a number it was handed -- but it stands on
        the workbook's cutoffs being right, which is a thing the tool cannot check.
        """
        if self.column_score is None:
            return None
        cutoffs = {medal: self.declared.get(medal, {}).get("cutoff") for medal in STRICT}
        if not all(cutoffs.values()):
            return None
        if not cutoffs[BRONZE] < cutoffs[SILVER] < cutoffs[GOLD]:
            return None
        scores = [row.score for row in self.rows if row.score is not None]
        derived = {
            GOLD: sum(1 for s in scores if s >= cutoffs[GOLD]),
            SILVER: sum(1 for s in scores if cutoffs[SILVER] <= s < cutoffs[GOLD]),
            BRONZE: sum(1 for s in scores if cutoffs[BRONZE] <= s < cutoffs[SILVER]),
        }
        return derived, cutoffs, len(scores)

    def _derive_medals(self):
        """Give each row a medal worked out from the scores, when the workbook never wrote one down.

        Without this a year with no medal column drops out of questions b and c entirely, even when
        the workbook says plainly what each medal started at. With it, that year is counted like any
        other and every command says the medals were derived, so the reader can discount them.
        """
        self.derived_by = None
        if self.column_medal is not None or self.column_score is None:
            return
        cutoffs = None
        result = self.derive_from_cutoffs()
        if result is not None:
            cutoffs, self.derived_by = result[1], "the cutoffs the workbook declares"
        else:
            result = self.derive_from_counts()
            if result is not None:
                cutoffs, self.derived_by = result[1], "the Nth highest score for each count the workbook declares"
        if not cutoffs:
            return
        for row in self.rows:
            if row.score is None:
                continue
            if row.score >= cutoffs[GOLD]:
                row.medal = GOLD
            elif row.score >= cutoffs[SILVER]:
                row.medal = SILVER
            elif row.score >= cutoffs[BRONZE]:
                row.medal = BRONZE

    def derive_from_counts(self):
        """Cutoffs worked out by applying the declared counts to the score column.

        The mirror of derive_from_cutoffs, for the years whose workbook wrote down how many medals
        it gave but not the score each started at. If eight golds were awarded, the gold cutoff is
        the eighth highest score. Ties on a boundary are reported, because a tie means the workbook
        cannot have awarded exactly that many medals at exactly that score.
        """
        if self.column_score is None:
            return None
        counts = {medal: self.declared.get(medal, {}).get("count") for medal in STRICT}
        if not all(counts.values()):
            return None
        scores = sorted((row.score for row in self.rows if row.score is not None), reverse=True)
        if len(scores) < sum(counts.values()):
            return None
        cutoffs, ties, at = {}, {}, 0
        for medal in (GOLD, SILVER, BRONZE):
            at += counts[medal]
            cutoffs[medal] = scores[at - 1]
            ties[medal] = sum(1 for s in scores if s == scores[at - 1])
        return counts, cutoffs, ties, len(scores)

    @staticmethod
    def _column_label(raw, column):
        for row in range(min(4, len(raw))):
            value = raw.iat[row, column]
            if not is_blank(value) and as_number(value) is None:
                return nfc(value)
        return None

    # -- the facts the report needs --------------------------------------------------------------

    def medal_rows(self, medal):
        return [row for row in self.rows if row.medal == medal]

    def counts(self):
        return {medal: len(self.medal_rows(medal)) for medal in MEDAL_CLASSES}

    def cutoff(self, medal):
        scores = [row.score for row in self.medal_rows(medal) if row.score is not None]
        return min(scores) if scores else None

    def centre_tally(self):
        tally = defaultdict(Counter)
        for row in self.rows:
            if row.medal in STRICT:
                tally[row.centre or "UNPLACED"][row.medal] += 1
        return tally

    def medallist_keys(self, include_equivalent=False):
        allowed = set(STRICT) | (set(EQUIV.values()) if include_equivalent else set())
        return {row.key for row in self.rows if row.medal in allowed and row.key}

    def centre_of_key(self):
        return {row.key: row.centre for row in self.rows if row.key and row.medal in STRICT}


_BOOKS = {}


def book(filename):
    name = os.path.basename(filename)
    if name not in _BOOKS:
        _BOOKS[name] = Book(name)
    return _BOOKS[name]


def workbook_names():
    directory = os.environ.get("DATA_DIR", ".")
    found = sorted(os.path.basename(p) for p in glob.glob(os.path.join(directory, "*.xlsx")))
    return [name for name in found if not name.startswith("~$")]


def all_books():
    return [book(name) for name in workbook_names()]


# ================================================================================================
# 5. L3: the local model as a classifier, never as a voice
# ================================================================================================

def model_assist(kind, labels):
    """Ask the local model to put labels this file could not place into a closed enum.

    Only the distinct labels go to the model -- never a row, never an identity column. Only an enum
    value comes back: anything else the model says is thrown away. Returns {label: enum value}.
    """
    labels = [label for label in labels if nfc(label).strip()]
    if not labels or os.environ.get("MODEL_ASSIST", "1") == "0":
        return {}
    if not os.environ.get("QWEN_BASE_URL") or not os.environ.get("QWEN_API_KEY"):
        return {}
    if kind == "medal":
        enum = MEDAL_CLASSES
        what = ("Each line below is a label from the 'medal' column of a Thai programming-olympiad "
                "results spreadsheet. Say which class each label belongs to.")
    elif kind == "centre_code":
        enum = CENTRE_CODES + ["unknown"]
        what = ("Each line below is a short code used in contestant usernames at the Thai "
                "programming olympiad (TOI). Each code abbreviates the regional centre (POSN/สอวน.) "
                "that entered the contestant: a university or a school. Say which centre each is. "
                "Answer unknown rather than guess.")
    else:
        enum = CENTRE_CODES + ["unknown"]
        what = ("Each line below is the name of a regional centre of the Thai olympiad (POSN/สอวน.). "
                "Give the centre's standard abbreviation.")
    if kind != "medal":
        what += "\n\nThe centres and their abbreviations are:\n" + "\n".join(
            f"  {code} = {CENTRE_NAMES[code]}" for code in CENTRE_ORDER)
    numbered = "\n".join(f"{index + 1}. {nfc(label).strip()}" for index, label in enumerate(labels[:40]))
    try:
        reply = inside.ask_model(
            "You are a strict classifier. You answer only with lines of the form N=VALUE. "
            "VALUE must be copied exactly from the allowed list. Never explain.",
            f"{what}\n\nAllowed values: {', '.join(enum)}\n\nLabels:\n{numbered}\n\n"
            f"Answer with one line per label, exactly '<number>=<value>'.",
            max_tokens=900, temperature=0.0,
            chat_template_kwargs={"enable_thinking": False},
        )
    except Exception as error:                                       # noqa: BLE001
        print(f"[tool] model assist failed: {type(error).__name__}: {error}", file=sys.stderr)
        return {}
    allowed = {value.lower(): value for value in enum}
    placed = {}
    for line in reply.splitlines():
        match = re.match(r"\s*(\d+)\s*=\s*([A-Za-z_]+)\s*$", line)
        if not match:
            continue                                     # the model's own words are discarded here
        index, value = int(match.group(1)) - 1, match.group(2).lower()
        if 0 <= index < len(labels) and value in allowed and value != "unknown":
            placed[labels[index]] = allowed[value]
    return placed


# ================================================================================================
# 6. L4: the output guard
# ================================================================================================

_LINES = []


def out(line=""):
    _LINES.append(str(line))


def _name_like(text):
    """Does this value have the shape of a person's name? Two or more words, or one long word."""
    stripped = nfc(text).strip()
    return len(stripped) >= 8 or len(stripped.split()) >= 2


def _is_identity_column(sheet, position):
    """Is this column the one that holds who the contestant is?

    Wider than 'the header said so', because a workbook may not say so, and narrower than 'the role
    is identifying', because a stray summary cell such as 'Count' is given that role too and must
    not end up on the blocklist -- a blocklist full of ordinary English words would refuse every
    reply the tool makes.
    """
    if sheet.roles[position][0] != ROLE_IDENTIFYING:
        return False
    if _in(sheet.headers[position], H_NAME):
        return True
    values = [v for v in sheet.body.iloc[:, position] if not is_blank(v) and as_number(v) is None]
    if len(values) < 5:
        return False
    distinct = len({norm(v) for v in values})
    return distinct / len(values) >= 0.8 and sum(1 for v in values if _name_like(v)) / len(values) >= 0.6


_OWN_WORDS = None


def own_words():
    """Every word this file itself can write.

    The blocklist is built from the workbooks, and a workbook is full of ordinary words: a column
    headed 'Count', a name whose first syllable is spelled like an English word. Left alone, those
    land on the blocklist and the guard then refuses every honest reply the tool makes, which is a
    guard that protects nothing because it is switched off within the hour. A word this file already
    writes for its own reasons is not evidence that a workbook leaked, so it is exempt -- and the
    exemption maintains itself, because it is read from this file's own source.
    """
    global _OWN_WORDS
    if _OWN_WORDS is None:
        try:
            with open(os.path.abspath(__file__), encoding="utf-8") as handle:
                source = handle.read()
        except OSError:
            source = ""
        _OWN_WORDS = set(re.findall(r"[a-z]{2,}", source.lower()))
    return _OWN_WORDS


_BLOCKLIST = None


def blocklist():
    global _BLOCKLIST
    if _BLOCKLIST is None:
        _BLOCKLIST = _build_blocklist()
    return _BLOCKLIST


def touches_identity(text):
    """Does this piece of text contain an identity string, or a word of one?"""
    haystack = norm(text)
    if not haystack:
        return False
    words, _ = blocklist()
    for word in words:
        if " " in word or len(word) >= 8:
            if word in haystack:                        # a whole name, wherever it is embedded
                return True
        elif re.search(r"(?<![0-9a-z฀-๿])" + re.escape(word)
                       + r"(?![0-9a-z฀-๿])", haystack):
            return True                                 # a word of a name, standing on its own
    return False


def _build_blocklist():
    """Every contestant identity string in every workbook, and every word of one.

    Built from all twelve workbooks, not only the ones this command used, so the guard is the same
    whichever command ran. A workbook that will not open is reported in the reply, not ignored.
    """
    words, unreadable = set(), []
    for name in workbook_names():
        try:
            sheets = pd.read_excel(inside.path(name), sheet_name=None, header=None)
        except Exception:                                            # noqa: BLE001
            unreadable.append(name)
            continue
        for raw in sheets.values():
            if raw.empty:
                continue
            sheet = Sheet("", 0, raw, _header_row(raw))
            for position in range(len(sheet.roles)):
                if not _is_identity_column(sheet, position):
                    continue
                for value in sheet.body.iloc[:, position]:
                    if is_blank(value) or as_number(value) is not None or not _name_like(value):
                        continue
                    text = norm(value)
                    words.add(text)
                    for part in re.split(r"[\s.,;:/\\()\[\]-]+", text):
                        if len(part) >= 3 and part not in _HONORIFICS and part not in own_words():
                            words.add(part)
    return words, unreadable


def guard(text):
    """The last check before anything is printed. Returns a reason to refuse, or None."""
    for index, character in enumerate(text):
        if character == "\n":
            continue
        if not 32 <= ord(character) <= 126:
            return f"a character outside printable ASCII at position {index} (U+{ord(character):04X})"
    if touches_identity(text):
        return "a contestant identity string appears in the reply"
    unreadable = blocklist()[1]
    return None if not unreadable else f"__unreadable__{len(unreadable)}"


def flush():
    text = "\n".join(_LINES)
    reason = guard(text)
    if reason and reason.startswith("__unreadable__"):
        text += f"\nguard: {reason.split('__unreadable__')[1]} workbook(s) would not open, so the " \
                "identity blocklist is incomplete for this reply; see 'audit' for which"
        reason = guard(text.replace("guard:", "guard;"))
        if reason and reason.startswith("__unreadable__"):
            reason = None
    if reason:
        print(f"[tool] REFUSED: {reason}", file=sys.stderr)
        print(f"[tool] withheld reply:\n{text}", file=sys.stderr)
        print("REFUSED: the tool blocked its own reply because it did not pass the confidentiality")
        print("guard. Nothing was printed. The Operator can read the reason with team/errors.")
        sys.exit(4)
    print(text)


# ================================================================================================
# 7. commands
# ================================================================================================

def _year(book_):
    return f"TOI {book_.year}" if book_.year is not None else ascii_or_token(book_.file, "file")


def _resolve_unknown_labels(books):
    """One model call for the medal labels, one for the centre labels, for the whole run."""
    medal_labels = {}
    centre_labels = {}
    for current in books:
        if not current.ok:
            continue
        sheet = current.sheet
        if current.column_medal is not None:
            for value in sheet.body.iloc[:, current.column_medal]:
                if not is_blank(value) and medal_from_label(value) is None:
                    medal_labels[nfc(value).strip()] = token(value, "medal-label")
        if current.column_centre is not None:
            for value in sheet.body.iloc[:, current.column_centre]:
                if not is_blank(value) and centre_from_label(value) is None:
                    centre_labels[nfc(value).strip()] = token(value, "centre-label")
    stems = set()
    for current in books:
        if current.ok:
            stems |= {row.stem for row in current.rows if row.centre is None and row.stem}
    stems -= set(_LEARNED_CODES)

    placed_medals = model_assist("medal", list(medal_labels)) if medal_labels else {}
    placed_centres = model_assist("centre", list(centre_labels)) if centre_labels else {}
    placed_stems = model_assist("centre_code", sorted(stems)) if stems else {}
    _LEARNED_CODES.update(placed_stems)

    notes = []
    for current in books:
        if not current.ok:
            continue
        for row in current.rows:
            if row.medal_label:
                for label, tok in medal_labels.items():
                    if tok == row.medal_label and label in placed_medals:
                        row.medal = placed_medals[label]
                        row.medal_label = None
                        break
            if row.centre is None and row.stem in _LEARNED_CODES:
                row.centre = _LEARNED_CODES[row.stem]
            if row.centre is None and row.centre_label:
                for label, tok in centre_labels.items():
                    if tok == row.centre_label and label in placed_centres:
                        row.centre = placed_centres[label]
                        row.centre_label = None
                        break
        current.unclassified_medals = Counter(row.medal_label for row in current.rows if row.medal_label)
        current.unplaced_centres = Counter(
            row.centre_label for row in current.rows if row.centre is None and row.centre_label)
    for label, value in placed_medals.items():
        notes.append(f"model_placed medal {medal_labels[label]} -> {value}")
    for label, value in placed_centres.items():
        notes.append(f"model_placed centre {centre_labels[label]} -> {value}")
    for stem, value in sorted(placed_stems.items()):
        notes.append(f"model_placed username_code {token(stem, 'code')} -> {value}")
    return notes


# -- question a ----------------------------------------------------------------------------------

def _medal_lines(book_):
    lines = []
    counts = book_.counts()
    for medal in STRICT:
        cutoff = book_.cutoff(medal)
        missing = sum(1 for row in book_.medal_rows(medal) if row.score is None)
        line = f"  {medal}: count={counts[medal]} cutoff={show_number(cutoff)}"
        if missing:
            line += f" (scores missing for {missing} of them)"
        if 0 < counts[medal] <= 2:
            line += "  [the cutoff of a group this small is one contestant's own score]"
        lines.append(line)
    equivalents = {name: counts[name] for name in EQUIV.values() if counts[name]}
    if equivalents:
        lines.append("  equivalent: " + " ".join(f"{k}={v}" for k, v in sorted(equivalents.items()))
                     + "  [labelled 'equivalent to', excluded from the counts above]")
    if book_.unclassified_medals:
        lines.append("  unclassified_labels: " + " ".join(
            f"{label} x{n}" for label, n in book_.unclassified_medals.most_common()))
    if book_.declared:
        parts = []
        for medal in STRICT:
            entry = book_.declared.get(medal, {})
            if entry:
                parts.append(f"{medal}(count={entry.get('count', '?')},cutoff={show_number(entry.get('cutoff'))})")
        if parts:
            lines.append("  declared_by_the_workbook: " + " ".join(parts)
                         + "  [the workbook's own summary block, not recomputed]")
    return lines


def _cross_check(book_):
    """Do the two derivations agree? They come at the same year from opposite ends."""
    by_cutoff, by_count = book_.derive_from_cutoffs(), book_.derive_from_counts()
    if by_cutoff is None or by_count is None:
        return "only one derivation was possible, so there is nothing to check it against"
    counts_a, counts_b = by_cutoff[0], by_count[0]
    cuts_a, cuts_b = by_cutoff[1], by_count[1]
    off = [m for m in STRICT if counts_a[m] != counts_b[m] or cuts_a[m] != cuts_b[m]]
    if not off:
        return ("cross_check: counting from the declared cutoffs and ranking from the declared "
                "counts give the same answer")
    return "cross_check: the two derivations disagree on " + ", ".join(off)


def cmd_medals(filename=None):
    books = [book(filename)] if filename else all_books()
    notes = _resolve_unknown_labels(books)
    out("question a: medals and cutoffs")
    out("the cutoff is the lowest score that still received that medal, computed over the rows")
    out("")
    for current in sorted(books, key=lambda b: (b.year is None, b.year or 0)):
        out(f"{_year(current)} file={ascii_or_token(current.file, 'file')}")
        if not current.ok:
            out(f"  undetermined: {current.problem}")
            out("")
            continue
        out(f"  sheet={ascii_or_token(current.sheet.label, 'sheet')} (#{current.sheet.index}) "
            f"contestants={len(current.rows)}")
        if current.column_medal is None:
            out("  no column of medal labels in this workbook")
            if not current.derived_by:
                out("  undetermined: no medal labels, no cutoffs, nothing to count")
                out("")
                continue
            out(f"  medals below are derived from {current.derived_by}, applied to the scores")
            for line in _medal_lines(current):
                out(line)
            out("  " + _cross_check(current))
            out("")
            continue
        if current.column_score is None:
            out("  cutoffs undetermined: the workbook has no column of total scores")
        for line in _medal_lines(current):
            out(line)
        out("")
    for note in notes:
        out(note)


# -- question b ----------------------------------------------------------------------------------

def cmd_centres(filename=None):
    books = [book(filename)] if filename else all_books()
    notes = _resolve_unknown_labels(books)
    total = defaultdict(Counter)
    years_used, years_failed = [], []
    for current in books:
        if not current.ok:
            years_failed.append((current, current.problem))
            continue
        if current.column_medal is None and not current.derived_by:
            years_failed.append((current, "the workbook has no column of medal labels and no cutoffs"))
            continue
        years_used.append(current)
        for centre, counter in current.centre_tally().items():
            for medal, count in counter.items():
                total[centre][medal] += count

    out("question b: medals per centre")
    out(f"years_counted={len(years_used)} years_not_counted={len(years_failed)}")
    for current in years_used:
        if current.derived_by:
            out(f"note {_year(current)}: medals derived from {current.derived_by}, "
                "not read from a medal column")
    out("")
    out(f"{'centre':<10}{'gold':<6}{'silver':<8}{'bronze':<8}total")
    grand = Counter()
    for centre in CENTRE_ORDER:
        counter = total.get(centre, Counter())
        row_total = sum(counter[medal] for medal in STRICT)
        grand.update(counter)
        out(f"{centre:<10}{counter[GOLD]:<6}{counter[SILVER]:<8}{counter[BRONZE]:<8}{row_total}")
    unplaced = total.get("UNPLACED", Counter())
    out(f"{'UNPLACED':<10}{unplaced[GOLD]:<6}{unplaced[SILVER]:<8}{unplaced[BRONZE]:<8}"
        f"{sum(unplaced[medal] for medal in STRICT)}")
    out(f"{'ALL':<10}{grand[GOLD] + unplaced[GOLD]:<6}{grand[SILVER] + unplaced[SILVER]:<8}"
        f"{grand[BRONZE] + unplaced[BRONZE]:<8}"
        f"{sum(grand[m] + unplaced[m] for m in STRICT)}")
    out("")
    out("UNPLACED is a medal whose centre this tool could not work out. It belongs in the")
    out("undetermined bucket, not in a centre's row.")
    labels = Counter()
    for current in years_used:
        labels.update(current.unplaced_centres)
    if labels:
        out("unplaced_labels: " + " ".join(f"{label} x{n}" for label, n in labels.most_common()))
    for current, problem in years_failed:
        out(f"not_counted {_year(current)}: {problem}")
    for note in notes:
        out(note)


# -- question c ----------------------------------------------------------------------------------

def cmd_repeats():
    books = all_books()
    _resolve_unknown_labels(books)
    usable = [b for b in books if b.ok and (b.column_medal is not None or b.derived_by)]
    unusable = [(b, b.problem or "the workbook has no column of medal labels and no cutoffs")
                for b in books if b not in usable]

    years = Counter()
    years_equivalent = Counter()
    for current in usable:
        for key in current.medallist_keys():
            years[key] += 1
        for key in current.medallist_keys(include_equivalent=True):
            years_equivalent[key] += 1

    spread = Counter(years.values())
    repeat = sum(1 for count in years.values() if count >= 2)
    repeat_equivalent = sum(1 for count in years_equivalent.values() if count >= 2)

    out("question c: people who medalled in two or more years")
    out("")
    out(f"answer: {repeat}")
    out("")
    out(f"years_counted={len(usable)} of {len(books)}")
    out(f"distinct_medallists={len(years)}")
    for count in sorted(spread):
        out(f"medallists_in_{count}_year{'s' if count > 1 else ''}={spread[count]}")
    out(f"same_count_if_equivalent_medals_are_counted_too={repeat_equivalent}")
    missing = sum(b.identity_missing for b in usable)
    out(f"rows_with_no_contestant_identity={missing}")
    out("")
    out("how two rows are decided to be the same person: the contestant identity string is")
    out("normalised (unicode NFC, honorific prefix removed, all spaces and punctuation removed,")
    out("lower-cased) and then hashed with SHA-256 under a salt that is new for every run. Only")
    out("the hashes are compared, only counts of hashes are printed, and the identity string is")
    out("discarded the moment the hash is taken.")
    out("what this cannot tell: two different people whose normalised identity strings are equal")
    out("are counted as one person, and one person whose identity string is written differently in")
    out("two years is counted as two people. Neither can be checked without reading the names.")
    for current, problem in unusable:
        out(f"not_counted {_year(current)}: {problem}")


# -- reserve question ----------------------------------------------------------------------------

def cmd_consecutive():
    books = all_books()
    _resolve_unknown_labels(books)
    usable = sorted([b for b in books if b.ok and b.year is not None
                     and (b.column_medal is not None or b.derived_by)], key=lambda b: b.year)
    by_year = {b.year: b.medallist_keys() for b in usable}
    centre_by_year = {b.year: b.centre_of_key() for b in usable}

    pairs = Counter()
    students = defaultdict(set)
    gaps = []
    for earlier, later in zip(usable, usable[1:]):
        if later.year - earlier.year != 1:
            gaps.append((earlier.year, later.year))
            continue
        for key in by_year[earlier.year] & by_year[later.year]:
            centre = centre_by_year[earlier.year].get(key) or "UNPLACED"
            pairs[centre] += 1
            students[centre].add(key)

    out("reserve question: the centre whose students most often medal in consecutive years")
    out("a pair is one person who medalled in year Y and again in year Y+1; the pair is credited")
    out("to the centre that person was entered under in year Y")
    out("")
    out(f"{'centre':<10}{'consecutive_pairs':<19}students_involved")
    for centre in CENTRE_ORDER + ["UNPLACED"]:
        out(f"{centre:<10}{pairs[centre]:<19}{len(students[centre])}")
    out("")
    if pairs:
        top = max(pairs.values())
        winners = sorted(centre for centre, count in pairs.items() if count == top and centre != "UNPLACED")
        out(f"answer: {', '.join(winners) if winners else 'undetermined'}"
            + ("  [tied]" if len(winners) > 1 else ""))
    else:
        out("answer: undetermined")
    out(f"consecutive_year_pairs_examined={sum(1 for a, b in zip(usable, usable[1:]) if b.year - a.year == 1)}")
    for earlier, later in gaps:
        out(f"gap: TOI {earlier} and TOI {later} are not consecutive years, so no pair was counted across them")
    out("this answer rests on the same identity matching as question c, with the same limits")


# -- diagnostics ---------------------------------------------------------------------------------

def cmd_shape(filename):
    current = book(filename)
    out(f"file={ascii_or_token(current.file, 'file')}")
    if current.problem and not current.ok:
        out(f"unreadable: {current.problem}")
        if not getattr(current, "all_sheets", None):
            return
    for sheet in getattr(current, "all_sheets", []):
        chosen = " <- the sheet the tool reads" if current.sheet is sheet else ""
        out(f"sheet #{sheet.index} name={ascii_or_token(sheet.label, 'sheet')} "
            f"rows={len(sheet.body)} columns={len(sheet.headers)} header_row={sheet.header_row}{chosen}")
        for position, header in enumerate(sheet.headers):
            role, confidence = sheet.roles[position]
            values = [v for v in sheet.body.iloc[:, position] if not is_blank(v)]
            out(f"  col{position:<3} role={role:<12} conf={confidence:.2f} "
                f"values={len(values):<4} distinct={len({norm(v) for v in values}):<4} "
                f"medal_cells={sheet.medal_cells(position):<4} centre_cells={sheet.centre_cells(position):<4} "
                f"numeric={sum(1 for v in values if as_number(v) is not None):<4} "
                f"header={ascii_or_token(header, 'header')}")
    out("")
    out("role=identifying means the column is treated as personal data and is never read into")
    out("anything this tool prints. Every column whose role the tool could not establish gets that")
    out("role: the policy is default deny.")


def cmd_audit(filename=None):
    books = [book(filename)] if filename else all_books()
    notes = _resolve_unknown_labels(books)
    out("audit: how the tool read each workbook")
    out("")
    for current in sorted(books, key=lambda b: (b.year is None, b.year or 0)):
        out(f"{_year(current)} file={ascii_or_token(current.file, 'file')}")
        if not current.ok:
            out(f"  unreadable: {current.problem}")
            out("")
            continue
        sheet = current.sheet
        out(f"  sheet=#{sheet.index} name={ascii_or_token(sheet.label, 'sheet')} header_row={sheet.header_row}")
        for role, position in (("username", current.column_username), ("centre", current.column_centre),
                               ("medal", current.column_medal), ("score", current.column_score),
                               ("identity", current.column_identity)):
            if position is None:
                out(f"  {role}_column=none")
            else:
                out(f"  {role}_column=col{position} header={ascii_or_token(sheet.headers[position], 'header')}")
        if current.derived_by:
            out(f"  medals_derived_from={current.derived_by}")
        out(f"  contestant_rows={len(current.rows)} with_identity={current.identity_seen} "
            f"without_identity={current.identity_missing}")
        counts = current.counts()
        out("  medal_classes: " + " ".join(f"{name}={counts[name]}" for name in MEDAL_CLASSES))
        scored = sum(1 for row in current.rows if row.score is not None)
        out(f"  rows_with_a_score={scored}")
        placed = Counter(row.centre for row in current.rows if row.centre)
        out(f"  centres_seen={len(placed)} rows_placed={sum(placed.values())} "
            f"rows_unplaced={len(current.rows) - sum(placed.values())}")
        if current.unclassified_medals:
            out("  unclassified_medal_labels: " + " ".join(
                f"{label} x{n}" for label, n in current.unclassified_medals.most_common()))
        unresolved = Counter(row.stem for row in current.rows if row.centre is None and row.stem)
        if unresolved:
            out("  unplaced_username_codes: " + " ".join(
                f"{token(stem, 'code')} x{n}" for stem, n in unresolved.most_common()))
        if current.unplaced_centres:
            out("  unplaced_centre_labels: " + " ".join(
                f"{label} x{n}" for label, n in current.unplaced_centres.most_common()))
        if current.declared_rejected:
            out(f"  declared_block_rejected: {current.declared_rejected} is not a plausible medal tally")
        if current.summary_block is not None:
            out(f"  summary_block=col{current.summary_block} (too few cells to be the medal column)")
        if current.declared:
            for medal, entry in sorted(current.declared.items()):
                numbers = " ".join(f"col{c}={show_number(v)}" for c, v in entry.get("numbers", []))
                out(f"  declared {medal}: count={entry.get('count', '?')} "
                    f"cutoff={show_number(entry.get('cutoff'))} | raw {numbers}")
        out("")
    for note in notes:
        out(note)


def cmd_ask(filename, question):
    """The local model over one workbook, with every identifying column removed first.

    Kept for probing a workbook whose shape the tool did not expect. The model never sees an
    identity column, and its words still have to pass the output guard, so an answer that is not
    plain ASCII is refused rather than printed.
    """
    current = book(filename)
    if not current.ok:
        out(f"unreadable: {current.problem}")
        return
    sheet = current.sheet
    keep = [position for position, (role, _) in enumerate(sheet.roles) if role != ROLE_IDENTIFYING]
    dropped = len(sheet.roles) - len(keep)
    frame = sheet.body.iloc[:, keep].copy()
    frame.columns = [sheet.headers[position] or f"col{position}" for position in keep]
    answer = inside.ask_model(
        "You answer questions about a spreadsheet. Answer in English, in plain ASCII, in at most "
        "eight short lines. Give numbers, never a person's name and never a row's text.",
        f"This is sheet '{sheet.label}' of a results workbook, with the identifying columns already "
        f"removed:\n\n{frame.to_csv(index=False)}\n\nQuestion: {question}",
        max_tokens=600, chat_template_kwargs={"enable_thinking": False},
    )
    out(f"file={ascii_or_token(current.file, 'file')} sheet=#{sheet.index} "
        f"identifying_columns_removed={dropped}")
    out("model_answer_begins")
    out(ascii_fold(answer))
    out("model_answer_ends")
    out("this answer is the local model's words, not a count this tool made. Treat it as a hint to")
    out("check with another command, not as a number for the report.")


def cmd_files():
    names = workbook_names()
    out(f"workbooks={len(names)}")
    for name in names:
        out(ascii_or_token(name, "file"))


def cmd_help():
    out("tool.py -- what it accepts")
    out("")
    out("  help                        this text")
    out("  files                       the workbook names on the server")
    out("  medals [<file>]             question a: gold/silver/bronze counts and cutoffs,")
    out("                              for one workbook or for all twelve")
    out("")
    out("Where a workbook has no medal column but does say what each medal started at, or how")
    out("many of each it gave, the medals are worked out from the scores and every command that")
    out("uses them says so. Where it says neither, the year is undetermined and stays that way.")
    out("A medal whose centre could not be worked out is counted under UNPLACED, never spread")
    out("over the centres and never dropped.")
    out("  centres [<file>]            question b: medals per centre, summed over the workbooks")
    out("  repeats                     question c: how many people medalled in two or more years")
    out("  consecutive                 reserve question: consecutive-year medallists per centre")
    out("  shape <file>                every sheet, every column and the role the tool gave it")
    out("  audit [<file>]              how the tool read the workbooks, with what it could not place")
    out("  ask <file> \"<question>\"     the local model over the workbook, identifying columns")
    out("                              removed first; a hint, not a number for the report")
    out("")
    out("what the tool will never print: a contestant's name, part of one, or a username. Every")
    out("reply is built from this file's own text, from integers and scores computed over rows,")
    out("and from a closed vocabulary of centre codes and medal classes. A label that does not")
    out("fit that vocabulary is printed as an opaque token like <centre-label#2 script=thai")
    out("chars=22>, and the medals behind it are reported as UNPLACED. Before anything is")
    out("printed the whole reply is checked against every identity string in all twelve")
    out("workbooks and against printable ASCII; if it fails, nothing is printed.")
    out("")
    out("centre codes: " + " ".join(CENTRE_ORDER))
    out("medal classes: " + " ".join(MEDAL_CLASSES))


# ================================================================================================
# 8. main
# ================================================================================================

COMMANDS = {
    "help": (0, 0, cmd_help),
    "files": (0, 0, cmd_files),
    "medals": (0, 1, cmd_medals),
    "centres": (0, 1, cmd_centres),
    "repeats": (0, 0, cmd_repeats),
    "consecutive": (0, 0, cmd_consecutive),
    "shape": (1, 1, cmd_shape),
    "audit": (0, 1, cmd_audit),
}


def main(argv):
    if not argv:
        cmd_help()
        flush()
        return
    name, rest = argv[0], argv[1:]
    try:
        if name == "ask":
            if len(rest) < 2:
                out("usage: ask <file> \"<question>\"")
                flush()
                sys.exit(2)
            cmd_ask(rest[0], " ".join(rest[1:]))
        elif name in COMMANDS:
            low, high, function = COMMANDS[name]
            if not low <= len(rest) <= high:
                out(f"usage: {name}" + (" <file>" if high else "") + ("  (file optional)" if low == 0 and high else ""))
                flush()
                sys.exit(2)
            function(*rest)
        else:
            out(f"unknown command. Run 'help' for the list.")
            flush()
            sys.exit(2)
    except FileNotFoundError as error:
        out(f"error: {error}")
        flush()
        sys.exit(1)
    except ValueError as error:
        out(f"error: {error}")
        flush()
        sys.exit(1)
    flush()


if __name__ == "__main__":
    main(sys.argv[1:])
