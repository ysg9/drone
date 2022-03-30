#!/bin/sh
set -ex

unset CGO_ENABLED

# update deps
go mod edit -droprequire=github.com/Azure/azure-storage-blob-go
go mod edit -replace github.com/gogo/protobuf=github.com/gogo/protobuf@v1.3.2
go mod tidy

go build -o drone-server ./cmd/drone-server
ls -l drone-server
rm -f .dockerignore

# for deps scanning
go list -m all > go.list
ls -l go.list

