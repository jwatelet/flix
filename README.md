# This is an application made with the pragmatic studio formation
The app is an IMDB look a like.
## Getting started
```
bundle install
rails db:migrate
rails db:seed
```

## How to debug with vscode

```
rdbg -n --open=vscode -c -- bin/rails s
```

## Config
Configured to work with Clever Cloud:
- postgresql database
- S3 like (Cellar)