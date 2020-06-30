vim = ~/.vim
all:update

install:
	@mv ~/.vimrc ~/.vimrc_bak || echo "There was no existing .vimrc, so no need to backup"
	@ln -s ${vim}/vimrc ~/.vimrc
	@git submodule update --init
	@make -s command-t
	@make -s pathogen

update:
	@git submodule foreach git checkout master
	@git submodule foreach git reset --hard HEAD
	@git submodule foreach git pull
	@make -s command-t
	@make -s pathogen

command-t:
	@cd ${vim}/bundle/command-t && rake clean && rake make

pathogen:
	@mkdir -p ~/.vim/autoload ~/.vim/bundle
	@curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
