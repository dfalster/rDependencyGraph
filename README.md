rDependencyGraph
================

Makes a plot of function relations.

Originally inspired by an analysis and code from
[Romain francois](http://romainfrancois.blog.free.fr/index.php?post/2011/10/30/Rcpp-reverse-dependency-graph)
on the dependency in the Rcpp package, then modified by Remko Duursma and Daniel Falster.

Requires [graphviz](http://www.graphviz.org/Download..php) to be installed first.

Three functions

- `dependencyForAPath(path="./R", prune=".onAttach", plotit=TRUE)`
- `dependencyForFiles(filenames, prune=".onAttach", plotit=TRUE, name= "functions")`
- `dependencyForAPackage(package, prune=".onAttach", plotit=TRUE)`

each returns an object of type 'dependency', can b passed to plot function.

Currently crashes when function lists contains illegal characters, see https://github.com/dfalster/rDependencyGraph/issues/1

Note food web function also has plt option, currently enabled, so entire purpose of this package is to make a flat 2D plot.
