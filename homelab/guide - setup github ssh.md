[Source](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

**1. Generate SSH Key**
```shell
ssh-keygen -t ed25519 -C "your_email@example.com"
```

1. Save to `~/.ssh/id_ed25519_github`
2. Enter passphrase.

**2. Get public key**
```shell
cat ~/.ssh/id_ed25519_github.pub
```

**3. Add public key to GitHub**

1. Go to https://github.com/settings/keys
2. Enter public key in input box

**4. Add SSH key to ssh-agent**

1. Start the ssh-agent in the background
```shell
eval "$(ssh-agent -s)"
```

2. Add SSH private key to the ssh-agent.
```shell
ssh-add ~/.ssh/id_ed25519_github
```

**5. (Optional) Create alias to automate step 4**

Why automate? Step 4 only last for a few minutes, you need to do step 4 every time you want to push/pull

```shell
# add into ~/.bash_aliases
alias git-agent='eval "$(ssh-agent -s)"; ssh-add ~/.ssh/id_ed25519_github;'
```

**IMPORTANT:** use passphrase while generating ssh key for extra security