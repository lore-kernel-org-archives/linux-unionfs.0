From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] overlay: stress test changes to top and bottom layers
 simultaneously
Date: Thu, 8 Dec 2016 09:16:39 -0500
Message-ID: <20161208141639.tzblbtwlqyzhckrm@thunk.org>
References: <20161208035844.18544-1-tytso@mit.edu>
 <20161208043739.GF29149@eguan.usersys.redhat.com>
 <CAOQ4uxhKvQKMqUtGS+meRyt3WRzH=-DkGndCqmEUD1d+v1_Dog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33654 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751989AbcLHOQo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Dec 2016 09:16:44 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhKvQKMqUtGS+meRyt3WRzH=-DkGndCqmEUD1d+v1_Dog@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Thu, Dec 08, 2016 at 08:37:58AM +0200, Amir Goldstein wrote:
> do you have a reference for said races in past fs?
> I am asking because it could be useful to focus on more specific
> concurrent access patterns.

The thing which brought this up was the the equivalent test scenario
was causing crashes in a kernel implementation of sdcardfs.  Sdcardfs
is this horrible hack, originally implemented in FUSE, that (a)
provides case insensitive lookups, and (b) implements Android's
application-centric permissions system.  Someone (I think at Samsung)
tried to implement this in the kernel using wrapfs[1] as a base.

[1] http://wrapfs.filesystems.org/

It turns out that if you run fsstress on the top and bottom
directories, it will crash very quickly.  This was reproduced not just
on sdcardfs, but on the base wrapfs.  For more details, please see [2].
(BTW, this is not terribly surprising because Al Viro has made fairly
disparaging comments about wrapfs-based file systems in the past.)

[2] http://www.fsl.cs.sunysb.edu/pipermail/wrapfs/2016-October/000140.html

Since we also have some users of overlayfs in a product capacity, I
whipped up a test to make sure that overlayfs didn't suffer from the
same problem, and I was glad to see that it did _not_ crash or hang,
as advertised.

Since the use of unionfs is deprecated, I didn't bother to test it,
although I could if someone was really curious whether it would BUG or
not.  (Given that both wrapfs and sdcardfs did BUG, I'm pretty that
unionfs, as a wrapfs derivitive, also would go down in flames.  It
might also be fun, since there are some Ubuntu Docker users using
AUFS, to see if AUFS --- as another wrapfs derivitive --- might also
be succeptible.)

> I am not that familiar with fsstress modes, but I suppose it is possible
> to setup a work set in lower before starting the concurrent access test.
> I have a feeling that would be beneficial to catching yet another class of bugs.

The trick here is that we are starting fsstress with the same seed in
the top and bottom directories, at the same time.  That means the same
pathnames are likely to be modified at the top and bottom, leading to
races both in the VFS and in the overlay file system.

> > But from kernel Documentation:
> >
> > "Changes to the underlying filesystems while part of a mounted overlay
> > filesystem are not allowed.  If the underlying filesystem is changed,
> > the behavior of the overlay is undefined, though it will not result in
> > a crash or deadlock."
> >
> > So at least kernel should not crash or deadlock.
> 
> Yes, that is the only thing that this test should be verifying.

That's why I wrote this test, in fact.  :-)

							- Ted
