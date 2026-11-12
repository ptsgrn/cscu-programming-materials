run:
	@python server.py &
	@sleep 0.5
# 	Run 2 clients concurrently for 5 seconds each
	-timeout 5 python client.py & timeout 5 python client.py & wait
# 	Stop server after clients are done
	@pkill -x python
