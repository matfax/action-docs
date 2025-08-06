# action-docs
Github action that generates docs for a github action and injects them into the README.md

# Usage
To use action-docs github action, configure a YAML workflow file, e.g. `.github/workflows/documentation.yml`, with the following:
```yaml
name: Generate action docs
on:
  - pull_request
jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        ref: ${{ github.event.pull_request.head.ref }}

    - name: Update README.md from action.yml
      uses: Dirrk/action-docs@v1
```
| WARNING: This requires your README.md to contain comment delimiters, view this file in raw mode to see how it works |
| --- |

<!--- BEGIN_ACTION_DOCS --->
## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|----------|
| action\_docs\_debug\_mode | Enable debug mode | false | false |
| action\_docs\_git\_commit\_message | Commit message | chore(action-docs): automated action | false |
| action\_docs\_template\_file | Template file to use for rendering the markdown docs | ./src/default\_template.tpl | false |
| action\_docs\_working\_dir | Directory that contains the action.yml and README.md | . | false |
| create\_pr | Create/update PR for documentation changes | true | false |
| pr\_body | Body for the pull request | Automated documentation update by action-docs | false |
| pr\_branch | Branch name for the pull request | action-docs/update-documentation | false |
| pr\_title | Title for the pull request | Update action documentation | false |

## Outputs

| Name | Description |
|------|-------------|
| num\_changed | Number of files changed |
| pr\_number | Pull request number (if created) |
| pr\_url | Pull request URL (if created) |
<!--- END_ACTION_DOCS --->
