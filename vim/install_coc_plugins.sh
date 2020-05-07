#!/bin/bash

mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
yarn cache list
# Change arguments to extensions you need
yarn add           \
  coc-tsserver     \
  coc-json         \
  coc-lists        \
  coc-ecdict       \
  coc-markdownlint \
  coc-snippets     \
  coc-lines        \
  coc-syntax       \
  coc-ultisnips    \
  coc-eslint       \
  coc-prettier     \
  coc-highlight    \
  coc-html         \
  coc-tag

