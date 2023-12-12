# exit on error
set -o errexit

npm rebuild esbuild && yarn
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:drop db:create
bundle exec rails db:migrate