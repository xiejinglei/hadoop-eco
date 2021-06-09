# VE472 Lab 4 Spark and Drill

For all groups, you are expected to deploy **a cluster over all computers in your group**, instead of a pseudo-distributed one (multi-nodes on one computer). 

Each group should hand in a report showing 
- Your installation and deployment documentation of Spark and Drill, including important steps and result showing (could be screenshots of node status, etc.)
- Ex.2: commands and results for the queries
- Ex.3: your code and results

## I. Spark
Apache Spark is a fast and general-purpose cluster computing system. It provides high-level APIs in `Java`, `Scala`, `Python` and `R`, and an optimized engine that supports general execution graphs. It also supports a rich set of higher-level tools including Spark SQL for SQL and structured data processing, MLlib for machine learning, GraphX for graph processing, and Spark Streaming.
  
### 1. Install spark
Spark offical website: http://spark.apache.org/downloads.html

Since we have already installed hadoop, we can install "Spark with user provided Apache Hadoop". For example, `spark-2.4.3-bin-without-hadoop.tgz` (https://spark.apache.org/docs/2.4.3/).

 Spark can run both by itself, or over several existing cluster managers. It currently provides several options for deployment:

- Standalone Deploy Mode: simplest way to deploy Spark - on a private cluster
- Apache Mesos
- Hadoop YARN
- Kubernetes

General steps for spark on YARN:
-  Find the YARN Master node (i.e. which runs the Resource Manager). The following steps are to be performed on the master node only.
-  Download the Spark tgz package and extract it somewhere.
-  Configure Hadoop Classpath: https://spark.apache.org/docs/2.4.3/hadoop-provided.html
-  Define these environment variables:
    ```bash
    # Spark variables
    export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
    export SPARK_HOME=<extracted_spark_package>
    export PATH=$PATH:$SPARK_HOME/bin
    export LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native
    ```
- Run spark job using `spark-submit`. Example:
    ```bash
    spark-submit --class org.apache.spark.examples.SparkPi \
    --master yarn \
    --deploy-mode cluster \
    --driver-memory 1g \
    --executor-memory 1g \
    --executor-cores 1 \
    examples/jars/spark-examples*.jar \
    5
    ```
    If task succeeeded, something like this may appear in your output:
    ```
    client token: N/A
    diagnostics: N/A
    ApplicationMaster host: hadoop-master
    ApplicationMaster RPC port: 34143
    queue: default
    start time: 1623136363960
    final status: SUCCEEDED
    tracking URL: http://hadoop-master:8088/proxy/application_1623135707044_0008/
	user: xiejinglei
    ```
    When running on YARN, 2 modes exist :
    - `client` : runs the Driver on the client which submits the spark job. In this case, this creates a process on the master.
    - `cluster` : runs the Driver on a slave node. This will create a process (for the driver) inside the ApplicationMaster container of one of the slave nodes.

Spark shell
```
$ TERM=xterm-color spark-shell
```
```
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
Spark context Web UI available at http://hadoop-master:4040
Spark context available as 'sc' (master = local[*], app id = local-1623138123087).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.4.3
      /_/
         
Using Scala version 2.11.12 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_291)
Type in expressions to have them evaluated.
Type :help for more information.

scala>
```
You may also try pyspark shell:
```
$ pyspark
```

### 2. RDD
Every Spark application consists of a driver program that runs the user’s main function and executes various parallel operations on a cluster. The main abstraction Spark provides is a `resilient distributed dataset (RDD)`, which is a collection of elements partitioned across the nodes of the cluster that can be operated on in parallel. 

RDDs are created by starting with a file in the HDFS (or any other Hadoop-supported file system), or an existing Scala collection in the driver program, and transforming it. Users may also ask Spark to persist an RDD in memory.

RDD can be manipulated using Spark shell, SparkR, pyspark, scala and java APIs, etc.

RDD programming guide: https://spark.apache.org/docs/2.4.3/rdd-programming-guide.html

Simple examples in pyspark:
```py
>>> data = [1, 2, 3, 4, 5]
>>> distData = sc.parallelize(data)
>>> distData = distData.map(lambda x: 2*x)
>>> dataList = distData.collect()
>>> dataList
[2, 4, 6, 8, 10]
>>> listSum = distData.reduce(lambda a, b: a + b)
>>> listSum
30
```

```py
## Average number of each word
>>> data = {('apple', 2), ('pine', 1), ('pineapple', 2)}
>>> distData = sc.parallelize(data)
>>> total = distData.map(lambda (x, y): y).reduce(lambda x, y: x + y)  # total number of words
>>> avg = total / distData.distinct().count()
```

## II. Drill 
Drill is an Apache open-source SQL query engine for Big Data exploration. Drill is designed from the ground up to support high-performance analysis on the semi-structured and rapidly evolving data coming from modern Big Data applications, while still providing the familiarity and ecosystem of ANSI SQL, the industry-standard query language. 

Official tuturial for drill on hadoop: https://drill.apache.org/docs/creating-a-basic-drill-cluster/

Simple examples:
```sql
apache drill> select columns[0] as name, columns[1] as id, columns[2] as grade from dfs.`/home/xiejinglei/course/ve472/lab2/l4-names/grades.csv` limit 2;
+----------------+------------+-------+
|      name      |     id     | grade |
+----------------+------------+-------+
| Irvin Kitagawa | 4320355991 | 85    |
| Salina Bryant  | 7615527683 | 96    |
+----------------+------------+-------+
2 rows selected (0.361 seconds)
```

```sql
apache drill> select * from (select columns[0] as name, columns[1] as id, columns[2] as grade from dfs.`/home/xiejinglei/course/ve472/lab2/l4-names/grades.csv`) where name = 'Tad Wyze' order by grade desc;
+----------+------------+-------+
|   name   |     id     | grade |
+----------+------------+-------+
| Tad Wyze | 7345030868 | 93    |
| Tad Wyze | 7345030868 | 64    |
| Tad Wyze | 7345030868 | 60    |
| Tad Wyze | 7345030868 | 55    |
| Tad Wyze | 7345030868 | 52    |
| Tad Wyze | 7345030868 | 51    |
| Tad Wyze | 7345030868 | 38    |
| Tad Wyze | 7345030868 | 37    |
| Tad Wyze | 7345030868 | 37    |
| Tad Wyze | 7345030868 | 32    |
| Tad Wyze | 7345030868 | 29    |
| Tad Wyze | 7345030868 | 28    |
| Tad Wyze | 7345030868 | 22    |
| Tad Wyze | 7345030868 | 13    |
| Tad Wyze | 7345030868 | 13    |
| Tad Wyze | 7345030868 | 13    |
| Tad Wyze | 7345030868 | 0     |
+----------+------------+-------+
```

Drill can also deal with data in avro format, parquet format, etc. with a faster speed.