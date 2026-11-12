run: compile
	@./build/fork

compile:
	@mkdir -p build
	@gcc -o build/fork fork.c -Wall -Werror -Wextra -Wpedantic -std=c99

clean:
	rm -rf build fork