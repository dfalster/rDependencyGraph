
# in the prune argument you can list functions you don't want in the
# dependency graph, .onAttach() is a typically hidden function that
# executes stuff when the package is attached (see R-exts)

dependencyForAPath <- function(path="./R", prune=".onAttach"){
  
  filenames <- list.files(pattern="[.][rR]$", path=path, full.names=TRUE)

  dependencyForFiles(filenames, prune=prune)
}  

dependencyForFiles <- function(filenames, prune=".onAttach"){
  e <- new.env()  
  for(x in filenames) source(x, local = e)
  functionNames <- ls(env=e) 
  dependencyForFunctions(functionNames,  prune=prune)
} 

dependencyForAPackage <- function(package, prune=".onAttach"){ 
  
  library(package, character.only = TRUE, quietly=TRUE)
  
  functionNames <- as.character(lsf.str(paste0("package:", package)))
  
  dependencyForFunctions(functionNames,  prune=prune)
}
  

dependencyForFunctions <- function(functionNames, prune=".onAttach"){  
  
  library(mvbutils, quietly=TRUE)  
  
  f <- foodweb(functionNames)
  
  foodwebSummary <- summary(f)
  
  # prune functions:
  if(length(prune) > 0 && all(is.character(prune)))
    foodwebSummary[[prune]] <- NULL
  
  graph <- makeDependencyGraph(foodwebSummary)
  
  obj <-list(graph =graph, foodwebSummary= invisible(foodwebSummary), foodweb = f)
  class(obj) <- "dependency"
  obj
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
      graph <- c(graph, sprintf("%s->%s",fun,dep)) 
    }
  }
  graph
}

# It seems graphViz does not like special characters, replace with capital letters
sanitize<-function(x){
  s <- c(".", "?", "!", "$","*", "%", "&")
  for(i in seq_along(s))
    x <- gsub(s[i], LETTERS[i], x, fixed=TRUE)
  x  
}

summary.foodweb <- function(x,...){
  
  l <- apply(x$funmat, 1, function(f)names(f[f==1]))
  emp <- sapply(l, length)
  theseemp <- which(emp==0)
  l2 <- l[setdiff(1:length(l), theseemp)]
  
  return(l2)
}

plot.dependency <- function(x, name = "dependency-plot"){
  x$graph <- sanitize(x$graph)
  
  fname <-paste0(name, ".dot")
  output <- file(fname, open = "w" )
  writeLines( "digraph G {", output )
  writeLines( "   rankdir=LR;", output )
  writeLines( sprintf( "%s ; ", x$graph), output )
  writeLines( "}", output )
  close(output)
  cmd <- paste0("dot -Tpng ", fname, " > " ,sub(".dot", ".png", fname, fixed = TRUE))
  system(cmd)  
  cmd
}
