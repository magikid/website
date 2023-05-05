---
title: "Java Thread Synchronization"
date: 2016-09-16T20:28:20Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
During week 4 of my class in Operating Systems, I learned about thread
synchronization. Since this whole class is based in Java, we've been
implementing all of the OS ideas in Java.

I've taken a Java class before where we dealt with threads but it was quite a
while ago. We used things like Thread.new() and Thread.sleep(). I've now learned
that both of those are quite outdated ways to deal with threads.

Anyway, I learned about CyclicBarriers
[https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CyclicBarrier.html] 
and CountDownLatches
[https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CountDownLatch.html]
. A CyclicBarrier works in a similar manner to a CountDownLatch except that a
CyclicBarrier can be reset and waited on several times. In practice, I couldn't
get my threads to synchronize after resetting the CyclicBarrier so I had to use
both the CountDownLatch and CyclicBarrier.
