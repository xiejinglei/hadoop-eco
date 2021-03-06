# VE472 Lab 2 Hadoop

## Time line
- Lab May 19: 
  - Instructions on installing hadoop and setting up clusters
  - Introduction to MapReduce and Hadoop streaming

- Lab May 26: Present your work to TAs (in groups)

- Before 5.30: Hand in your report (Ex. 2).
  - Your code
  - Performance on your own computer
  - Performance on your group cluster

Tip: You are encouraged to record the steps of your work. 


## I. Hadoop
The Apache™ Hadoop® project develops open-source software for reliable, scalable, distributed computing.

- Distributed processing of large data sets across clusters of computers
- Sale up from single servers to thousands of machines, each offering local computation and storage
- The hadoop library is designed to detect and handle failures at the application layer

Three modes:
- Local (Standalone) Mode
- Pseudo-Distributed Mode
- Fully-Distributed Mode

### Installation
- Linux is STRONGLY recommended.
- Version for this semester: `Hadoop 3.2.2`
- Apache Hadoop from 3.0.x to 3.2.x now supports only `Java 8`
- Install according to official document: https://hadoop.apache.org/docs/r3.2.2/hadoop-project-dist/hadoop-common/SingleCluster.html
- You may want to add `bin` directory of hadoop to your `PATH`
- You may try examples in the document.


### Standalone and Pseudo-distributed
- `Standalone` mode is mainly used for debugging where you don’t really use HDFS. You can use input and output both as a local file system in standalone mode. You also don’t need to do any custom configuration in the files `mapred-site.xml`, `core-site.xml`, `hdfs-site.xml`.
- `Pseudo-distributed` mode is also known as a single-node cluster where both NameNode and DataNode will reside on the same machine. A separate JVM is spawned for every Hadoop component. May need to change `mapred-site.xml`, `core-site.xml`, `hdfs-site.xml`.


### Cluster
Note: sorry that some of the links below are in Chinese 
- Official document: https://hadoop.apache.org/docs/r3.2.2/hadoop-project-dist/hadoop-common/ClusterSetup.html
-  Obtain your ip address: `ifconfig`
-  Enable ssh: You may need to allow ssh in your linux firewall. Useful link: https://linuxize.com/post/how-to-enable-ssh-on-ubuntu-18-04/. If you are using vitural machine, you may find the following helpful:
   - Vmware: 
      - Bridge: Set network to bridge mode. Then it directly shares the WLAN network with host machine.
      - NAT: https://blog.csdn.net/Zereao/article/details/. Cons: may need to shutdown your firewall in host computer.
    - Vitrual box: 
      - https://dev.to/awwsmm/setting-up-an-ubuntu-vm-on-windows-server-2g23
      - https://medium.com/@jootorres_11979/how-to-set-up-a-hadoop-3-2-1-multi-node-cluster-on-ubuntu-18-04-2-nodes-567ca44a3b12
  
    Use the following to check if the connection is OK
    ```sh
    ping <host_ip>
    ssh <user_name>@<host_ip>
    ```
- Build cluster ubuntu:
  - https://www.tutorialspoint.com/hadoop/hadoop_multi_node_cluster.htm 
  - https://www.cnblogs.com/warehouse/p/10676140.html
  - Very useful link (hadoop 3.2.1 on Ubuntu): https://medium.com/@jootorres_11979/how-to-set-up-a-hadoop-3-2-1-multi-node-cluster-on-ubuntu-18-04-2-nodes-567ca44a3b12
  - Note: some parameters in newer versions are different from older versions.
  - HDFS monitor example (1 master / 1 slave):
  ![](https://raw.githubusercontent.com/xiejinglei/links/master/new-datanode-fixed.JPG)

- Tip: You may need to start a datanode / nodemanager manually in master (refer to offical docs):
  ```sh
  hdfs --daemon start datanode
  yarn --daemon start nodemanager
  ```
  
- Tip: When you are finished with the jobs, remember to stop hdfs and yarn
  ```sh
  ./sbin/start-dfs.sh
  ./sbin/stop-yarn.sh
  ```
  or more simply
  ```sh
  ./sbin/stop-all.sh
  ```
  If you started something manually, then you may have to stop it manually. Eg:
  ```sh
  hdfs --daemon stop datanode
  yarn --daemon stop nodemanager
  ```

## II. HDFS
Useful commands
```bash 
hdfs dfs -ls <dir_in_hdfs>
hdfs dfs -mkdir <dir_in_hdfs>
hdfs dfs -put <file_in_your_system> <dir_in_hdfs>
hdfs dfs -get <file_in_hdfs>
```

## III. MapReduce
A MapReduce program is composed of a `map` procedure, which performs filtering and sorting, and a `reduce` method, which performs a summary operation. Example: Ex.2.

Example test command:
```sh
cat grade.csv | ./mapper.sh | ./reducer.sh
```

![avatar](https://raw.githubusercontent.com/xiejinglei/links/master/mr.JPG)

## IV. Hadoop streaming
Hadoop streaming is a utility that comes with the Hadoop distribution. The utility allows you to create and run Map/Reduce jobs with any executable or script as the mapper and/or the reducer.

- Useful link: https://hadoop.apache.org/docs/r1.2.1/streaming.html#Hadoop+Streaming
- Package: `share/hadoop/tools/lib/hadoop-streaming-3.2.2.jar`
- Useful args:
  - `-files`: can be your mapper and reducer files. Tell the framework to pack your executable files as a part of job submission.
  - `-input`: input file or directory (hdfs)
  - `-output`: output directory (hdfs)
  - `-mapper`: name of mapper file
  - `-reducer`: name of reducer file
- Your mapper and reducer can be in any language you want.
- You may want to copy your result from hdfs using `hadoop fs -get`.


## Trouble Shooting
Go to `logs/` to view possible error.
1. Datanode cannot connect to master at port 9000. Keeps retrying connection.
   
   After starting HDFS, use
   ```sh
   netstat -tpnl
   ```
   to check port listening status. If port 9000 is on but still cannot be connected, the following command
   
   ```sh
   ufw allow 9000
   ```
   may slove the issue. Also check `/etc/hosts` to see if the configuration for `hadoop-master` is correct. Use LAN IP instead of localhost IP.


## Switch from cluster mode to pseudo-distributed
1. Change hdfs/tarn xml files
2. Edit `etc/hadoop/workers`, delete `hadoop-slave1` and so on