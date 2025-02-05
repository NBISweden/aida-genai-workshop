#!/bin/bash
chmod 644 /usr/local/share/ca-certificates/verdi.crt
update-ca-certificates

# Switch to comfyui user and execute command
exec gosu comfyui "$@"