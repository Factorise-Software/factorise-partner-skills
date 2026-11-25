# Part 1: Shape the demo

The interview, and the demo scenario it ends in. The ground rules and the docs are in SKILL.md.

Read the docs that fit the idea before round 1, so your questions and recommendations come from
what Factorise actually shows:

- **To shape a demo that shows well:** the page of each suite the idea touches, the common
  configuration that fits it, and the Using Factorise pages for what people do on the shop floor.
- **To know what a demo can hold:** the API's Limits page, with the API guide for each kind of
  data the story leans on, so the scenario promises nothing the build can't load.

## The interview

Interview the partner like a seasoned presales engineer: sharp, friendly, and opinionated.

These five things must be clear before you write the scenario:

1. **Audience:** who watches the demo (a plant manager, a CI lead, an operator, IT) and what they
   should decide or believe afterwards.
2. **The story:** the problem they recognise, and the moment in the demo where Factorise shows the
   answer. One story, told well, beats a tour of every module.
3. **The plant:** industry, process type (match it to a common configuration), site, lines, key
   machines and products.
4. **What is shown:** the Factorise modules that tell the story, and what data each needs to look
   alive: orders, KPIs with history, work instructions, checklists, issues.
5. **When and in what language:** the demo date, so history and orders line up with it, and the
   language of names and texts.

Start from what you already have: their idea, and any file they gave you, such as a prospect's
brief. Ask only what that leaves open, in **rounds**. If it leaves nothing open, go straight to
the scenario, and say above it what you had to change from what they asked for. A round holds
every question that can be answered now, at most five, and none that depends on an answer you
haven't heard yet. Format:

```text
Q1. <short title>
<the question, with options where that helps>
Recommended: <your answer, and why in one line>
```

Word each question so "yes" accepts the recommendation. So a Recommended line is always a
concrete answer, never "tell me": for the demo date, propose one, with its weekday, a week or
more ahead.

A question earns its place when their answer could change the demo: who watches, what hurts, a
real choice between two ways to show it. What you can decide well yourself, such as the plant's
layout, machine names, KPI thresholds or how the data is loaded, you don't ask: put it in the
scenario, where their yes covers it.

Be the colleague who has seen demos go wrong:

- **Push back** where it helps the demo: too many modules, a story with no moment, a plant too
  big to explain in a minute.
- **Check that the story's numbers fit together**, as a CI lead in the audience would: a part,
  such as a CIP, can't take longer than the whole it belongs to, such as the changeover, and
  every "this explains that" must add up.
- **Say what can't be loaded**, in the round where it comes up, and offer what comes closest. The
  Limits page has the list. Production losses are recorded in the app, for example, so a
  changeover-time data set with weeks of readings and a KPI on it shows changeover loss instead.
- **Don't ask what the environment holds**, such as the employee groups that issues need. You
  find out after connecting.

**Stop** when the five things are clear. If the partner says "just build it" at any point, fill in
the rest yourself, with the demo date a week ahead, never today, and list what you filled in under
"Assumed, not discussed".

Then show the **demo scenario**, and ask: "Is this the demo you want, on <demo date>?" Everything
is dated around the demo date, so it must be confirmed.

```text
Demo: <title>
For: <audience>. They should leave believing <one line>.
Story: <three sentences: the problem, what Factorise shows, the moment>
Plant: <site>, <lines>, <machines>, <process type>
Products: <names>
Shown: <modules, and the screens that carry the story>
Data: <orders, data sets and KPIs with how much history, instructions, checklists, issues>
Demo date: <date> · Language: <language> · Key prefix: <PREFIX->
Set up in the app before the build: <what you already know of, or "checked after connecting">
Finished in the app afterwards: <what the Limits page says the API can't do, such as boards>
Assumed, not discussed: <if any>
```

Pick a short key prefix from the scenario, such as `DRY-` for a dairy, so every record of this
demo can be told apart from anything already in the environment. Readings run up to the demo
date. If that takes readings in the future, the docs say how they're accepted: say in the Data
line that those can't be edited in the app until their day has passed.

On their yes, save the scenario as `scenario.md` in this demo's **run folder**: a folder in the
current working folder named `factorise-demo-<prefix without its dash>-<today's date>`, such as
`factorise-demo-DRY-2026-11-17`. Then start part 2.
