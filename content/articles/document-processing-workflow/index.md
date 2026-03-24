---
title: "Document Processing Workflow"
date: 2025-11-20T00:00:00Z
draft: false
type: docs
authors: "Mark Hollow"
weight: 1
---

The Digital Bangkok Recorder project provides a digital archive of 19th-century Thai 
newspapers, primarily focusing on the preservation of Dr. Dan Beach Bradley’s newspaper
publications. The project uses a workflow centered on semi-automated transcription to
prioritise historical accuracy, archaic spellings and original layout as they appeared 
in print. The project makes these historical records accessible for research and 
long-term study.

The workflow is summarized below as a multi-step process from with the acquisition of 
high-resolution digital images to online publication.

{{% steps %}}

### Document Scanning

Depending on the document, either an OptiBook 3600 scanner or a Fujifilm X-T20 camera was used for image capture.

The OptiBook is an old model but just about still works albeit needing the 25 year old Windows XP operating systems! This scanner is perfect for this work having a very thin case edge so books don't need to be stretched wide open, limiting damage to the spine. However, it's limited to A4/Letter size pages.

For larger pages, such as in the จดหมายเหตุ สยามไสมย (Siam Samai) a Fuji X-T20 camera (24 megapixel) was used in a copy mount. A glass pane held the pages fully flat and a remote control was used to prevent camera movement which could have added a slight blur to the images. The Fuji connects directly to a laptop so there's no messing around with memory cards.


### Image Pre-Processing

{{< imglimit "background_noise.png" "Image Pre-Processing" "80%">}}

Each page image is converted to greyscale. Contrast and other basic parameters are auto-adjusted to ensure the print is as clear as possible. At times, image rotation was applied if misaligned and thresholding can remove background noise.


### Page Segmentation

{{< imglimit "structural_analysis.png" "Structural analysis" "80%">}}

This was the topic of a PyCon Asia-Pacific conference paper - the use of the [OpenCV](https://opencv.org/) (Open Computer Vision) library to identify the structural elements
of each page. This process combines elementary computer vision algorithms in OpenCV: morphalogical transforms, image dilation, and contour detection combine to outline the columns and other features which make up the structural page elements. These are programmatically extracted as separate images to  simplify reading the text.


### Optical Character Recognition (OCR)

{{< imglimit "ocr_example.png" "Tesseract / LLM OCR example" "100%">}}

OCR is the process that "reads" the image, producing text as the output. The project started using the [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) software but switched to LLMs. LLMs are much more tolerant of image quality and do [a much better job](/articles/experimenting-with-llms-for-optical-character-recognition/) of producing accurate output. Older models had a tendency to hallucinate but more recent iterations are greatly improved.

The example image demonstrates the greater capability of LLMs vs Tesseract. The source image (top) is read by Tesseract (bottom left) and an LLM (bottom right). The red text shows mistakes made by the OCR process. The difference in capability needs no commentary.


### Duplicate Text Detection

Newspapers contain advertisements, announcements and other text passages which are repeated from one edition to the next. Proofreading these individually is time consuming and a system to automatically detect them was added to the workflow, reducing the workload by around 15-25% per newspaper.

Each paragraph is indexed with a "trigram index" - an index of 3 character sequences and a count of their occurrences. Those sequences and occurrence counts make a kind of digital fingerprint which can be compared efficiently using a [similarity function](https://en.wikipedia.org/wiki/Cosine_similarity).
It's quick, simple, and quite accurate. 


### Word Spacing Reconstruction

{{< imglimit "word_spacing_example2.png" "Automated word spacing reconstruction" "100%">}}

Traditional Thai writing omits punctuation to separate clauses and sentences, unlike English which uses commas and full stops. Furthermore, Thai does not typically use spaces between words.

The American-printed Bangkok Recorder newspaper diverged from these norms by incorporating full stops, commas, and spaces to separate words, despite the white space offering little structural function.

In contrast, the Siam Samai newspaper adopted a different approach. It retained the word spacing introduced by Bradley but eschewed Western punctuation, relying instead on traditional Thai punctuation (๏ .... ๚ะ) to mark the start and end of paragraphs. This leaves the preserved spacing as the primary conveyor of structural information.

Given that the original OCR process struggled to accurately and consistently maintain this crucial structural spacing across the over 1,100 pages of the Siam Samai, an automated reconstruction method was implemented using computer vision techniques.

This process identifies the bounding boxes of each word and aligns their x-position with corresponding text character positions. The effectiveness of this technique is visually demonstrated by the above image showing the page scan with overlaid word bounding boxes on the left, and the resulting reconstructed, colour-coded text on the right.

The image of the proofreading tool below is also a good example showing the success of the reconstruction, retaining even subtle features, such as a vertical, arc-like shape in the word spacing, are clearly reproduced in the processed text.

While the automated method was highly successful, a small number of severely deteriorated pages needed manual correction.


### Automated Proofreading

The consistency of spelling, particularly in older English newspapers, is a challenge, often including archaic spellings and non-English words, such as transliterated Siamese proper nouns. A dictionary of these unique words is built during manual proofreading, which simplifies their identification on subsequent pages. While English spelling is generally consistent, the transliteration of Thai words varies. Consequently, the custom dictionary is augmented with similarity searches, similar to those employed for detecting duplicate text.

Spelling consistency is a much greater issue with Thai-language content. At the time The Bangkok Recorder was published, spelling hadn’t been standardised and the newspaper predates the first monolingual Thai dictionary (compiled by its own editor, Dr. Dan Beach Bradley). As a result, spelling is inconsistent, affecting both Thai words and transliterated English words. Differences can even be observed between page columns, suggesting that multiple typesetters, each with their own preferred spellings, may have been employed at the printworks.

To improve recognition of mid-19th century Siamese, LLM fine-tuning was performed. Text-line pairs showing pre- and post-correction versions were used to incrementally enhance the LLM's capabilities. This process significantly improved the recognition of the now-obsolete characters ฃ (kho khuat) and ฅ (kho khon). These characters were likely underrepresented in the original LLM training data, leading the initial OCR output to incorrectly substitute them with ข (kho khai) and ต (to tao), respectively.


### Manual Proofreading

{{< imglimit "proofreader.png" "Proofreading Tool" "100%">}}

The proofreading tool is designed to support the manual review of each page. It presents the scanned image on the left, with zoom and contrast controls for enhancing image details. The right side displays the editable OCR-generated text. A key feature is that selecting a word in the tool brings up a palette of similar words, which includes both those with similar spellings and the most frequent substitutions for that word. This is particularly helpful for common OCR issues, such as the automatic replacement of old spellings, like เปน, with their modern equivalent, เป็น.


### Western and Thai Dates

The Bangkok Recorder contains several date discrepancies between the Western and Thai calendars.

This issue prompted research into Thai lunar calendars, resulting in the creation of an open-source Python library [pythaidate](https://github.com/hmmbug/pythaidate), and was the subject of a presentation at the 2023 PyCon Thailand Programming Conference.

Corrected dates are provided on this site's newspaper index pages to address those originally published incorrectly.

{{% /steps %}}

## Summary

This process has successfully delivered two million words of newspaper articles in both the Thai and English languages with high accuracy and provided a valuable resource for anyone interested in 19th century Siamese history and the language of the time.