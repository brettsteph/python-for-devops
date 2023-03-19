install:
	#install command
format:
	#format
lint:
	#flake8 or #pylint
test:
	#test
deploy:
	#deploy
all: install lint test deploy
	