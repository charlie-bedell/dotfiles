#!/bin/bash
for file in .zshrc .zshenv .emacs .yabairc .skhdrc .sketchybarrc
do
  ln -s ~/dotfiles/"$file" ~/$file && echo "symlink created for $file in" ~/
done
