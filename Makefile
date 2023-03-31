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
	#deploy to container registry
	# Retrieve an authentication token and authenticate your Docker client to your registry.
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
	# Build your Docker image using the following command
	docker build -t fastapi-wiki .
	# Tag your image so you can push the image to this repository.
	docker tag fastapi-wiki:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/fastapi-wiki:latest
	# Push this image to your newly created AWS repository
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/fastapi-wiki:latest
all: install lint test deploy
	