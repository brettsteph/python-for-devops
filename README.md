# python-for-devops

![Drawing sketchpad](https://user-images.githubusercontent.com/3052677/226190383-2c031af7-6e85-4259-8c95-88877d7b8a5d.png)


## Scaffold

![Drawing sketchpad](https://user-images.githubusercontent.com/3052677/226187972-2d801181-b1b5-4fac-8a68-9dddefae0289.png)

1. Create a Python Virtual Environment: `python3 -m venv /workspace/**/.venv` or `virtualenv /workspace/**/.venv` (I used `virtualenv /workspace/**/.venv`)
2. Add virtual environment source to the bottom of the .bashrc file `vim ~/.bashrc` --> `source /workspace/**/.venv/bin/activate`
3. Create empty files using the `touch` command `Dockerfile` `Makefile` `requirements.txt` `mylib` `mylib/__init__.py` `mylib/logic.py` `main.py`(for microservice)

### Requirements.txt

1. wikipedia - Access and parse data in Wikipedia
2. pytest - Testing
3. pytest-cov - How many lines of code are covered
4. pylint - Code linting
5. black - Code formatting
6. fire - Create commandline tool

#### Makefile update
````makefile
install:
	#install
	pip install --upgrade pip && pip install -r requirements.txt
format:
	#format
	black *.py
lint:
	#lint
	pylint --disable=R, C hello.py
test:
	#test
	python -m pytest -vv test_hello.py
deploy:
	#deploy
all: install lint test deploy
````

The run `make install`. After all the packages are installed run `pip freeze` and update the requirements.txt file with the current versions installed.