

plotDependencyForAPath <- function(path="./R", prune=".onAttach", plotit=TRUE){
  
  filenames <- list.files(pattern="[.][rR]$", path=path, full.names=TRUE)

  plotDependencyForFiles(filenames, prune=prune, plotit=plotit, name= basename(path))
}  

plotDependencyForFiles <- function(filenames, prune=".onAttach", plotit=TRUE, name= "functions"){
  e <- new.env()  
  for(x in filenames) source(x, local = e)
  functionNames <- ls(env=e) #TODO : HOW TO LIST FUNCTIONS IN FILES
  plotFunctionDependency(functionNames, name =name, prune=prune, plotit=plotit)
} 

plotDependencyForAPackage <- function(package, prune=".onAttach", plotit=TRUE){ 
  
  library(package, character.only = TRUE)
  
  functionNames <- as.character(lsf.str(paste0("package:", package)))
  
  plotFunctionDependency(functionNames, name =package, prune=prune, plotit=plotit)
}
  

plotFunctionDependency <- function(functionNames, name = "plot", prune=".onAttach", plotit=TRUE){  
  
  library(mvbutils, quietly=TRUE)  
  
  f <- foodweb(functionNames, plotting=FALSE)
  
  foodwebSummary <- summary(f)
  
  # prune functions:
  if(length(prune) > 0 && all(is.character(prune)))
    foodwebSummary[[prune]] <- NULL
  
  graph <- makeDependencyGraph(foodwebSummary)
  
  # Make .dot file (input for graphViz)
  makeGraphVizPlot(paste0(name, "-dep"), graph)
  
  return(invisible(foodwebSummary))
}

# make graph of function dependencies
# (mostly written by :
# Francois Romain 'Rcpp reverse dependency graph' (http://romainfrancois.blog.free.fr/index.php?post/2011/10/30/Rcpp-reverse-dependency-graph)

makeDependencyGraph <- function(foodwebSummary){
  
  fs<- foodwebSummary
  graph <- character(0)
  for(i in 1:length(fs)){
    for(j in 1:length(fs[[i]])){
      fun <- names(fs)[i]
      dep <- fs[[i]][j]
      
      # It seems graphViz does not like special characters here...
      # Is there a workaround?
      fun <- gsub("\\.", "", fun)
      dep <- gsub("\\.", "", dep)
      
      graph <- c(graph, sprintf("%s->%s",fun,dep)) 
    }
  }
  graph
}

summary.foodweb <- function(x,...){
  
  l <- apply(x$funmat, 1, function(f)names(f[f==1]))
  emp <- sapply(l, length)
  theseemp <- which(emp==0)
  l2 <- l[setdiff(1:length(l), theseemp)]
  
  return(l2)
}

makeGraphVizPlot <- function(name, graph){
  fname <-paste0(name, ".dot")
  output <- file(fname, open = "w" )
  writeLines( "digraph G {", output )
  writeLines( "   rankdir=LR;", output )
  writeLines( sprintf( "%s ; ", graph), output )
  writeLines( "}", output )
  close(output)
  system(paste0("dot -Tpng ", fname, " > " ,sub(".dot", ".png", fname, fixed = TRUE)))  
}
