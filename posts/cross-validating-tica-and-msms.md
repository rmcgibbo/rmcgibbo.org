Title: Cross-validating tICA and MSMs
Date: 2014-10-28
Tags: MSMs, tICA, theory, cross validation, protein dynamics

Some of our new work at the intersection of chemical physics and machine
learning on the construction of [Markov models][1] is now out on arXiv and
under review. The title of [our manuscript][2] is **"Variational cross-validation of
slow dynamical modes in molecular kinetics"**.

The question that lead down this road was

> "How do we perform cross-validation on tICA and MSMs ([3], [4], [1])?"

### Brief digression: What's tICA?
tICA is a linear dimensionality reduction method for multivariate
timeseries data that seeks to find the most slowly decelerating linear
functions of a set of input timeseries, $\\{X_t\\}$. You can see the papers
for more detail, but the gist of it comes down to solving a generalized
eigenvalue equation,
$$
C(\tau) v = \lambda \Sigma v,
$$
where $C(\tau)$ is the *time lagged correlation matrix*, which is a matrix containing
the average correlation of the $i$th component of the signal at time $t$ with
the $j$th component of the signal at time $t+\tau$, and $\Sigma$ is the covariance --
basically same idea, but without the time delay.

In our application domain, protein dynamics, the input signals $\\{X_t\\}$ are
usually some pre-processed (featurized) projection of our real data. We know that
there are slowly-decorrelating degrees of freedom (e.g. reaction coordinates)
in our data, but since tICA is restricted to identifying linear projections,
preprocessing via nonlinear featurizations increases the power of the method.

### Back to cross-validation
The eigenvectors which come out, $v$, are learned parameters that are estimated
subject to statistical noise. Empirically, it's obvious that some featurizations
perform better than others, and that Tikhonov regularization on $\Sigma$ can be
critical (i.e. adding some multiple of the identity to $\Sigma$). So we're
definitely going to need some procedure for scoring the set of tICS generated
from one training dataset on a new test dataset.

### Why isn't this obvious?

As presented in the papers that introduce the method ([3], [4]), solving the
tICA problem is a stepwise procedure -- you get one tIC at a time by a stepwise
maximization of a series of autocorrelation functions **with mounting, data
dependent orthogonality constraints**. The significance of this is that it's
not obvious that there is any single unified objective function for the collection
of $n>1$ tICs.

The problem is that during training, the tICs constructed such that
$v_i^T \Sigma v_j = \delta_{ij}$. But since $\Sigma$ is estimated from data, if
you try to go back and _score_ a set of tICs on new data, you need to reestimate
$\Sigma$, at which point the tICs no longer orthogonal, which is essential.
To quote from the paper.

> While [previous] formulation[s] involves the stepwise optimization
> individual *ansatz* eigenfunctions with mounting orthogonality
> constraints, our approach arrives at the same result during training
> via the optimization of a single scalar functional of a collection of
> $m$ *ansatz* eigenfunctions simultaneously. This formulation uniquely
> enables the evaluation of the proposed eigenfunctions
> on new data which was held out during the fitting step, which we show
> to be essential to avoid overfitting.

### So what's the solution?

You'll have to check out [the manuscript][2] :) Or perhaps check back here
for another post.

[1]: http://dx.doi.org/10.1063/1.3565032   "Prinz et a.l"
[2]: http://arxiv.org/abs/1407.8083        "Variational cross.."
[3]: http://dx.doi.org/10.1021/ct300878a   "Schwnates tICA"
[4]: http://dx.doi.org/10.1063/1.4811489   "Perez-Hernandex tICA"