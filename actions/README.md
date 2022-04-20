# Actions

Shell scripts for performing templating or modifications to a repository. Intent is to be an idempotent change to allow it to be continuously run without creating unnecessary commits. 

## Ideas for Actions

- YAML Format on all of the workflows in `.github/workflows/<>`
- `.yaml` convention for all .github workflows
- Ensure LICENSE file (+ SPDX repository header)
- Ensure README in every repository
- Ensure SECURITY.MD / ARCHITECTURE.md in repository
- Ensure common "core" git files like licensing, security, templates
- Enforce format conventions on all languages (.go/python) - then add a linter to enforce it
- GitHub Labels
- Cleanup commands for unused files, or switch to more common way of managing external files
