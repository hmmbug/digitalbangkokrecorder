---
title: "Experimenting with LLMs for OCR"
date: 2024-11-03T00:00:00Z
draft: false
type: docs
---
This digital preservation project started some years ago now but was paused
due to other commitments. Recently though I've had time to get back to work
on it and this time bring some state-of-the-art tools to the job, namely 
LLMs -- Large Language Models.

<!--more-->

When this project first started publicly accessible LLMs weren't particularly 
powerful and, in general, were text-only. Google's OCR API back then
fell short as it often attempted to change spellings to modern ones where 
preservation of the original text is needed. Newer LLMs are much more capable 
so I've revisited using them and with some positive results.

Currently I'm working on the English language version of the Bangkok Recorder,
published from 1865-1867 by Dr D.B. Bradley, and edited by Dr N.A. McDonald.
The newspaper covers local and regional news plus regular reports of the latter
stages of the American Civil War and journals of expeditions to unchartered (by 
foreigners) regions of the country. Their diary of a trip from Bangkok to Chiang Mai
is so different from experience of the modern-day tourist trail!

Anyway, for this comparison I've used OpenAI's _gpt-4o_ model with a simple _prompt_
to instruct it:

> Read this text. Preserve the line lengths and spaces between words. Do not correct spellings.

The output of instruction will be compared to a more traditional OCR program, _tesseract_.


### Test 1: Medium font size

![OCR test 1: Medium font size](/images/ocr-tests/ocr-test-1.png)

| Tesseract      | LLM |
| ----------- | ----------- |
| We had hoped to be able to have{{< br >}}‘the Recorder make its re-appear-{{< br >}}ance among the eitizens of Bang-{{< br >}}kok- at the first of the year, so{{< br >}}that it might wish them the com-  | &nbsp;&nbsp;&nbsp;&nbsp;We had hoped to be able to have{{< br >}}the Recorder make its re-appear-{{< br >}}ance among the citizens of Bang-{{< br >}}kok at the first of the year, so{{< br >}}that it might wish them the com-       |

Tesseract misinterprets page markings as characters, for example, the start of the second line, 
and misspells one word (citizens, 3rd line) but otherwise does a good job.

However, the LLM improves on this with perfect spelling, ignoring the page markings and indenting the paragraph.


### Test 2: Small font, some unclear text

![OCR test 2: Small font, some unclear text](/images/ocr-tests/ocr-test-2.png)

| Tesseract      | LLM |
| ----------- | ----------- |
| In a certein very a! hook wo read somos{{< br >}}thing like thia, “Of making books there 1s{{< br >}}nd cad, and-mach study is a weariness of{{< br >}}‘le flesh. The anthor ofthese words had{{< br >}}a high repfitatién for wisdom in hie day, | In a certain very old book we read some-{{< br >}}thing like this, "Of making books there is{{< br >}}no end, and much study is a weariness of{{< br >}}the flesh". The author of these words had{{< br >}}a high reputation for wisdom in his day, |

Tesseract is clearly starting to struggle here, the text is garbled.

The LLM isn't confused though and represents the text perfectly, although it didn't include the paragraph indentation this time.


### Test 3: Smallest font, faded text

![OCR test 3: Smallest font, faded text](/images/ocr-tests/ocr-test-3.png)

| Tesseract      | LLM |
| ----------- | ----------- |
| There vw he pronchingin the Daghsh lnez age{{< br >}}prota Beaty at & ew, in the Cvew Protestant{{< br >}}Choeel si, ivauked upea the eleer ba ©, adjeisiay it{{< br >}}Premed 0 tae Doewo Cospasy Lainie{{< br >}}Kote & ia,{{< br >}}Ui ire cordiallyiayite 1 ta atteod | There will be preaching in the English language{{< br >}}next Sabbath at 4 P. M., in the New Protestant{{< br >}}Church situated upon the river bank, adjoining the{{< br >}}premises of the Borneo Company Limited, and{{< br >}}J. G. & Co.{{< br >}}All are cordially invited to attend |

This text is unclear to the human eye and is clearly beyond the capability of Tesseract. 

But the LLM does an excellent job, reproducing the text almost perfectly, except for
the paragraph indentation. There is just one mistake that is not noticeable from this 
one example -- the fourth line should read _J. Gunn & Co._ instead of _J. G. & Co._
This is only known because the same text is repeated in other editions and many of them
are much clearer to read, as in this example:

![OCR test 3a: Smallest font, clear text](/images/ocr-tests/ocr-test-3a.png){{< br >}}


### Test 4: Medium font, Thai language

Although the English version of the Bangkok Recorder is primarily in English, 
there are some pages in Thai, especially in the early editions, afterwhich the 
editor announces the Thai articles will be moved to the Thai version.

![OCR test 4: Medium font, Thai language](/images/ocr-tests/ocr-test-4.png)

