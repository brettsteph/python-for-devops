setup: 
	# Create Virtual Environment
	python3 -m venv .venv
activate:
	# Activate .venv
	source .venv/bin/activate
deactivate:
	# Deactivate .venv
	source .venv/bin/deactivate
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
pre-deploy:
	terraform init
	terraform validate
	terraform apply --auto-approve
deploy:
	#deploy to container registry
	# Retrieve an authentication token and authenticate your Docker client to your registry.
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 247232402049.dkr.ecr.us-east-1.amazonaws.com
	# Build your Docker image using the following command
	docker build -t python-app .
	# Tag your image so you can push the image to this repository.
	docker tag python-app:latest 247232402049.dkr.ecr.us-east-1.amazonaws.com/python-app:latest
	# Push this image to your newly created AWS repository
	docker push 247232402049.dkr.ecr.us-east-1.amazonaws.com/python-app:latest
destroy:
	terraform destroy --auto-approve
all: install lint test pre-deploy deploy
	