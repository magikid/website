---
title: "Authentication"
date: 2015-08-05T17:01:26Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
I've been thinking a lot about authentication for my library website,
Bibliophilium. It started out with do I need any? And moved to, how should I
manage it? To how far do I want to take this?

In Rails development, there is a golden standard library for authentication.
It's called Omniauth [https://github.com/intridea/omniauth]. Everyone seems to
use it. It integrates with other services like Facebook and Twitter allowing
signin from them through OAuth. OAuth is just the mechanism where you click
Login with Facebook" and a new window pops up where Facebook asks if it's OK to
login to the site. There are tons of guides out there for getting it setup with
a Rails application.

On the other hand, there is a simple library from Thoughtbot called Clearance
[https://github.com/thoughtbot/clearance]. It doesn't have many guides. Mainly
because it's simpler. It only uses email/password to login. There are no bells
and whistles to go along with it.

I also looked in to using a lower level authentication engine called Devise
[https://github.com/plataformatec/devise]. Omniauth is actually built on top of
Devise. My main qualm here is that I feel like it takes me even more into the
weeds.

So here I am. I'm at a crossroads. Do I go with simple for me or easier for the
users?

I think I'm going to take the middle road and use Omniauth like everyone else. I
tried using it once before but read way too much about the OAuth spec so got
scared away from it. I like avoiding handling people passwords though which
using a Facebook or Twitter logins would allow me to do.
