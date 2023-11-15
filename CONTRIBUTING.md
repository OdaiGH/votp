## Example Workflow for Contributing

(provided by [@spytheman](https://github.com/spytheman)) (copied from the one in  [vtl](https://github.com/vlang/vtl/blob/main/CONTRIBUTING.md))

(If you don't already have a GitHub account, please create one. Your GitHub
username will be referred to later as 'YOUR_GITHUB_USERNAME'. Change it
accordingly in the steps below.)

1. Fork https://github.com/odaigh/totp using GitHub's interface to your own account.
   Let's say that the forked repository is at
   `https://github.com/YOUR_GITHUB_USERNAME/v` .
2. Clone the main totp repository https://github.com/odaigh/totp to a local folder on
   your computer, say named vtl/ (`git clone https://github.com/odaigh/totp vtl`)
3. `cd vtl`
4. `git remote add pullrequest https://github.com/YOUR_GITHUB_USERNAME/v`
   NB: the remote named `pullrequest` should point to YOUR own forked repo, not the
   main v repository! After this, your local cloned repository is prepared for
   making pullrequests, and you can just do normal git operations such as:
   `git pull` `git status` and so on.

5. When finished with a feature/bugfix/change, you can:
   `git checkout -b fix_alabala`
6. `git push pullrequest` # (NOTE: the `pullrequest` remote was setup on step 4)
7. On GitHub's web interface, go to: https://github.com/odaigh/totp/pulls

   Here the UI shows a dialog with a button to make a new pull request based on
   the new pushed branch.
   (Example dialog: https://url4e.com/gyazo/images/364edc04.png)

8. After making your pullrequest (aka, PR), you can continue to work on the
   branch `fix_alabala` ... just do again `git push pullrequest` when you have more
   commits.

9. If there are merge conflicts, or a branch lags too much behind VTL's master,
   you can do the following:

   1. `git pull --rebase origin master` # solve conflicts and do
      `git rebase --continue`
   2. `git push pullrequest -f` # this will overwrite your current remote branch
      with the updated version of your changes.

The point of doing the above steps, is to never directly push to the main VTL
repository, _only to your own fork_. Since your local `master` branch tracks the
main VTL repository's master, then `git checkout master`, as well as
`git pull --rebase origin master` will continue to work as expected
(these are actually used by `v up`) and git can always do it cleanly.

Git is very flexible, so there are other ways to accomplish the same thing.
See the
[GitHub flow](https://guides.github.com/introduction/git-handbook/#github)
, for more information.
