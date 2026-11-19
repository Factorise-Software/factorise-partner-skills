# Part 4: Hand over

In order: the summary, the finish steps, the demo script. The ground rules and the docs are in
SKILL.md.

## The summary

Tell the partner, in a few lines:

- what is now in the environment, per group, with counts, and which records were changed;
- where to find it in the app: the exact name to search for on each screen the script opens;
- what to finish in the app before the demo (below);
- to log in as the presenter once before the demo day and run the script, and which steps to
  check closely;
- that they can block or delete the `claude-demo` account in Factorise when they're done, or keep
  it for the next demo;
- that they can ask you later to change the demo, or to send it again.

## The finish steps

Short numbered steps for what only the app can do, from the guides for configuring Factorise and
its master data and the Using Factorise pages, each with its site address. Go through the page's
instructions line by line and give a value for every field they mention. Where the pack has no
page with the fields for a step, give the step as far as the docs go and mark it "check in your
rehearsal".

A step may only name a record that this run created or that the partner confirmed exists, and may
only rely on a permission the person doing it already has: put the steps that add someone to a
group before the steps that need that group. Anything that falls due by itself, such as a
maintenance schedule, starts the day after the demo, unless the script shows it due.

Cover what the demo script needs. Typically:

- **Boards and their tiles:** a Trends tile for each KPI whose history the script shows.
- **The story's moment:** a production annotation on its date, such as when a fix started, so
  the presenter can point at it.
- **Nothing half-done on screen** next to the records in the script, such as the status of every
  machine on a line that is shown. The docs say in what state the API leaves a new record: if
  new machines start inactive, add a step to activate each one.
- **Issues:** the API leaves them new, unassigned, and logged by the `claude-demo` account. If
  the script says someone took on an issue, add the step with which that person, in the
  category's attending group, takes on its action. Go by the Executing Actions page for that,
  also where another page describes it differently.
- **The presenter's login:** ask whether they'll present with their own existing login, and have
  them check it has an employee record: an account made in User Management has none. Add that
  employee to the groups that see the boards, and as a manager of the group that handles the
  issues in the script, which the Issues Dashboard needs. Create a launchpad with a tile for
  every screen the script opens, select it on one of those groups, and if the presenter has
  other launchpads, make this one their preferred launchpad. The Launchpad configuration page
  has the steps.

## The demo script

Five to eight steps that walk the audience through the story, each with the screen to open, what
to click or show, and the one sentence to say. Put the moment from the scenario where it lands
hardest. Base the screens on the suite pages and the Using Factorise pages, and on the records
you created. Everything the script says must match what the screen shows on the demo date:

- each step rests on a docs page that says the screen shows it. Where no page says so, such as
  colours on a trend, mark the step "check in your rehearsal" and give a fallback;
- describe what the screen plots: a daily trend shows each day's value, not the month's average;
- check each number against the readings and thresholds;
- never say an operator did something the API did.

Save the script in `scenario.md` in the run folder too.
