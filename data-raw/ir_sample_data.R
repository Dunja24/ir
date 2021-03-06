## code to prepare `sample_data` dataset goes here

devtools::load_all()

d_mir <- utils::read.csv("./data-raw/klh_hodgkins_mir.csv",
                         header = TRUE)
d_reference <- utils::read.csv("./data-raw/klh_hodgkins_reference.csv",
                               header = TRUE,
                               as.is = TRUE)

colnames(d_mir)[1] <- "x"
d_mir <- ir_stack(d_mir)
metadata <- tibble::tibble(
  measurement_id = seq_along(d_mir$spectra),
  sample_id = d_reference$Sample.Name,
  sample_type = d_reference$Category,
  sample_comment = d_reference$Description,
  klason_lignin = units::set_units(d_reference$X..Klason.lignin..measured./100, "1"),
  holocellulose = units::set_units(d_reference$X..Cellulose...Hemicellulose..measured./100, "1")
)

ir_sample_data <- ir_new_ir(spectra = d_mir$spectra,
                         sample_id = metadata$sample_id,
                         metadata = metadata)

usethis::use_data(ir_sample_data, overwrite = TRUE)
