Title: New website!
Date: 2014-10-28
Tags: web, pelican, python

This is my first post on this new website! I went ahead and purchased the
domain <a href="http://rmcgibbo.org">rmcgibbo.org</a> to try to consolidate
my material on the web.

The domain was registered through GoDaddy, and its DNS settings were configured
through Amazon Route53. This site itself is simply static HTML/CSS/JS, and
is generated using <a href="http://blog.getpelican.com/">Pelican</a>, a staticd
site generator powered by Python.

Because the site is statically generated, it can be served cheaply (i.e.
from just an S3 bucket). I can author the content in my standard editor in
plain text (Markdown), and easily version control it. I chose Pelican because
it was written in Python and licensed under the GNU AGPL, which means that
I'll have the ability to customize any aspect of the site. I know that 
Jake VanderPlas's <a href="http://jakevdp.github.io/">blog</a> is written
using the same tools, and he's found some very cool ways to embed IPython
notebooks into the Pelican blog, which is something that I'm very excited about.
See <a href="https://jakevdp.github.io/blog/2014/01/10/d3-plugins-truly-interactive/">
this post</a> for an example.
