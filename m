From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/13] ovl: Create origin xattr on copy up for all files
Date: Thu, 26 Oct 2017 08:53:30 -0400
Message-ID: <20171026125330.GA28005@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <1508958575-14086-3-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxj88gEpnuPY1R9sAJn6OmZBzWK-N5u8-OoeL1SLnqHLmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932204AbdJZMxb (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 08:53:31 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj88gEpnuPY1R9sAJn6OmZBzWK-N5u8-OoeL1SLnqHLmw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 26, 2017 at 08:31:48AM +0300, Amir Goldstein wrote:
> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Right now my understanding is that origin xattr is created for all copied
> > up files if index=on. And if index=off, then we create it for all type
> > of files except hardlinks (nlink != 1).
> >
> > With metadata only copy up, I will still require origin xattr to copy up
> > data later, so create it even for hardlinks even with index=off.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c | 7 +------
> >  1 file changed, 1 insertion(+), 6 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index c441f93..8a8f538 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -470,9 +470,6 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >         /*
> >          * Store identifier of lower inode in upper inode xattr to
> >          * allow lookup of the copy up origin inode.
> > -        *
> > -        * Don't set origin when we are breaking the association with a lower
> > -        * hard link.
> >          */
> >         if (c->origin) {
> >                 err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> > @@ -538,9 +535,6 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
> >             c->stat.nlink > 1)
> >                 indexed = true;
> >
> > -       if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
> > -               c->origin = true;
> > -
> >         if (indexed) {
> >                 c->destdir = ovl_indexdir(c->dentry->d_sb);
> >                 err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
> > @@ -596,6 +590,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> >                 .parent = parent,
> >                 .dentry = dentry,
> >                 .workdir = ovl_workdir(dentry),
> > +               .origin = true,
> 
> If its always true, please remove the condition variable,

Right. I will remove it.

> but if it
> were up to me,
> I would set it to true only when metacopy is enabled for now and maybe relax it
> unconditionally later on

I rather not make it metacopy dependent. If there are issus with
this, they better come out now and don't want these issues to be visible
only if metacopy=on. It becomes another corner case to handle then. Want
to avoid it.

Vivek

> 
> >         };
> >
> >         if (WARN_ON(!ctx.workdir))
> > --
> > 2.5.5
> >
