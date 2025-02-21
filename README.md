# Todo MD Generator

A utility script to generate a `TODO.md` file from `TODO` comments in your Git repository. Automatically updates and keeps track of tasks across your codebase.

## Features

- Generates `TODO.md` files from repository comments
- Supports custom search patterns (e.g., `TODO`, `FIXME`)
- Exclude or include specific patterns
- Live mode to add generated files to Git staging
- Professional formatting for readability
- Stage generated files before commit

## Usage

```bash
./todo.md.sh [-h] [-o] [-l] [-f OUTPUT_FILE] [-t SEARCH_PATTERN] [-e EXCLUDE_PATTERN] [-i INCLUDE_PATTERN]
```

### Options

- `-h`: Show help and exit
- `-o`: Output to standard output instead of a file
- `-f`: Specify output file (default: `TODO.md`)
- `-t`: Define search pattern for comments
- `-e`: Exclude patterns from results
- `-i`: Include additional patterns in results
- `-l`: Stage generated files (TODO.md) to Git before commit

### Example

```bash
# Generate TODO.md with default settings and stage it for commit
./todo.md.sh -l

# Search for FIXME comments, save to custom file
./todo.md.sh -t FIXME -f FIXME.md
```

## Setup as Git Hook (Optional)

For automatic updates, you can configure the script as a Git hook:

1. Add the script to your repository.
2. Make it executable:

   ```bash
   chmod u+x todo.md.sh
   ```

3. Use it as part of your workflow or include it in your `.git/hooks/` directory.

To automatically stage generated files before commit, you can use the `-l` flag:

```bash
# Stage changes to TODO.md before committing
./todo.md.sh -l
```

This setup ensures that your `TODO.md` file is always up-to-date.

## Feedback and Contributions

Feel free to submit improvements, feature requests, or bug reports.
