for file in .zshrc .emacs
do
		ln -s ~/dotfiles/"$file" ~/$file
		echo "symlink created for $file in" ~/
		
done
