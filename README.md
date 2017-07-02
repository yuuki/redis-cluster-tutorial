redis-cluster-tutorial
======================

[Redis cluster tutorial](https://redis.io/topics/cluster-tutorial)

# Preparation

```
make prepare
```

# Startup nodes

```
make up
```

# Create cluster

```
make cluster/create
```

# Insert example data

```
make example
```

# Add new nodes (auto-rebalanced)

```
make up/reinforcement
# In another console
make cluster/reinforce
```
