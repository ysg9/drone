#!/bin/sh
set -ex

unset CGO_ENABLED

# update deps
go mod edit -droprequire=github.com/Azure/azure-storage-blob-go
go mod edit -replace github.com/gogo/protobuf=github.com/gogo/protobuf@v1.3.2
go mod edit -replace github.com/containerd/containerd=github.com/containerd/containerd@v1.6.6
go mod edit -replace github.com/miekg/dns=github.com/miekg/dns@v1.1.49
go mod tidy

go build -o drone-server ./cmd/drone-server
ls -l drone-server
rm -f .dockerignore

# for deps scanning
go list -m all > go.list
ls -l go.list

# nancy whitelist
cat > .nancy-ignore <<EOF
CVE-2022-29153
CVE-2022-24687
EOF
