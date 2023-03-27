import wikipedia


def wiki(name="War Goddess", length=1):
    """This is a wikipedia fetcher"""
    my_wiki = wikipedia.summary(name, length)
    return my_wiki

def search_wiki(name="James Bond"):
    """Search wikipedia for names"""
    my_wiki = wikipedia.search(name)
    return my_wiki