---
title: "Setting up a personal packagist, part 1"
date: 2019-09-11T00:29:31Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---

## Intro
While I was reading the composer docs looking for a way to speed up our setup, I discovered [Satis](https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md). It allows you to generate a private package repository. Here's how I got it setup.

I work on a [Symfony](https://symfony.com/) project for work. One of the pain points in developing it was any time we needed to add or update a dependency. Like most PHP projects, we use [Composer](https://getcomposer.org/) for managing our dependencies. The problem was that instead of using packages from [Packagist](https://packagist.org/), most of our packages are internal and hosted in bitbucket so any time we did ran composer update, composer would visit each repo and do a git fetch then have to parse all of the versions in that repo. It took forever.

## Getting Started
To start off with, I created a new folder for this project:

```
mkdir satis-server
cd satis-server
git init
git ci --allow-empty -m "Initial commit
```

### Setup Satis composer.json
Satis is configured through a composer.json file just like a regular PHP
project. The format looks pretty similar. Here's an example:

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

Let's go over what each of these sections mean.

* `name` is pretty self-explanitory. * It will be shown at the top of your repo page.
* `homepage` is very important. * Set this to the domain name that your server will live at. Whatever you put here show up in any projects' composer.lock files that point to your satis server.
* `repositories` lists where your server should look for packages.
  * This should
      be any private sources. You can use any of the [usual types](https://getcomposer.org/doc/05-repositories.md) for a composer.json
      file.
* `require` lists the versions of the packages that you want included in your satis server.
  * In my example, I'm including all versions of the phumbor package.
  * You can either list out all of the versions manually like
     I've done in my example or you can replace it with the option
     "require-all": true which will require all versions of all packages
* `require-dependencies` and `require-dev-dependencies` tells composer to also include all of the dependencies and dev dependencies of all the packages.
  * These aren't required but since my goal was speeding up our local composer functions, I wanted my server to have all of the packages that we'd need.
* `archive` says to create local copies of dist files.
  * This is technically optional.
  * Using this option, our satis server will download dist files (zip files) of the dependencies when possible and host them. Without this option, you're relying on the remote repos to always be available.
  * There are more options that are possible including hosting all of the package files on a CDN. See the [official docs](https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md) for all of the possible options.

## Building your server
Now that we've got a composer.json setup for satis, we need to build our server.
I'm using Docker to do that but you can also install satis locally.

```
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
```

You'll note that I'm mounting in my personal ssh credentials. This is only
required because the repos that I use at work aren't public. If all of the repos that you use are public, you probably don't need to do that.

Once you run that, it'll take a while to download everything but at the end you
should have a new folder called output with contents like this:

```
😎  λ ~/projects/satis-server/ master* ls -havl output
total 192K
drwxr-xr-x 6 chrisj chrisj  204 Sep 11 10:46 .
drwxr-xr-x 7 chrisj chrisj  238 Sep 11 10:46 ..
drwxr-xr-x 3 chrisj chrisj  102 Sep 11 10:46 dist
drwxr-xr-x 3 chrisj chrisj  102 Sep 11 10:46 include
-rw-r--r-- 1 chrisj chrisj 186K Sep 11 10:46 index.html
-rw-r--r-- 1 chrisj chrisj  192 Sep 11 10:46 packages.json
```

That's a fully functioning satis repo! Throw those files into the root of your
favorite server and you'll be able to point any PHP projects to it.

In the next post of this series, we'll explore how to dockerize this project.
