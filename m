Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A13C433ED
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 13:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 291486115B
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 13:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhDINpz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 09:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbhDINpy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Apr 2021 09:45:54 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFFDC061761
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Apr 2021 06:45:40 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id v29so2940316vsi.7
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Apr 2021 06:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mjbwxZLTfyMvTIAAB3KJizD/ANM3CPP2Lc59q5rRawA=;
        b=aK3LXwbfJM2K86PfIVmS+h8V2lnVkHYNWItFNMT69Df3a2+Wrr989fA0r9IDHxK8Ln
         q0w74EW69gHu5m1XJh8+vT9qu2ewcGlYx1qG9YtAbscQVVooitjjmbifJOMXqgQtb0t7
         BtdTCTF/UOynKIH9zqRXbL/1kU7pdWTFwT/8g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mjbwxZLTfyMvTIAAB3KJizD/ANM3CPP2Lc59q5rRawA=;
        b=pFMaPxAwrSTzWPhVr0d6+kKp65E1IDwcFqmPoeFrWfEl1ryXNNcrdnH1FiHVpjKDY3
         esIc5hMvVhRn22S8zVK31BCw1gzxZ4tTLrGVMSE0klaiwldcKGTZwhYx9pM8UCgchbKJ
         6WnU2hZGjwpYQp9CGMspLz4aFs6x+xiyJiIyEi3upud+NUvBtI31Gn5jsa6R7crade1r
         IlmkJGR+tt8lRuRQ8ckFqGEDVnw0MQleMlRsmuqkKZkaBOaj2V3NGJHu7WDx5jPMx1sx
         MEAI/9S9GY4vIFDt8o8dRYREzY9rLIGwNrRmGMIh0TpdkDeBQlmoonn0GFOaDkSGWyX6
         GBUA==
X-Gm-Message-State: AOAM5336KkJ93u9giyaWoFPtjibZSNheZP2sWKSzSj4j7GgKrXSWhlRl
        zCZeV6skwzWpNsu5uMOz9uCz3aQlJplsdp2Ep/JmCw==
X-Google-Smtp-Source: ABdhPJziNwqoXOHIqKtY2+xBsszR+39euUQGGGVXqZL9/ApN4CYJ8ffPcQYBBU+BpCpC6VPiwz3yQim8PQNBJmy/hWA=
X-Received: by 2002:a67:f487:: with SMTP id o7mr11175315vsn.7.1617975939801;
 Fri, 09 Apr 2021 06:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20201113065555.147276-1-cgxu519@mykernel.net> <20201113065555.147276-5-cgxu519@mykernel.net>
In-Reply-To: <20201113065555.147276-5-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Apr 2021 15:45:28 +0200
Message-ID: <CAJfpegtyUXcyiUG=YH1Hi06qwuYdtDL_kArQxN9mJUj7JJWZ0w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/9] ovl: mark overlayfs' inode dirty on modification
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Nov 13, 2020 at 7:57 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Mark overlayfs' inode dirty on modification so that
> we can recognize target inodes during syncfs.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/inode.c     |  1 +
>  fs/overlayfs/overlayfs.h |  4 ++++
>  fs/overlayfs/util.c      | 14 ++++++++++++++
>  3 files changed, 19 insertions(+)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 8cfa75e86f56..342693657ab0 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -468,6 +468,7 @@ int ovl_update_time(struct inode *inode, struct timespec64 *ts, int flags)
>                 if (upperpath.dentry) {
>                         touch_atime(&upperpath);
>                         inode->i_atime = d_inode(upperpath.dentry)->i_atime;
> +                       ovl_mark_inode_dirty(inode);
>                 }
>         }
>         return 0;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index f8880aa2ba0e..eaf1d5b05d8e 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -247,6 +247,7 @@ static inline bool ovl_open_flags_need_copy_up(int flags)
>  }
>
>  /* util.c */
> +void ovl_mark_inode_dirty(struct inode *inode);
>  int ovl_want_write(struct dentry *dentry);
>  void ovl_drop_write(struct dentry *dentry);
>  struct dentry *ovl_workdir(struct dentry *dentry);
> @@ -472,6 +473,9 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
>         to->i_mtime = from->i_mtime;
>         to->i_ctime = from->i_ctime;
>         i_size_write(to, i_size_read(from));
> +
> +       if (ovl_inode_upper(to) && from->i_state & I_DIRTY_ALL)
> +               ovl_mark_inode_dirty(to);
>  }

Okay, ovl_copyattr() certainly seems a good place to copy dirtyness as well.

What I'm fearing is that it does not cover all the places where
underlying inode can be dirtied.  This really needs an audit of all
filesystem modifying operations.

>
>  static inline void ovl_copyflags(struct inode *from, struct inode *to)
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 23f475627d07..a6f59df744ae 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -950,3 +950,17 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
>         kfree(buf);
>         return ERR_PTR(res);
>  }
> +
> +/*
> + * We intentionally add I_DIRTY_SYNC flag regardless dirty flag
> + * of upper inode so that we have chance to invoke ->write_inode
> + * to re-dirty overlayfs' inode during writeback process.
> + */
> +void ovl_mark_inode_dirty(struct inode *inode)
> +{
> +       struct inode *upper = ovl_inode_upper(inode);
> +       unsigned long iflag = I_DIRTY_SYNC;
> +
> +       iflag |= upper->i_state & I_DIRTY_ALL;
> +       __mark_inode_dirty(inode, iflag);
> +}
> --
> 2.26.2
>
>
