#' Imports infrared spectra from various files.
#'
#' \code{ir_import_spc} imports raw infrared spectra from a Thermo Galactic's
#' .spc file or several of such files. \code{ir_import_spc} is a wrapper function
#' to \code{\link[hyperSpec:read.spc]{read.spc}}.
#'
#' @param filenames A character vector representing the complete paths to
#' the .spc files to import.
#' @return An object of class \code{\link[ir:ir_new_ir]{ir}} containing the infrared spectra
#' extracted from the .spc file(s) and the metadata as extracted by
#' \code{\link[hyperSpec:read.spc]{read.spc}}. Metadata variables are:
#' \describe{
#'   \item{scan_number}{An integer value representing the number of scans.}
#'   \item{detection_gain_factor}{The detection gain factor.}
#'   \item{scan_speed}{The scan speed [kHz].}
#'   \item{laser_wavenumber}{The wavenumber of the laser.}
#'   \item{detector_name}{The name of the detector.}
#'   \item{source_name}{The name of the infrared radiation source.}
#'   \item{purge_delay}{The duration of purge delay before a measurement [s].}
#'   \item{zero_filling_factor}{A numeric value representing the zero filling factor.}
#'   \item{apodisation_function}{The name of the apodisation function.}
#'   \item{exponentiation factor}{The exponentiation factor used for file compression.}
#'   \item{data_point_number}{The number of data points in the spectrum}
#'   \item{x_variable_type}{The type of the x variable.}
#'   \item{y_variable_type}{The type of the y variable.}
#'   \item{measurement_date}{A POSIXct representing the measurement date and time.}
#'   \item{measurement_device}{The name of the measurement device.}
#' }
#' @export
ir_import_spc <- function(filenames) {

  d <- purrr::map(filenames, function(x){
    hyperSpec::read.spc(x,
                        log.txt = TRUE,
                        log.bin = TRUE,
                        log.disk = TRUE,
                        keys.hdr2data = TRUE,
                        keys.log2data = TRUE,
                        no.object = FALSE)
  })
  metadata <- purrr::map_df(d, function(x){
    data.frame(
      sample_id = stringr::str_remove_all(x@data$NAME, '"'),
      scan_number = as.integer(x@data$SCANS),
      detector_gain_factor = as.numeric(x@data$GAIN),
      scan_speed = as.numeric(stringr::str_extract(x@data$SPEED, "\\d")),
      laser_wavenumber = as.numeric(x@data$LWN),
      detector_name = stringr::str_remove_all(x@data$DET, '"'),
      source_name = stringr::str_remove_all(x@data$SRC, '"'),
      purge_delay = as.numeric(x@data$PURGE), # ___ todo: check unit
      zero_filling_factor = as.numeric(x@data$ZFF),
      apodisation_function = stringr::str_remove_all(x@data$APOD, '"'),
      exponentiation_factor = as.numeric(x@data$fexp),
      data_point_number = as.numeric(x@data$fnpts),
      x_variable_type = x@data$fxtype,
      y_variable_type = x@data$fytype,
      measurement_date = as.POSIXct(x@data$fdate),
      measurement_device = x@data$fsource,
      stringsAsFactors = FALSE
    )
  })
  metadata$measurement_id <- seq_len(nrow(metadata))
  spectra <- purrr::map(d, function(x){
    data.frame(x = x@wavelength,
               y = x@data$spc[1, , drop = TRUE],
               stringsAsFactors = FALSE)
  })

  d <- ir_new_ir(spectra = spectra,
            sample_id = metadata$sample_id,
            metadata = metadata)
  d$scan_speed <- units::set_units(d$scan_speed, "kHz")
  d$purge_delay <- units::set_units(d$purge_delay, "s")
  d

}
