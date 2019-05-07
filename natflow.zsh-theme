#!/bin/zsh

local basedir="%{${fg_bold[blue]}%}%1~%{${reset_color}%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "

local sign="%(!.%{${fg_bold[red]}%}#.%{${fg[blue]}%}$%{${reset_color}%} "

PROMPT="${basedir}\$(git_prompt_info)${sign}"
RPS1="%(?.%{${fg[green]}%}:D%{${reset_color}%}.%{$fg[red]%}:(%{$reset_color%})"
