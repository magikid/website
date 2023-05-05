---
title: "Timing docker build"
date: 2019-09-04T13:41:02Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
The other morning, I was looking over a recent Jenkins build at work and
realized that I had no idea why it took 5 minutes to build the container.  When
using Assetic
[https://symfony.com/doc/2.8/frontend/assetic/asset_management.html] to build
our assets, I can add a --profile flag and get line-by-line timings for each
asset generated.  I wanted that for docker build.

After a little research, I discovered the answer in a StackOverflow post
[https://stackoverflow.com/a/51760937/1695439].  The ts program which is part of
the moreutils package accepts data from a pipe and echos a timestamp plus the
original text.

I tried running it but got a "command not found" error in my terminal.  To
install the ts program, you need to install the moreutils package.  On my mac, I
ran brew install moreutils.  If you're not on mac, you should be able to install
it through your OS's package manager.

Now that I had the ts program installed, I was finally able to time my build.

λ ~/projects/foobar/ docker build . | ts
Sep 04 09:57:36 Sending build context to Docker daemon  4.096kB
Sep 04 09:57:36 Step 1/5 : FROM nginx:latest
Sep 04 09:57:36  ---> e445ab08b2be
Sep 04 09:57:36 Step 2/5 : WORKDIR /var/www/html
Sep 04 09:57:36  ---> Running in 045f73fdcb03
Sep 04 09:57:36 Removing intermediate container 045f73fdcb03
Sep 04 09:57:36  ---> 0cd92b8984a1
Sep 04 09:57:36 Step 3/5 : ADD index.html .
Sep 04 09:57:37  ---> a7f065a0e84d
Sep 04 09:57:37 Step 4/5 : USER www-data
Sep 04 09:57:37  ---> Running in e8058a99f42a
Sep 04 09:57:37 Removing intermediate container e8058a99f42a
Sep 04 09:57:37  ---> af9a4e545394
Sep 04 09:57:37 Step 5/5 : HEALTHCHECK CMD curl --fail http://localhost/ || exit 1
Sep 04 09:57:37  ---> Running in dffef986d061
Sep 04 09:57:37 Removing intermediate container dffef986d061
Sep 04 09:57:37  ---> 00c8c3bcbd61
Sep 04 09:57:37 Successfully built 00c8c3bcbd61
