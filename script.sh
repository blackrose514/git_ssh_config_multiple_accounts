#! /bin/bash

read -p "Enter 1st user name: " acc1_name
read -p "Enter 1st user email: " acc1_email
read -p "Enter 2nd user name: " acc2_name
read -p "Enter 2nd user email: " acc2_email

mkdir -p "$HOME/projects/$acc1_name"
mkdir -p "$HOME/projects/$acc2_name"

# Generate SSH keys
ssh-keygen -t ed25519 -C $acc1_email -N "" -f "$HOME/.ssh/github-$acc1_name"
ssh-keygen -t ed25519 -C $acc2_email -N "" -f "$HOME/.ssh/github-$acc2_name"

# Start ssh-agent
eval "$(ssh-agent -s)"

# Add SSH private keys to ssh-agent
ssh-add "$HOME/.ssh/github-$acc1_name"
ssh-add "$HOME/.ssh/github-$acc2_name"

# Create local .gitconfig for second account
sed \
-e "s/<acc2_name>/${acc2_name}/g" \
-e "s/<acc2_email>/${acc2_email}/g" \
./acc2.gitconfig > "$HOME/projects/${acc2_name}/${acc2_name}.gitconfig"

# Create global .gitconfig
sed \
-e "s/<acc1_name>/${acc1_name}/g" \
-e "s/<acc1_email>/${acc1_email}/g" \
-e "s/<acc2_name>/${acc2_name}/g" \
-e "s/<acc2_email>/${acc2_email}/g" \
./global.gitconfig > ~/.gitconfig

# Edit SSH config
sed \
-e "s/<acc1_name>/${acc1_name}/g" \
-e "s/<acc2_name>/${acc2_name}/g" \
./config > ~/.ssh/config

echo ""
echo "Public key for 1st account (${acc1_name}):"
cat "$HOME/.ssh/github-${acc1_name}.pub"

echo "Public key for 2nd account (${acc2_name}):"
cat "$HOME/.ssh/github-${acc2_name}.pub"

