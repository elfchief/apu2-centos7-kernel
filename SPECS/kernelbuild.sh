#!/bin/sh
rpmbuild -ba --target x86_64 --without kdump --without tools --without perf --without debug kernel.spec
