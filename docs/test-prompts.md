# Test prompts

Run these before a release, in the Code tab of the desktop app, on a demo environment with a
`claude-demo` account that has only the Webhook role. Nothing is sent until you say yes, so you can
stop at the plan. Start test 1 in an empty folder, signed out of the docs site in your browser.

1. `/make-demo a dairy plant with two filling lines that struggles with changeover losses`
   - It names the four parts, and says nothing is sent before a yes.
   - It says the browser will open, then the docs site asks you to sign in and
     `factorise-docs-pack` downloads. A folder `factorise-docs` appears, and the file is gone from
     Downloads. Run it again in the same folder: no browser opens.
   - Round 1 has at most five numbered questions, each with a recommended answer.
   - It flags that production losses can't be loaded, and offers changeover-time readings instead.
   - The scenario card has every line filled in, with a key prefix such as `DRY-`.
2. The same idea, then "just build it" after round 1.
   - It goes straight to the scenario card and lists what it assumed.
3. Confirm the scenario.
   - It explains the Webhook account in plain words, then gives the steps to create it.
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
    folder has a space in its name.
