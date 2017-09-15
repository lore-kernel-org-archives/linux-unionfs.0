From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Fri, 15 Sep 2017 11:35:25 -0700
Message-ID: <CA+55aFznOnFvOPghB2RWqx-H6n0Fc8zGy8c24zU-aYPVscvufQ@mail.gmail.com>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
 <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com>
 <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com>
 <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com>
 <CAJfpegvK_LyL0eHbmpp=NrJMnS1i8KkPpxRtBL_zyB_n-NKg7A@mail.gmail.com>
 <CA+55aFznd3O7CtT9tKSs4_HVY_OYiUHdcZFzx8eQaG8Ye5AVdA@mail.gmail.com> <20170915073226.GC19278@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:53435 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdIOSfb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Sep 2017 14:35:31 -0400
In-Reply-To: <20170915073226.GC19278@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Sep 15, 2017 at 12:32 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Fine.  Here's a patch reverting the new flags and adding O_UPPER.

Thanks, this patch looks fine to me, but now with the other discussion
I think I'll leave the d_real() thing alone and see if Al has more
comments about your other approach.

Because it _would_ be even more lovely if we could just get rid of it
entirely, and do all of this internally in ovlfs itself.

> And we still have that issue with an fd opened for read-only and then
> one opened for write, resulting in a copy-up, modification, and the
> read-only fd still seeing the old data (union mounts had the same
> issue, BTW).   So we need more hacks or some way to have a shared page
> cache that's breakable on copy up, which does not look trivial at all.

Ugh, no, that's *very* non-trivial.

I can see us doing magical things with the inode->i_mapping being an
ovlfs-private mapping, and then sharing the actual physical pages with
the mapping of the lower filesystem.

So that way, the actual file data would never point directly at the
lower filesystem.

But equally obviously, that would *only* work when the lower
filesystem is never modified directly. There may be other, even worse,
issues with page sharing across mappings.  So it might be a completely
broken model, I haven't thought much about it.

                 Linus
