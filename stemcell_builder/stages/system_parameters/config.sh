#!/usr/bin/env bash

set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_config.bash

persist_value stemcell_infrastructure
persist_value stemcell_operating_system
persist_value stemcell_version
