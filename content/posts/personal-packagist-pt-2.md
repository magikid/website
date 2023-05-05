---
title: "Setting up a personal packagist, part 2"
date: 2019-09-11T14:55:50Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---

This post continue from [part 1 of this series](https://www.christopherjones.us/personal-packagist-pt-1/).

In this post, we'll create a docker container for our satis server to run in
that can be used to deploy it into a Docker Swarm or Kubernetes cluster.

Storing the dist archives
So now that we've got satis building locally (or on a server somewhere), lets
put it into a container and deploy it. There are a few ways that we could do
this. We could put all of the archive files into the container itself or we can
put them onto a CDN or some sort of storage service. I tried both of these at
work. We have a pretty large list of dependencies for our project and when we
were building the archives into the container, we eneded up with a container
over 5GB in size. Docker handled it just fine but since I was building every
couple of hours to make sure that we had the latest packages in Satis, our
servers started hitting storage limits because of all of the previous docker
images laying around. After getting a stern talking to by our Devops team, I
moved the packages into a Google Storage bucket so that's what we'll do here
too.

I'm going to assume that you have gsutil installed and setup. If you don't,
Google has a quickstart
[https://cloud.google.com/storage/docs/quickstart-gsutil] that should get
everything installed.

To start, we'll create a bucket to store all of our archives. Don't forget to
replace the name of the bucket with the name of your bucket!
```
gsutil mb gs://cwj-satis-bucket
Creating gs://cwj-satis-bucket
```

Now that we've got a storage bucket, we need to tell Satis that's where we'll be
storing all of our archives. Satis will then rewrite its index file to point
clients to the bucket instead of itself.

Before we start updating everything, here's what our current composer.json file
looks like:
```
{
    "name": "work/satis-repo",
    "homepage": "https://satis.work.com",
    "repositories": [
        { "type": "vcs", "url": "ssh://bitbucket.work.com/mirrors/99designs.phumbor.git" }
    ],
    "require": {
        "99designs/phumbor": "*
    },
    "require-dependencies": true,
    "require-dev-dependencies": true,
    "archive": {
        "directory": "dist",
        "format": "zip
    }
}
```

We're going to change the archive section so that it looks like this:
```
    "archive": {
        "directory": "dist",
        "format": "zip",
        "prefix-url": "https://cwj-satis-bucket.storage.googleapis.com
    }
```

Once again, don't forget to update the bucket name to your bucket's name.

Now that we have composer.json updated to point to our bucket, we need to copy
our archives to the bucket. Our build is getting complicated so I'm going to
take a moment to create a Makefile that will handle this for us.

Build script
I'm going to start a simple Makefile that will do all of our building from now
on. Here we go:
```
.PHONY: all build-satis copy-archives
all: build-satis copy-archives

build-satis:
	cp ~/.ssh/id_rsa .
	cp ~/.ssh/id_rsa.pub .
	docker run --rm --init -it
		-e GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
		--volume ${PWD}:/build
		--volume "${COMPOSER_HOME:-$HOME/.composer}:/composer
		--volume ${PWD}/id_rsa:/root/.ssh/id_rsa
		--volume ${PWD}/id_rsa.pub:/root/.ssh/id_rsa.pub
		composer/satis --no-ansi -v build /build/composer.json /build/output
	rm id_rsa
	rm id_rsa.pub

push-assets:
	gsutil -m rsync -r ./output/ gs://cwj-satis-bucket/
```

There, now we can run make in our project directory and we'll build satis and
push the archives to our bucket. If you don't want to put this in docker, you
could stop right here and have a perfectly workable Satis server that could be
hosted on a VM or probably out of a bucket (but I haven't tried that).

Dockerize
I mentioned at the start of this article that I tried to put all of the archives
in a container first. I built a simple nginx container where the archives were
stored in the file system. I'm going to keep the same idea and instead of having
the archives stored locally, nginx is only going to store the index and some
basic information for our satis repository while proxying any archive requests
to our bucket.

I'm going to use the bitnami nginx image
[https://hub.docker.com/r/bitnami/nginx] to start from because they have a lot
of good, sane defaults.

Here's what our Dockerfile should look like:
```
FROM bitnami/nginx:1.16

# This is where all of our files will live
WORKDIR /app
# We'll get to this next but this is the nginx config for our server
COPY ./server_blocks/satis.christopherjones.us.conf /opt/bitnami/nginx/conf/server_blocks/
# Copy over some of the small files that Satis uses but none of our archives
COPY ./output/index.html ./index.html
COPY ./output/packages.json ./packages.json
COPY ./output/p ./p
```

Next, let's update our Makefile by adding another block to build our Docker
container:
```
TAG:=satis-server:latest

.PHONY: all build-satis copy-archives
all: build-satis copy-archives build-nginx

build-satis:
	cp ~/.ssh/id_rsa .
	cp ~/.ssh/id_rsa.pub .
	docker run --rm --init -it
		-e GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
		--volume ${PWD}:/build
		--volume "${COMPOSER_HOME:-$HOME/.composer}:/composer
		--volume ${PWD}/id_rsa:/root/.ssh/id_rsa
		--volume ${PWD}/id_rsa.pub:/root/.ssh/id_rsa.pub
		composer/satis --no-ansi -v build /build/composer.json /build/output
	rm id_rsa
	rm id_rsa.pub

push-assets:
	gsutil -m rsync -r ./output/ gs://cwj-satis-bucket/

build-nginx:
	docker build -t ${TAG} .
```

Great, let's tie it all together by building our container:
```
$ make
cp ~/.ssh/id_rsa .
cp ~/.ssh/id_rsa.pub .
docker run --rm --init -it
...
Scanning packages
Enter passphrase for key '/root/.ssh/id_rsa':
Selected 99designs/phumbor (0.1.0)
Selected 99designs/phumbor (0.1.1)
...
wrote packages to /build/output/p/99designs/phumbor$7883d94b94e047487e4616ff6a4e56ed7963e37cceec02e739451868f3087e24.json
Writing packages.json
Pruning include directories
Writing web view
rm id_rsa
rm id_rsa.pub
docker build -t satis-server:latest .
Sending build context to Docker daemon   1.04MB
Step 1/6 : FROM bitnami/nginx:1.16
 ---> a58e62787db2
Step 2/6 : WORKDIR /app
 ---> Using cache
 ---> 36710f3e54af
Step 3/6 : COPY ./server_blocks/satis.cnet.com.conf /opt/bitnami/nginx/conf/server_blocks/
 ---> Using cache
 ---> f8b1611f4292
Step 4/6 : COPY ./output/index.html ./index.html
 ---> c40177a2752a
Step 5/6 : COPY ./output/packages.json ./packages.json
 ---> a4da11c92972
Step 6/6 : COPY ./output/p ./p
 ---> 8efbd61365bc
Successfully built 8efbd61365bc
Successfully tagged satis-server:latest
```

I've omitted part of the output but at the end you should have a tagged docker
image that you can now deploy where ever you like!
