#!/bin/bash

set -ex

HOME=/config
export HOME

s6-setuidgid abc /app/protonmail/proton-bridge --cli