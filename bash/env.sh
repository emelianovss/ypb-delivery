#!/bin/bash

env $(cat "${@:1:1}" | xargs) ${@:2}
