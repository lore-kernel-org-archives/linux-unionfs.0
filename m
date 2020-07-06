Return-Path: <SRS0=8cne=AR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9E3C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 12:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FC98206F5
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 12:15:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ChhFA0Qp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgGFMPS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728976AbgGFMPS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jul 2020 08:15:18 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384F2C061794
        for <linux-unionfs@vger.kernel.org>; Mon,  6 Jul 2020 05:15:18 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f23so39075950iof.6
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Jul 2020 05:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7oLBLghrr79jFcmONz7EwL2GH/BGPeHdNV1OTjzcn1Q=;
        b=ChhFA0QpDFhr74csvQpDEPy0WEbWKQ6dM3I1m8Jd9qi9eLI1w/xTx5GRx5AtNVT27S
         XrIbYic3aA+73LYgc6xwvNobG2qfmc+3j5VaWopEJtcQBCjpfb0YR5cCyvCKcyci8pK6
         E4iKAkPe+5H9WrmTPlHWHQtfpusl/k7kwowhpy+mrFPb7b8diWC86O4/GmRYaq3mMR4H
         +TAk0B1BjrJ2QDYrz0EWDc5fpYvVOjU3X3/L+R7zKcWvermvXoLtt07fvGIXe/kt/y2c
         rwuGS1Guz/YBdO8w5Tc0JsJgXHU+Q15vTc7FMPc1HSLvAHqkX79eFFuie5CwIOyQ7AeX
         5VjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7oLBLghrr79jFcmONz7EwL2GH/BGPeHdNV1OTjzcn1Q=;
        b=WQZeSDiYCAxMJFhAlhynzcDk7PiJPDThacZ/u9+l8EcRvSvbjyFbh8PVLOLT/wp5T1
         M6cXC4Lglk7ugXyVmg9BDdQO9avBd1Xl/NSKniTAbwFbOnCEBV3lFWUGEhRDvGSFE7rO
         S0UDTi5B8GUCu2p6bTXxJK+1eimWdCCuH+d6UiZzy48uyKij0tciNSRwZfSPnnBYlICc
         9XEXTPfrMLkW30bFfbD+5lX2Ag8i/hoAiVWWZoVkUYM9fTI2P1XuPjE0TNqwuroBlgTk
         cQBZi7Aa0L2zXcsXt8GEbdXHg/N6TGVFoJGfy4THyAT4dQIyfhz/vT54kHR3rXcn5dl+
         J0RQ==
X-Gm-Message-State: AOAM530j3mDb+qyksX36sneqPX0KToucpZ4EnZJYTPOgAA7fmSHs0VAq
        YgJZYamfrJ91QccF46tXpmDRHVA6XBfBhw1wa6USg79h
X-Google-Smtp-Source: ABdhPJxQSwIfNanqz6fJEoK7UwatxyLP4Qi7he4MKtez7JKBhqbznf2+G35f6qI1hAjUrUpqNxyUlAq3PQnUTq+dcC0=
X-Received: by 2002:a02:a986:: with SMTP id q6mr10601851jam.93.1594037717550;
 Mon, 06 Jul 2020 05:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200621063759.15497-1-amir73il@gmail.com>
In-Reply-To: <20200621063759.15497-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 6 Jul 2020 15:15:06 +0300
Message-ID: <CAOQ4uxh203q=t98GV_+2FSAo1oEVmJPjP1CfhSAqY0cO_moAjQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix oops in ovl_indexdir_cleanup() with nfs_export=on
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jun 21, 2020 at 9:38 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Mounting with nfs_export=on, xfstests overlay/031 triggers a kernel panic
> since v5.8-rc1 overlayfs updates.

Ping.

This is a kernel OOPS regression in v5.8-rc1.

Push tested branch ovl-fixes based on v5.8-rc3 with this change.
It contains two other non-critical fixes, which are pretty obvious,
so you may want to consider taking them as well.

Thanks,
Amir.

>
>  overlayfs: orphan index entry (index/00fb1..., ftype=4000, nlink=2)
>  BUG: kernel NULL pointer dereference, address: 0000000000000030
>  RIP: 0010:ovl_cleanup_and_whiteout+0x28/0x220 [overlay]
>
> Bisect point at commit c21c839b8448 ("ovl: whiteout inode sharing")
>
> Minimal reproducer:
> --------------------------------------------------
> rm -rf l u w m
> mkdir -p l u w m
> mkdir -p l/testdir
> touch l/testdir/testfile
> mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> echo 1 > m/testdir/testfile
> umount m
> rm -rf u/testdir
> mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> umount m
> --------------------------------------------------
>
> When mount with nfs_export=on, and fail to verify an orphan index, we're
> cleaning this index from indexdir by calling ovl_cleanup_and_whiteout().
> This dereferences ofs->workdir, that was earlier set to NULL.
>
> The design was that ovl->workdir will point at ovl->indexdir, but we are
> assigning ofs->indexdir to ofs->workdir only after ovl_indexdir_cleanup().
> There is no reason not to do it sooner, because once we get success from
> ofs->indexdir = ovl_workdir_create(... there is no turning back.
>
> Reported-and-tested-by: Murphy Zhou <jencce.kernel@gmail.com>
> Fixes: commit c21c839b8448 ("ovl: whiteout inode sharing")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/super.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 91476bc422f9..15939ab39c1c 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1354,6 +1354,12 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
>
>         ofs->indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
>         if (ofs->indexdir) {
> +               /* index dir will act also as workdir */
> +               iput(ofs->workdir_trap);
> +               ofs->workdir_trap = NULL;
> +               dput(ofs->workdir);
> +               ofs->workdir = dget(ofs->indexdir);
> +
>                 err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
>                                      "indexdir");
>                 if (err)
> @@ -1843,20 +1849,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                 sb->s_flags |= SB_RDONLY;
>
>         if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
> -               /* index dir will act also as workdir */
> -               dput(ofs->workdir);
> -               ofs->workdir = NULL;
> -               iput(ofs->workdir_trap);
> -               ofs->workdir_trap = NULL;
> -
>                 err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
>                 if (err)
>                         goto out_free_oe;
>
>                 /* Force r/o mount with no index dir */
> -               if (ofs->indexdir)
> -                       ofs->workdir = dget(ofs->indexdir);
> -               else
> +               if (!ofs->indexdir)
>                         sb->s_flags |= SB_RDONLY;
>         }
>
> --
> 2.17.1
>
