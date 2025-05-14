class LanguagetoolObsidian < Formula
  desc "LanguageTool server optimized for Obsidian integration"
  homepage "https://github.com/mrlesmithjr/homebrew-languagetool"
  url "https://languagetool.org/download/LanguageTool-6.6.zip"
  sha256 "227a92d6e9f64c8b24aa96ff29cd1fc415271543dea56f56182ddb476a7720be"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://languagetool.org/download/"
    regex(/href=.*?LanguageTool[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  option "with-snapshot", "Install the latest development snapshot instead of stable release"

  depends_on "openjdk@17"

  resource "snapshot" do
    url "https://internal1.languagetool.org/snapshots/LanguageTool-latest-snapshot.zip"
    # Note: SHA will change frequently for snapshots
  end

  def install
    if build.with? "snapshot"
      resource("snapshot").stage do
        # Find the actual directory name which might include a date
        snapshot_dir = Dir["LanguageTool-*"].first
        system "cp", "-R", snapshot_dir, buildpath/"LanguageTool-snapshot"
        libexec.install Dir["LanguageTool-snapshot/*"]
      end
    else
      libexec.install Dir["*"]
    end

    # Create bin directory
    (bin/"languagetool-obsidian-server").write <<~EOS
      #!/bin/bash
      JAVA_HOME="#{Formula["openjdk@17"].opt_prefix}/libexec/openjdk.jdk/Contents/Home"
      exec "${JAVA_HOME}/bin/java" -Xmx512m -cp "#{libexec}/languagetool-server.jar" org.languagetool.server.HTTPServer --port 8081 --allow-origin "*" "$@"
    EOS

    # Make the script executable
    chmod 0755, bin/"languagetool-obsidian-server"

    # Create configuration directory
    (prefix/"etc/languagetool-obsidian").mkpath
    
    # Create configuration file
    (prefix/"etc/languagetool-obsidian/server.properties").write <<~EOS
      port=8081
      allowOriginUrl=*
      maxTextLength=50000
      maxCheckTimeMillis=10000
      maxErrorsPerWordRate=100
    EOS
  end

  service do
    run [opt_bin/"languagetool-obsidian-server"]
    keep_alive true
    log_path var/"log/languagetool-obsidian.log"
    error_log_path var/"log/languagetool-obsidian.err.log"
    working_dir libexec
    environment_variables JAVA_HOME: Formula["openjdk@17"].opt_prefix/"libexec/openjdk.jdk/Contents/Home"
  end

  test do
    # Start the server in the background
    pid = fork do
      exec bin/"languagetool-obsidian-server"
    end
    
    # Give it a moment to start
    sleep 5
    
    # Test the server with a simple request
    system "curl", "-s", "http://localhost:8081"
    
    # Clean up
    Process.kill("TERM", pid)
    Process.wait(pid)
  end

  def caveats
    <<~EOS
      LanguageTool for Obsidian is now installed!
      
      To start the server:
        brew services start languagetool-obsidian
        
      For Obsidian LanguageTool Plugin configuration:
      1. Install the LanguageTool plugin from Community Plugins
      2. Set the API URL to: http://localhost:8081
      3. Enable 'Auto check on file open' and 'Auto check on text change'
      
      This formula maintains all the CORS headers needed for Obsidian integration
      and is configured to start automatically at login.
    EOS
  end
end
