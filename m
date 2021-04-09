Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AFCC433B4
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 13:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0869761108
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 13:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhDINtd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 09:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbhDINtc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Apr 2021 09:49:32 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD96CC061761
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Apr 2021 06:49:18 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id z23so673069uan.8
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Apr 2021 06:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a04r4S2bwT3yI/nXZO7/FhQTP1BmeTnC/ClHUjRaLsQ=;
        b=kpe1XcfddV4yaaQtv2H5SJ5yDVe3icOTQ+86MuMEude6fS85DDPdMKqNgpxMJctvv9
         gPKcsd1EF/kCsMkXOtVLozrxxzV+OLUHbBTRx3XcEXikRB9/oF4I3KeJjnqOB7jr5cri
         lxGC4tc29nQ4zVMOsMaXaa1DVOprXXQ2ffPQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a04r4S2bwT3yI/nXZO7/FhQTP1BmeTnC/ClHUjRaLsQ=;
        b=rkbEheDSGnt3E2ahHQ5MHDgAepVYO5ls7N0z1OsouCuZWCf8IbR7MOJKQFZst/FhCt
         2BNB0DIVoIIACFE14fD5CVJ1QEid7XkCJsWqUZV2Y7tESdSzQhdziXxhMkNPPjpF+2PG
         JfWmw+foEHhgCwkbhhnYi+qyRoM0RM5q8EbWmz2JAVthMYPg6J7Je5GKTcIxpJ7pBB0/
         oQsa3KeibNCNrrzIUfHy4VxvJiCLUcy6N6fCTkEZM3So51Sf+ywZ4tn5CL0EN77SanGS
         u6/ANt/j6HOQCJZAUQjle2IJXBMNnE9bj2OV3GXYwVydn2l5UCm0N/gVBanfxJjP3uWC
         lISw==
X-Gm-Message-State: AOAM533sFmfy/t5+9wCImasroX1eXI6l5LNntUjoo/Jh5AX7s0Ngcfd6
        ZF8U9zPmuI5hV1/9gGOWN60I3LCHQTXOe8t3BXuF6g==
X-Google-Smtp-Source: ABdhPJz0HYhlCK5ToIS879fgxpnuUX8Ztb+DG3M20GUQnLWjzcP9xva3Jd2Q8dKhTy0JFf6LkE32FqaVL3GCUcuIu4s=
X-Received: by 2002:ab0:596f:: with SMTP id o44mr10533554uad.8.1617976157986;
 Fri, 09 Apr 2021 06:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201113065555.147276-1-cgxu519@mykernel.net> <20201113065555.147276-7-cgxu519@mykernel.net>
In-Reply-To: <20201113065555.147276-7-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Apr 2021 15:49:07 +0200
Message-ID: <CAJfpegt6BUvEL2NtfMkYJfC_NBuLxKhV3U7-h4azhoM+ttxZAA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 6/9] ovl: implement overlayfs' ->write_inode operation
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
> Implement overlayfs' ->write_inode to sync dirty data
> and redirty overlayfs' inode if necessary.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/super.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 883172ac8a12..82e001b97f38 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -390,6 +390,35 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
>         return ret;
>  }
>
> +static int ovl_write_inode(struct inode *inode,
> +                          struct writeback_control *wbc)
> +{
> +       struct ovl_fs *ofs = inode->i_sb->s_fs_info;
> +       struct inode *upper = ovl_inode_upper(inode);
> +       unsigned long iflag = 0;
> +       int ret = 0;
> +
> +       if (!upper)
> +               return 0;
> +
> +       if (!ovl_should_sync(ofs))
> +               return 0;
> +
> +       if (upper->i_sb->s_op->write_inode)
> +               ret = upper->i_sb->s_op->write_inode(inode, wbc);
> +
> +       if (mapping_writably_mapped(upper->i_mapping) ||
> +           mapping_tagged(upper->i_mapping, PAGECACHE_TAG_WRITEBACK))
> +               iflag |= I_DIRTY_PAGES;
> +
> +       iflag |= upper->i_state & I_DIRTY_ALL;

How is I_DIRTY_SYNC added/removed from the overlay inode?

Thanks,
Miklos
