# Part 3: Plan and build

In order: the plan, what keeps this demo apart from everything else in the environment, and
sending, which the shared send.md describes. What a change to a built demo adds is at the end.
The ground rules, the docs and "How to call the API" are in SKILL.md.

## The plan

**Plan in plain words** before you build anything. Make it realistic for the industry and small
enough to explain in a minute. Unless the scenario says otherwise:

- one site, one or two lines, three to eight machines, two to four products, each made in one to
  three stages. When the story is about changeovers, give each line that changes over at least
  two products or formats;
- five to ten production orders from the demo date onwards, matching the story, such as as many
  product changes as the changeover readings show. Orders aren't started or confirmed through
  the API, so past orders would look missed. Leave orders out if the demo doesn't show production;
- two to four data sets with a KPI or QPI each, and readings that tell the story, from four weeks
  before the demo date. Add a daily trend on each KPI whose history the demo shows: a board tile
  shows only the board's own period, while a trend shows weeks;
- one work instruction and one checklist that fit the story, such as a changeover checklist;
- two or three open issues, if Issue Optimiser is shown.

**Readings carry the story, so give them a shape:** a trend, a bad week, the effect of a fix, a
difference between lines or shifts. Never a flat line, pure noise, or noise as big as the story
itself. Make a fix look real: a few days of ramp-in or one slip back before the new level holds.
Use the time zone of the plant, with the right offset on each date. Make thresholds contiguous,
so every value has a colour.

**Make everything agree:** readings with each other (a part fits inside its whole, at the same
times of day), and with the text of the work instruction and checklist. Before you show the
plan, read each instruction step and checklist question against the readings, and fix whichever
is wrong. A figure in the plan is worked out from the readings, not estimated: the script will
quote it.

**Show the plan** in the app's screen words, not the API's, grouped as plant, products,
processes, orders, measurements, instructions and checklists, issues:

- what will be created, with names and counts;
- what will be changed: per record its name and each field's old → new value, and what else uses
  it, such as the products or orders that refer to a changed unit or BOM;
- what already exists and is reused or left alone;
- what can't be undone through the API. Take it from "Done in the Factorise app" on the Limits
  page and the guide of each group, and name what this build touches;
- what the partner finishes in the app afterwards (part 4).

Ask: "Shall I build this in `<host>`?" One yes covers every group.

## Keep this demo apart

"Shared environments" on the Access and environments page says what gets a prefix and what is
reused: follow it, with this demo's key prefix. On top of that:

- a record matched by its name shows its prefix on screen. On an environment the check found
  empty, use the plain name. Otherwise put the prefix behind the name in brackets, such as
  "Changeover time (DRY)", and say so in the plan. Do the same for any name that already exists
  there, so nothing shows twice;
- never reuse or change a record that carries another demo's prefix: it's that demo's, and may
  be changed or removed with it.

## Build

On their yes, follow send.md: the request files, sending and reading each answer, and when you
stop. When every group is sent, start part 4.

## Change a demo that's there

For a demo they built before, or records they name: "Change records that are there", "Send a
run again" and "Remove orders you sent" in send.md. Each change is its own run: name its run
folder with the demo's prefix and today's date. For a demo, on top of that:

- you may fill in a value the partner leaves open;
- what "The plan" says about readings and about everything agreeing holds for a change too;
- if the change touches what the demo script says or shows, such as a name or a number, give
  the changed steps of the script after the send, and save them in that demo's `scenario.md`.
