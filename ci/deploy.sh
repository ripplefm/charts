#! /bin/bash

set -e

helmfile apply --suppress-secrets
