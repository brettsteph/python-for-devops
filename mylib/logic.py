import wikipedia
from textblob import TextBlob


def wiki(name="War Goddess", length=1):
    """This is a wikipedia fetcher"""
    my_wiki = wikipedia.summary(name, length)
    return my_wiki


def search_wiki(name="James Bond"):
    """Search wikipedia for names"""
    my_wiki = wikipedia.search(name)
    return my_wiki


def phrase(name):
    """Return phrases from wikipedia"""
    page = wiki(name)
    blob = TextBlob(page)
    phrases = blob.noun_phrases
    return phrases
