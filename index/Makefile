.PHONY: test test-bootstrapping test-indexing up down

test: test-bootstrapping test-indexing

test-bootstrapping:
	./test_bootstrapping.sh

test-indexing:
	./test_indexing.sh

make build:
	docker compose build

up:
	docker compose up

down:
	docker compose down
