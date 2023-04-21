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

#go build -tags "oss nolimit" -o drone-server ./cmd/drone-server
go build -o drone-server ./cmd/drone-server
ls -l drone-server
rm -f .dockerignore

# for deps scanning
go list -m all > go.list
ls -l go.list

# nancy whitelist
# CVE-2022-29153: not using consul
echo CVE-2022-29153 > .nancy-ignore
#
# CVE-2020-8561: Webhook redirect in kube-apiserver
# fixed by configuring kube-apiserver with --profile=false
# https://github.com/kubernetes/kubernetes/issues/104720
echo CVE-2020-8561 >> .nancy-ignore
#
# sonatype-2022-6522: profiling info served on unix-domain socket
# to be fixed in v0.28
# https://github.com/kubernetes/apiserver/commit/76a233ebec7963131ddf3f59221bef5387d5b8ac
# meanwhile, we don't use k8s in drone-server
echo sonatype-2022-6522 >> .nancy-ignore
#
#CVE-2022-24687
