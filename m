From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 01/11] ovl: Create origin xattr on copy up for all files
Date: Wed, 18 Oct 2017 08:55:15 -0400
Message-ID: <20171018125515.GB3445@redhat.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
 <1508274358-17456-2-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxhSYwQdeofy94jttDznfn6NSeM32UQSBKKvcE=xjjAs=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751828AbdJRMzR (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 08:55:17 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhSYwQdeofy94jttDznfn6NSeM32UQSBKKvcE=xjjAs=A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 07:09:37AM +0300, Amir Goldstein wrote:
> On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Right now my understanding is that origin xattr is created for all copied
> > up files if index=on. And if index=off, then we create it for all type
> > of files except hardlinks (nlink != 1).
> >
> > With metadata only copy up, I will still require origin xattr to copy up
> > data later, so create it even for hardlinks even with index=off. I am
> > hoping it does not break anything because we do OVL_INDEX test before
> > using inode number of origin.
> 
> I still have a nudging buzz that loosing the information about this upper
> being a broken hardlink may come back to bite us some time, but can't
> put my finger on how.

Hi Amir,

Can't we do stat() on ORIGIN and check nlink to figure out if it is a broken
hard link or not. (If it ever becomes a problem in future). IOW, we still
have a way to figure out if this is broken hard link or not. Just that
it involves extra step of doing stat() and its not the presence/absense
of ORIGIN.

> 
> To reduce the level of that buzz, I suggest to set origin for broken hardlink
> only when doing metacopy and then break the origin association when
> removing metacopy xattr.

While removing metacopy xattr, I will not have any idea whether it is
broken hard link or not. I guess I will have to use above trick and do
stat() on ORIGIN and detect broken hard links.

I feel really odd about special casing this broken hard link case and
setting and clearing ORIGIN with metacopy flags. It makes code
twisted and complicated.

Given stat() should allow us to figure out if something is broken hard
link or not, does it make you feel any better about it.

> 
> In any case, this patch needs to update the comment above setting
> origin xattr that claims to break the association with broken hardlink.

Ok, Will do.

Vivek
> 
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index c441f9387a1b..0a6294ea64d5 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -538,9 +538,6 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
> >             c->stat.nlink > 1)
> >                 indexed = true;
> >
> > -       if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
> > -               c->origin = true;
> > -
> >         if (indexed) {
> >                 c->destdir = ovl_indexdir(c->dentry->d_sb);
> >                 err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
> > @@ -596,6 +593,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> >                 .parent = parent,
> >                 .dentry = dentry,
> >                 .workdir = ovl_workdir(dentry),
> > +               .origin = true,
> >         };
> >
> >         if (WARN_ON(!ctx.workdir))
> > --
> > 2.13.5
> >
