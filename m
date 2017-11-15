From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 03/15] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Wed, 15 Nov 2017 10:35:16 -0500
Message-ID: <20171115153516.GC13895@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
 <20171109205019.11409-4-vgoyal@redhat.com>
 <CAOQ4uxgRv2A9nWvf2Yo7m_7FtMdDQ05DLqCih4qiViBo4wxNng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757097AbdKOPfR (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Nov 2017 10:35:17 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgRv2A9nWvf2Yo7m_7FtMdDQ05DLqCih4qiViBo4wxNng@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 10, 2017 at 09:07:04AM +0200, Amir Goldstein wrote:
> On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > By default metadata only copy up is disabled. Provide a mount option so
> > that users can choose one way or other.
> >
> > Also provide a kernel config and module option to enable/disable
> > metacopy feature.
> >
> > Like index feature, we verify on mount that upper root is not being
> > reused with a different lower root. This hopes to get the configuration
> > right and detect the copied layers use case. But this does only so
> > much as we don't verify all the lowers. So it is possible that a lower is
> > missing and later data copy up fails.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Fine, as long as Miklos agrees not to enforce exclusive dir lock,
> it's fine by me.
> 
> Please take a look at my ovl-features patches and say what you think.
> It is time we started to enforce some order with all the inter-dependencies
> between features.
> With my proposal, it will make mounting an overlay with metacopy object
> on older kernel slightly harder (but not impossible), so it can help admins
> from tripping over themselves.

I am trying to understand all that discussion but I realiaze that metacopy
feature will have issues if mounted with older kernel. Some of the files
will be metacopy only and old kernel will think that these files have
been truncated.

Turning metacopy=off with new kernel should be fine though. This just
means that new copy up operations will not be metacopy only and files
which are metacopy only will be copied up when opened for WRITE.

So we need some mechanism where old kernel can detect a new incomatible
feature in fs metadata and either refuse to mount.

Right now we don't seem to have any mechanism to do that in overlayfs.
Having something like that will make it harder to make mistakes.


[..]
> > -       if (ofs->config.index && !ovl_can_decode_fh(path->dentry->d_sb)) {
> > +       if ((ofs->config.index || ofs->config.metacopy) &&
> > +            !ovl_can_decode_fh(path->dentry->d_sb)) {
> > +               if (ofs->config.index)
> > +                       pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
> > +
> > +               if (ofs->config.metacopy)
> > +                       pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to metacopy=off.\n", name);
> > +
> >                 ofs->config.index = false;
> > -               pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
> > +               ofs->config.metacopy = false;
> >         }
> >
> 
> So you didn't like the less granular but shorter warning I used in my
> verify_dir patches, e.g.:
>                  ofs->config.index = false;
>  -               pr_warn("overlayfs: fs on '%s' does not support file
> handles, falling back to index=off.\n", name);
> +               ofs->config.metacopy = false;
> +               pr_warn("overlayfs: fs on '%s' does not support file
> handles, falling back to index=off,metacopy=off.\n", name);
> 
> Doesn't matter much to me,

Actually, I do like shorter warning with single line. I think I just forgot
to make this change. I will do it in V7.

Vivek
