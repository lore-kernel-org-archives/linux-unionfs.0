Return-Path: <SRS0=bzPr=62=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8888C54E4A
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 May 2020 07:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C425E20736
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 May 2020 07:50:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GXlFi+8I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgELHun (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 May 2020 03:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgELHun (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 May 2020 03:50:43 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0051C061A0C
        for <linux-unionfs@vger.kernel.org>; Tue, 12 May 2020 00:50:42 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id w6so11329728ilg.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 May 2020 00:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0iebERdUSPVvOyD3YR0MriaAaOCbyOjwPxh+7q0elE0=;
        b=GXlFi+8IMoFyCvjrg4uFvZcvDQIXx/CfJ1KkcRAZw8z+6isEDWT7cuTQSYgEyRyekW
         eLLylKB0KD3kEbgzt3rSGG85ddYU6pEsFwOxDiwVxuBgKJ2l25Bh14P5zeKITSFiC22G
         batxHzzIorNhOreP562rGuJrZX8HMFXc1qw98cDsYbG55EAdeBeWkYM4GbaBQYrsyMmU
         L7EUUTa/U4/FszUedoDtJAxaVnE2tGJ5DYOoq0mM3S09ftCHzf/vS7CVs8O3ymxbsmYF
         Oy9Pq7pKBH0F7ftUqfia1CKpKWa32BlvQ6DTYgQ8V8caqpuxYcWwcdsPWmo8VlxwPzUL
         Q9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0iebERdUSPVvOyD3YR0MriaAaOCbyOjwPxh+7q0elE0=;
        b=DBUqjbBAbztJ5B+sU3i27PnRL2SOirAVsU9a+SYJRtgUsll8/RTGLrTxk/7aewO+DB
         ItWSmcOGGfcjuSftZ3AIh1O619HSANziXf5yg5GzqZQceeZ9W9Q0kbRccQS9+Q5nrx9Z
         zB77Zi9m3mRN6pjMlEHeMa8Lf1/uVBHxTMJycSCv9WPN8PSJ2ZBOB4r8lQfEo/u61fVn
         kPAyF2xTNyAx1jTqoaV8dnUwwzuzB2/dvPP+ezan3hPzs5WEotqrUc/Nhv8jzWHjzl19
         hTyqrpJI1L/76HXspqVL4fu2gYBmKIiy7VRuggJ8sD3xHY5Ek0DTxynOZokJir95zyKO
         u4FA==
X-Gm-Message-State: AGi0PuYaWM5eNqM9cFugUQZKZcV6CF+JxmP6+LAtr0piAYVAM6MVZJF6
        VY235n/ZujK/OcPt4BrCeaUSc/XhtlEKrP7ttBg=
X-Google-Smtp-Source: APiQypJkfk5h3WCJJvuCmnoDTPr0TebNH2Zn3eg2hTrrbYfU/7xjS91VzfRABgJkZ/hmPTClgJiY060E0NP8KvzOdkw=
X-Received: by 2002:a92:b69b:: with SMTP id m27mr20042981ill.250.1589269842233;
 Tue, 12 May 2020 00:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200512071313.4525-1-cgxu519@mykernel.net>
In-Reply-To: <20200512071313.4525-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 12 May 2020 10:50:31 +0300
Message-ID: <CAOQ4uxiA_Er_VA=m8ORovGyvHDFuGBS4Ss_ef5un5VJbrev3jw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] ovl: suppress negative dentry in lookup
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 12, 2020 at 10:13 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> When a file is only in a lower layer or in no layer at all, after
> lookup a negative dentry will be generated in the upper layer or
> even worse many negetive dentries will be generated in upper/lower
> layers. These negative dentries will be useless after construction
> of overlayfs' own dentry and may keep in the memory long time even
> after unmount of overlayfs instance. This patch tries to kill
> unnecessary negative dentry during lookup.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
> v1->v2:
> - Only drop negative dentry after slow lookup.
>
>  fs/namei.c            |  9 ++++++---
>  fs/overlayfs/namei.c  | 35 ++++++++++++++++++++++++++++++++++-
>  include/linux/namei.h |  8 ++++++++
>  3 files changed, 48 insertions(+), 4 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index a320371899cf..1cc2960c7804 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1386,7 +1386,7 @@ static inline int handle_mounts(struct nameidata *nd, struct dentry *dentry,
>   * This looks up the name in dcache and possibly revalidates the found dentry.
>   * NULL is returned if the dentry does not exist in the cache.
>   */
> -static struct dentry *lookup_dcache(const struct qstr *name,
> +struct dentry *lookup_dcache(const struct qstr *name,
>                                     struct dentry *dir,
>                                     unsigned int flags)
>  {
> @@ -1402,6 +1402,7 @@ static struct dentry *lookup_dcache(const struct qstr *name,
>         }
>         return dentry;
>  }
> +EXPORT_SYMBOL(lookup_dcache);
>
>  /*
>   * Parent directory has inode locked exclusive.  This is one
> @@ -1500,7 +1501,7 @@ static struct dentry *lookup_fast(struct nameidata *nd,
>  }
>
>  /* Fast lookup failed, do it the slow way */
> -static struct dentry *__lookup_slow(const struct qstr *name,
> +struct dentry *__lookup_slow(const struct qstr *name,
>                                     struct dentry *dir,
>                                     unsigned int flags)
>  {
> @@ -1536,6 +1537,7 @@ static struct dentry *__lookup_slow(const struct qstr *name,
>         }
>         return dentry;
>  }
> +EXPORT_SYMBOL(__lookup_slow);
>
>  static struct dentry *lookup_slow(const struct qstr *name,
>                                   struct dentry *dir,
> @@ -2460,7 +2462,7 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
>  }
>  EXPORT_SYMBOL(vfs_path_lookup);
>
> -static int lookup_one_len_common(const char *name, struct dentry *base,
> +int lookup_one_len_common(const char *name, struct dentry *base,
>                                  int len, struct qstr *this)
>  {
>         this->name = name;
> @@ -2491,6 +2493,7 @@ static int lookup_one_len_common(const char *name, struct dentry *base,
>
>         return inode_permission(base->d_inode, MAY_EXEC);
>  }
> +EXPORT_SYMBOL(lookup_one_len_common);
>
>  /**
>   * try_lookup_one_len - filesystem helper to lookup single pathname component
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 723d17744758..d8e71173ea75 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -191,6 +191,39 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
>         return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
>  }
>
> +static struct dentry *ovl_lookup_positive_unlocked(const char *name,
> +                                                  struct dentry *base,
> +                                                  int len)
> +{
> +       struct qstr this;
> +       struct dentry *ret;
> +       bool not_found = false;
> +       int err;
> +
> +       err = lookup_one_len_common(name, base, len, &this);
> +       if (err)
> +               return ERR_PTR(err);
> +
> +       ret = lookup_dcache(&this, base, 0);
> +       if (ret)
> +               return ret;
> +
> +       inode_lock_shared(base->d_inode);
> +       ret = __lookup_slow(&this, base, 0);
> +       if (!IS_ERR(ret) &&
> +           d_flags_negative(ret->d_flags)) {
> +               not_found = true;
> +               d_drop(ret);
> +       }
> +       inode_unlock_shared(base->d_inode);
> +
> +       if (not_found) {
> +               dput(ret);
> +               ret = ERR_PTR(-ENOENT);
> +       }
> +       return ret;
> +}
> +

I think there was a misunderstanding.

This helper should be in vfs code, not duplicating vfs code
and please don't duplicate code in vfs either.

I think you can use a lookup flag (LOOKUP_POSITIVE_CACHE???)
to describe the desired behavior and implement it inside
lookup_slow(). Document the semantics as well as explain
in the context of the helper the cases where modules might
find this useful (because they have higher level caches).

Besides the fact that this helper really needs review by Al
and that duplicating subtle code is wrong in so many levels,
I suppose the functionality could prove useful to other subsystems
as well.

Thanks,
Amir.
