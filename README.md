# Setup Ninja

Setup Ninja is a work-in-progress project designed to automate the installation of all necessary programs for your dotfiles, regardless of the Linux distribution. The goal is to eliminate the need for manual installation by providing a streamlined, Lua-based solution.

## Features

- **Cross-Distribution Compatibility**: Install programs seamlessly across different Linux distributions.
- **Domain-Based Organization**: Packages are divided into topics or domains, such as coding tools, system tools, UI, etc.
- **Lua-Powered**: Users need Lua installed to use this tool.

## Installation

1. Ensure Lua is installed on your system.
2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/setup-ninja.git
   ```
3. Navigate to the project directory:
   ```bash
   cd setup-ninja
   chmod +x setup-ninja
   ./setup-ninja
   ```

## Usage

1. Write your lua packages files, see `packages.lua` file.
2. Run `./setup-ninja --config <package_file>`. You can add `--dry-run` to check what will be done.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve Setup Ninja.

## License

This project is licensed under the MIT License.
