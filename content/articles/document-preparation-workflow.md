---
title: "Document Preparation Workflow"
date: 2025-11-20T00:00:00Z
draft: true
type: docs
authors: "Mark Hollow"
---

## Document Scanning

Depending on the document, I use either an OptiBook 3600 scanner or a 
Fuji X-T20 camera to capture images of each page. 

The OptiBook is an old model but just about still works, running from a virtual 
machine running Windows XP! It's still in use because it's able to scan books
without damaging the spine due to the very narrow distance between the glass 
platter and the case edge. It's limited to A4/Letter size pages.

For larger pages, such as in the จดหมายเหตุ สยามไสมย a different means of image 
capture is required. A Fuji X-T20 (24 megapixel) in a copy mount works well. A 
glass panel is useful to hold the pages fully flat, and a remote control 
prevents camera movement which could add slight blur to the images. The Fuji 
has the advantage of being able to capture direct to laptop so there's no
messing around with memory cards either.

## Image Processing

Previously for this project, automated processing would be applied to scans to 
remove image artifacts such as background noise and convert to black & white
(not grey-scale) image. That was the best image format for the Tesseract OCR
software.

However, LLMs are now being used and tests have shown they work better with 
unprocessed, grey-scale images so not much processing is required. Some pages do 
benefit from contrast adjustment but this is applied manually if needed. 

LLMs have a limit to how much data can be processed per request. This requires
long text segments to be split up. Experimentation showed that OpenAI's o4-mini,
for example, works well with 15-20 lines of text. This is done automatically
with a simple algorithm that looks for suitable split points. It also balances
the number of lines per split image so that the last image isn't just one or 
two lines - having more data in the image provides better results.

## Optical Character Recognition (OCR)

This project has moved from Tesseract OCR software to LLMs. LLMs are much more 
tolerant of image quality and do [a much better job](/articles/experimenting-with-llms-for-optical-character-recognition/)
of reading the text, although they have an occasional tendency to just make
up quite believable text.

As longer images are split into multiple segments prior to OCR, there's also a 
process to concatenate the resultant text back into the same length as the original
image.

## Duplication Detection

Each newspaper contains advertisements which are repeated from one edition to the 
next. A system for automatically detecting these duplicates reduces the amount of
proofreading required, typically by at least one page per edition.

The process is straight-forward. Firstly, the OCR text as a series of character 
n-grams. Each occurance of an n-gram is counted. An n-gram is a sequence of 
consecutive characted. For example, this paragraph (converted to lowercase) starts 
with this sequence of 4 character n-grams "the ", "he p", "e pr", " pro" and 
so on. 

The combination of these n-grams and their occurance counts, when considered 
together, make a kind of digital fingerprint for each article. These fingerprints 
are then compared for similarity with a mathematical function called 
[cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity). This works very well and is almost always accurate, even with the unproofed OCR 
text.

## Online Proofreading Tool

