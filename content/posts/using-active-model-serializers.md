---
title: "Using Active Model Serializers"
date: 2015-04-01T23:00:00Z
tags: [XXXXXX]
categories: ["blog import"]
draft: false
---
 
Boy, this one is late. I blame moving. Hilary and I finally got the keys to our
new place and have started moving in. Last time I wrote about programming, I
discussed APIs. In this post, I want to continue in the same theme and discuss
implementing an API in a Rails application.

Rails has a great, simple way to output standard JSON instead of an HTML
document.

class FlashcardsController < ApplicationController
  def index
    render json: Deck.all
  end
end


That block of code would output all of the Decks in the database as a JSON
object. The problem is that it doesn't give you much control over it. What if
you had a relation where each deck has_many: cards? That controller wouldn't
give you any indication about it. That's where a handy gem called 
active_model_serializers [https://github.com/rails-api/active_model_serializers] 
comes in. Active model serializers gives you very fine control over what is
output in JSON.

The way it works is you create a file in the serializers directory for each
model. Then you can define exactly which attributes are output as JSON as well
as how they're output. This is what a simple AMS looks like for a model Deck(id:
number, title:string, public: boolean, card_id: number).

class DeckSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :title

  has_many :cards
end


The attribute line specifies which parts of the model to expose in your API. The
has_many line tells AMS to expose that there decks and cards are related. The
neat part of this is the embed :ids line. Taking that line out AMS will include
the cards that are associated with the deck in the JSON response. With that line
in, AMS will simply give you the ids instead of the whole card object.

I love using AMS for creating JSON responses. Next week I'll combine what I
talked about APIs with AMS and Grape.
