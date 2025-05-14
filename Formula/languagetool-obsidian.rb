class LanguagetoolObsidian < Formula
  desc "LanguageTool server optimized for Obsidian integration"
  homepage "https://github.com/mrlesmithjr/homebrew-languagetool"
  
  if build.with? "snapshot"
    url "https://internal1.languagetool.org/snapshots/LanguageTool-latest-snapshot.zip"
    sha256 :no_check
    version "latest-snapshot"
  else
    url "https://languagetool.org/download/LanguageTool-6.6.zip"
    sha256 "53600506b399bb5ffe1e4c8dec794fd378212f14aaf38ccef9b6f89314d11631"
    version "6.6"
  end
  
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://languagetool.org/download/"
    regex(/href=.*?LanguageTool[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  option "with-snapshot", "Install the latest development snapshot instead of stable release"

  depends_on "openjdk@17"

  def install
    libexec.install Dir["*"]
    
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
    # Simplified test that should be more reliable in CI
    system "#{bin}/languagetool-obsidian-server", "--help"
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
