---
title: "Emergency Backup Text Editor"
date: 2015-05-14T22:51:41Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
UPDATE (5/18/2015): Here are my config files
[https://github.com/magikid/linuxconfigfiles]

I've talked before [http://blog.christopherjones.us/2015/04/08/tools/] about how
my favorite programming editor is Sublime Text. Just because I have a favorite
though doesn't mean that I always get to use it. Today's post is about my second
favorite text editor.

Vim is my backup text editor. I like it because

 * it's installed everywhere
 * its commands are very powerful
 * it's crazy customizable
 * and the plugins

To the first point, vim is always installed when I first log into a new
terminal. Sometimes other, simpler editors like nano
[http://www.nano-editor.org] aren't. If not vim then at least vi which is close
enough for most of my work. It works great at the command line too since I don't
always have access to a full-on graphical interface.

The commands in vim have a long and infamous history. You run a command like 
:s/hi/bye/g to swap text around. To save and exit, you type :wq. And if you're
not expecting it, the differences between the modes will get you every time.
You'll think you're in insert mode and start typing away only to discover that
you're in command mode and you've just accidentally created 10 documents,
deleted 5 and written gibberish in the first. If it seems like I'm complaining,
I'm not. It's more like teasing a sibling. For all its quirks, vim is amazing.

If it's quirkiness annoys you, most of it can be changed through customizing
your .vimrc file. For example, I hate that the default key to exit insert mode
is escape. On most of my keyboards, I feel like Richard Nixon's secretary making
that stretch. In my .vimrc file, I always override the escape key and set the
sequence jj to exit out of insert mode. Changing command sequences is only one
of many options that can be changed in the file. You can turn line numbers on,
change the status bar around, tell vim how to handle mouse interaction, wrap
your lines at a certain point and a ton of others. The main point is that if
there is something you don't like about vim, you can probably change it in your 
.vimrc.

Unfortunately, you can't change everything in your .vimrc. It's great for
changing already existing capabilities but it can't substantially change the way
vim functions. For that, we turn to plugins. Plugins extend the capabilities of
vim. For example, if you want to see a file tree while your programming so you
can easily open files, there's a plugin for that (NERD tree
[https://github.com/scrooloose/nerdtree]).



If you want to align all the equal signs in a block of code, there's a plugin
for that (Tabular [https://github.com/godlygeek/tabular]).



There are plugins that do all sorts of neat things that save time and
keystrokes.

Although it can be intimidating to learn, once you have the basics down, vim can
be a powerful ally. It's ubiquity, extensibility, and general kick-assery put it
ahead of its (console-based) opponents.
