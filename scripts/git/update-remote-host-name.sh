#!/bin/sh
# set -x
# Run this script from the repo you want to update the remote

# Running the script from its location allow to keep all the references
scriptdir="$(dirname "$0")"
. "$scriptdir/config-many-certificates-utils.sh"

# STEP: Get current old and host_name
old_remote=$(git config --get remote.origin.url)
old_host_name=$(echo "$old_remote" | awk -F: '{print $1}' | awk -F@ '{print $2}')
account=$(echo "$old_remote" | awk -F/ '{print $1}' | awk -F: '{print $2}')
echo "Old remote: $old_remote"

# STEP: Check if the old host name contains already the account, if so no change is requred
if [[ $old_host_name == *"$account"* ]]; then
    echo "The remote is already updated (it contains the account in the hostname): $old_remote"
    echo "Exiting the script..."
    exit
fi

# STEP: Compute the new remote and set it to the current repo
new_host_name=$(get_host_name "$old_host_name" "$account")
new_remote=$(echo "$old_remote" | sed "s/$old_host_name/$new_host_name/g")
git remote set-url origin "$new_remote"
echo "New remote: $(git config --get remote.origin.url)"
