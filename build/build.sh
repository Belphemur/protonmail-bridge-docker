#!/bin/bash

set -ex

VERSION=$1
target_grpc_version="v1.79.3"

# Clone new code
git clone https://github.com/ProtonMail/proton-bridge.git --depth 1 --branch v$VERSION
cd proton-bridge
sed -i 's/127.0.0.1/0.0.0.0/g' internal/constants/constants.go

# Update vulnerable grpc to fix GHSA authorization bypass (< v1.79.3)
 current_grpc_version="$(go list -m -f '{{.Version}}' google.golang.org/grpc 2>/dev/null || true)"
 if [[ -z "$current_grpc_version" ]] || [[ "$(printf '%s\n' "${current_grpc_version#v}" "${target_grpc_version#v}" | sort -V | head -n1)" != "${target_grpc_version#v}" ]]; then
 	go get google.golang.org/grpc@"$target_grpc_version"
 fi
go mod tidy

ARCH=$(uname -m)
if [[ $ARCH == "armv7l" ]] ; then
	# This is expected to fail, and we use the following patch to fix
	make build-nogui || true
	# For 32bit architectures, there was a overflow error on the parser
	# This is a workaround for this problem found at:
	#   https://github.com/antlr/antlr4/issues/2433#issuecomment-774514106
	find $(go env GOPATH)/pkg/mod/github.com/\!proton\!mail/go-rfc5322*/ -type f -exec sed -i.bak 's/(1<</(int64(1)<</g' {} +
fi

# Build
make build-nogui
