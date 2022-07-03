#!/bin/bash
for file in .zshrc .emacs .yabairc .skhdrc
do
  ln -s ~/dotfiles/"$file" ~/$file && echo "symlink created for $file in" ~/
done
