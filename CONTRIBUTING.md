# Contributing to LanguageTool for Obsidian

Thank you for considering contributing to this Homebrew tap for LanguageTool optimized for Obsidian! Your help is essential for making this tool better.

## How to Contribute

There are many ways to contribute:

1. **Reporting bugs**: Create an issue if you find a problem
2. **Suggesting enhancements**: New features or improvements
3. **Improving documentation**: Corrections, clarifications, or translations
4. **Contributing code**: Submit pull requests with bug fixes or new features

## Development Process

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** with clear commit messages
3. **Test your changes** thoroughly
4. **Create a pull request** describing what you've done and why

### Testing Your Changes

Before submitting a pull request, make sure to test your formula:

```bash
# Uninstall any existing version
brew uninstall languagetool-obsidian

# From your tap directory, install the local version
brew install --build-from-source ./Formula/languagetool-obsidian.rb

# Test that the installation works
brew services start languagetool-obsidian
curl http://localhost:8081
```

## Formula Guidelines

When modifying the formula, please follow these guidelines:

1. **Follow Homebrew style**: Use the [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook) as a reference
2. **Keep it simple**: Avoid unnecessary complexity
3. **Maintain compatibility**: Changes should not break existing installations
4. **Document changes**: Update the README.md if you add features

## Pull Request Process

1. Update the README.md with details of changes if appropriate
2. The PR should work with the latest versions of macOS and Homebrew
3. Your PR will be reviewed by the maintainers, who may request changes
4. Once approved, your PR will be merged

## Code of Conduct

Please be respectful and constructive in all interactions. Harassment or harmful behavior of any kind will not be tolerated.

## Questions?

If you have any questions or need help with your contribution, please open an issue and ask!

Thank you for your interest in improving LanguageTool for Obsidian!
