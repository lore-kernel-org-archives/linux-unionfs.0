From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay: test creating lower hardlinks for copied up
 files
Date: Tue, 31 Oct 2017 11:32:15 +0800
Message-ID: <20171031033215.GE17339@eguan.usersys.redhat.com>
References: <1509365216-10796-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxj-AQcW8__3DcL5e+PSejYgW8kP=RD4OOxsD8OGOFZeSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbdJaDcS (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2017 23:32:18 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj-AQcW8__3DcL5e+PSejYgW8kP=RD4OOxsD8OGOFZeSg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Mon, Oct 30, 2017 at 02:10:52PM +0200, Amir Goldstein wrote:
> On Mon, Oct 30, 2017 at 2:06 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > kernel v4.13 introduced the index=on feature for not breaking hardlinks
> > on copy-up.  With the index feature enabled a regression was introduced -
> > lower files that are hardlined while overlay is offline can result in
> > lookup error after overlay in mounted.
> >
> > The regression was fixed by upstream commit
> >   6eaf011144af ovl: fix EIO from lookup of non-indexed upper
> > that was merged to v4.14-rc7.
> >
> > This test verifies that behavior is sane after creating lower hardlinks
> > for copied up files while overlayfs is offline.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Eryu,
> >
> > This is a regression test for a fix that was just merged to v4.14-rc7.
> >
> > The test requires and enables index=on, so it would fail on kernels
> > prior to v4.14-rc7 regardless if they are complied with
> > CONFIG_OVERLAY_FS_INDEX=y or not.
> >
> > Amir.
> >
> >  tests/overlay/042     | 137 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/042.out |   2 +
> >  tests/overlay/group   |   1 +
> >  3 files changed, 140 insertions(+)
> >  create mode 100755 tests/overlay/042
> >  create mode 100644 tests/overlay/042.out
> >
> > diff --git a/tests/overlay/042 b/tests/overlay/042
> > new file mode 100755
> > index 0000000..29858d6
> > --- /dev/null
> > +++ b/tests/overlay/042
> > @@ -0,0 +1,137 @@
> > +#! /bin/bash
> > +# FS QA Test 042
> > +#
> > +# Test creating lower hardlinks for copied up files.
> > +#
> > +# kernel v4.13 introduced the index=on feature for not breaking
> > +# hardlinks on copy-up. With the index feature enabled a regression was
> > +# introduced - lower files that are hardlined while overlay is offline
> > +# can result in lookup error after overlay in mounted.
> > +# The regression was fixed by upstream commit
> 
> Some indentation fixes I forgot to commit:
> 
> +# kernel v4.13 introduced the index=on feature for not breaking hardlinks
> +# on copy-up.  With the index feature enabled a regression was introduced -
> +# lower files that are hardlined while overlay is offline can result in
> +# lookup error after overlay in mounted.

I've fixed it up on commit, thanks!

Eryu
