from fastapi import FastAPI
import uvicorn
from mylib.logic import wiki as wiki_page
from mylib.logic import search_wiki
from mylib.logic import phrase as wiki_phrases


app = FastAPI()


@app.get("/")
async def read_root():
    return {"message": "Demo Wikipedia API. Call /search, /wiki, or /phrase."}


@app.get("/search/{value}")
async def search(value: str):
    """Page to search in wikipedia"""
    result = search_wiki(value)
    return {"result": result}


@app.get("/wiki/{name}")
async def wiki(name: str):
    """Retrieve wikipedia page"""
    result = wiki_page(name)
    return {"result": result}


@app.get("/phrase/{name}")
async def phrase(name: str):
    """Retrieve phrases from wikipedia"""
    result = wiki_phrases(name)
    return {"result": result}


if __name__ == "__main__":
    uvicorn.run(app, port=8080, host="0.0.0.0")
