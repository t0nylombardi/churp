# exit on error
set -o errexit

npm rebuild esbuild && yarn
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:drop db:create
bundle exec rails db:migrate