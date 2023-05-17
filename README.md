# mjex11/poker_app
ポーカーの役を返すwebアプリです。
- Ruby version: 3.2.2
- Rails version: 7.0.4.3
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
