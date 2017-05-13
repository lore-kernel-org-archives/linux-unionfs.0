From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/2] ovl: constant d_ino across copy up
Date: Sat, 13 May 2017 17:25:32 +0300
Message-ID: <CAOQ4uxg3_wLfcCGEn4XjdaCJS8uU3FFYVXRRhzUcSE+rggQ9xA@mail.gmail.com>
References: <1494510147-18658-1-git-send-email-amir73il@gmail.com> <1494510147-18658-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34774 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbdEMOZd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 13 May 2017 10:25:33 -0400
Received: by mail-oi0-f65.google.com with SMTP id w10so12824193oif.1
        for <linux-unionfs@vger.kernel.org>; Sat, 13 May 2017 07:25:33 -0700 (PDT)
In-Reply-To: <1494510147-18658-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

On Thu, May 11, 2017 at 4:42 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> This patch is based on an earlier POC by Miklos Szeredi.
>
> When all layers are on the same fs, and iterating a directory which
> may contain copy up entries, call vfs_getattr() on the overlay entries
> to make sure that d_ino will be consistent with st_ino from stat(2).
>
[...]
>
> +/*
> + * Set d_ino for upper entries. Non-upper entries should always report
> + * the uppermost real inode ino and should not call this function.
> + *
> + * When not all layer are on same fs, report real ino also for upper.
> + *
> + * When all layers are on the same fs, and upper has a reference to
> + * copy up origin, call vfs_getattr() on the overlay entry to make
> + * sure that d_ino will be consistent with st_ino from stat(2).
> + */
> +static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
> +
> +{
> +       struct dentry *dir = path->dentry;
> +       struct dentry *this = NULL;
> +       enum ovl_path_type type;
> +       u64 ino = p->real_ino;
> +       int err = 0;
> +
> +       if (!ovl_same_sb(dir->d_sb) || WARN_ON(p->idx))
> +               goto out;
> +
> +       if (p->name[0] == '.') {
> +               if (p->len == 1) {
> +                       this = dget(dir);
> +                       goto get;
> +               }
> +               if (p->len == 2 && p->name[1] == '.') {
> +                       /* we shall not be moved */
> +                       this = dget(dir->d_parent);
> +                       goto get;
> +               }
> +       }
> +       this = lookup_one_len(p->name, dir, p->len);

Mmm... that reeks of layer violation, but I can't find anything obvious
that could go wrong from calling lookup on overlay dir here, is there?

It's just so convenient to use overlay lookup here, get the overlay
entry from cache and stat it, so I can't think of a better alternative.

BTW, couldn't find anything obviously wrong with stat'ing overlay
dir and dir->d_parent here either, is there?

> +get:
> +       type = ovl_path_type(this);
> +       if (OVL_TYPE_ORIGIN(type)) {
> +               struct kstat stat;
> +               struct path statpath = *path;
> +
> +               statpath.dentry = this;
> +               err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
> +               if (err)
> +                       goto fail;
> +
> +               WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
> +               ino = stat.ino;
> +       }
> +
