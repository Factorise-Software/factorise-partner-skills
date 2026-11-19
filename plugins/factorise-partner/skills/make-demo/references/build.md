# Part 3: Plan and build

In order: the plan, the request files, sending and reading each answer, and when you stop. A
change to a demo that's already there is at the end. The ground rules, the docs and "How to call
the API" are in SKILL.md.

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

**Show the plan**, grouped as plant, products, processes, orders, measurements, instructions and
checklists, issues:

- what will be created, with names and counts;
- what will be changed: per record its name and each field's old → new value, and what else uses
  it, such as the products or orders that refer to a changed unit or BOM;
- what already exists and is reused or left alone;
- what can't be undone through the API. Take it from "Done in the Factorise app" on the Limits
  page and the guide of each group, and name what this build touches;
- what the partner finishes in the app afterwards (part 4).

Ask: "Shall I build this in `<host>`?" One yes covers every group.

## The request files

Write each request to a file in the run folder, numbered in sending order, such as
`01-factory-hierarchy.json`. Make long files, such as weeks of readings, with a short script in
what the computer certainly has: the shell on a Mac, PowerShell on Windows. Don't count on
Python or Node being there.

Follow the Tutorial's load order, and its path for everything orders run on. Within that order:

- send what can't be changed afterwards as late as what depends on it allows. A refusal earlier
  on then leaves nothing behind that's hard to put right;
- send checklists that name process tasks before the orders, so new orders pick them up;
- an issue is dated when it's sent, so word it about something before the build day.

**Keep this demo apart from everything else in the environment.** "Shared environments" on the
Access and environments page says what gets a prefix and what is reused: follow it, with this
demo's key prefix. On top of that:

- a record matched by its name shows its prefix on screen. On an environment the check found
  empty, use the plain name. Otherwise put the prefix behind the name in brackets, such as
  "Changeover time (DRY)", and say so in the plan. Do the same for any name that already exists
  there, so nothing shows twice;
- never reuse or change a record that carries another demo's prefix: it's that demo's, and may
  be changed or removed with it;
- what you reuse, such as a unit "Minute" or an issue priority, you only refer to. Never change
  it, or a setting the whole environment shares, such as which item status is the default,
  unless the partner asks, and say then that every record that uses it sees the change. Make a
  new one only when nothing fits, with a free value where it must be unique, such as a unit
  symbol or a priority rank;
- if this account can't read a list you'd reuse from, ask the partner what's there before you
  send a record of that kind: sending a name that exists changes that record.

Before you send, check that every link points to a record in an earlier file or already in the
environment, and that each file is valid JSON.

## Send, and read each answer

Send the files in order, one at a time. After each call:

- add a line to `SEND-LOG.md` in the run folder: the file, where it went, the answer's code, the
  counts, and any errors word for word. That's what Factorise needs if something goes wrong;
- where a record has no key of its own, such as a checklist or a work instruction, write the
  `uid` its answer gives into its row in the request file, as the docs advise. A later change or
  resend then finds the same record. Records with a key are found by their key.

What an answer means, whether anything was written, and whether sending again is safe, is in the
Errors page and under "Retries" in How REST writes work. Go by those. For a demo, on top of that:

- **Saved:** note how many records were created, updated and unchanged, and go on. If a record
  shows as updated that the plan didn't mean to change, stop and tell the partner before the
  next group. A new product's own BOM, which Factorise creates empty with it, is meant to change.
- **Refused for a mistake in the file:** fix it and send the file again, once. If it's something
  only the partner knows, ask them in plain words.
- **An answer that names a setup step** a docs page describes too, such as synchronising Model
  Reflection: give the partner the steps from that page, wait for "done", and send the file once
  more.
- **A part of Factorise this account can't use** (403 or 404 for one group, or 401 while other
  reads still answer): nothing from that group was saved. Ask whether to go on without it, and
  offer steps to make those records by hand in the app.
- **401 on everything:** the login stopped working. Run the connect script again.

Stop at the first group that still fails after one fix, unless the partner chose to go on
without it. Later groups depend on it.

When every group is sent, start part 4.

## When you stop

Say what is already in the environment and what isn't, and that nothing from the failed group was
saved. If you show Factorise's error, put it in a quote block introduced as "Factorise answered:",
then say in your own words what it means. Suggest they send the run folder to their contact at
Factorise: its send log holds the answer, with the `logId` Factorise asks for when there is one.

## Change a demo that's there

For a demo they built before, or records they name. Each change is its own run: write its files
in a run folder of its own, named with the demo's prefix and today's date, and ask for a yes
before you send, as for a build.

**Change records**, such as a line to rename, a BOM to fix, or new KPI thresholds. Ask only what
the change needs. Change only the records the partner names; you may fill in a value they leave
open.

- Start from the record as it is now. "The whole record" in How REST writes work says why: a row
  replaces the record, and a field you leave out is cleared. Read the record back. If this
  account can't, or it's a kind that isn't read back whole, such as readings, take its file from
  the run folder that made it, and ask whether it was changed in the app since. If neither works, ask the partner for all its current values, and say in
  bold that any field they don't give will be cleared.
- For a new name or key, the docs say when a row renames the record and when it makes a new one
  next to the old. Say in the plan which will happen, and that an old record that stays is
  removed by hand in the app.
- If the Limits page says a change is done in the app, don't refuse it. Say in one line that it
  may not work through the API, and ask "Do you want me to try this change?" Go on with their
  answer: Factorise's answer shows whether it worked.
- What "The plan" says about readings and about everything agreeing holds for a change too.
  Show the change as in "Show the plan": per record, each field old → new, and what else uses it.
- If the change touches what the demo script says or shows, such as a name or a number, give the
  changed steps of the script after the send, and save them in that demo's `scenario.md`.

**Send a demo again**, to rebuild it. Say first that a resend puts every record back the way
that run had it, so changes made in the app since are lost, and that orders are left out. A run
that changed records applies the same changes again. If Factorise now refuses the old files for
names it no longer knows, it was upgraded since: build the files again from the docs as they are
now, with the same keys and uids.

**Remove a demo's orders.** This is the only removing you do. Take the orders from the request
files of the demo's run folder; if several run folders hold orders, ask which demo they mean.
List the orders, and send, the way the Send production orders guide describes, only after their
yes to exactly that list. Anything else they want removed is done in the app: say so, and give
the steps if the pack has them.
