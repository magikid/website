---
title: "Limiting Firefox memory usage in Ubuntu"
date: 2021-03-02T15:52:41Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
`systemd-run --user --scope -p MemoryLimit=2G firefox`

Update `/usr/share/applications/firefox.desktop` so that each `Exec` line starts with that.

[Found here](https://www.reddit.com/r/linuxadmin/comments/fbfc6w/how_to_wrap_my_firefox_process_in_a_cgroup_to/fj3z5tr?context=3)
