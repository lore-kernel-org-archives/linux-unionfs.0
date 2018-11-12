Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37424 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbeKLMHX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Nov 2018 07:07:23 -0500
Date: Mon, 12 Nov 2018 10:16:17 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] overlay: create directory over deleted whiteout
Message-ID: <20181112021617.GB3889@desktop>
References: <20181031095502.12504-1-mszeredi@redhat.com>
 <CAOQ4uxi9YX23C7NLQ2yqsz1Ur4nwMZFbQta=nBU=6bvYPU2YGg@mail.gmail.com>
 <CAOQ4uxikt5u-a4f+Z1bT38E5p2mcBq++8qP64OzVobe8Z1RhLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxikt5u-a4f+Z1bT38E5p2mcBq++8qP64OzVobe8Z1RhLQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Nov 11, 2018 at 06:45:25PM +0200, Amir Goldstein wrote:
> On Wed, Oct 31, 2018 at 12:17 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Oct 31, 2018 at 11:55 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
> > >
> > > There's a bug in the overlayfs implementation starting from the very first
> > > merged version that may cause an Oops of various forms if a directory is created
> > > over a whiteout dentry, but the actual whiteout on the upper layer was removed
> > > to the directory creation.
> > >
> > > Reported by: kaixuxia <xiakaixu1987@gmail.com>
> > > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > > ---
> >
> > Looks good. A bit of commentary could be useful...
> 
> Eryu,
> 
> I see you have not included this test in today's update.
> Maybe you though that this discussion did not conclude.
> On my part, besides adding the 2 comment lines, there
> are no further concerns.

Yeah, I saw the discussion was on going so I didn't save the thread to
my "to-review" queue and it fell out of my radar.. I'll queue it now.

> 
> FYI, the fix for this bug is now in master:
> 5e1275808630 ovl: check whiteout in ovl_create_over_whiteout()

Thanks for the reminder!

Eryu
