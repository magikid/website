---
title: "Nodes"
date: 2015-07-23T22:59:09Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
In my data structures class, we've been talking about things like Linked Lists
and Search Trees.

One thing that I've noticed in common with most of these structures is that
they're made up of nodes.

A node is just a simple way to store data. In a linked list, a node will also
store a reference to the next node. In a tree structure, it will store
references to its parent node, as well as child nodes one to the left and one to
the right.

A linked list has a head and a tail (first and last elements). In the version I
wrote for class, I made a doubly-linked circular list. That's a fancy way of
saying that each node kept track of the next and previous and the tail element
kept a reference to the head and vice-versa.

class ListNode
  attr_accessor :next, :prev, :value

  def initialize(node_value)
    value = node_value
  end
end


In order to keep track of the head and tail elements, I used what's called a
sentinel node. That's a special node in the list with a value of null.

sentinel = ListNode.new(null)


That makes for a linked list that looks like this:



It's the basis for all array type storage.

The next topic that we covered was trees. Specifically, we discussed the various
Binary Search Trees. Don't be scared of the words Binary and Search in there (or
even tree). It just means that the tree data structure is sorted.



See how each node on the left is less than the one above? And every node on the
right is greater than the one above it? That's what makes it a binary search
tree.

There are several different kinds of these trees because one of the biggest
things that effects how long it takes to find a given element in the tree is how
tall it is, called its height.

In the tree that I've drawn, the height is 3. I started at the root element (5)
and walked down the longest path to the bottom. That's the easiest way to
determine the height.

To try to minimize the height, there is a way to rotate the tree around a
different node. In this tree, we've got a pretty balanced tree already. However,
we could rotate the tree and choose 4 as our new root. That would make the tree
look like:



It's not much of a difference since it still has a height of 3.

So far I've been doing pretty well in this class. I'm looking to finish strong.
Next week is the end of class.
