#!/bin/bash
# run uperf netperf workload with local host and TCP protocol

# test setup
sudo echo
echo "Creating uperf cgroups"
sudo cgcreate -g cpu,cpuset:uperf

echo "Initializing cgroup cpuset:uperf.."

echo "Setting uperf:cpuset.cpus to 0-143"
sudo cgset -r cpuset.cpus="0-143" uperf

echo "Setting uperf:cpuset.mems to 0"
sudo cgset -r cpuset.mems="0" uperf

echo "Initializing cgroup cpuset:uperf done..."

echo "Setting core scheduling"
sudo cgset -r cpu.tag=1 uperf

echo "Starting follower uperf process..."
sudo cgexec -g cpu,cpuset:uperf uperf -s &
echo "Starting leader uperf process...144 threads, TCP protocol"
sudo cgexec -g cpu,cpuset:uperf uperf -m netperf.xml -a -e -p > ./uperf_TCP_144.log

echo "Clean up uperf workload after test"
sudo pkill uperf
sudo cgset -r cpu.tag=0 uperf
sudo cgdelete -g cpu,cpuset:uperf

echo "uperf netperf workload test done!"
