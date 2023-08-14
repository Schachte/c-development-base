TARGET := cproject
ARCH := arm64

CC = clang
CFLAGS = -Iinclude -g -Wall -Wextra -std=c11 -arch arm64
LDFLAGS = -g
SOURCES = $(wildcard src/*.c)
OBJECTS = $(SOURCES:.c=.o)

.PHONY: build
build: $(OBJECTS)
	@echo "Building \"$(TARGET)\" binary..."
	@$(CC) $(CFLAGS) $(SOURCES) -o bin/$(TARGET) 
	@make clean
	@echo "Complete..."

%.o: %.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "Removing object files..."
	@rm -f $(OBJECTS) 

tidy:
	@echo "Running clang-tidy"
	@clang-tidy $(SOURCES) -- $(CFLAGS) -Iinclude

format:
	@echo "Running clang-format"
	@clang-format -i -style=file $(SOURCES) -fallback-style=none 

.PHONY: build-env
build-env:
		@echo "Building Docker image for builder env..."
		@echo "Be patient, this might take a while"
		@docker buildx rm multi-platform-builder || true
		@docker buildx create --use --platform=linux/amd64 --name multi-platform-builder --append
		@docker buildx inspect --bootstrap
		@docker buildx build --platform linux/amd64 -f builder.Dockerfile -t $(TARGET)-builder:latest --load .

.PHONY: run-env
run-env:
		@echo "Running dev env"
		@docker run \
				--rm \
				-it \
				--platform linux/amd64 \
				--workdir /builder/mnt \
				-v .:/builder/mnt \
				$(TARGET)-builder:latest \
				/bin/bash


# runs tests via ceedling in a pre-built docker container. This is for running tests 
# when not actively developing in the dev env container (ie. make run-env)
.PHONY: test-docker
test-docker:
	@echo "Running test suite"
	@docker run \
			--rm \
			-it \
			--platform linux/amd64 \
			--workdir /builder/mnt \
			-v .:/builder/mnt \
			$(TARGET)-builder:latest \
			/bin/bash -c "ceedling test:all && ceedling gcov:all && ceedling utils:gcov"

.PHONY: test
test:
	@echo "Running test suite"
	@ceedling test:all
	@ceedling gcov:all

.PHONY: coverage
coverage:
	@echo "Running coverage"
	@ceedling gcov:all utils:gcov