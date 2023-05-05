---
title: "Personal Infrastructure"
date: 2021-02-19T14:21:59Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
I run a hobbyist's infrastructure out of my basement.  I have a Raspberry Pi 3 (`amy`), a Raspberry Pi 2 (`hermes`), an old gaming rig (`theprofessor`), and a DigitalOcean droplet (`zoidberg`).  Each of them has a purpose and they are each precious to me.

Managing them has been a pain lately so I've been working on reducing the pain.  For starters, I've moved a lot of the boring configuration management over to Ansible.  That has been a big help actually.  Now I can use templates for the configuration files and keep everything up-to-date quickly and easily.

Another thing that I've done is install [Tailscale](https://tailscale.com/) on all of my servers and devices.  That gave me a quick and easy way to connect from my laptop no matter where I am.  Under the hood, it uses Wireguard so it's secure and fast.  Anecdotally, it was about a 10x speedup for me.  I have gigabit fiber coming into my house and a gigabit LAN infrastructure.  When I was running OpenVPN, the max connection speed through the VPN I could get was around 5 Mb/s.  Now that I've switched over to Wireguard, I regularly see around 50 Mb/s.  It was a nice improvement.

Each server in my infrastructure has a specific purpose.  `amy` runs [Home Assistant](https://www.home-assistant.io/) and the attendant services for it for local control of IoT devices.  `hermes` runs [Pi-hole](https://pi-hole.net/) for whole-house ad-blocking.  `zoidberg` power this website and several others.  And `theprofessor` is my NAS.  Pretty much all of those services are running in Docker.  To manage them, I've been my own container orchestration service.  Last week, I read the post [Running Nomad for home server](https://mrkaran.dev/posts/home-server-nomad/) and figured it was time to get a container orchestration system going.

I've tried running [k3s](https://k3s.io/) on my infra before but on my severely-limited nodes, it would never seem to start properly or once started could never run another container.  [Nomad](https://www.nomadproject.io/) seemed promising though.  I'm happy to report that I got it running in about an hour on all of my nodes except `hermes` and I suspect that's due to the ridiculously old arm version that `hermes` has.  I'm still working on migrating my services over to it but so far I'm enjoying using nomad as opposed to managing all the services myself.
