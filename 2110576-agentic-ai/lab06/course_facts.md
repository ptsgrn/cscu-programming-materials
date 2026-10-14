# Course facts: Agentic AI for Computer Engineering, first semester 2569

This file is everything the course help bot is allowed to know. If a question is not
answered here, the true answer is "I don't know; ask the teaching team."

## The course

- Agentic AI for Computer Engineering is an elective in the Department of Computer
  Engineering, Chulalongkorn University. The semester has 16 weeks; week 16 is the final exam.
- Each week is one 3-hour session, Wednesday 13:00 to 16:00. Until Lab 7 most sessions were labs;
  after it, the sessions are for the final project.
  Sessions often run past 16:00.
- Arriving more than 15 minutes late results in a score penalty. The size of the penalty
  is not in this file.
- Students work in teams of about four. There are ten teams.
- The course is paperless. Everything is handed in through the LMS, except team sheets,
  which are shared Google Docs.
- The models used in class run on the department's own server (a DGX B200) behind a
  gateway. Two models are available: Qwen (qwen3.5) and Gemma (gemma-4-31b).
- The gateway has two addresses. `https://llm.nattee.net/v1` works from any network, and
  it is the one the Lab 6 starter uses. The university address, `http://161.200.93.57:4000/v1`,
  works only after you connect to the university VPN; the university Wi-Fi alone is not enough.
- Every team has its own gateway key. Never share it outside the team or post it.

## Roles

In most labs each team member has one of these four roles, and roles rotate every week.
Some labs used different role names (Lab 4, the retrieval lab, is one).

- Driver: the only person typing to the AI agent. Writes the prompts, accepts or rejects changes.
- Skeptic: never touches the keyboard. Assumes the output is wrong and looks for where.
  The Skeptic signs off before the team hands in.
- Scribe: keeps the team's record of what was tried, in what order, and what failed.
- Operator: runs the environment: keys, model settings, measuring time and tokens.

## The three rituals

These happen in most labs and are written individually or by the team.

1. Decomposition gate, at the start of the lab: which parts of the task must be plain code, which
   need a model, and where is the line.
2. Prediction ledger, before and after: predict token cost, time, and the first thing
   that will go wrong; afterwards, write what actually happened.
3. Stopping rule, before handing in: "We verified ___ of the output, by ___ method, and
   stopped because ___."

The rituals are marked on how your predictions improve across the term, not on whether
one prediction was right.

## The labs

Lab 7 is the last lab. After it, the sessions are for the final project. Week numbers are
weeks of the semester, so they do not match lab numbers.

| Week | Date (Wednesday) | Session |
|---|---|---|
| 1 | 5 August 2026 | Lab 1: Same Question, Two Tools |
| 2 | 12 August | No class (Mother's Day holiday) |
| 3 | 19 August | A lecture |
| 4 | 26 August | Lab 2: What Is This Thing? |
| 5 | 2 September | Lab 3: Build the Loop |
| 6 | 9 September | Lab 4: Retrieval |
| 7 | 16 September | Lab 5: The Wall |
| 8 | 23 September | No class (midterm exams) |
| 9 | 30 September | No class (graduation ceremony) |
| 10 | 7 October | Lab 6: Ship the Bot |
| 11 | 14 October | Lab 7: The bot gets tools, the last lab |
| 12 to 14 | 21 October, 28 October, 4 November | Final project work |
| 15 | 11 November | Final project presentations |
| 16 | 18 November | Final exam |

## Final project

- Teams build a final project after Lab 7: project work in weeks 12 to 14 (21 October to
  4 November), presentations in week 15 (Wednesday 11 November 2026).
- The project proposal is due in week 13, Wednesday 28 October 2026.
- At least one core part of the project must run on a self-hosted open-weight model
  (for example Qwen or Gemma on the department server).
- Before a project counts as finished, a different team must try to break it.
- Project shapes to choose from: Insight Engine, Build an Agent, Consulting Sprint,
  Systems Benchmark and Deploy, Extend Your Capstone.

## Contact

Ask questions in the course Discord or at the start of a lab. The teaching team is
Nattee (lecturer), a co-lecturer, and the TAs.
