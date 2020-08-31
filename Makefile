.PHONY: build
build:
	@bazel build //...

.PHONY: test
test:
	@./test.sh

.PHONY: clean
clean:
	@bazel clean
	-@rm -f hash1
	-@rm -f hash2

default: build
