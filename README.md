[![Python application with Github Actions](https://github.com/brettsteph/python-for-devops/actions/workflows/devops.yml/badge.svg)](https://github.com/brettsteph/python-for-devops/actions/workflows/devops.yml)
[![Python application with Github Actions](https://codebuild.us-east-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiZGVCNUhCcFBqU0dnSUdoWFdLVWdjWmtGS0RqZyt5Mk9abytPK1BjKy9Mdmx5aVorem0xeGhQMW94RHZyVlN2dWc4SVFLQk1oT3dkdWljU2RXK2JwK2ZvPSIsIml2UGFyYW1ldGVyU3BlYyI6IkNGM1JkbEFCVEdZZ0lKZmIiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)


# python-for-devops

## Scaffold CICD

![Drawing sketchpad (1)](https://user-images.githubusercontent.com/3052677/231305098-4a1071c7-9661-4c0a-a4b9-f1888740f42f.png)

### Setup

1. Create a Python Virtual Environment: `python3 -m venv /workspace/**/.venv` or `virtualenv /workspace/**/.venv` (I used `virtualenv /workspace/**/.venv`)
2. Add virtual environment source to the bottom of the .bashrc file `vim ~/.bashrc` --> `source /workspace/**/.venv/bin/activate`
3. Create empty files using the `touch` command `Dockerfile` `Makefile` `requirements.txt` `mylib` `mylib/__init__.py` `mylib/logic.py` `main.py`(for microservice)4. 
4. Populate `Makefile`
5. Setup Continous Integration, i.e. check code for lint errors
![lint-failure](https://user-images.githubusercontent.com/3052677/227738996-8913c069-ceb6-49f3-9228-93f0ec2afb5e.png)
6. Build cli using Python Fire Library `./cli-fire.py --help` to test the logic.

### Requirements.txt

1. wikipedia - Access and parse data in Wikipedia
2. pytest - Testing
3. pytest-cov - Coverage measurement used to gauge the effectiveness of tests
4. pylint - Code linting
5. black - Code formatting
6. fire - Create commandline tool

### Makefile update
```makefile
install:
	#install
	python -m pip install --upgrade pip
	pip install ruff pytest
	if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
	python -m textblob.download_corpora
format:
	#format
	black *.py mylib/**/*.py
lint:
	#Lint
	# Disable warning -> --disable=R,C
	pylint --disable=R,C *.py mylib/**/*.py
test:
	#test with pytest
	# To use TestClient install httpx
	pip install httpx
	python -m pytest -vv --cov=mylib --cov=main mylib/tests/test_*.py
build:
	#build container
	docker build -t deploy-fastapi .
run:
	#run docker -> copy and paste to run manually
	# docker run -p 8080:8080 <image_name>
deploy:
	#deploy to container registry of choice
all: install lint test deploy
```

The run `make install`. After all the packages are installed run `pip freeze` and update the requirements.txt file with the current versions installed.

### Containerize FastAPI

Build and tag docker image: `docker build -t deploy-fastapi .`.

Run docker: `docker run -p 8080:8080 <image_id>`.

### AWS CodeBuild

Add `buildspec.yml` file to repository with the following: 

```yaml
version: 0.2

phases:
	build:
		commands:
			- make all
```