| Tesseract |
| --------- |
| 9 แนงมีศเคซีโมร ก็ได้เปนเจ้ เข้{{< br >}}เมื่อง นุย8ก ได้สาม ยี้ ยมา แล้ว นั้น,   รา{{< br >}}เข้เควัยฝ่าย พวกขยก+   ทํา การ ซักๆข้ง{{< br >}}ยู่ริศเต็ต์ลินกัล ต่าง ๆ นั้น' ซาว เมือง |

| LLM |
| ---------- |
| ⃝  อนึ่งมีศเตอร์ซีโมเว,  ที่ได้เปนเจ้า{{< br >}}เมืองนุยอกไต้สามปี๋มาแล้วนั้น, มีใจ{{< br >}}เช่นควัยฝ่ายพวกขบถ, ทำการขัดขวาง{{< br >}}บริศเต็นศ์ลินกัลต่าง ๆ นั้น; ชาวเมือง |

| Actual |
| ---------- |
| &nbsp;&nbsp;&nbsp;&nbsp;๏ หนึ่ง มีศเตอ ซีโมร, ที่ ได้ เปน เจ้า{{< br >}}เมือง นุยอก ได้ สาม ปี มา แล้ว นั้น, มี ใจ{{< br >}}เช่น ดวัย ฝ่าย พวก ขบถ, ทำ การ ขัด ชอ้ง{{< br >}}ปริศเต็นต์ ลินกัล ต่าง ๆ นั้น; ชาว เมือง |

Although it's quite good, the LLM struggles more. Here are several of the inaccuracies:

* Punctuation: in the 1st line the obsolete ๏ (ฟองมัน) is misrepresented as a circle character.
* English transliteration: ซีโมเว ("Seymowe") instead of ซีโมร (Seymour), บริศเต็นศ์ ("Bresidens") instead of ปริศเต็นต์ (President)
* Thai words: 2nd line, ไต้ (tai) instead of ได้ (dai).
* Spaces between words aren't preserved. This word spacing is specific to Bradley's printing though and rarely found in any other Thai print, so it's not surprising that the LLM ignores it.

It should be noted that where it does read accurately it does maintain archaic spellings.
For example, on the first line เปน instead the modern day เป็น which became the
common spelling in the mid-20th century. It also attempts to read ดว้ย (modern day ด้วย)
with the ้ tone mark above the second letter, ว, instead of the first letter, ด. 
It unfortunately misreads both  ั instead of ้ and ค instead of ด. However, preserving
the archaic spellings is something Google OCR struggles with, typically trying to auto-correct
to modern equivalents.


### Hallucinations

A hallucination is a _["is a response generated by AI that contains false or misleading 
information presented as fact"](https://en.wikipedia.org/wiki/Hallucination_(artificial_intelligence))_.
From the many pages processed so far from these newspapers, hallucinations are found quite frequently.

![OCR Hallucination 1](/images/ocr-tests/ocr-hall-1.png)

> Wrong impressions will get abroad occa-{{< br >}}
> ssionally. Truth demands that we state

In this example the hyphenation of "_occassionally_" is between the two Ss but in the LLM output
the first second is moved to the next line. Of course, this doesn't change the meaning at all,
just the typography.

However the next example is more problematic. 

![OCR Hallucination 2](/images/ocr-tests/ocr-hall-2.png)

> &nbsp;&nbsp;&nbsp;&nbsp;The London Spectator concludes a late article on{{< br >}}
> Gen. Sherman’s march, written on receipt of Ameri-{{< br >}}
> can news now four weeks old, with the emphatic{{< br >}}
> (now prophetic) declaration: -- "There is not a{{< br >}}
> **court nor office** in Europe who, if Sherman suc-{{< br >}}
> ceeds, will not recognize the addition of one more{{< br >}}
> to the short list of first-class leaders of armies."

The phrase in bold, "court nor office" is not in the original text. The LLM just made
it up and it works.

Compare this with more traditional OCR software, for example in test 3 above. When _tesseract_ 
can't read some text it's obvious:

> There vw he pronchingin the Daghsh lnez age

instead of:

> There will be preaching in the English language

It's easy to automatically detect these failures with a simple n-gram analysis and
then highlight to the user the lines most likely to need correction. However, LLMs 
can hallucinate perfectly reasonable text making it nearly impossible to detect, and
instead requiring manual proofreading of all output.


## Conclusion & Next Steps

Although the LLM isn’t flawless, but it significantly outperforms previous versions. Clearer text produces
significantly better results, as would be expected, and Thai text is mostly read correctly,
but with more inaccuracies than English.

The next step is to introduce an additional processing stage to attempt to correct the errors.
This will require fine-tuning the LLM with training data of incorrect and correct pairs of lines to
teach it the desired output. Initially this will be done for the English newspaper as, at the
time of writing, over 13,000 lines of text have already been manually proofread and corrected.

There are [recent reports of similar work](https://review.gale.com/2024/09/03/using-large-language-models-for-post-ocr-correction/) which show a >50% reduction in errors
from this basic training on scans of 19th century English newspapers.

A first batch of English Bangkok Recorder newspapers (January - June 1865)
is expected to be published on this site within the next few months.
