# Helm chart for k8s-haproxy deployment as kubernetes DaemonSet
### Here is a helm chart that allows you to deploy a proxy as a daemoset based on haproxy.

The chart can be useful for creating static endpoints proxies in the kybernetes cluster for your microservices.
It is enough for your micro service to know the name of the service with k8s-haproxy and the desired port, and the actual availability of numerous backends and their current list will contain haproxy.
_____________________________________________________________________________________________________________
**For example:**

Dozens of your microservices are looking at redis-cache at `redis-haproxy:6379` and the haproxy configuration stores a whole list of nodes of this redis cluster:
```
redis-server-1.example.com:6379
redis-server-2.example.com:6379
redis-server-3.example.com:6379
redis-server-4.example.com:6379
redis-server-5.example.com:6379
```
- haproxy itself monitors the online availability of each of these backends and removes the node from balancing in case of its unavailability
- if you need to add several more servers with redis to this backend, it's enough to do it on haproxy, instead of adding to each of your dozen microservices
_____________________________________________________________________________________________________________

All available parameters and their values are described in [values.yaml](values.yaml)

Helm dependencies that are needed to scan the chart are in the dependencies section [Chart.yaml](Chart.yaml)