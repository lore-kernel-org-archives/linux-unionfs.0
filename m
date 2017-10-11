From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 5/9] ovl: Set xattr OVL_XATTR_METACOPY on upper file
Date: Wed, 11 Oct 2017 16:16:30 -0400
Message-ID: <20171011201630.GE8086@redhat.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-6-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxgNg3SO=xyvh_oAH-ExQGQCWXMGKygdAhmGeDdanyo=vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752454AbdJKUQb (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2017 16:16:31 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgNg3SO=xyvh_oAH-ExQGQCWXMGKygdAhmGeDdanyo=vA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Tue, Oct 10, 2017 at 08:03:05PM +0300, Amir Goldstein wrote:

[..]
> > @@ -511,6 +564,10 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
> >                 goto out_cleanup;
> >
> >         ovl_inode_update(d_inode(c->dentry), newdentry);
> > +       if (c->metadata_only) {
> > +               smp_wmb();
> 
> This wmb does not address the only problem imo.
> The problem is you must not allow inode to appear to have
> An upper dentry before you made sure metacopy flag is visible.
> So first you need to set metacopy flag before updating upper.
> Then you also need to test them is correct order with rmb.

Ok, so conceptually it makse sense to me that OVL_METACOPY flag should
be set before upper dentry is made visible.

So ovl_set_flag(OVL_METACOPY) should move before ovl_inode_update(). 
ovl_inode_update() already has a smp_wmb(). So write side is probably
fine.

But read side, ovl_upperdentry_dereference() only has data dependency
barrier and not smp_rmb(). (lockless_dereference(oi->__upperdentry)). I
am not sure if that's sufficient for ovl_inode->flags read or not. May
be we need to replace data dependency barrier with smp_rmb() in in
ovl_upperdentry_dereference()?

Even if we do this, I think we need barriers around setting/resetting
of OVL_METACOPY for the reset case. I will explain this in other patch.

Vivek
