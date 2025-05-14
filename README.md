# Homebrew LanguageTool for Obsidian

A Homebrew tap providing LanguageTool optimized for Obsidian integration. This tap offers an easy way to install and manage a local LanguageTool server that works seamlessly with the Obsidian LanguageTool plugin.

## Features

- ✅ **Privacy-Focused**: All grammar and spell checking happens locally on your machine
- ✅ **No Usage Limits**: Unlimited checking without subscription fees
- ✅ **Automatic Startup**: Server starts automatically when you log in
- ✅ **Obsidian Integration**: Works seamlessly with the Obsidian LanguageTool plugin
- ✅ **CORS Support**: Properly configured CORS headers for browser access
- ✅ **Version Options**: Support for both stable releases and development snapshots

## Installation

```bash
# Add this tap to your Homebrew
brew tap mrlesmithjr/languagetool

# Install LanguageTool for Obsidian
brew install languagetool-obsidian

# Start the server
brew services start languagetool-obsidian
```

### Installing Development Snapshots

If you want to try the latest development snapshot instead of the stable version:

```bash
brew install languagetool-obsidian --with-snapshot
```

## Obsidian Configuration

After installation:

1. Install the LanguageTool plugin from Obsidian's Community Plugins
2. Configure the plugin with:
   - Server URL: `http://localhost:8081`
   - Ensure "Auto check on file open" and "Auto check on text change" are enabled

![Obsidian Configuration](https://user-images.githubusercontent.com/YOUR_USER_ID/obsidian-config.png)

## Usage

### Starting/Stopping the Server

```bash
# Start the server
brew services start languagetool-obsidian

# Stop the server
brew services stop languagetool-obsidian

# Restart the server
brew services restart languagetool-obsidian
```

### Checking Status

```bash
# Check if the server is running
brew services list | grep languagetool-obsidian
```

### Testing the Server

```bash
# Test the server response
curl http://localhost:8081

# Test grammar checking
curl -X POST "http://localhost:8081/v2/check" \
  -d "text=She don't like it" \
  -d "language=en-US"
```

## Updating

To update to the latest version:

```bash
brew update
brew upgrade languagetool-obsidian
```

## Troubleshooting

If you encounter issues:

### Check Service Status

```bash
brew services list | grep languagetool-obsidian
```

### View Log Files

```bash
cat $(brew --prefix)/var/log/languagetool-obsidian.log
cat $(brew --prefix)/var/log/languagetool-obsidian.err.log
```

### Verify Port Availability

```bash
lsof -i :8081
```

### Run Server Manually

```bash
$(brew --prefix)/bin/languagetool-obsidian-server
```

### Common Issues

1. **Server not starting**:

   - Ensure Java is properly installed
   - Check if another service is using port 8081

2. **Obsidian plugin can't connect**:

   - Verify the server is running
   - Make sure the URL is set correctly in the plugin settings

3. **CORS errors**:
   - The server is configured with `--allow-origin "*"` by default
   - If you're seeing CORS errors, restart the server

## Uninstallation

```bash
# Stop the service
brew services stop languagetool-obsidian

# Uninstall
brew uninstall languagetool-obsidian

# Remove the tap (optional)
brew untap mrlesmithjr/languagetool
```

## Comparison with Other Methods

| Feature              | This Formula           | Official Homebrew Formula | Manual Installation |
| -------------------- | ---------------------- | ------------------------- | ------------------- |
| CORS Support         | ✅ Yes                 | ❌ No                     | ⚠️ Manual Config    |
| Obsidian Integration | ✅ Optimized           | ❌ Requires Config        | ⚠️ Requires Config  |
| Automatic Updates    | ✅ Via `brew upgrade`  | ✅ Via `brew upgrade`     | ❌ Manual           |
| Service Management   | ✅ Via `brew services` | ✅ Via `brew services`    | ❌ Manual           |
| Snapshot Support     | ✅ Yes                 | ❌ No                     | ⚠️ Manual           |

## Credits

- [LanguageTool](https://languagetool.org/) - The open-source proofreading software
- [Obsidian](https://obsidian.md/) - The knowledge base that works on local Markdown files

## License

This tap is provided under the MIT License. LanguageTool itself is licensed under LGPL 2.1.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
