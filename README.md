# Repository Templating & File Automation

Experimenting with a model of building a lightweight cron+bash system for performing templating&file modification to multiple repositories.

## Idea

The basics of this repository was the idea of leveraging the GitHub CLI (`gh`) to automate the creation of pull requests that were intended to facilitate common chore work in repositories. This would reduce the need to handle things like setting up license files, formatting, metadata, GitHub Actions, etc.

Rather than continuously scanning all of the repositories for anything that might not be compliant with this, this instead works based off a work-item model, where an entry in created in the database (which is just a directory `tasks` in this repository). On a schedule items would be pulled from the work queue, executing the process until at least one "change" was made. If everything was up to spec, then all of the available `tasks` would be removed from the directory.

The task executions are staggered to avoid triggering a mass change in all repositories, as to avoid having to cleanup a mess of invalid changes / PRs that need to be declined.

An example of a work item would be:

```json
{
  "branch": "ensure-workflows-are-linted",
  "script": "actions/workflow-lint.sh",
  "title": "docs(build): Workflow linting process",
  "body": "Body of the pull request",
  "labels": "documentation,chore",
  "repository": "jrbeverly/repository-template-file-invoke-prototype"
}
```

## Notes

- This rough model works suprisingly well for getting some 'base' elements going
- Merge queue, or some form of automated approvals makes sense for some of these changes (as they are additive only changes)
- GitHub Apps (or some managed "service-cron") would be a better approach rather this rough "bash" process
- Often times the templates & modifications that wish to be applied to repositories would be better as a 'fit-for-purpose' code/service
- Validating the scripts against multiple repositories is a bit of a pain
- Using Git as a "database" for a work queue that only pulls a single digit number of times per day works suprisingly well
- Staggering the changes works great to avoid a sudden huge set of changes all at once
- This kind of system should be split out from the CI processes, as coupling it introduces some pain points with regards to the 'CRONJOB' nature of this
