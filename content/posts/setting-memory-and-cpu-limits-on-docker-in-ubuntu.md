---
title: "Setting memory and CPU limits on Docker in Ubuntu"
date: 2021-03-02T15:42:08Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
I've been hunting down a problem this morning that keeps causing my laptop to totally lock up.  I suspected it was related to Docker because it happened every time I hit a particular endpoint on a local webserver running in Docker.

When I was running Docker on a MBP, I could easily limit the total resources Docker used through a program that lived in the taskbar.  I found it more challenging on Ubuntu but after some poking around, I found an [question on StackOverflow](https://unix.stackexchange.com/q/537645) by user Leltir that gave me the answer.  I have modified the answer by adding comments and adding my particular limits

1. Create a file in `/etc/systemd/system/docker_limit.slice` with the following contents:
  ```
  [Unit]
  Description=Slice that limits docker resources
  Before=slices.target
  [Slice]
  # Turn on CPU limit
  CPUAccounting=true
  # Set CPU limit to use 400% of total CPU resources
  # I have 8 cores so this limits Docker to using 4 of them
  CPUQuota=400%
  # Turn on memory limit
  MemoryAccounting=true
  # Set memory limit to 8GB
  MemoryLimit=8G
  ```

2. Run the following to load the new system file and start it:
  ```
  sudo systemctl daemon-reload
  sudo systemctl start docker_limit.slice
  ```
3. Add the following to `/etc/docker/daemon.json` (merging it into any existing JSON in that file):
  ```
  {"cgroup-parent": "/docker_limit.slice"}
  ```
4. Restart docker with `sudo systemctl restart docker`

For help with what limits can be set in the system file, see the [RedHat doc "Modifying Control Groups"](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/resource_management_guide/sec-modifying_control_groups)
