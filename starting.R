library(dplyr)
library(purrr)
library(aws.s3)
library(qs)

bucket <- "another-test-johan-rosa"
put_bucket(bucket)

write_object <- function(object, name, bucket) {
  file <- tempfile(fileext = ".qs")
  qs::qsave(object, file)
  put_object(
    file = file,
    object = paste0(name, ".qs"),
    bucket = bucket
  )
}

read_object <- function(object, bucket) {
  path <- tempfile()
  aws.s3::save_object(
    file = path,
    object = object,
    bucket = bucket
  )
  obj <- qs::qread(file = path)
  unlink(path)
  return(obj)
}

write_object(mtcars, "mtcars", bucket)
read_object("mtcars.qs", bucket)

aws.s3::get_bucket_df(bucket)
