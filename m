From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: hash directory inodes for fsnotify
Date: Mon, 15 Jan 2018 10:49:51 +0200
Message-ID: <CAOQ4uxi_7a_6z4bFZo7q6mWBdQqZcLbdZ4Hd_JfxHRE+iu7oqg@mail.gmail.com>
References: <1515947740-16120-1-git-send-email-amir73il@gmail.com> <20180115083604.GA26612@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:44137 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753842AbeAOItw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 03:49:52 -0500
Received: by mail-yb0-f194.google.com with SMTP id h62so4163781ybi.11
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jan 2018 00:49:52 -0800 (PST)
In-Reply-To: <20180115083604.GA26612@veci.piliscsaba.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Niklas Cassel <niklas.cassel@axis.com>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 15, 2018 at 10:36 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Sun, Jan 14, 2018 at 06:35:40PM +0200, Amir Goldstein wrote:
>> fsnotify pins a watched directory inode in cache, but if directory dentry
>> is released, new lookup will allocate a new dentry and a new inode.
>> Directory events will be notified on the new inode, while fsnotify listener
>> is watching the old pinned inode.
>>
>> Hash all directory inodes to reuse the pinned inode on lookup. Pure upper
>> dirs are hashes by real upper inode, merge and lower dirs are hashed by
>> real lower inode.
>>
>> The reference to lower inode was being held by the lower dentry object
>> in the overlay dentry (oe->lowerstack[0]). Releasing the overlay dentry
>> may drop lower inode refcount to zero. Add a refcount on behalf of the
>> overlay inode to prevent that.
>>
>> As a by-product, hashing directory inodes also detects multiple
>> redirected dirs to the same lower dir and uncovered redirected dir
>> target on and returns -ESTALE on lookup.
>>
>> The reported issue dates back to initial version of overlayfs, but this
>> patch depends on ovl_inode code that was introduced in kernel v4.13.
>
> One nit: we are changing i_nlink for the overlay inode.  Not sure it matters,
> but better keep it consistent with st_nlink.  So added the following incremental
> patch on top of yours.
>

Okay. Proposing a minor variation below with 2 fewer lines. Up to you.

Thanks,
Amir.

>
>
> Index: linux/fs/overlayfs/inode.c
> ===================================================================
> --- linux.orig/fs/overlayfs/inode.c     2018-01-15 09:29:25.447748554 +0100
> +++ linux/fs/overlayfs/inode.c  2018-01-15 09:29:13.506835860 +0100
> @@ -645,6 +645,7 @@ struct inode *ovl_get_inode(struct dentr
>         /* Already indexed or could be indexed on copy up? */
>         bool indexed = (index || (ovl_indexdir(dentry->d_sb) && !upperdentry));
>         struct dentry *origin = indexed ? lowerdentry : NULL;
> +       bool is_dir;
>
>         if (WARN_ON(upperdentry && indexed && !lowerdentry))
>                 return ERR_PTR(-EIO);
> @@ -659,12 +660,13 @@ struct inode *ovl_get_inode(struct dentr
>          * Hash dir that is or could be merged by origin inode.
>          * Hash pure upper and non-indexed non-dir by upper inode.
>          */
> -       if (S_ISDIR(realinode->i_mode))
> +       is_dir = S_ISDIR(realinode->i_mode);
> +       if (is_dir)
>                 origin = lowerdentry;
>
>         if (upperdentry || origin) {
>                 struct inode *key = d_inode(origin ?: upperdentry);
> -               unsigned int nlink;
> +               unsigned int nlink = 1;

+               unsigned int nlink = is_dir ? 1 : realinode->i_nlink;

>
>                 inode = iget5_locked(dentry->d_sb, (unsigned long) key,
>                                      ovl_inode_test, ovl_inode_set, key);
> @@ -685,8 +687,9 @@ struct inode *ovl_get_inode(struct dentr
>                         goto out;
>                 }
>
> -               nlink = ovl_get_nlink(lowerdentry, upperdentry,
> -                                     realinode->i_nlink);
> +               if (!is_dir)
> +                       nlink = ovl_get_nlink(lowerdentry, upperdentry,
> +                                             realinode->i_nlink);

+                   nlink = ovl_get_nlink(lowerdentry, upperdentry, nlink);

>                 set_nlink(inode, nlink);
>         } else {
>                 inode = new_inode(dentry->d_sb);
> @@ -700,7 +703,7 @@ struct inode *ovl_get_inode(struct dentr
>                 ovl_set_flag(OVL_IMPURE, inode);
>
>         /* Check for non-merge dir that may have whiteouts */
> -       if (S_ISDIR(realinode->i_mode)) {
> +       if (is_dir) {
>                 struct ovl_entry *oe = dentry->d_fsdata;
>
>                 if (((upperdentry && lowerdentry) || oe->numlower > 1) ||
