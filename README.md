# mjex11/poker_app
A poker web app.
- Ruby version: 3.2.2
- Rails version: 7.0.4.3
# Deployment Flow
Deploy ECS with GitOps
```mermaid
graph TB
  A["poker_app Repo"] -- "Merge to Main" --> B["release-please Action"]
  B -- "Create PR" --> C["Merge PR"]
  C -- "Push Image" --> D["ECR"]
  D -- "Event Bridge" --> E["Lambda"]
  E -- "Request Github API" --> F["poker_app_deploy Github Action"]
  F -- "Create PR for task-definition" --> G["Merge PR"]
  G -- "Deploy" --> H["ECS"]
  linkStyle 0 stroke:#2ecd71,stroke-width:2px;
  linkStyle 1 stroke:#2ecd71,stroke-width:2px;
  linkStyle 2 stroke:#2ecd71,stroke-width:2px;
  linkStyle 3 stroke:#2ecd71,stroke-width:2px;
  linkStyle 4 stroke:#2ecd71,stroke-width:2px;
  linkStyle 5 stroke:#2ecd71,stroke-width:2px;
  linkStyle 6 stroke:#2ecd71,stroke-width:2px;
```
# Configuration
```
bundle install
```
```
rails assets:precompile
```
```
rails s
```
# with docker
```
docker build . -t poker_app
```
```
docker run -e "SECRET_KEY_BASE=your_secret_key" -p 3000:3000 poker_app
```
# test
```
rspec
```
