require 'formula'

class Cloogpolly < Formula
  homepage 'http://www.cloog.org/'
#  url "http://repo.or.cz/w/cloog.git/snapshot/22643c94eba7b010ae4401c347289f4f52b9cd2b.tar.gz"
  url "git://repo.or.cz/cloog.git", :revision => "22643c94eba7b010ae4401c347289f4f52b9cd2b"
  version "0.18.2-polly"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on 'pkg-config' => :build
  depends_on 'gmp'
  depends_on 'islpolly'

  keg_only "Conflicts with cloog in main repository."

  def install
    system "./autogen.sh"

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-gmp=system",
      "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
      "--with-isl=system",
      "--with-isl-prefix=#{Formula["islpolly"].opt_prefix}"
    ]

    args << "--with-osl=bundled" if build.head?

    system "./configure", *args
    system "make install"
  end

  test do
    cloog_source = <<-EOS.undent
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    output = pipe_output("#{bin}/cloog /dev/stdin", cloog_source)
    assert_match /Generated from \/dev\/stdin by CLooG/, output
  end
end
