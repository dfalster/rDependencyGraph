rDependencyGraph
================

Makes a plot

Originally inspired by an analysis and code from
[Romain francois](http://romainfrancois.blog.free.fr/index.php?post/2011/10/30/Rcpp-reverse-dependency-graph)
on the dependency in the Rcpp package, then modified by Remko Duursma and Daniel Falster.

Requires [graphviz](http://www.graphviz.org/Download..php) to be installed first.

Three functions

- `plotDependencyForAPath(path="./R", prune=".onAttach", plotit=TRUE)`
- `plotDependencyForFiles(filenames, prune=".onAttach", plotit=TRUE, name= "functions")`
- `plotDependencyForAPackage(package, prune=".onAttach", plotit=TRUE)`
