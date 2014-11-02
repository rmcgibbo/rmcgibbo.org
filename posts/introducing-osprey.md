Title: Introducing Osprey
Date: 2014-11-01
Tags: machine learning, theory, cross validation

Last week, I started work on a new open source software project whose goal
is to streamline hyperparameter optimization for machine learning algorithms.
The tool is called **osprey**, and it's available on [github](https://github.com/rmcgibbo/osprey),
[pypi](https://pypi.python.org/pypi/osprey/), and [readthedocs](http://osprey.readthedocs.org/).
It integrates closely with scikit-learn.

Osprey is designed to make hyperparameter optimization as easy as possible to run,
by optimizing the cross-validation performance of your model with respect to
its hyperparameters using random search, or Bayesian methods via Gaussian
processes or tree-structured Parzen estimators. Multiple osprey processes can
run in parallel, to easily leverage cluster compute resources without needing to
boot up any external server.

Take it for a spin, and let me know what you think!