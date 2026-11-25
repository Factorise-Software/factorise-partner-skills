# Factorise for partners

Claude skills for Factorise partners:

- **make-demo**: describe a demo in a sentence, and Claude helps you shape it and then builds it
  in your own Factorise environment.

  > "Make a demo: a dairy plant with two filling lines that struggles with changeover losses."

- **configure-environment**: hand Claude a customer's data, or name a change, and Claude sets it
  up in the environment you name.

  > "Load this product list into acme.factorise-suite.com."

## What make-demo does

1. **Gets the docs.** The first time, Claude asks whether it may download the Factorise docs to
   read. On your yes, your browser opens and downloads them. Sign in with your Microsoft account
   for the Factorise docs if it asks.
2. **Shapes your idea.** Claude asks a few short rounds of questions: who watches the demo, what
   story it tells, what the plant looks like. It asks only what your idea leaves open, and every
   question comes with a recommended answer, so you can say "yes" and move on, or "just build it"
   at any time.
3. **Connects to your environment.** You make a Factorise account just for Claude and type its
   password into a pop-up window on your computer, not into the chat.
4. **Builds the demo** after you've seen the plan and said yes: plant, lines, machines, products,
   production orders, KPIs with weeks of history, a work instruction, a checklist and issues.
5. **Hands over** what's there, the few things to finish in the app, and a step-by-step demo
   script.

You don't have to finish in one go. Once you've said yes to the scenario, Claude saves it, and
"continue with my demo" in a new session picks it up from there.

Later, ask Claude to change a demo you built, such as "rename line 2" or "make the bad week
worse". It shows each change, old and new, before it sends anything.

## What configure-environment does

For a real environment, a customer's or your own: a first load of the plant and its products, a
list to import, or a change to what's there, such as "rename line 2" or "new thresholds for OEE".

1. **Connects to the environment you name**, the same way as make-demo: an account just for
   Claude, and a pop-up window for its password. It tells you what it sees there and asks you
   to type the address back, so a test environment and a live one are never mixed up. Later,
   it offers the environments you connected to before.
2. **Shows a plan.** Claude lays your list (pasted, or a CSV file) next to what the environment
   already holds: what is new, what is there already, and what would change, with old and new
   values. It uses only your data and never makes up a name, a code or a quantity.
3. **Sends it after your yes.** In a live environment it asks again before each next group of
   records.
4. **Wraps up** with what's there now and what's left to do in the app.

**An environment with its own API extensions.** Some customers have extensions built for them,
which the Factorise docs don't describe. When you ask for something the standard API doesn't
cover, Claude asks whether the environment has an extension for it. If you have its
documentation, point Claude to the file or folder, or paste the text. Claude keeps a copy per
environment in a folder `factorise-custom-api`, so you give it once. What goes through an
extension is listed apart in the plan, gets its own yes, and is tried with one record first.
An extension that needs its own key or token can't be used.

It can also just tell you what an environment holds. It doesn't delete anything: that's done in
the app.

## What you need

