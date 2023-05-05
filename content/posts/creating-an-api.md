---
title: "Creating an API"
date: 2015-03-18T23:25:10Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
Part 1 in my series on creating an API in Rails. Here's part 2
[/52in52/api/2015/04/01/using-grape-api/].

This week, I have been working hard to add an API to a website that I wrote. I'm
going to explain what an API is and why I want one for this website.

When you visit a website, your browser uses a protocol called HTTP. HTTP is made
up of verbs that describe interactions with the server. When you visit 
http://christopherjones.us, your browser uses the HTTP verb GET because you want
to "get" the page. When you log in to a website, your browser uses the verb POST
like you're mailing the data to the server. There are a bunch of other verbs
used as well but I'm not going to get into them. After doing a GET request, the
server located at http://christopherjones.us responds with the page you
requested, its response will look something like:

<html>
    <head>
        <title>Chris W Jones</title>
    </head>
    <body>...</body>
</html>


Believe it or not, that response is hard for a computer to read. The difficulty
comes from the fact that anything can be in between those <body> tags. It could
be a picture of a cat or it could be the entire text of the Iliad. Computers
don't do so well with that much ambiguity which is why developers use APIs. APIs
are the computer's interface to a website.

When designing an API, developers think about what kinds of information that
users will want to use from their site. For example in my Bibliophilum website,
I might have an API endpoint that allows users to request the books in their
library. Another endpoint might allow users to see which books are currently
loaned from their library. When a user wants the list of their books, they'll do
a GET request to that endpoint and the server will respond with something that a
computer can understand like:

[
    {
	    id: 1,
		title: "Moby Dick",
    	author: "Herman Melville
    },
	{
    	id: 2,
		title: "Accelerando",
    	author: "Charles Stross
	}
]


The format of the response from the server is usually documented and doesn't
change. This allows the computer using the API to understand the data received.

I really wanted to develop an API for this website because of a new trend in web
development. This trend is towards using a single page to serve the whole
website and requesting the different pages in the background. Gmail is a good
example of a single page application (SPA) like this.

In the traditional client/server architecture, your browser sends a GET request
to my server. My server responds with the page. You click the link which sends
another GET request for that page which my server responds with. In the SPA
architecture, your browser sends a GET request for my main page. After that,
when you click a link on the page the page rewrites itself to be the new page,
requesting additional data from the server as needed.

The main benefit of using this SPA is that the processing power my server would
use to generate the page is offloaded to your browser saving me bandwidth and
electricity. The API comes into this when the SPA requests additional data as
needed. It needs to be able to understand the data so it queries the API.

That is an overview of what APIs are and one way that they're used. Next week,
I'm going to explore a specific way to implement an API in Rails using a gem
called Grape.
