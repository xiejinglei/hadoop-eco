# VE472 Project cluster setup SU2021
## General info
1. Machine info: https://focs.ji.sjtu.edu.cn/git/TAs/ve472/issues/5
2. Docker configurations: https://github.com/xiejinglei/hadoop-cluster
3. Make sure the versions exist in tsinghua's mirror. May need to change `Dockerfile` and `download.sh`. In SU2021, we use 
    ```
    HADOOP_VERSION=3.2.2
    DRILL_VERSION=1.18.0
    ZOOKEEPER_VERSION=3.5.9
    SPARK_VERSION=2.4.8
    ```

## Test on single server
1. Install git
2. Install docker: `install-docker.sh`
3. Initialize network:
    ```bash
    docker system prune
    master/init_swarm.sh
    master/init_network.sh
    ```
4. Go to `hadoop-cluster/build`. Run `start-cache.sh`. This will start a caching container for `apt` downloads.

## Steps
### Starting with servers
- Install docker for each server