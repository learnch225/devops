ENV_NAME=$(awk -F= '/^environment/ {gsub(/ /, "", $2); print toupper($2)}' /etc/salt/grains)