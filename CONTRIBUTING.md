# How to Contribute

## General workflow
0. (External contributors only) Create a fork of the repository
1. Pull any changes from `main` to make sure you're up-to-date
2. Create a branch from `main`
    * Give your branch a name that describes your change (e.g. add-scoreboard)
    * Focus on one change per branch
3. Commit your changes
    * Keep your commits small and focused
    * Write descriptive commit messages in [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/) format
4. When you're ready, create a pull request to `main`
    * Keep your PRs small (preferably <300 LOC)
    * Format your title in [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/) format
    * List any changes made in your description
    * Link any issues that your pull request is related to as well

### Example:
```text
Create scoreboard for total points

ADDED - Scoreboard displayed in-game at game end  
CHANGED - Updated `StorageManager` class to persist scoreboard data
```

After the pull request has been reviewed, approved, and passes all automated checks, it will be merged into main.

## Development
### Containerized Linting and Testing
Follow these instructions to lint and tests using the provided Docker scripts.

#### Install Dependencies
Before running the scripts, you must have [Docker](https://www.docker.com/products/docker-desktop/) installed.

#### Running the scripts
To run the linting and testing scripts, run one of the following commands:

**macOS:**
```bash
scripts/test
```

**Windows:**
```batch
scripts\test
```

### Native Linting and Testing
Follow these instructions to lint and tests natively.

#### Install Dependencies
Assuming you have [Bundler](https://bundler.io/) installed, to install dependencies, run the following command:
```bash
bundle install
```

#### Lint
To lint the project, run the following command:
```bash
bundle exec rubocop
```

#### Test
To test the project, run the following command:
```bash
bundle exec rspec
```

Or alternatively:
```bash
bundle exec rake
```