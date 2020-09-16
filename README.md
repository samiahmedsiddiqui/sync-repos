# Sync Repos

It helps when you have a private repo where you are developing the features and then wants to push it to the public repo.

## Default branch

### Parameters

| Argument |  Type  | Required | Description                                                                                                                                                                            |
|----------|:------:|:--------:|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| From     | String |    Yes   | Repository name, from where the repository needs to be synced. Like `samiahmedsiddiqui/sync-repos-private`                                                                             |
| To       | String |    Yes   | Repository name that needs to be synced. Like `samiahmedsiddiqui/sync-repos`                                                                                                           |
| Message  | String |    No    | Commit message if not passed then the default message is used.<br><br><br>**Default:** `Sync with ${From} repo`. `${From}` is the Repo name that is passed as the first argument.      |

### Usage

#### Sync any Repo

To sync from GitHub Repo to GitLab repo and vice versa or To use SSH for cloning repos.

```bash
# Without commit message
./sync-default-repos.sh https://github.com/samiahmedsiddiqui/sync-repos-private.git https://gitlab.com/samiahmedsiddiqui/sync-repos.git

# With commit message
./sync-default-repos.sh https://github.com/samiahmedsiddiqui/sync-repos-private.git https://gitlab.com/samiahmedsiddiqui/sync-repos.git Fetching latest updates
```

#### For GitHub (Clone through HTTPS)

```bash
# Without commit message
./sync-default-repos-github.sh samiahmedsiddiqui/sync-repos-private samiahmedsiddiqui/sync-repos 

# With commit message
./sync-default-repos-github.sh samiahmedsiddiqui/sync-repos-private samiahmedsiddiqui/sync-repos Fetching latest updates
```

#### For GitLab (Clone through HTTPS)

```bash
# Without commit message
./sync-default-repos-gitlab.sh samiahmedsiddiqui/sync-repos-private samiahmedsiddiqui/sync-repos 

# With commit message
./sync-default-repos-gitlab.sh samiahmedsiddiqui/sync-repos-private samiahmedsiddiqui/sync-repos Fetching latest updates
```

## Any other branch

### Parameters

| Argument |  Type  | Required | Description                                                                                                                                                                            |
|----------|:------:|:--------:|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| From     | String |    Yes   | Repository name, from where the repository needs to be synced. Like `samiahmedsiddiqui/sync-repos-private`                                                                             |
| Branch   | String |    Yes   | Branch name from where to get the latest updates.                                                                                                                                      |
| To       | String |    Yes   | Repository name that needs to be synced. Like `samiahmedsiddiqui/sync-repos`                                                                                                           |
| Branch   | String |    No    | Branch name, where to sync the updates.<br><br>**Default:** Use the same branch name as the `${From}` branch (second argument). It is required if you like to pass the commit message. |
| Message  | String |    No    | Commit message if not passed then the default message is used.<br><br><br>**Default:** `Sync with ${From} repo`. `${From}` is the Repo name that is passed as the first argument.      |

### Usage

#### Sync any Repo

To sync from GitHub Repo to GitLab repo and vice versa or To use SSH for cloning repos.

```bash
# Without commit message
./sync-repos.sh https://github.com/samiahmedsiddiqui/sync-repos-private.git https://gitlab.com/samiahmedsiddiqui/sync-repos.git

# With commit message
./sync-repos.sh https://github.com/samiahmedsiddiqui/sync-repos-private.git https://gitlab.com/samiahmedsiddiqui/sync-repos.git Fetching latest updates
```

#### For GitHub (Clone through HTTPS)

```bash
# Without commit message
./sync-repos-github.sh samiahmedsiddiqui/sync-repos-private samiahmedsiddiqui/sync-repos 

# With commit message
./sync-repos-github.sh samiahmedsiddiqui/sync-repos-private samiahmedsiddiqui/sync-repos Fetching latest updates
```

#### For GitLab (Clone through HTTPS)

```bash
# Without commit message
./sync-repos-gitlab.sh samiahmedsiddiqui/sync-repos-private samiahmedsiddiqui/sync-repos 

# With commit message
./sync-repos-gitlab.sh samiahmedsiddiqui/sync-repos-private samiahmedsiddiqui/sync-repos Fetching latest updates
```
