From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] overlayfs: ignore empty NFSv4 ACLs in ext4 upperdir
Date: Mon, 5 Dec 2016 10:19:33 -0500
Message-ID: <20161205151933.GA17517@fieldses.org>
References: <5a6862bd-924d-25e4-2a8e-ba4f51e66604@web.de>
 <CAJfpeguwUtRWRGmNmimNp-FXzWqMCCQMb24iWPu0w_J0_rOnnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJfpeguwUtRWRGmNmimNp-FXzWqMCCQMb24iWPu0w_J0_rOnnw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Patrick Plagwitz <Patrick_Plagwitz-S0/GAf8tV78@public.gmane.org>, "linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Dec 05, 2016 at 10:28:18AM +0100, Miklos Szeredi wrote:
> [Added a few more CCs]
> 
> On Mon, Dec 5, 2016 at 1:51 AM, Patrick Plagwitz
> <Patrick_Plagwitz-S0/GAf8tV78@public.gmane.org> wrote:
> > Mounting an overlayfs with an NFSv4 lowerdir and an ext4 upperdir causes copy_up operations, specifically the function copy_up.c:ovl_copy_xattr, to fail with EOPNOTSUPP.
> > For example, having the following folders:
> >
> > |- nfs <- NFSv4 is mounted here
> > |--|- folder
> > |- root <- ext4 is mounted here
> > |- work <- also ext4
> > |- merged <- overlay is mounted here with
> >              lowerdir=nfs,upperdir=root,workdir=work
> >
> > And calling
> > # touch merged/folder/file
> > will print
> > touch: cannot touch 'merged/folder/file': Operation not supported
> >
> > This is because NFS returns the xattr system.nfs4_acl with an empty value even if no NFS ACLs are in use in the lower filesystem. Trying to set this xattr in the upperdir
> > fails because ext4 does not support it.
> >
> > Fix this by explicitly checking for the name of the xattr and an empty value and ignoring EOPNOTSUPP if both things match.
> >
> > Signed-off-by: Patrick Plagwitz <patrick_plagwitz-S0/GAf8tV78@public.gmane.org>
> > ---
> > Maybe NFS could be changed to not return empty system.nfs4_acl values, I don't know. In any case, to support upperdir ext4 + lowerdir NFSv4, returning the error code from
> > vfs_setxattr with this xattr name must be avoided as long as the value is empty.
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 36795ee..505b86e 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -123,6 +123,9 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
> >                         continue; /* Discard */
> >                 }
> >                 error = vfs_setxattr(new, name, value, size, 0);
> > +               if (error == -EOPNOTSUPP && *value == '\0' &&
> > +                               strcmp(name, "system.nfs4_acl") == 0)
> > +                       error = 0;
> >                 if (error)
> >                         break;
> >         }
> 
> I agree that this should be fixed, but adding such exceptions for
> certain filesystems or xattrs is not the proper way, IMO.
> 
> Can NFS people comment on this?  Where does the nfs4_acl come from?

This is the interface the NFS client provides for applications to modify
NFSv4 ACLs on servers that support them.

> What can overlayfs do if it's a non-empty ACL?

As little as possible.  You can't copy it up, can you?  So any attempt
to support it is going to be incomplete.

> Does knfsd translate posix ACL into NFS acl?  If so, we can translate
> back.  Should we do a generic POSIX<->NFS acl translator?

knsd does translate between POSIX and NFSv4 ACLs.  It's a complicated
algorithm, and lossy (in the NFSv4->POSIX direction).  The client
developers have been understandably reluctant to have anything to do
with it.

So, I think listxattr should omit system.nfs4_acl, and attempts to
set/get the attribute should error out.  The same should apply to any
"system." attribute not supported by both filesystems, I think?

I don't understand overlayfs very well, though.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
