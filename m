Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4FAC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 12:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E1C6142A
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 12:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351176AbhI3M5t (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351173AbhI3M5s (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Sep 2021 08:57:48 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A2AC06176A
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Sep 2021 05:56:06 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id r8so4153237uap.0
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Sep 2021 05:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4NMeHKKTyAGCpOOy3N5j+Y4kBgerv4UGsLR0VwEeEpQ=;
        b=o7snawbz68x/cCIJ3BbRpgHNBQ6M+TzWngw5F6loARc9+dM6dSLNcB2h5xJNS+wxNd
         tDNqpATgGxjazDV5qX6JxBUlW0+PC9UXHmskDWLNusLM8a/2ZSuYfHDKH2lqyOOdTfMc
         NFI2xp+LDxV4TMX7yNVa57zV+M2diM6Wnl7k4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NMeHKKTyAGCpOOy3N5j+Y4kBgerv4UGsLR0VwEeEpQ=;
        b=CX/Z9dSQdBZo7PIZjgLf9lVq0TZBlVO34IyrBgkk7eI36qCGyQBaJzPLhpZHhtUeLi
         OxxKsa3B0uTMl1//lhrJyyvp4xj17hJ+lBlOLuTaCHuod78tk1wH/9MY/W/j9dmO8vEs
         TMre31S8ivaqBOMZv//sUL1IMux+nMg5ICul/cl4lJOt7gqhy429tjIRn/ALklATWo2I
         cYRB2TT2bKAvQJliXoj52OO4gCDwzEl8oeiEaiXt8LT7P1SeA16zi/ELxOJIcyLf5v41
         8sqeW3z6RrfKtKGtCJSDdb3O1ghRizuvmVEiFihWKQUd4chFlCvrTI2UMc7qmCJEvaoI
         xqXA==
X-Gm-Message-State: AOAM530qkbvh+8zvZ0C570vvudjT2+d1zGJ9ZJZRlgJEZ18VqUtmpm8f
        oF+gNw7iWX614EnuNkTtqwYsmd9Hqx2F8juyetgJsg==
X-Google-Smtp-Source: ABdhPJzZPqlYo/OA7xpYUhrwETBr1UDCOClvRBHiS5Ww7axivu/X0teXsDl0f45NKgox8G/g1rmvcRI9kgeWLXegaro=
X-Received: by 2002:ab0:471d:: with SMTP id h29mr5262001uac.11.1633006565123;
 Thu, 30 Sep 2021 05:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210928124757.117556-1-cgxu519@mykernel.net>
In-Reply-To: <20210928124757.117556-1-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 30 Sep 2021 14:55:54 +0200
Message-ID: <CAJfpegsHH1wpLXDJXemVM1mpcRACRwew8pc2X62KkyuwS91jKQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: set overlayfs inode's a_ops->direct_IO properly
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Huang Jianan <huangjianan@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 28 Sept 2021 at 14:48, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Loop device checks the ability of DIRECT-IO by checking
> a_ops->direct_IO of inode, in order to avoid this kind of
> false detection we set a_ops->direct_IO for overlayfs inode
> only when underlying inode really has DIRECT-IO ability.
>
> Reported-by: Huang Jianan <huangjianan@oppo.com>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

Can you please add  Fixes: and  Cc: stable@vger.kernel.org tags?

> ---
>  fs/overlayfs/dir.c       |  2 ++
>  fs/overlayfs/inode.c     |  4 ++--
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/util.c      | 14 ++++++++++++++
>  4 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 1fefb2b8960e..32a60f9e3f9e 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -648,6 +648,8 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
>         /* Did we end up using the preallocated inode? */
>         if (inode != d_inode(dentry))
>                 iput(inode);
> +       else
> +               ovl_inode_set_aops(inode);

This is too late, since the dentry was instantiated and can be found
through a cached lookup already.

Anyway, I think this can be dropped, since ovl_inode_init() should be
called for inodes preallocated by ovl_create_object() as well:
inode_insert5() will set I_NEW on the preallocated inode.

It is interesting that ovl_fill_inode() will be called a second time
on the preallocated inode.  This is something that should probably be
cleaned up, but that's a separate patch.

>
>  out_drop_write:
>         ovl_drop_write(dentry);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 832b17589733..a7a327e4f790 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -659,7 +659,7 @@ static const struct inode_operations ovl_special_inode_operations = {
>         .update_time    = ovl_update_time,
>  };
>
> -static const struct address_space_operations ovl_aops = {
> +const struct address_space_operations ovl_aops = {
>         /* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
>         .direct_IO              = noop_direct_IO,
>  };
> @@ -786,6 +786,7 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
>         ovl_copyattr(realinode, inode);
>         ovl_copyflags(realinode, inode);
>         ovl_map_ino(inode, ino, fsid);
> +       ovl_inode_set_aops(inode);

OVL_UPPERDATA is only set after ovl_get_inode() in all callers.  This
needs to be moved into ovl_inode_init() before calling
ovl_inode_set_aops() otherwise this won't work correctly for a copied
up file.

Thanks,
Miklos
