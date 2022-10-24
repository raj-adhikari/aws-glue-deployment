# --- root/main.tf ---

# module "networking" {
#   source       = "./networking"
#   vpc_cidr     = "10.0.0.0/16"
#   public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
# }

# module "compute" {
#   source        = "./compute"
#   web_sg        = module.networking.web_sg
#   public_subnet = module.networking.public_subnet
# }


#===========================================
variable "job_language" {
  default = "python"
}

variable "bucket_name" {
  default = "glue-scripts-6587"
}

variable "temp_dir" {
  default = "glue-scripts-6587/temp"
}

variable "glue_arn" {
  default = "arn:aws:iam::356585319840:role/glue-default-role"

}
variable "job_name" {
  default = "compress-small-files-large-files"
}
variable "file_name" {
  default = "glue-compress.py"
}
variable "max_capacity" {
  default = "10"
}
variable "python_version" {
  default ="3"
}
variable "worker_type" {
  default = "G.1X"
}
#===========================================

# resource "aws_s3_object" "upload-glue-script" {
#   bucket = "${var.bucket_name}"
#   key = "Scripts/${var.file_name}"
#   source = "${var.file_name}"
# }

resource "aws_glue_job" "pyspark_glue_job" {
  name = "${var.job_name}"
  role_arn = "${var.glue_arn}"

  command {
    script_location = "s3://${var.bucket_name}/Scripts/${var.file_name}"
    name = "glueetl"
    python_version = "${var.python_version}"
  }

  default_arguments = {
  "--job-language" = "${var.job_language}"
  "--job-bookmark-option" = "job-bookmark-disable"
  "--TempDir" = "s3://${var.temp_dir}"
  }

  glue_version = "3.0"
  worker_type = "${var.worker_type}"
  number_of_workers = "10"
  timeout = "2880"
  max_retries = "0"
}