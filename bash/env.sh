#!/bin/bash

env -i $(cat "${@:1:1}" | xargs) ${@:2}
