install:
	#install
	pip install --upgrade pip && pip install -r requirements.txt
format:
	#format
	black *.py mylib/*.py
lint:
	#lint
	pylint --disable=R, C hello.py
test:
	#test
	python -m pytest -vv test_hello.py
deploy:
	#deploy
all: install lint test deploy
	