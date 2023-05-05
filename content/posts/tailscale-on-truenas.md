---
title: "Tailscale on Truenas"
date: 2022-03-22T14:27:02Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
TrueNAS SCALE really make it hard to install Tailscale but now that I've figured it out, I'll share it with everyone.

<!--more-->

1. Head to your TrueNAS dashboard and visit `System/Tunables`
1. Add a new Tunable with the following settings:
  - Variable: `tailscaled_enable`
  - Value: `YES`
  - Type: `rc.conf`
  - Enabled: checked
1. Click save
1. Open a shell
1. Run the following commands to enable the `pkg` command and install tailscale:
  ```
  sed -ibak 's/enabled: yes/enabled: no/' /usr/local/etc/pkg/repos/local.conf
  sed -ibak 's/enabled: no/enabled: yes/' /usr/local/etc/pkg/repos/FreeBSD.conf
  pkg install tailscale
  ```

1. Start the Tailscale daemon and make sure it starts on reboots:
  ```
  service tailscaled enable
  service tailscaled start
  ```

1. Login to Tailscale
  ```
  tailscale up
  ```

Congratulations, you should now have Tailscale installed!

To make it so you can't install any other packages on your system again, run:
```
sed -ibak 's/enabled: no/enabled: yes/' /usr/local/etc/pkg/repos/local.conf
sed -ibak 's/enabled: yes/enabled: no/' /usr/local/etc/pkg/repos/FreeBSD.conf
```
