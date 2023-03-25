install:
	#install
	python -m pip install --upgrade pip
	pip install ruff pytest
	if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
format:
	#format
	black *.py mylib/*.py
lint:
	#Lint
	# #Stop the build if there are Python syntax errors or undefined names
	# ruff --format=github --select=E9,F63,F7,F82 --target-version=py37 .
	# # default set of ruff rules with GitHub Annotations
	# ruff --format=github --target-version=py37 .
	# Disable warning -> --disable=R,C
	pylint --disable=R,C *.py mylib/*.py
test:
	#test with pytest
	python -m pytest -vv *.py mylib/*.py
deploy:
	#deploy
all: install lint test deploy
	