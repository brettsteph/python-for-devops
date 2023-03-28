install:
	#install
	python -m pip install --upgrade pip
	pip install ruff pytest
	if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
	python -m textblob.download_corpora
format:
	#format
	black *.py mylib/*.py
lint:
	#Lint
	# Disable warning -> --disable=R,C
	pylint --disable=R,C *.py mylib/*.py
test:
	#test with pytest
	# To use TestClient install httpx
	pip install httpx
	python -m pytest -vv --cov=mylib --cov=main mylib/tests/test_*.py
build:
	#build container
deploy:
	#deploy
all: install lint test deploy
	