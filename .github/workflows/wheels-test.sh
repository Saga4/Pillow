#!/bin/bash
set -e

# For Unix, ensure fribidi is installed by the system.
if [[ "$OSTYPE" != "darwin"* ]]; then
    if [ "${AUDITWHEEL_POLICY::9}" == "musllinux" ]; then
        apk add curl fribidi
    else
        yum install -y fribidi
    fi
fi

python3 -m pip install numpy

if [ ! -d "test-images-main" ]; then
    curl -fsSL -o pillow-test-images.zip https://github.com/python-pillow/test-images/archive/main.zip
    unzip pillow-test-images.zip
    mv test-images-main/* Tests/images
fi

# Runs tests
python3 selftest.py
python3 -m pytest Tests/check_wheel.py
python3 -m pytest
