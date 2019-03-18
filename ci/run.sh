#! /bin/bash

set -e

helmfile diff --suppress-secrets
