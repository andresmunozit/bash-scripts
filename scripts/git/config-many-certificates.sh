#!/bin/bash
# set -x
# Load required functions
scriptdir="$(dirname "$0")"
. "$scriptdir/config-many-certificates-utils.sh"

# Example output: id_rsa_github.com_andresmunozit
get_private_key_name() {
  host_name=$1
  account=$2
  echo "id_rsa_${host_name}_${account}"
}

# Example output: id_rsa_github.com_andresmunozit.pub
get_public_key_name() {
  host_name=$1
  account=$2
  echo "$(get_private_key_name "$host_name" "$account").pub"
}

# When a variable is declared using single quotes it will be treated as a literal string. This means that any special
# characters, including variables, commands and escape sequences, within the single quotes will not be evaluated or
# expanded.
# ssh_config_path="~/.ssh/config", we avoid the use of the ~ character in the path since it's being treated as a
# special character by bash and it is not being expanded
ssh_config_path="$HOME/.ssh/config"
backup_suffix_format='%Y-%m-%d_%H-%M-%S'
backup_suffix="backup-$(date +"$backup_suffix_format")"

# STEP: Create a backup if the config file exists
if test -e "$ssh_config_path"; then
  backup_file_name="${ssh_config_path}_${backup_suffix}"
  cp "$ssh_config_path" "$backup_file_name"
  echo "File $ssh_config_path existed, a backup was created at $backup_file_name"
  echo "" > "$ssh_config_path"
else
  touch "$ssh_config_path"
  echo "File $ssh_config_path didn't exist and it was created"
fi

# STEP: Write the ssh_config_path file for each argument
for arg in "$@"
do
  IFS=',' read -ra parts <<< "$arg"
  host_name=${parts[0]}
  account=${parts[1]}
  private_key_name=$(get_private_key_name "$host_name" "$account")
  echo "Host $(get_host_name "$host_name" "$account")
    HostName $host_name
    User git
    IdentityFile ~/.ssh/${private_key_name}" >> "$ssh_config_path"
done
echo "Config file $ssh_config_path content:"
cat "$ssh_config_path" && echo

# STEP: Create the ssh key pairs if they don't exist
# start ssh-agent
eval `ssh-agent -s`
for arg in "$@"
do
  IFS=',' read -ra parts <<< "$arg"
  host_name=${parts[0]}
  account=${parts[1]}
  private_key_name=$(get_private_key_name "$host_name" "$account")
  public_key_name=$(get_public_key_name "$host_name" "$account")
  if ! test -e "$HOME/.ssh/$private_key_name" && ! test -e "$HOME/.ssh/$public_key_name"; then
    email=${parts[2]}
    echo "Keys $private_key_name and $public_key_name don't exist, creating..."
    ssh-keygen -t rsa -b 4096 -C "$email" -f "$HOME/.ssh/$private_key_name"
  else
    chmod 600 "$HOME/.ssh/$private_key_name"
    echo "Keys $private_key_name or $public_key_name exist, not creating"
  fi
  # Load the key to the ssh agent
  ssh-add "$HOME/.ssh/$private_key_name"
  echo
done

echo "List of identities added to SSH agent:"
ssh-add -l

# STEP: Rename ~/.ssh/id_rsa to avoid git using it by default
if test -e "$HOME/.ssh/id_rsa" || test -e "$HOME/.ssh/id_rsa.pub"; then
  mv "$HOME/.ssh/id_rsa" "$HOME/.ssh/id_rsa.$backup_suffix"
  mv "$HOME/.ssh/id_rsa.pub" "$HOME/.ssh/id_rsa.pub.$backup_suffix"
  echo
  echo "File $HOME/.ssh/id_rsa and $HOME/.ssh/id_rsa.pub have been added the sufix $backup_suffix so they are not used by default"
fi

exit 0
