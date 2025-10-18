build-asset-debug:
	npx rollup -c --configBuildDebug --bundleConfigAsCjs
.PHONY: build-asset-debug

build-asset-release:
	npx rollup -c --configBuildRelease --bundleConfigAsCjs
.PHONY: build-asset-release

build-asset: build-asset-debug
.PHONY: build-asset

build-debug: clean build-asset-debug
	npx elm-land build
.PHONY: build-debug

build-release: clean build-asset-release
	npx elm-land build
.PHONY: build-release

build: build-debug
.PHONY: build

clean:
	@rm -fr dist/*
	@rm -fr static/assets/**/*.{css,js,*.map}
.PHONY: clean

server: build-asset-debug
	@npx elm-land server
.PHONY: server

watch-asset:
	npx rollup -w -c --configBuildDebug --bundleConfigAsCjs
.PHONY: watch-asset
