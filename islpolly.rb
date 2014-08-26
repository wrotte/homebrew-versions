require "formula"

class Islpolly < Formula
  homepage "http://freecode.com/projects/isl"
  # Track gcc infrastructure releases.
  url "git://repo.or.cz/isl.git", :revision => "163646566efd07086ed4fbe99ecbf8d5bb8ebca0"

  version "0.13-polly"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  keg_only "Conflicts with isl in main repository."

  depends_on "gmp4"

  def install
    system "./autogen.sh"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp4"].opt_prefix}"
    system "make"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end
end
