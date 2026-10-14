#!/usr/bin/env fish
# team/replies-save.fish
# Fetches the full reply log once via ./replies (one crossing), then reformats it
# per run — same style as error-log.txt — and writes the result to log.txt.

set here (dirname (status --current-filename))
set tmp (mktemp)

$here/replies > $tmp
or begin
    echo "replies-save.fish: ./replies failed" >&2
    rm -f $tmp
    exit 1
end

set last (grep -oE '^=== run [0-9]+' $tmp | awk '{print $3}' | tail -n 1)
if test -z "$last"
    echo "replies-save.fish: no replies in log" >&2
    rm -f $tmp
    exit 1
end

for i in (seq 1 $last)
    echo "== $i "(string repeat -n 64 =)
    awk -v n=$i '/^=== run [0-9]+ /{p=($3==n); next} p' $tmp | sed 's/^/  /'
    echo ""
end > $here/log.txt

rm -f $tmp
