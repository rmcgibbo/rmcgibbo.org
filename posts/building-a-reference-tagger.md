Title: Building a Conditional Random Fields Tagger for Academic Citations
Date: 2015-02-22
Tags: software, machine learning, web, citations

Over the weekend, I built a system that identifies, parses and formats unstructured
academic citations. The system is running at <a href="http://reftag.rmcgibbo.org"
target="_blank">http://reftag.rmcgibbo.org</a>.

It can take a raw string like
<i>"Wang, L.-P.; Titov, A.; McGibbon, R.; Liu, F.; Pande, V. S.; Martinez, T. J.
Nature Chemistry 2014, 6, 1044-1048."</i> and format it into a structured BibTeX
record for example.

This is a description of how it works, and how you can build a similar system.
All the code that implements this system is [available on GitHub](https://github.com/rmcgibbo/reftagger).

### 1. Formulate the problem

The first step is to properly formulate the problem that we want to solve.
This problem seemed very similar to [part-of-speech tagging](http://en.wikipedia.org/wiki/Part-of-speech_tagging)
in computational linguistics, so I started there.

The first pre-processing step in our system will be to
[tokenize](http://en.wikipedia.org/wiki/Tokenization_(lexical_analysis))
the input query. Then we have a
[structured prediction](http://en.wikipedia.org/wikipediai/Structured_prediction)
problem: given a vector of tokens, predict a tag or label associated with each token.

The tags for our system will be ``{'givenname', 'surname', 'title', 'journal',
'page_number', 'volume', 'year', 'issue', 'None'}``. Each token needs to be
assigned a label from this set.

### 2. Find training data

At this point, I guess you could decide to start building a big collection of
regexes to parse all possible citation formats, but that's going
to lead to a very brittle solution. And it would be no fun.

So instead we're going to need to acquire some training data: many unstructured
citations with the proper tags. Each data point will be a tuple, `(tokens, tags)`.

  1. CrossRef API.

      The [CrossRef REST API](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md)
      is great for getting structured information about journal articles. In
      particular, they have a ``/sample`` API enpoint that returns random journal
      articles with their DOI and metadata, which is perfect.

      Given a DOI, the CrossRef API also provides endpoints to return styled
      citations in many formats, such as MLA, Chicago, American Chemical Society, etc.

      The challenge here is that, given the styled citation from CrossRef and
      all of its metadata, we need to still tag every token. The right way to
      do this, I think, would be a dynamic programming solution similar to
      [Needleman–Wunsch](http://en.wikipedia.org/wiki/Needleman%E2%80%93Wunsch_algorithm).

  2. Full text HTML and XML articles.

      Many journals let you download articles in an HTML (or XML for PLOS) format,
      and the markup for each reference that the paper cites is both styled
      according to the journal's format, but also tagged. This perfect, although
      you do need to write a slightly different scraper for each journal.

Using the two strategies above, I downloaded and tagged about 20,000 citations.
The [BeautifulSoup](http://www.crummy.com/software/BeautifulSoup/bs4/doc/) and
[requests](http://docs.python-requests.org/en/latest/) libraries made this a
lot easier than it otherwise would have been.


### 3. Extract features

In part-of-speech tagging, the most important feature is just the word / token
itself, although other features (such as whether the word is capitalized) have
been shown to be useful. For academic citations, many of the tokens like authors'
surnames and some of the technical words in article titles are very rare and
diverse, so we need to be able to make accurate predictions about words that
never appear in the training set.

The featurization is a good place to introduce auxiliary data. For example, the
U.S. Census produces a list of all of the unique surnames that occurred in the
2000 Census. Using a token's presence or absence in this list as a feature is a
great way to introduce tailored prior information into the model, beyond what
we could hope to capture in the training set.

Similarly, I also used a list of common given names obtained from the U.S. Social
Security Administration, and a list of academic journals and their abbreviations
downloaded from PubMed.

To help reason about rare words that appear elsewhere, such as in article titles,
we can use [WordNet](http://wordnet.princeton.edu/). For each token longer than 4
characters that appears in WordNet, I found the nearest WordNet hypernym that is
among the most common 5,000 words in english, and used it as a feature. This
accomplishes a kind of dimensionality reduction over word space that's sensitive
to word meanings and their relationship.

### 4. Train a model

After reading a couple papers in the academic literature on POS tagging, I
decided that the best class of models would be a Conditional Random Field (CRF).
These models seem to get state-of-the-art or near state-of-the-art performance on
POS tagging tasks, and equally importantly, there are a number of high quality
open source implementations available, with reasonable documentation.

I chose [CRFsuite](http://www.chokkan.org/software/crfsuite/) and the [python-crfsuite](http://python-crfsuite.readthedocs.org/en/latest/)
bindings, which are as simple as

    $ pip install python-crfsuite

Based on a 50-50 test train split, I found that overall performance sensitivity
of the hyperparameter selection (L1 and L2 strengths, elastic-net regularization)
was fairly low, so I didn't spend a lot of time tuning.

The per-tag accuracy of the system is about 99% on the training set and 98.5%
on the test set.

I think there's still room to improve, but it's likely to come from more (and cleaner)
training data!g
