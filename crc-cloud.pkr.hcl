packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.6"
      source = "github.com/hashicorp/amazon"
    }
  }
}

variable bundle-download-url {
  description = "Set the full url to download the bundle to be exported"
  default = ""
}
variable shasumfile-download-url {
  description = "Set the full url to download the shasumfile to check the bundle"
  default = ""
}

// variables for ocp preset
variable ocp-default-url-format {  
  default = "https://mirror.openshift.com/pub/openshift-v4/clients/crc/bundles/openshift/%s"
}
variable ocp-default-bundlename-format {  
  default = "crc_libvirt_%s_amd64.crcbundle"
}
variable ocp-default-shasumfilename {  
  default = "sha256sum.txt"
}
variable ocp-default-version {
  default = "4.11.18"
}
 
locals {
  // compose values
  bundle-url = (var.bundle-download-url != "" ? 
    var.bundle-download-url : 
    "${format(var.ocp-default-url-format, var.ocp-default-version)}/${format(var.ocp-default-bundlename-format, var.ocp-default-version)}")
  shasumfile-url = (var.shasumfile-download-url != "" ? 
    var.bundle-download-url : 
    "${format(var.ocp-default-url-format, var.ocp-default-version)}/${var.ocp-default-shasumfilename}")
}

source null local {
  communicator = "none"
}

build {
  name = "crc-cloud"

  sources = ["null.local"]

  provisioner shell-local {

    environment_vars = [
      "SHASUMFILE_DOWNLOAD_URL=${local.shasumfile-url}",
      "BUNDLE_DOWNLOAD_URL=${local.bundle-url}"]

    script = "./image-exporter.sh"

  }

  # Add post processor for import image on AWS
  // https://developer.hashicorp.com/packer/plugins/post-processors/amazon

  # Add post processor for import image on GCP it uses the compressed format from script
  // https://developer.hashicorp.com/packer/plugins/post-processors/googlecompute/googlecompute-import

  # Check image import for azure it seems it is required vhd
  // https://learn.microsoft.com/en-us/azure/virtual-machines/linux/create-upload-generic



}