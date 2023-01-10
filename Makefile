VERSION ?= 0.0.1
CONTAINER_MANAGER ?= podman
# Image URL to use all building/pushing image targets
IMG ?= quay.io/ariobolo/crc-cloud-builder:${VERSION}

# Build the container image
.PHONY: oci-build
oci-build: 
	${CONTAINER_MANAGER} build -t ${IMG} -f oci/Containerfile .

# Push the container image
.PHONY: oci-push
oci-push:
	${CONTAINER_MANAGER} push ${IMG}
	
# Run container image with linked files to quick dev and test
.PHONY: oci-dev
oci-dev:
	${CONTAINER_MANAGER} run -it --rm --entrypoint=bash -v ${PWD}:/workspace:z ${IMG}
