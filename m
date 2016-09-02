From: Guillem Jover <guillem@debian.org>
Subject: Bug#836211: dpkg: Cannot upgrade some packages on overlayfs: Invalid cross-device link
Date: Fri, 2 Sep 2016 15:03:54 +0200
Message-ID: <20160902130353.tzrthpcakf5hk54n@gaara.hadrons.org>
References: <147265657047.31705.7496372748096616425.reportbug@felipepc>
 <20160902113633.5kbibrlwlhhlppyr@home.ouaza.com>
 <CAJfpegu-JhRpDmzx1=fLsnL+=FTsAX21Up5A6s4eQFDPZ2ET3g@mail.gmail.com>
Reply-To: Guillem Jover <guillem@debian.org>, 836211@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.836211.B836211.147282144328775@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegu-JhRpDmzx1=fLsnL+=FTsAX21Up5A6s4eQFDPZ2ET3g@mail.gmail.com>
List-URL: <https://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Miklos Szeredi <miklos@szeredi.hu>, 836211@bugs.debian.org
Cc: Raphael Hertzog <hertzog@debian.org>, Felipe Sateler <fsateler@debian.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Hi!

On Fri, 2016-09-02 at 14:30:58 +0200, Miklos Szeredi wrote:
> You are the first to report that this quirk actually causes problems
> in real life.
> 
> I have plans to fix this by adding a "redirector" attribute so that
> copied up directories (and perhaps files) can refer to lower directory
> that is found at a different location relative to the root of the
> overlay from the location of the upper directory.
> 
> Maybe an example can make this more clear:
> 
> lower/foo/bar/baz
> upper/foo/bar <- whiteout
> upper/moved/here <- redirects to "foo/bar"
> 
> will result in the tree:
> 
> overlay/moved/here/baz

That'd be very much appreciated, thanks!

> > It does not seem very correct to put the burden on user-space to be aware
> > of overlayfs restrictions such as this one. Renaming a directory is
> > not something that happens often in practice in the uses cases where
> > we use overlayfs but it's still frequent enough to deserve better than
> > a EXDEV error IMO and dpkg trying to rename "foo/" into "foo.dpkg-tmp/"
> > is in its right to assume that this rename will not cross any device
> > boundary.
> 
> The EXDEV trick  just works for mv(1), hence this didn't seem to be a
> big issue in practice.

In dpkg, the directory is rename(2)d to perform an atomic temporary backup,
so that it can be rolled-back in case of errors during unpacking. Having to
possibly do a deep-copy and a deep-remove, and then trying to recover from
errors inbetween those, would be very unsatisfactory.

Thanks,
Guillem
