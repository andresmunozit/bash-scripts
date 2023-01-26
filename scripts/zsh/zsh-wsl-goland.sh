#!/bin/bash
function goland() {
    powershell.exe -c goland $(wslpath -w $1)
}
