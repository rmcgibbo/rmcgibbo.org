Title: Deploying with Travis-CI and S3
Date: 2014-10-29
Tags: software, web, travis, aws

[Travis-CI][1] is _fantastic_ for testing software (continuous integration)
during open-source development. Less widely known, I think is how useful it can
be for deployment.

With travis-ci, you have full access (passwordless `sudo`) access to a fresh
Ubuntu virtual machine that runs automatically on every commit to your github
repository. Sure, you can use this to run your tests, but you can do a lot more
as well.

### Generate this website!

This site is built with [Pelican][4], and deployed on Amazon S3. I use travis-ci
to automate the deployment -- every commit to github triggers travis to rebuild
the HTML/CSS/JS content and push it to S3. This completely automates the deployment
workflow. To publish a new post, I just push to github. It's Heroku-like convenience
for (basically) free. You can check out the
[source code](https://github.com/rmcgibbo/rmcgibbo.org) for this site to see how
it works.


### Deploy documentation

In [MDTraj][2] and [OpenMM][3] libraries, for example, our documentation is
built directly from the source code using the Sphinx and Doxygen tools, which
output HTML and PDF documents. Our travis-ci virtual machines, after running
the tests, rebuild the documentation and deploy a versioned copy directly to
Amazon S3 buckets which are configured as publicly accessible websites. No more
worrying about the docs getting out of sync with the code -- they're updated
automatically.

### Build binaries

We also use travis, and its Windows cousin, [Appveyor CI][5] to build binaries
of released and development snapshots of MDTraj. We use the python [conda package
manager][6] to build binaries for a large matrix of different versions of the
dependencies, and then push the binaries directly to the [binstar][7] index
so that users can `conda install` them without needing to compile.

The one caveat here is that, for MDTraj, we still target the (very ancient)
RHEL5, and  to avoid GLIBC incompatibles, we need to build our linux release
binaries on a sufficiently old distro. The infrastructure running
at Travis-CI is too new, unfortunately. But we still _do_ use for distributing
binaries of the development snapshot, which are handy for downstream integration
testing downstream.


[1]: http://travis-ci.org
[2]: http://mdtraj.org
[3]: http://openmm.org
[4]: http://blog.getpelican.com/
[5]: http://www.appveyor.com/
[6]: http://technicaldiscovery.blogspot.com/2013/12/why-i-promote-conda.html
[7]: http://binstar.org/