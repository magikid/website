---
title: "Personal Infrastructure Part 2"
date: 2021-02-26T16:20:37Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
This is a continuation from [Part 1](https://christopherjones.us/personal-infrastructure)

I ran all of my services in nomad for about a year.  It worked pretty well but the biggest hassle was running a CSI plugin using my ~~Free~~ TrueNAS instance for storage for the services.  I had this issue where occasionally the CSI volume would think it had more claims than allowed.  After dealing with that for several months and a chat with a homelab mentor, I decided to stop using a container orchestration service and treat all of these services like pets and not cattle.
