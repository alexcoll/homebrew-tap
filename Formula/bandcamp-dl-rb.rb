class BandcampDlRb < Formula
  desc "Download your Bandcamp purchases and organize them for a Plex library"
  homepage "https://github.com/alexcoll/bandcamp-dl-rb"
  url "https://github.com/alexcoll/bandcamp-dl-rb/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "4d521e688855cf3ffadedc06ca9b32c13af5056327d5651ee9a373bc08adddee"
  license "GPL-3.0-only"

  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    # The gemspec reads VERSION from version.rb. Stamp it with the formula's
    # version so a stale version in the source archive can't build a gem whose
    # name doesn't match what we install below.
    inreplace "lib/bandcamp_dl_rb/version.rb",
              /VERSION = '[^']*'/,
              "VERSION = '#{version.to_s}'"

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "--no-document",
           "--install-dir", libexec, "#{name}-#{version}.gem"

    # Copy the gem's executable into the keg and wrap it so GEM_HOME points
    # at the keg and the formula's Ruby is used.
    exe = "bandcamp_dl_rb"
    libexec_bin = libexec/"bin"
    libexec_bin.mkpath
    File.binwrite libexec_bin/exe,
                  File.binread(libexec/"gems/#{name}-#{version}/exe/#{exe}")
    chmod 0755, libexec_bin/exe
    (bin/exe).write_env_script libexec_bin/exe,
                               PATH:     "#{formula_opt_bin("ruby")}:$PATH",
                               GEM_HOME: libexec

    man1.install "man/bandcamp_dl_rb.1"
  end

  test do
    assert_match "bandcamp_dl_rb", shell_output("#{bin}/bandcamp_dl_rb --help")
    assert_predicate share/"man/man1/bandcamp_dl_rb.1", :exist?
  end
end
