From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v7 04/14] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Fri, 17 Nov 2017 11:18:36 -0500
Message-ID: <20171117161836.GC15566@redhat.com>
References: <20171116220335.13448-1-vgoyal@redhat.com>
 <20171116220335.13448-5-vgoyal@redhat.com>
 <CAOQ4uxj2UCtUhNF30DTHg=8u675-us0PiRvxcZ7DEoC+=DE-3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759197AbdKQQSh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 11:18:37 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj2UCtUhNF30DTHg=8u675-us0PiRvxcZ7DEoC+=DE-3w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 01:23:58PM +0200, Amir Goldstein wrote:

[..]
> > @@ -1164,6 +1187,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >
> >         ofs->config.redirect_dir = ovl_redirect_dir_def;
> >         ofs->config.index = ovl_index_def;
> > +       ofs->config.metacopy = ovl_metacopy_def;
> >         err = ovl_parse_opt((char *) data, &ofs->config);
> >         if (err)
> >                 goto out_err;
> > @@ -1209,6 +1233,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >         else if (ofs->upper_mnt->mnt_sb != ofs->same_sb)
> >                 ofs->same_sb = NULL;
> >
> > +       if (!(ovl_force_readonly(ofs)) && ofs->config.metacopy) {
> > +               /* Verify lower root is upper root origin */
> > +               err = ovl_verify_origin(upperpath.dentry,
> > +                                       oe->lowerstack[0].dentry, false, true);
> > +               if (err) {
> > +                       pr_err("overlayfs: failed to verify upper root origin\n");
> > +                        goto out_free_oe;
> > +               }
> > +       }
> > +
> >
> 
> Fs can have upper but no workdir and you still need to verify lower
> If metacopy is enabled

Hmm..., trying to understand this. This probably is more involved.

So first use case is that if metacopy is being enabled, verify lower
root is upper root origin. (Even if it is read-only fs).

if (ofs->upper_mnt && ofs->config.metacopy)
	ovl_verify_origin().

But this does not cover the case of same fs being remounted with
metacopy=off. In that case we will not do metacopy only copy ups but
existing metacopy inodes will still require that lower does not change.

Will it make sense to set OVL_METACOPY xattr on upper when metacopy=on
is done first time on mount. And later in subsequent mounts, if METACOPY
is set on upper, make sure to verify origin and make sure lower supports
file handles etc.

Thanks
Vivek
