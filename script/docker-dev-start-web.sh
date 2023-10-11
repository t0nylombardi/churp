#!/usr/bin/env bash
set -xeuo pipefail
./script/wait-for-scp.sh db 5432
./script/wait-for-scp.sh redis 6379
if [[ -f ./tmp/pids/server.pid ]]; then
  rm ./tmp/pids/server.pid
fi

rm -frv node_modules
npm rebuild esbuild && yarn

bundle

if [[ -f .db-created ]]; then
  bin/rails db:create
  bin/rails db:migrate
  touch .db-created
else
  bin/rails db:migrate
fi

if [[ -f .db-seeded ]]; then
  bin/rails db:seed
  touch .db-seeded
fi

bin/dev