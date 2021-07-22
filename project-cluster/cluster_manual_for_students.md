# VE472 SU2021 Project cluster manual

Technical issues regarding the project cluster will be updated here. 

Start early and have fun :-)

Note: Please **DO NOT** alter any configuration of related software or the system without asking TA.

## Login
- Please add your **latest ssh public key** to the end of this file. Then TA will add your key to `hadoop-master`.
- Enter `hadoop-master` using
    ```
    ssh <your_group>@10.119.6.238 -p 2224
    ```
    For example, `pgroup1` will use
    ```
    ssh pgroup1@10.119.6.238 -p 2224
    ```

## Check node status
- YARN: http://10.119.6.238:8088/
- HDFS: http://10.119.6.238:9870/

## Usage
- HDFS: each group should has the read and write permission to the folder `/user/<group_name>` in HDFS.
- Spark:
  - Home directory at `$SPARK_HOME`.
  - You may use the command `spark-submit` directly.
- Drill:
  - Home directory at `$DRILL_HOME`.
  - You may use the command `drill-conf` directly to start the `drill` terminal.
  - You may tell the TAs if any drillbit goes away.
    ```sql
    SELECT * FROM sys.drillbits;
    ```





## ssh keys
Please add your latest public key here. 

- pgroup1

    | # | name | key | 
    |---|---|---|
    | 1 | | |
    | 2 | | |
    | 3 | | |
    | 4 | | |
    | 5 | | |

- pgroup2

    | # | name | key | 
    |---|---|---|
    | 1 | | |
    | 2 | | |
    | 3 | | |
    | 4 | | |
    | 5 | | |

- pgroup3

    | # | name | key | 
    |---|---|---|
    | 1 | | |
    | 2 | | |
    | 3 | | |
    | 4 | | |

- pgroup4

    | # | name | key | 
    |---|---|---|
    | 1 | | |
    | 2 | | |
    | 3 | | |
    | 4 | | |
    | 5 | | |