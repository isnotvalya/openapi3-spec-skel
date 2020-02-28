#!/bin/zsh

SERVE_PORT=${SERVE_PORT:-8888}

IMAGE_DOCS=pensioner/redoc-cli
IMAGE_DOCS_TAG=0.9.6

GIT_COMMIT="$(git rev-parse --short HEAD)"
GIT_COMMIT=${GIT_COMMIT:-unknown}

serve_docs_for_dev() {
    echo "* Starting docs server on http://127.0.0.1:$SERVE_PORT/"
    docker run --rm -p $SERVE_PORT:$SERVE_PORT -v $(pwd):/data:ro $IMAGE_DOCS:$IMAGE_DOCS_TAG serve \
        -t /data/templates/main.hbs \
        -s -w -p $SERVE_PORT index.yaml
}

build_public_docs() {
    docker run --rm -v $(pwd):/data $IMAGE_DOCS:$IMAGE_DOCS_TAG bundle \
        --title "Public API (version: $GIT_COMMIT)" \
        -t /data/templates/main.hbs \
        -o /data/docs.html \
        index.yaml
}

case "$1" in
    # serve)
    #     serve_docs_for_dev
    # ;;
    build)
        build_public_docs
    ;;
    *)
        echo "Usage: $(basename "$0") <build>"
        exit 1
    ;;
esac
