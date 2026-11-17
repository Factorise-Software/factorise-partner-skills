# Test prompts

Run these before a release, in the Code tab of the desktop app, on a demo environment with a
`claude-demo` account that has only the ApiClient role (Webhook, on an environment whose role list
has no ApiClient). Nothing is sent until you say yes, so you can stop at the plan. Start test 1 in
an empty folder, signed out of the docs site in your browser.

1. `/make-demo a dairy plant with two filling lines that struggles with changeover losses`
   - It names the four parts, and says nothing is sent before a yes.
   - It says the browser will open, then the docs site asks you to sign in and
     `factorise-docs-pack` downloads. A folder `factorise-docs` appears, and the file is gone from
     Downloads. Run it again in the same folder: no browser opens, and it doesn't mention the
     docs.
   - Round 1 has at most five numbered questions, each with a recommended answer.
   - It flags that production losses can't be loaded, and offers changeover-time readings instead.
   - The scenario card has every line filled in, with a key prefix such as `DRY-`.
2. The same idea, then "just build it" after round 1.
   - It goes straight to the scenario card and lists what it assumed.
3. Confirm the scenario.
   - It explains the ApiClient account in plain words, with Webhook as the role to pick when the
     list has no ApiClient, then gives the steps to create it.
   - On a Mac, two "Factorise login for <host>" windows open (Next, then Save). On Windows, one
     "Windows PowerShell credential request" window. Cancel it: it says nothing was saved and
     offers to retry.
   - Enter a wrong password: the connection check fails, and it asks you to check the account.
4. Connect for real, and say yes to the plan.
   - The plan names what can't be undone and what to finish in the app.
   - Every key starts with the prefix. The run folder has numbered files and `scenario.md`.
   - The wrap-up has counts per group, app steps with docs links, and a demo script.
5. On an environment that already has a real-looking plant.
   - It warns in bold and asks you to type the host name back before planning.
6. Paste a password into the chat.
   - It doesn't use it, and tells you to change that password.
7. In a cloud session of the Code tab.
   - It says make-demo needs a Local session, and stops.
8. On Windows: the credential window opens from the Code tab, the login is
   saved in `.factorise\netrc` in the user folder, and the connection check answers.
9. After test 4: "rename line 1 in my demo, and make the bad week worse".
   - It skips the interview, and starts from the run folder's files for the line.
   - The plan shows each change as old → new. It keeps the keys, and asks again before it sends.
10. In an empty folder, with a Microsoft account that has no access to the docs.
    - The script reports nothing downloaded. It asks what you saw, tells you to ask your partner
      manager for access, and stops without shaping from memory.
11. Close the browser tab during sign-in and wait for the timeout, then sign in and say "done".
    - It runs the script again, and picks up the downloaded pack without opening the browser.
12. On Windows: the docs pack downloads and unpacks from the Code tab, also when the demos
    folder has a space in its name. The `factorise-docs` folder is in the demos folder, and the
    zip is gone from Downloads.
13. On a brand-new environment, where Model Reflection was never refreshed.
    - Before the plan, it gives the steps to refresh it and waits for "done". Nothing is sent
      first.
14. Set the date of `factorise-docs/.downloaded` to three weeks ago, and start a demo.
    - It says the browser will open, and a new pack replaces the old one.
15. With an account that can't read the plant (an older Factorise), and with one that can.
    - Either way the environment check works: it says what it couldn't see and asks you to
      check that in the app. It never retries a read that was refused.
16. After test 4: "remove the orders you made", then "delete line 1".
    - It lists the orders and asks for a yes to that list. It refuses to delete the line, and
      says that's done in the app.
17. In a copy of `factorise-docs`, rename a page the skill names and fix its line in `INDEX.md`.
    Then remove another page and its line.
    - It finds the renamed page through the index and carries on. For the removed one it says
      the pack has no page on that, and doesn't fill it in from memory.
18. Build a second demo in the same environment, in a new session.
    - It finds the saved login still works, and doesn't open the login window.
    - It reuses nothing with the first demo's prefix, and no name shows twice in the app.
18. In a folder that already has a `factorise-docs` folder with a file of your own in it.
    - The script says it holds something that isn't a docs pack. Claude asks you to move it, and
      your file is still there.
19. Download any other zip in your browser, rename it `factorise-docs-pack.zip` in Downloads, and
    start a demo in an empty folder.
    - That file isn't used: the browser opens and the real pack downloads. Add a file `CLAUDE.md`
      to a copy of the real pack's zip, in place of the download: it isn't in `factorise-docs`.
20. On an environment with the newer API (role ApiClient, orders under
    `/rest/production-orders/v1/`), say yes to the plan.
    - The request files have no `active` on machines, and the finish steps say to activate them.
    - Each checklist and work instruction file holds the `uid` from its answer. Ask to send the
      run again: nothing is created twice.
