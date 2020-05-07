#!/bin/zsh

setopt EXTENDED_GLOB
for template_file in ${ZDOTDIR:-${USER_HOME}}/.zim/templates/*; do
  user_file="${ZDOTDIR:-${USER_HOME}}/.${template_file:t}"
  cat ${template_file} ${user_file}(.N) > ${user_file}.tmp && mv ${user_file}{.tmp,}
done

source "${ZDOTDIR:-${USER_HOME}}/.zlogin"
