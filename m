From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Fri, 15 Sep 2017 10:06:24 +0200
Message-ID: <CAJfpeguB=H=FNyMDyyO4417o1DSiw-5RS0S3nzENHiCRiqmYRQ@mail.gmail.com>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
 <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com>
 <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com>
 <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com>
 <CAJfpegvK_LyL0eHbmpp=NrJMnS1i8KkPpxRtBL_zyB_n-NKg7A@mail.gmail.com>
 <CA+55aFznd3O7CtT9tKSs4_HVY_OYiUHdcZFzx8eQaG8Ye5AVdA@mail.gmail.com> <20170915073226.GC19278@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36746 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdIOIG1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Sep 2017 04:06:27 -0400
Received: by mail-wr0-f195.google.com with SMTP id g50so839583wra.3
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Sep 2017 01:06:26 -0700 (PDT)
In-Reply-To: <20170915073226.GC19278@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Sep 15, 2017 at 9:32 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Sep 14, 2017 at 01:24:22PM -0700, Linus Torvalds wrote:
>
>> I just don't see any reason why those two "flags" arguments are separate.
>
> Fine.  Here's a patch reverting the new flags and adding O_UPPER.

And, btw. I also hate all the hacks we need to do in the VFS for the
sake of overlayfs.  It may actually end up all being removed and all
the stacking moved to overlayfs; that's something I'd really like to
look at.   All of these hacks are there because overlayfs lets the
open file be owned by the underlying filesystem, which is good for
performance and results in simpler code in overlayfs, but may not
actually be worth it.

The whole overlayfs thing started because I was looking at the union
mounts patches and seeing all the horrid vfs impacts and deciding,
that surely some of this can go into a filesystem without major loss
of performance.   The first versions had really minimal vfs impact,
but it turned out that that wasn't enough for a bunch of things to
work correctly so d_real() evolved into the beast it is now.

And we still have that issue with an fd opened for read-only and then
one opened for write, resulting in a copy-up, modification, and the
read-only fd still seeing the old data (union mounts had the same
issue, BTW).   So we need more hacks or some way to have a shared page
cache that's breakable on copy up, which does not look trivial at all.

Thanks,
Miklos
