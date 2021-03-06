#' Generate Erdos-Renyi precision matrix
#'
#' Estimate a precision matrix with a Erdos-Renyi network structure and simulate multivariate normal data.
#'
#' @param p       Dimension of network
#' @param prop    rewiring probability
#' @param numT    number of timepoints
#' @return
#' A list with components
#' \item{Precision}{Estimated p by p inverse covariance matrix}
#' \item{Data}{Data matrix containing the simulated time series for each region (numT by p data matrix)}
#'
#' @references Csardi G, Nepusz T: The igraph software package for complex network research, InterJournal, Complex Systems 1695. 2006. \url{http://igraph.org}
#' @examples
#' fit<-ErdosRenyi(40,.15,200)
#' fit$Precision
#' fit$Data
#' @export

ErdosRenyi<-function(p, prop,numT){
  Results=list();
  grpobj<-erdos.renyi.game(p, prop, type = "gnp", directed = FALSE,loops = FALSE)
  testgrh<-as.matrix(as_adjacency_matrix(grpobj, type = "both", attr = NULL,edges = FALSE, names = TRUE,sparse=FALSE))
  GrphT<-matrix(0,p,p)
  indices=which(testgrh[upper.tri(testgrh)]==1)
  GrphT[upper.tri(GrphT)][indices]=rnorm(length(indices),mean=0,sd=.5)
  GrphT=GrphT+t(GrphT)

  diag(GrphT)=rowSums(abs(GrphT))+rep(.25,p)

  prec2sigma=solve(GrphT)
  interm=eigen(prec2sigma)
  sqrtmat=interm$vectors%*%diag(sqrt(interm$values))%*%solve(interm$vectors)

  SMdat <- matrix(rnorm(numT * p), ncol=p) %*%sqrtmat
  Results$Precision=GrphT;
  Results$Data=SMdat;
  return(Results)
}




