﻿#!/usr/bin/with-contenv bash

set -ex

HOME=/config
export HOME

s6-setuidgid abc /app/protonmail/proton-bridge --cli init