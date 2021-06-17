# Project cluster setup
## General info
1. Machine info: https://focs.ji.sjtu.edu.cn/git/TAs/ve472/issues/5
2. Docker configurations: https://github.com/tc-imba/hadoop-cluster
3. Make sure the versions exist in tsinghua's mirror. May need to change `Dockerfile` and `download.sh`

## Test on one server
1. Install git
2. Install docker: `install-docker.sh`
3. Go to `hadoop-cluster/build`. Run `start-cache.sh`.

## Steps
### Starting with servers
- Install docker for each server