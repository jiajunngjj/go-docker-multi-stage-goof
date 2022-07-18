# Snyk Container Multi-Stage Demo

## Build the image and scan with Snyk

1. Build the image with Docker:

```docker build -t go-docker-goof .```

2. Push the image into your own repo

3. Run Snyk container test:

```snyk container test jiajunngjj/go-docker-goof --dockerfile=Dockerfile```

Result will show that it picks up the final FROM.

## Introduce an image layer which include Snyk before the final FROM

Build the image layer:

```docker build -t go-multi-docker-goof-snyk:build_snyk -f Dockerfile --target build-with-snyk```

Run Snyk test before building the final image:

```docker run --rm -e SNYK_TOKEN go-multi-docker-goof-snyk:build_snyk snyk config set SNYK_TOKEN; snyk test```
