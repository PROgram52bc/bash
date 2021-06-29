#!/usr/bin/env python3
import json
import functools
import re
import sys
import pprint

DEBUG=1
def D(msg=""):
    if DEBUG:
        print(msg)

try:
    with open("notes.json") as f:
        notes = json.load(f)
except FileNotFoundError:
    print("Failed to open [notes.json]")
    sys.exit(-1)

active_notes = notes.get("activeNotes")

#################################
#  build a map from id to note  #
#################################

def reducer(mp, note):
    identifier = note['id']
    # add tags to the content
    tags = "\n".join(map(lambda tag: f"#{tag}", note.get('tags', [])))
    # build content
    content = tags + "\n" + note['content'].replace("\r", "")
    # build title
    title = note['content']
    title = title.partition('\n')[0]
    title = title.lstrip('# ') # Remove the leading # sign
    title = title.rstrip('\n\r') # Remove the trailing spaces
    title = title.replace(' ', '_') # Replace spaces with underscores

    D(f"Title: {title}")
    D(f"Tag lines:\n{tags}")

    # build filename
    filename = f"{title}.md"

    # build the note object
    mp[identifier] = {
        'title': title,
        'content': content,
        'filename': filename,
    }
    return mp

note_map = functools.reduce(reducer, active_notes, {})

#####################
#  transform links  #
#####################

def repl(match):
    identifier = match.group(1)
    note = note_map.get(identifier, {})
    title = note.get('title', "UNDEFINED TITLE")
    filename = note.get('filename', "UNDEFINED FILENAME")
    D("Link Before: " + match.group())
    D("Link After: " + f"[{title}]({filename})")
    D()
    return f"[{title}]({filename})"

pattern = re.compile(r"\[[^[]*?\]\(simplenote://note/(.*?)\)")

#####################
#  write out files  #
#####################

for note in note_map.values():
    content = pattern.sub(repl, note.get('content', "UNDEFINED CONTENT"))
    filename = note.get("filename")
    with open(filename, "w") as f:
        f.write(content)

