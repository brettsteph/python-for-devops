[![Python application with Github Actions](https://github.com/brettsteph/python-for-devops/actions/workflows/devops.yml/badge.svg)](https://github.com/brettsteph/python-for-devops/actions/workflows/devops.yml)

# python-for-devops

<!-- ![Drawing-1 sketchpad](https://user-images.githubusercontent.com/3052677/226196359-77297233-de3c-40ac-9433-c4681825a16b.png) -->


## Scaffold

![Drawing sketchpad](https://user-images.githubusercontent.com/3052677/226187972-2d801181-b1b5-4fac-8a68-9dddefae0289.png)

### Setup

1. Create a Python Virtual Environment: `python3 -m venv /workspace/*/.venv` or `virtualenv /workspace/*/.venv` (I used `virtualenv /workspace/*/.venv`)
2. Add virtual environment source to the bottom of the .bashrc file `vim ~/.bashrc` --> `source /workspace/*/.venv/bin/activate`
3. Create empty files using the `touch` command `Dockerfile` `Makefile` `requirements.txt` `mylib` `mylib/__init__.py` `mylib/logic.py` `main.py`(for microservice)4. 
4. Populate `Makefile`
5. Setup Continous Integration, i.e. check code for lint errors
![lint-failure](https://user-images.githubusercontent.com/3052677/227738996-8913c069-ceb6-49f3-9228-93f0ec2afb5e.png)
6. Build cli using Python Fire Library `./cli-fire.py --help` to test the logic.

### Requirements.txt

1. wikipedia - Access and parse data in Wikipedia
2. pytest - Testing
3. pytest-cov - How many lines of code are covered
4. pylint - Code linting
5. black - Code formatting
6. fire - Create commandline tool

### Makefile update
````makefile
install:
	#install
	pip install --upgrade pip && pip install -r requirements.txt
format:
	#format
	black *.py mylib/*.py
lint:
	#lint
	pylint --disable=R,C *.py mylib/*.py
test:
	#test
	python -m pytest -vv *.py mylib/*.py
deploy:
	#deploy
all: install lint test deploy
````

The run `make install`. After all the packages are installed run `pip freeze` and update the requirements.txt file with the current versions installed.
