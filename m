Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <7da0ae14-8eda-1d53-ec45-38c457c35117@rasmusvillemoes.dk>
In-Reply-To: <7da0ae14-8eda-1d53-ec45-38c457c35117@rasmusvillemoes.dk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 20 Sep 2018 14:20:26 +0300
Message-ID: <CAOQ4uxgnoPBVwpZZuFzgq-+cGW+pvsKSb-_ia_qX5va+kjSy5g@mail.gmail.com>
Subject: Re: revealing file from lower fs ('reverting changes')
Content-Type: text/plain; charset="UTF-8"
To: linux@rasmusvillemoes.dk
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Sep 20, 2018 at 12:17 PM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> I'm wondering if there is a way to remove a file from the upper
> directory without leaving a whiteout behind, but instead let the file
> (if any, of course) in the lower file system become visible? Obviously
> this can be done by unmounting the overlay, removing the file (or
> whiteout) from the upper dir, then mounting again, but I'd like to be
> able to do this to a live system. Essentially, having a way to revert
> changes done to an existing file.
>
> I briefly looked into dir.c, and it seems that ovl_remove_upper would
> actually do the right thing, but there doesn't seem to be any way to get
> there via normal VFS operations. RENAME_WHITEOUT is the exact opposite,
> and even if there was a RENAME_NOWHITEOUT, that would have a lot of
> problems (probably wouldn't work if the file is a whiteout (src dentry
> lookup would fail), requires coming up with a tmp name to rename to and
> then unlink that as a second step, semantics if the file only exists in
> the lower layer). Maybe an AT_REMOVEUPPER flag for unlinkat could be
> implemented (which would fail with ENOENT unless the file is in the
> upper part of an overlay file system)? Or, as an overlayfs specific
> ioctl on the containing directory?
>

RENAME_NOWHITEOUT sounds reasonable to me, as well as
REMOVE_NOWHITEOUT (how the hell did AT_ prefix end up in
AT_REMOVEDIR?)

Those should be pretty simple to implement for a positive non-dir dentry
and will require some more vfs and ovl changes for a negative dentry
(i.e. upper is a whiteout).
For example, this patch should probably do for REMOVE_NOWHITEOUT
(after you propagated unlink(2) flags into unlink() inode operation):

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -833,7 +833,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
                goto out_drop_write;

        old_cred = ovl_override_creds(dentry->d_sb);
-       if (!lower_positive)
+       if (!lower_positive || flags & RENAME_NOWHITEOUT)
                err = ovl_remove_upper(dentry, is_dir, &list);
        else
                err = ovl_remove_and_whiteout(dentry, &list);
---

You can see why REMOVE_NOWHITEOUT makes sense in this context.
Patch should be quite simple for RENAME_NOWHITEOUT as well as long
as it is not allowed to mix it with neither RENAME_WHITEOUT nor with
RENAME_EXCHANGE.
Directories will be a little bit more complicated to reveal.

Note that d_drop(dentry) in ovl_remove_upper() is essential to avoid
leaving a negative dentry in dcache and forcing lookup to re-find
the lower inode.

Thanks,
Amir.
