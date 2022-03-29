#!/bin/sh
set -ex

# update deps
go mod edit -replace github.com/dgrijalva/jwt-go=github.com/dgrijalva/jwt-go/v4@v4.0.0-preview1
go mod edit -replace github.com/gogo/protobuf=github.com/gogo/protobuf@v1.3.2
go mod tidy

go build -o drone-server ./cmd/drone-server
ls -l drone-server
rm -f .dockerignore

# for deps scanning
go list -m all > go.list
ls -l go.list

