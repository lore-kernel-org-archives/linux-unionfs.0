Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80232C433EF
	for <linux-unionfs@archiver.kernel.org>; Sat, 26 Feb 2022 16:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiBZQix (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 26 Feb 2022 11:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiBZQiw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 26 Feb 2022 11:38:52 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1A6267117
        for <linux-unionfs@vger.kernel.org>; Sat, 26 Feb 2022 08:38:18 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id c23so10153007ioi.4
        for <linux-unionfs@vger.kernel.org>; Sat, 26 Feb 2022 08:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kptxVqDxzUzfSCGkHIKsxUDACu4/H3c0pwyjpgoqZgA=;
        b=MHiQszqAXotrDV3vpJNkuSjQI7rhI70LSW0M4UsS8Zjz91N48PXdsaAJixUo+bkWbw
         tyBo2fgurJ4bFJdJco6pDiNxuWXD3PE/cuRLXcHm06oz45kU0P7mGsHEW+CwNbOYgPLg
         CTIYqIsfDQRXjyIM9Lmqj8UwRQ+tLZk4PwOpM4fPj2pDDc8NwvlB79Ph2D5p+yxOn2Es
         tN3Iumzky9+24TFGTX+S8wQlJW5TLnx1ceOMmHR2QmUP8ALc7o8fsCDHm0uNkyXYWNwb
         hkFabUTPBFKr44sOwT5QpIHa1ZWjTnSGkwjSMcBXRS7Y848n0/gpBjjadg+SRRWJ7h6U
         t4Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kptxVqDxzUzfSCGkHIKsxUDACu4/H3c0pwyjpgoqZgA=;
        b=L9Od0vabK4vkKrcZsCdPwavxr8sqC3/I5o/nric+CLDZJXjvTbmChrdI0IPNzNltSd
         hRj5mU8oP9CpqTPns2N2pF9+w/bJrP8X0ZJBxmkHMPlBVZeZHZn2cdEpwsywfqdNj339
         dSnlQOb1rdtN5L7wwqgTXteQgGZH5U0+dQBVARUId63X6u3NEyvAAobKIWG2Z4Og08qQ
         cemL+1G150q6CP+na9aezKzaA+mSv2UGQaDsvqewlyt8ypO/EfkveHFpn1WmYjfAE5Nh
         ToKXfQ856KazJqH0AgNSI/a39IfIgwgZowIa/GdIoi/IsI4+giPW5GsyvDopu41cIcsV
         LYhw==
X-Gm-Message-State: AOAM5310I9raeRxC3jk0mEI6jM26VxWR+8baSgEous6xlh96NkyiJsYK
        jYsdORooY7pdjgS5DlJlzvqEFdlyKNUYCemU3Sl4zl3OT/k=
X-Google-Smtp-Source: ABdhPJxDvK+1O1Y264EcOBcjHALUl1Ay7vFMHDRPS4kTaw1VBcWkHvkgmO1Rnyl2tYgu2Ju2EQPy3bQzky7t+b9wz88=
X-Received: by 2002:a05:6638:4905:b0:317:1dda:b116 with SMTP id
 cx5-20020a056638490500b003171ddab116mr1955693jab.188.1645893496369; Sat, 26
 Feb 2022 08:38:16 -0800 (PST)
MIME-Version: 1.0
References: <20220226152058.288353-1-cgxu519@mykernel.net>
In-Reply-To: <20220226152058.288353-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 26 Feb 2022 18:38:05 +0200
Message-ID: <CAOQ4uxiWZ4TWq4LuNOHYMHDgX+2Srq_3HNe+t5z-Ch4AFw9bRA@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: fsync parent directory in copy-up
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Feb 26, 2022 at 5:21 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Calling fsync for parent directory in copy-up to
> ensure the change get synced.

It is not clear to me that this change is really needed
What if the reported problem?

Besides this can impact performance in some workloads.

The difference between parent copy up and file copy up is that
failing to fsync to copied up data and linking/moving the upper file
into place may result in corrupted data after power failure if temp
file data is not synced.

Failing the fsync the parent dir OTOH may result in revert to
lower file data after power failure.

The thing is, although POSIX gives you no such guarantee, with
ext4/xfs fsync of the upper file itself will guarantee that parents
will be present after power failure (see [1]).

This is not true for btrfs, but there are fewer users using overlayfs
over btrfs (at least in the container world).

So while your patch is certainly "correct", for most users its effects
will be only negative - performance penalty without fixing anything.
So I think this change should be opt-in with Kconfig/module/mount option.

Unfortunately, there is currently no way to know whether the underlying
filesystem needs the parent dir fsync or not.
I was trying to promote a VFS API for a weaker version of fsync for
the parent dir [2] but that effort did not converge.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/1552418820-18102-1-git-send-email-jaya@cs.utexas.edu/
[2] https://lore.kernel.org/linux-fsdevel/20190527172655.9287-1-amir73il@gmail.com/

>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/copy_up.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index e040970408d4..52ca915f04a3 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -944,6 +944,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>  {
>         int err;
>         DEFINE_DELAYED_CALL(done);
> +       struct file *parent_file = NULL;
>         struct path parentpath;
>         struct ovl_copy_up_ctx ctx = {
>                 .parent = parent,
> @@ -972,6 +973,12 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                                   AT_STATX_SYNC_AS_STAT);
>                 if (err)
>                         return err;
> +
> +               parent_file = ovl_path_open(&parentpath, O_WRONLY);
> +               if (IS_ERR(parent_file)) {
> +                       err = PTR_ERR(parent_file);
> +                       return err;
> +               }
>         }
>
>         /* maybe truncate regular file. this has no effect on dirs */
> @@ -998,6 +1005,14 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                         err = ovl_copy_up_meta_inode_data(&ctx);
>                 ovl_copy_up_end(dentry);
>         }
> +
> +       if (!err) {
> +               if (parent_file) {
> +                       vfs_fsync(parent_file, 0);
> +                       fput(parent_file);
> +               }
> +       }
> +
>         do_delayed_call(&done);
>
>         return err;
> --
> 2.27.0
>
>
