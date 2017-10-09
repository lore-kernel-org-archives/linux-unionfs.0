From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 8/8] ovl: Fix ovl_getattr() to get number of blocks from
 lower
Date: Mon, 9 Oct 2017 10:45:23 -0400
Message-ID: <20171009144523.GD29869@redhat.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
 <1507312037-30909-9-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxgYC=UKpXw+P36PnB2hxDzV+L=QP_j8whJeL2GCrSxLnw@mail.gmail.com>
 <20171006190104.GA1449@redhat.com>
 <CAOQ4uxh4fcDc4FovOW_9vNGVJ3mDKrT=YVyXBNOFQAL_a2Gh_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754098AbdJIOp0 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Oct 2017 10:45:26 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh4fcDc4FovOW_9vNGVJ3mDKrT=YVyXBNOFQAL_a2Gh_w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 06, 2017 at 10:09:38PM +0300, Amir Goldstein wrote:

[..]
> >> > @@ -140,6 +143,17 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
> >> >         if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
> >> >                 stat->nlink = dentry->d_inode->i_nlink;
> >> >
> >> > +       if (ovl_test_flag(OVL_METACOPY, d_inode(dentry))) {
> >> > +               u32 lowermask = STATX_BLOCKS;
> >> > +
> >> > +               if (!lowerstat_done) {
> >>
> >> I guess lowerstat_done is as result from my comment,
> >> but I did not mean I think vfs_getattr() is expensive,
> >> I just didn't like the duplication of that code block, but maybe
> >> just a matter of personal taste.
> >> Can be sorted out later.
> >
> > Yes, I added this because I thought you wanted to avoid that extra
> > vfs_getattr() call. I am open to change it whatever way you like.
> > Personally I did not like this extra boolean and I liked unconditional
> > vfs_getattr() better. It was not most optimized but was easier to
> > understand.
> >
> 
> Yeh, I liked it without the boolean better as well.
> What I meant is once this patch lands:
> https://github.com/chandanr/linux/commit/e9024b0a08a1c725daed548f68ff703305c40124
> vfs_getattr() will be called for all non-dir with ORIGIN anyway, so
> METACOPY will be able to piggy back STATX_BLOCKS flag on the same call.

Aha, got it. Once these patches are merged, I will rebase my patch on top
of it. 

In the mean time, for the purpose of review and test, I will continue with my
patch.

Vivek
