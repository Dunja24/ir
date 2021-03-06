% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ir_average.R
\name{ir_average}
\alias{ir_average}
\title{Averages infrared spectra within groups.}
\usage{
ir_average(x, ...)
}
\arguments{
\item{x}{An object of class \code{\link[ir:ir_new_ir]{ir}}.}

\item{...}{Variables in \code{x} to use as groups.}
}
\value{
An object of class \code{ir}.
}
\description{
\code{ir_average} averages infrared spectra within
a user-defined group. \code{NA} values are omitted by default
}
