---
title: "Ruby 2.3"
date: 2016-01-04T12:59:09Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
Over the Christmas break, Ruby dropped a new version. I installed it as soon as
I heard and I've been exploring it since.

There are a few things in it that I think will be super useful so I thought I'd
write a bit about them.

Lonely Operator
This is a neat operator that Ruby stole from other languages. It looks kind of
strange: &.. It allows you to collapse a bunch of nil checks into a single
statement.

Since in a Ruby if statement, nil is treated the same as false, if any of the
methods that you want to call aren't defined then the if statement will evaluate
to false. An example:

# Before 2.3
if person && person.address && person.address.country
  puts person.address.country
end

# IN 2.3
if person&.address&.country
  puts person.address.country
end


As you can see, a lot cleaner looking code with the lonely operator.

New enumerable methods
I found out about these by reading a rosseta.net
[https://rossta.net/blog/whats-new-in-ruby-2-3-enumerable.html] blog post. The
two new methods are grep_v and chunk_while.

Ruby Enumerables have had grep for quite a while. It has the same usage as the
command line program grep. It allows you to search through an enumerable. The
new grep_v does the opposite. It excludes what you don't want.

# I'll use the alphabet
alphabet = ("a".."z")

# To get only the vowels, I'll use grep
alphabet.grep(/a|e|i|o|u/)
=> ["a", "e", "i", "o", "u"]

# To get only the consonants, I'll use grep_v
alphabet.grep_v(/a|e|i|o|u/)
=> ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]


On to chunk_while. I understand this but I can't think of a use case for it. It
allows you to create an enumerator when a condition is met. It is the opposite
of slice_when.

# Our good old alphabet
alphabet = ("a".."z")

# Using slice_when
alphabet.slice_when{|i| i =~ /a|e|i|o|u/}.to_a
=> [["a", "b"], ["c"], ["d"], ["e", "f"], ["g"], ["h"], ["i", "j"], ["k"], ["l"], ["m"], ["n"], ["o", "p"], ["q"], ["r"], ["s"], ["t"], ["u", "v"], ["w"], ["x"], ["y"], ["z"]]

# Using chunk_while gives the opposite
alphabet.chunk_while{|i| i=~ /a|e|i|o|u/}.to_a
=> [["a"], ["b", "c", "d", "e"], ["f", "g", "h", "i"], ["j", "k", "l", "m", "n", "o"], ["p", "q", "r", "s", "t", "u"], ["v", "w", "x", "y", "z"]]


As you can see, using slice_when creates an array whenever the letter is a vowel
and chunk_while with the same condition creates an array whenever it isn't a
vowel.

Frozen strings
This is yet another change in 2.3. It allows you to freeze strings which means
that you can't change individual letters after a string has been frozen. The
main benefit to this is that Ruby has to allocate fewer objects when using a
frozen string. The performance benefits are so good that they're talking of
making strings frozen by default in Ruby 3.0.

# With a normal string
 :004 > my_string = "Harry Potter
 => "Harry Potter" 
 :005 > my_string[0] = "G
 => "G" 
 :006 > puts my_string
Garry Potter
 => nil 

# With a frozen string
 :009 > my_string = "Harry Potter
 => "Harry Potter" 
 :010 > my_string.freeze
 => "Harry Potter" 
 :011 > my_string[0] = "G"                                                                                                                                              
RuntimeError: can't modify frozen String
        from (irb):11:in `[]='
        from (irb):11
        from /home/chrisj/.rvm/rubies/ruby-2.3.0/bin/irb:11:in `<main>'


There are a ton of other changes both big and small. For further reading, check
out this great post by Nithin Bekal
[http://nithinbekal.com/posts/ruby-2-3-features/].
