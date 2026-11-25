# Send

How records get into the environment once the partner has said yes to a plan: the request files,
sending and reading each answer, and when you stop. Then the three things that start from
records already there: changing them, sending a run again, and removing orders you sent. The
ground rules, the docs and "How to call the API" are in SKILL.md. What the plan holds and which
yes it needs is in the file that sent you here: build.md in make-demo, plan.md in
configure-environment. One plan is one run, with one run folder.

## The request files

Write each request to a file in the run folder, numbered in sending order, such as
`01-factory-hierarchy.json`. Make long files, such as weeks of readings or hundreds of rows from
a list, with a short script in what the computer certainly has: the shell on a Mac, PowerShell
on Windows. Don't count on Python or Node being there. Keep each file within the sizes on the
Limits page, and split a longer list over files.

Values from the partner's data go into a request file as data only. A script reads them from
the partner's file and writes them as JSON text, with quotes and other special characters
escaped. Never put a value from their data into a command line. Afterwards, check that the
file holds as many records as the source, and that names with accents came through.

Follow the Tutorial's load order, and its path for everything orders run on. Within that order:

- send what can't be changed afterwards as late as what depends on it allows. A refusal earlier
  on then leaves nothing behind that's hard to put right;
- send checklists that name process tasks before the orders, so new orders pick them up;
- an issue is dated when it's sent, so word it about something before today.

**Records the whole environment shares.** "Shared environments" on the Access and environments
page lists what every user of an environment shares by name, such as units and item statuses.

- What you reuse, you only refer to. Never change it, or a setting the whole environment
  shares, such as which item status is the default, unless the partner asks, and say then that
  every record that uses it sees the change. Make a new one only when nothing fits, with a free
  value where it must be unique, such as a unit symbol or a priority rank.
- If this account can't read a list you'd reuse from, ask the partner what's there before you
  send a record of that kind: sending a name that exists changes that record.

**On Windows, in PowerShell:** write a file with
`[IO.File]::WriteAllText(<path>, <json>, (New-Object Text.UTF8Encoding $false))`, never with
`Out-File` or `Set-Content`, which add a mark at the start that Factorise refuses. Give
`ConvertTo-Json` a `-Depth` of 10, read with `-Encoding UTF8`, and build paths from
`$PSScriptRoot`. Have a script that makes readings print each day's values, and check them
against the plan.

Before you send, check that every link points to a record in an earlier file or already in the
environment, and that each file is valid JSON. A link that needs a `uid` Factorise only gives
in an answer, such as a checklist's instruction set, can't be complete yet: leave it open,
say so in the plan, and write the `uid` in from the earlier file's answer just before you send
that file.

If the partner wants to look before they say yes, write the files and tell them in plain words
what each holds. Nothing is sent.

## Send, and read each answer

Send the files in order, one at a time. After each call:

- add a line to `SEND-LOG.md` in the run folder: the time, the host, the file, where it went,
  the answer's code, the counts, and any errors word for word. That's what Factorise needs if something goes
  wrong;
- where a record has no key of its own, such as a checklist or a work instruction, write the
  `uid` its answer gives into its row in the request file, as the docs advise. A later change or
  resend then finds the same record. Records with a key are found by their key.

What an answer means, whether anything was written, and whether sending again is safe, is in the
Errors page and under "Retries" in How REST writes work. Go by those. On top of that:

- **Saved:** note how many records were created, updated and unchanged, and go on. If a record
  shows as updated that the plan didn't mean to change, stop and tell the partner before the
  next group. A new product's own BOM, which Factorise creates empty with it, is meant to change.
- **Refused for a mistake in the file:** fix it and send the file again, once. If the fix
  changes a value, a key or which records are sent, show the partner first. If it's something
  only the partner knows, ask them in plain words, naming the record.
- **No answer at all**, such as a timeout: send the same file once more, as "Retries" allows.
  If that gets no answer either, stop, and say plainly that you don't know whether this group
  was saved, and how to check it in the app.
- **An answer that names a setup step** a docs page describes too, such as synchronising Model
  Reflection: give the partner the steps from that page, wait for "done", and send the file once
  more.
- **A part of Factorise this account can't use** (403 or 404 for one group, or 401 while other
  reads still answer): nothing from that group was saved. Ask whether to go on without it, and
  offer steps to make those records by hand in the app.
- **401 on everything:** the login stopped working. Run the connect command again.

Stop at the first group that still fails after one fix, unless the partner chose to go on
without it. Later groups depend on it.

## When you stop

Say what is already in the environment and what isn't, and, when Factorise answered with a
refusal, that nothing from the failed group was saved. If you show Factorise's error, put it in a quote block introduced as "Factorise answered:",
then say in your own words what it means. Suggest they send the run folder to their contact at
Factorise: its send log holds the answer, with the `logId` Factorise asks for when there is one.

## Change records that are there

Such as a line to rename, a BOM to fix, or new KPI thresholds. A change needs a plan and a yes
before you send, like any run. Ask only what the change needs. Change only the records the
partner names. If their words can fit more than one record, such as "the first line" or "the
oven", name the record you take it to be at the top of the plan, by name, code and site, and
list the others in one line. When they only ask to see what would change, show it and don't
ask to send.

- Start from the record as it is now. "The whole record" in How REST writes work says why: a row
  replaces the record, and a field you leave out is cleared. Read the record back, and keep
  every field the partner doesn't change exactly as it is, with every list it holds in full,
  such as a BOM's lines or a checklist's questions: never a part of a list. Send only the list
  that holds the record, not the empty lists that came with it. On their yes, read the record
  once more if the plan is more than a few minutes old, and save it in the run folder as
  `before-<name of the request file>`, so the old values are on record. If this account can't read it, or
  it's a kind that isn't read back whole, such as readings, take its file from the run folder
  that made it, and ask whether it was changed in the app since. If neither works, ask the
  partner for all its current values, and say in bold that any field they don't give will be
  cleared.
- For a new name or key, the docs say when a row renames the record and when it makes a new one
  next to the old. Say in the plan which will happen, and that an old record that stays is
  removed by hand in the app.
- If the Limits page says a change is done in the app, don't refuse it. Say in one line that it
  may not work through the API, give the steps for the app if the pack has them, and ask "Do
  you want me to try this change?" Go on with their answer: Factorise's answer shows whether
  it worked.
- Show the change per record: each field old → new, and what else uses the record, such as the
  products or orders that refer to a changed unit or BOM.

## Send a run again

Only to the environment that run's `SEND-LOG.md` names. For any other environment, the same
data is a new plan. Say first that a resend puts every record back the way that run had it, so
changes made in the app since are lost, and that orders are left out. A run that changed
records applies the same changes again. Read back what the run's files touch, show what the
resend would change now, and ask for a yes, as for any send. If Factorise now refuses the old
files for names it no longer knows, it was upgraded since: build the files again from the docs
as they are now, with the same keys and uids.

**Going on with a run that stopped** is the same, for the files its log doesn't show as saved:
confirm the environment with the partner, read back what those files touch, and show anything
that changed since the plan before you ask.

## Remove orders you sent

This is the only removing you do, and only for orders a run of yours made: its request files
list them, and its `SEND-LOG.md` names this environment and shows them as created. If several
run folders hold such orders, ask which they mean. List the orders, and send, the way the Send
production orders guide describes, only after their yes to exactly that list. Say what that
guide says it does to an order, and that it can't be reversed. Any other order, and anything
else they want removed, is done in the app: say so, and give the steps if the pack has them.
