#!/bin/bash

env $(cat "${@:1:1}" | grep -v '#' | xargs) ${@:2}
