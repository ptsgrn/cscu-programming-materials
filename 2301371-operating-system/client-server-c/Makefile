run: compile
	@./build/server &
	@sleep 0.5
# 	Run 2 clients concurrently for 5 seconds each
	-timeout 5 ./build/client & timeout 5 ./build/client & wait
# 	Stop server after clients are done
	@pkill -x server

compile:
	@mkdir -p build
	@gcc -o build/server server.c -Wall -Werror -Wextra -Wpedantic -std=c99
	@gcc -o build/client client.c -Wall -Werror -Wextra -Wpedantic -std=c99

clean:
	rm -rf build
