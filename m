From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 04/11] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Wed, 18 Oct 2017 10:10:59 -0400
Message-ID: <20171018141059.GG3445@redhat.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
 <1508274358-17456-5-git-send-email-vgoyal@redhat.com>
 <CAOQ4uximnQT43BK3Ut82Vs0FMDi03cxAkyDK4LthkMiXHii-HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdJROLA (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 10:11:00 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uximnQT43BK3Ut82Vs0FMDi03cxAkyDK4LthkMiXHii-HQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 07:31:51AM +0300, Amir Goldstein wrote:

[..]
> > @@ -644,9 +664,16 @@ static int ovl_lower_dir(const char *name, struct path *path,
> >          * The inodes index feature needs to encode and decode file
> >          * handles, so it requires that all layers support them.
> >          */
> > -       if (ofs->config.index && !ovl_can_decode_fh(path->dentry->d_sb)) {
> > +       if ((ofs->config.index || ofs->config.metacopy) &&
> > +            !ovl_can_decode_fh(path->dentry->d_sb)) {
> > +               if (ofs->config.index)
> > +                       pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
> > +
> > +               if (ofs->config.metacopy)
> > +                       pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to metacopy=off.\n", name);
> > +
> 
> In my verify_dir patches I used the following more compact warning
> style instead of granular warnings:
> 
>     pr_warn("overlayfs: fs on '%s' does not support file handles,
> falling back to index=off,metacopy=off.\n", name);

Ok, I was not sure about it. I am fine with above style too.

BTW, I have a question. Current code seems to ensure that upper/work
supports file handles.

	/* Check if upper/work fs supports file handles */
	if (ufs->config.index &&
		!ovl_can_decode_fh(ufs->workdir->d_sb)) {
		ufs->config.index = false;
		pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
	}

I am wondering why that's the case and do I need it for metacopy feature
also. I thought that file handle support requirement was only on lower
dirs because they are the one who will export the origin file handle. All
upper has to do it that save this file handles in an xattr.

What am I missing?

Vivek
