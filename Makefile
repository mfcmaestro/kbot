#APP=$(shell basename $(shell git rev-parse --show-toplevel))
APP=kbot
REGISTRY=vdubovets
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
GO_BUILD=go build -v -o kbot -ldflags "-X="github/mfcmaestro/kbot/cmd.appVersion=${VERSION}

TARGETOS=linux #linux darwin windows
TARGETARCH=amd64 #amd64 arm64

format:
	gofmt -s -w ./

lint:
	go lint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} ${GO_BUILD}

linux: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} ${GO_BUILD}

arm: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=arm64 ${GO_BUILD}

amd: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=amd64 ${GO_BUILD}

windows: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=${TARGETARCH} ${GO_BUILD}

darwin: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=${TARGETARCH} ${GO_BUILD}

image:
	docker build --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH} . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}