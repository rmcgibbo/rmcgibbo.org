#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
import os

AUTHOR = u'Robert T. McGibbon'
SITENAME = u'rmcgibbo'
SITEURL = 'https://rmcgibbo.org'
#THEME = os.path.expanduser('~/projects/pelican-themes/pelican-mockingbird')
THEME = 'theme'
#TWITTER_USERNAME = '@rmcgibbo'
GITHUB_USERNAME = 'rmcgibbo'
GOOGLE_ANALYTICS = 'UA-55213879-1'
DISQUS_SITENAME = 'rmcgibbo-org'


TIMEZONE = 'America/New_York'
DEFAULT_LANG = u'en'

ARTICLE_URL = 'posts/{slug}/'
ARTICLE_SAVE_AS = 'posts/{slug}/index.html'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
DEFAULT_PAGINATION = 10
# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True
DIRECT_TEMPLATES = ('index', 
                    'posts_index',
                    'tags',)
PAGINATED_DIRECT_TEMPLATES = ('posts_index',)
POSTS_INDEX_SAVE_AS = 'posts/index.html'

PATH = 'posts'
PAGES_PATH = ['../pages']
TEMPLATE_PAGES = {'../pages/publications.html': 'publications/index.html'}
STATIC_PATHS = ['static']

NAVIGATION_BAR = [
   ('/', 'About'),    
   #('/posts', 'Posts'),
   ('/publications', 'Publications'),
]
