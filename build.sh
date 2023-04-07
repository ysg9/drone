#!/bin/sh
set -ex

unset CGO_ENABLED

# update deps
go mod edit -droprequire=github.com/Azure/azure-storage-blob-go
go mod edit -replace github.com/gogo/protobuf=github.com/gogo/protobuf@v1.3.2
go mod edit -replace github.com/miekg/dns=github.com/miekg/dns@v1.1.53
go mod edit -replace github.com/containerd/containerd=github.com/containerd/containerd@v1.6.20
go mod edit -replace golang.org/x/text=golang.org/x/text@v0.9.0
go mod edit -replace golang.org/x/net=golang.org/x/net@v0.9.0
go mod edit -replace github.com/emicklei/go-restful/v3=github.com/emicklei/go-restful/v3@v3.10.2
go mod tidy

go build -o drone-server ./cmd/drone-server
ls -l drone-server
rm -f .dockerignore

# for deps scanning
go list -m all > go.list
ls -l go.list

# nancy whitelist
# CVE-2022-29153: not using consul
echo CVE-2022-29153 > .nancy-ignore
#CVE-2022-24687