- The **Claude desktop app** on a Mac or Windows computer, with a paid Claude plan. The skills run
  in its **Code** tab. On Windows, Claude Code also needs
  [Git for Windows](https://git-scm.com/download/win); the app tells you if it's missing.
- **Access to the Factorise docs** at docs.factorise-suite.com, with your own Microsoft account.
  Open that address in your browser to check. No access yet? Ask your partner manager at
  Factorise.
- For configure-environment: **the environment's address**, and someone who is a SysAdmin or
  Administrator there, you or your customer, to create a user account for Claude.
- For make-demo: a **Factorise environment for demos**, where you're a SysAdmin or Administrator,
  so you can create a user account. Claude adds records that can only be removed by hand in the app, so don't
  use an environment that's in use. A brand-new environment must have had its first setup: the
  licence entered and Model Reflection refreshed, as the docs' "Setting up Master Data" page
  describes. Claude checks this with you before it builds.

## Install

1. Open the Claude desktop app, go to the **Code** tab, choose **Local**, and open a folder for
   your Factorise work, such as `Documents/Factorise`.
2. Type these two lines into the chat, one at a time:

   ```text
   /plugin marketplace add Factorise-Software/factorise-partner-skills
   ```

   ```text
   /plugin install factorise-partner@factorise
   ```

   The first line tells Claude where to find Factorise's plugins, the second installs this one.
   Each answers with a short confirmation.
3. Describe what you want, or type `/make-demo` or `/configure-environment` and your request. If
   Claude doesn't know those, close the session and start a new one.

While it works, Claude asks before it runs a command or saves a file on your computer. It saves
what it sends in a folder inside the folder you opened, `factorise-demo-…` or
`factorise-config-…`, one file per group of records, so expect a number of these questions. For
saving files, you can choose to allow them for the whole session. What Claude reads from an
environment is kept in a folder `factorise-reads`, which you can delete at any time.

Claude also asks to read files from the plugin's own folder, with a path that has
`factorise-partner` in it and ends in `references`, when it starts connecting, building and
wrapping up. Those are its instructions for that part. Allow reading from that folder for the
whole session.

The commands look technical. The docs download and the login window start with `bash` (Mac) or
`powershell` (Windows). Each send or read starts with `curl` and has one web address near the
end, starting with `https://`. Answer the `curl` questions one at a time, and look at that
address: what stands between `https://` and the next `/` must be exactly your environment's
address, such as `acme.factorise-suite.com`. If it's anything else, choose No and tell Claude.

## About the account Claude uses

Claude asks you to create a Factorise user, such as `claude-demo` or `claude-config`, with only
the **ApiClient** role. The Factorise docs describe ApiClient as the role for other software that works through
the API, and say it can't log in to the app or open any page. (An older Factorise has no
ApiClient: there the role is **Webhook**.) So you never share your
own login, what Claude creates or changes shows as done by that account, and you can block or
delete it when you're done. In a customer's environment, their administrator makes the account,
or you do if you're one there: the customer should know it exists either way.

The password goes from a pop-up window straight into a small file on your computer that only your
user can open. It never goes into the chat. Claude is told never to open that file: the program
that sends the data reads the login from it. That's an instruction Claude follows, not a lock,
and the file isn't encrypted, so use a password you use nowhere else and give the account only
that one role. The login is only ever sent to the address you saved it for, and the window
warns you when that address isn't on factorise-suite.com.

There's one saved login per environment. Ask Claude "which environments am I connected to?" to
see them, and "remove my saved login for acme.factorise-suite.com" when a project is done.
Blocking the account in Factorise is what really ends its access.

## About the docs

The Factorise docs are for customers and partners only, so they aren't part of this plugin.
Claude asks before it downloads them, and says what will happen: your own browser opens the
download on docs.factorise-suite.com, and you sign in there as you always do. You can also
download the file yourself and tell Claude when it's in your Downloads folder. After two
weeks Claude asks whether to get the current docs, and goes on with the ones it has if you say
no. Claude never sees your docs login.

The pages are saved in a folder `factorise-docs` inside the folder you opened. Don't share that
folder, and don't keep files of your own in it: a new download replaces it. If the folder you
opened already has something else called `factorise-docs`, Claude leaves it alone and asks you
to move it. Only a file your browser downloaded from docs.factorise-suite.com is used, and only
its pages are kept. The downloaded file itself is removed from your Downloads folder once it's
unpacked. You can delete the folder at any time: Claude asks again when it needs the docs.

## Help

Questions, or a result that didn't come out the way you expected: contact your partner manager at
Factorise Software. It helps to send the run folder Claude made, `factorise-demo-…` or
`factorise-config-…`. It holds what was sent, the plan and the environment's address, never your
password. A `factorise-config-…` folder holds your customer's data: keep it, and share it, as you
would any customer file.
