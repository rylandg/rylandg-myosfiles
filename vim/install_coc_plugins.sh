#!/bin/bash

mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
# Change arguments to extensions you need
yarn add coc-tsserver coc-json coc-snippets coc-ultisnips coc-tslint-plugin
