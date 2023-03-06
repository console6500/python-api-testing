PORT ?= 3000
NAME ?= python-api
TEST ?= python -m pytest --verbose --junit-xml=junit.xml
RUN  ?= uvicorn main:app --host 0.0.0.0 --port 3000 --reload

setup:
	@pip install --upgrade pip > /dev/null 2>&1
	@pip install --requirement requirements.txt > /dev/null 2>&1
	@echo "$(NAME) Setup complete"

test:
	$(TEST)

run:
	$(RUN)

build: test
	docker build -t $(NAME) .

docker-test: build
	docker run --rm --init \
		--name $(NAME)-test $(NAME) $(TEST)

docker-run: build
	docker run --rm --init \
		--publish $(PORT):3000 --name $(NAME) $(NAME)

docker-detach: build
	docker run --rm --init --detach \
		--publish $(PORT):3000 --name $(NAME) $(NAME)

docker-logs:
	docker logs $(NAME)

docker-stop:
	docker stop $(NAME)

all: setup test run
