build:
	@bazel build //...

test:
	@./test.sh

.PHONY: build test
