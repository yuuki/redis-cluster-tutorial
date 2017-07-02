prepare:
	git submodule update --init
	bundle install
	@echo "Please install redis, supervisor"

up:
	supervisord -n -c ./config/supervisord.conf -l ./log/supervisord.log -e debug

cluster/create:
	bundle exec ./bin/redis-trib.rb create --replicas 1 127.0.0.1:7100 127.0.0.1:7101 127.0.0.1:7102 127.0.0.1:7103 127.0.0.1:7104 127.0.0.1:7105

example:
	( cd ./redis-rb-cluster; bundle exec ruby ./example.rb 127.0.0.1 7100 )
