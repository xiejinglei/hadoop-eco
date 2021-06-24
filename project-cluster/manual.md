# VE472 Project cluster setup SU2021
## General info
1. Machine info: https://focs.ji.sjtu.edu.cn/git/TAs/ve472/issues/5
2. Docker configurations: Forked from Yihao's project https://github.com/xiejinglei/hadoop-cluster
3. Make sure the versions exist in tsinghua's mirror. May need to change `Dockerfile` and `download.sh`. In SU2021, we use 
    ```
    HADOOP_VERSION=3.2.2
    DRILL_VERSION=1.18.0
    ZOOKEEPER_VERSION=3.5.9
    SPARK_VERSION=2.4.8
    ```

## Test on single server
1. Install git. Clone repo `hadoop-cluster`.
2. Install docker: `install-docker.sh`
3. ssh: 
    ```bash
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    ```
    At `hadoop-cluster`,
    ```bash
    mkdir -p .config && cp ~/.ssh/{id_rsa,id_rsa.pub} .config
    ```
4. Build docker image
    ```bash
    ./download.sh
    ./build/docker-build-image.sh
    ```
    (If network fails, rerunning build may solve the problem)
5. Hadoop network
    ```bash
    docker system prune
    master/init_swarm.sh
    master/init_network.sh
    ```
    `docker network ls` gives
    ```
    docker network ls
    NETWORK ID     NAME              DRIVER    SCOPE
    cb168c89bdf0   bridge            bridge    local
    bcf47c35ea10   docker_gwbridge   bridge    local
    w7r56juo3zp3   hadoop-net        overlay   swarm
    af4f44438604   host              host      local
    u9b8vtf644k9   ingress           overlay   swarm
    443ba0c414ca   none              null      local
    ```
6. Start containers
    ```
    ./standalone.sh
    ```
7. Check hdfs status in `hadoop-master`
    ```
    hdfs fsck /   
    ```
    Check yarn status
    ```
    yarn top   
    ```



## Steps
### Starting with servers
- Install docker for each server




## Trouble shooting
1. Remove all containers: 
   ```
   docker rm -f $(docker ps -aq)
   ```

2. Error when starting master container
   ```
   Error starting userland proxy: listen tcp4 0.0.0.0:22: bind: address already in use
   ```
   Solved by changing `master/docker-compose.yml`
    ```yml
    ports:
      - "9870:9870"
      - "8088:8088"
      - "8047:8047"
      - "19888:19888"
      - "2224:22"           <- this line
    ```
3. Spark may need to set environment variables
    ```
    export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
    ```
