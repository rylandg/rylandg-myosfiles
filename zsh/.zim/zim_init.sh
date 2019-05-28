#!/bin/zsh

setopt EXTENDED_GLOB
for template_file in ${HOME}}/.zim/templates/*; do
  user_file="${HOME}/.${template_file:t}"
  cat ${template_file} ${user_file}(.N) > ${user_file}.tmp && mv ${user_file}{.tmp,}
done

source "${ZDOTDIR}/.zlogin"
