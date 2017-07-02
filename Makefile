.PHONY: prepare
prepare:
	git submodule update --init
	bundle install
	@echo "Please install redis, supervisor"

.PHONY: up
up:
	supervisord -n -c ./config/supervisord.conf -l ./log/supervisord.log -e debug

.PHONY: up/reinforcement
up/reinforcement:
	supervisord -n -c ./config/supervisord-reinforcement.conf -l ./log/supervisord.log -e debug

.PHONY: cluster/create
cluster/create:
	bundle exec ./bin/redis-trib.rb create --replicas 1 127.0.0.1:7100 127.0.0.1:7101 127.0.0.1:7102 127.0.0.1:7103 127.0.0.1:7104 127.0.0.1:7105

.PHONY: cluster/info
cluster/info:
	bundle exec ./bin/redis-trib.rb info 127.0.0.1:7100

.PHONY: cluster/add-node
cluster/add-node:
	bundle exec ./bin/redis-trib.rb add-node 127.0.0.1:7106 127.0.0.1:7100
	bundle exec ./bin/redis-trib.rb add-node --slave 127.0.0.1:7107 127.0.0.1:7106
	sleep 10

.PHONY: cluster/rebalance
cluster/rebalance:
	bundle exec ./bin/redis-trib.rb rebalance --use-empty-masters --auto-weights 127.0.0.1:7100

.PHONY: cluster/reinforce
cluster/reinforce: cluster/add-node cluster/rebalance cluster/info

.PHONY: example
example:
	( cd ./redis-rb-cluster; bundle exec ruby ./example.rb 127.0.0.1 7100 )

.PHONY: clean
clean:
	find ./config -name appendonly.aof | xargs rm -f
	find ./config -name dump.rdb | xargs rm -f
	find ./config -name nodes.conf | xargs rm -f
