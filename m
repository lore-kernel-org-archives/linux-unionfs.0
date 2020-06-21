Return-Path: <SRS0=6Laf=AC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883D1C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 01:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B80C24797
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 01:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DIxaz72Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgFUBrp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 21:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgFUBro (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 Jun 2020 21:47:44 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D8FC061794
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 18:47:44 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u128so6421470pgu.13
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 18:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xeEqTBfhkj82v2X/d3ZWYRBtOATR6H1lOilcdgqboOM=;
        b=DIxaz72ZHDNanXER+L99CQyvYax5mUljH91GTwWAEXgalt6DG3hS3v5R0apnXiHBbC
         hhVNBVB8Hbk6u/oN+pmceB2F7jnb2BgqqkWIWedIUmF5L+7SgY26hZHykzuApbs5jm5W
         xtIZYey6wTaXtcA7KI+aU1UmEyV3aT3svJDkmuJ8dIKgX4VJeMs4oB2NxJZRXApAmYJe
         2a+VwT9zLzEG4YHE00WTVf4cCarBRuAlwHjT1JMLPPPjWvC5Axq8+CQdL+Br2YCm6249
         Bk24eAFiO0u5Gf9lfgcvecPfxPMKEiHubnEsz3pGg7KlYrLsQ5A+F5FqPngBNLGfcnt9
         CVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xeEqTBfhkj82v2X/d3ZWYRBtOATR6H1lOilcdgqboOM=;
        b=OFG1HldHVtxhbKaHpQjW7VHzX6Eon/iYw3CIA4WgCnGa5ccg9rZL+4cv/WaB+9NUK7
         sL2WeShKhkWrQhW5CsygXNd6lYbgZMeJe3MLWkWok2BgFxLgincPZHrXstdoNDUh2lVt
         WJvbRJVS9mIDr7R1A28KrNRRf+LBh/JVCvOHatZKznlzIxDjEEds8cn8T6L+R8NL0eQV
         S3F0W/XIcijakU3wiogZxvmnLPuEvCtgJA23IKMS7zt6gpG3YR6Ubkee5trnj1+J+Gro
         WX7koVD37g5ddJnsyG5qjL7lxvAEfalc3iBDRPl72h95u7R99I3tedKDq2yqtqLSdm+2
         5xDA==
X-Gm-Message-State: AOAM533gWA0BDAc5M8cXnzoF6GTNW6EazUpiiJzQ1lEU8fy4xoxtzF0j
        FsH2kdcjVSBemHQEbG8wviBM1FCh
X-Google-Smtp-Source: ABdhPJw4G1wvQtjydMiK/8B+t1bHw+9NK78dnVY+JGHIMaZoFa9jM3BT/Bcziwlxfpzvdr6NtJDlZg==
X-Received: by 2002:a62:5247:: with SMTP id g68mr15162189pfb.244.1592704063714;
        Sat, 20 Jun 2020 18:47:43 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j17sm9300257pjy.22.2020.06.20.18.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 18:47:43 -0700 (PDT)
Date:   Sun, 21 Jun 2020 09:47:35 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH v2] ovl: fix NULL ref while cleanup index when mount with
 nfs_export
Message-ID: <20200621014735.x3ixdiqyu6e6vtui@xzhoux.usersys.redhat.com>
References: <20200620132845.w34h6y2p5txrsd73@xzhoux.usersys.redhat.com>
 <CAOQ4uxiZ=JmSzDQ-05EJyPr4iRtDsXYyNSpqh8iaiDxcO-paZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiZ=JmSzDQ-05EJyPr4iRtDsXYyNSpqh8iaiDxcO-paZw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jun 20, 2020 at 07:14:02PM +0300, Amir Goldstein wrote:
> On Sat, Jun 20, 2020 at 4:28 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > Mounting with nfs_export=on, xfstests overlay/031 triggers panic
> > since v5.8-rc1 overlayfs updates.
> >
> > [ 7492.110430] run fstests overlay/031 at 2020-06-10 00:25:16
> > [ 7492.487300] overlayfs: disabling metacopy due to nfs_export=on
> > [ 7492.514270] overlayfs: "xino=on" is useless with all layers on same fs, ignore.
> > [ 7492.648049] overlayfs: disabling metacopy due to nfs_export=on
> > [ 7492.675189] overlayfs: "xino=on" is useless with all layers on same fs, ignore.
> > [ 7492.781437] overlayfs: disabling metacopy due to nfs_export=on
> > [ 7492.808608] overlayfs: "xino=on" is useless with all layers on same fs, ignore.
> > [ 7492.842132] overlayfs: orphan index entry (index/00fb1d000175e1f1e51e134b75b98d1f572f21252d030004002ae1559a, ftype=4000, nlink=2)
> > [ 7492.895298] BUG: kernel NULL pointer dereference, address: 0000000000000030
> > [ 7492.926984] #PF: supervisor read access in kernel mode
> > [ 7492.950703] #PF: error_code(0x0000) - not-present page
> > [ 7492.974243] PGD 0 P4D 0
> > [ 7492.985754] Oops: 0000 [#1] SMP PTI
> > [ 7493.001771] CPU: 11 PID: 951781 Comm: mount Not tainted 5.7.0+ #1
> > [ 7493.029799] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 09/18/2013
> > [ 7493.059809] RIP: 0010:ovl_cleanup_and_whiteout+0x28/0x220 [overlay]
> > [ 7493.087978] Code: 00 00 0f 1f 44 00 00 41 57 41 56 49 89 f6 41 55 41 54 49 89 d4 55 48 89 fd 53 48 83 ec 08 4c 8b 47 20 48 83 bf a8 00 00 00 00 <4d> 8b 68 30 0f 84 41 01 00 00 80 7d 7c 00 0f 85 b7 00 00 00 48 8b
> > [ 7493.173542] RSP: 0018:ffffbb8409a7fc20 EFLAGS: 00010246
> > [ 7493.197332] RAX: 00000000fffffffe RBX: ffff9425aa44ee40 RCX: 0000000000000000
> > [ 7493.230058] RDX: ffff9420f64c5a40 RSI: ffff9425a25d91c8 RDI: ffff94259dfc9680
> > [ 7493.262699] RBP: ffff94259dfc9680 R08: 0000000000000000 R09: 000000000000000b
> > [ 7493.295568] R10: 0000000000000000 R11: ffffbb8409a7fab8 R12: ffff9420f64c5a40
> > [ 7493.328117] R13: ffff94259dfc9680 R14: ffff9425a25d91c8 R15: ffff9420f64c5a40
> > [ 7493.360681] FS:  00007f43bdfc2080(0000) GS:ffff9425af740000(0000) knlGS:0000000000000000
> > [ 7493.397797] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 7493.424340] CR2: 0000000000000030 CR3: 000000082bd18001 CR4: 00000000001606e0
> > [ 7493.456765] Call Trace:
> > [ 7493.467695]  ovl_indexdir_cleanup+0x1ab/0x330 [overlay]
> > [ 7493.491605]  ? ovl_cache_entry_find_link.constprop.18+0x80/0x80 [overlay]
> > [ 7493.522754]  ovl_fill_super+0x1031/0x11d0 [overlay]
> > [ 7493.545183]  ? sget+0x1c7/0x220
> > [ 7493.559242]  ? get_anon_bdev+0x40/0x40
> > [ 7493.576593]  ? ovl_show_options+0x230/0x230 [overlay]
> > [ 7493.599407]  mount_nodev+0x48/0xa0
> > [ 7493.615187]  legacy_get_tree+0x27/0x40
> > [ 7493.632193]  vfs_get_tree+0x25/0xb0
> > [ 7493.647926]  do_mount+0x7ae/0x9d0
> > [ 7493.662996]  ? _copy_from_user+0x2c/0x60
> > [ 7493.681534]  __x64_sys_mount+0xc4/0xe0
> > [ 7493.698370]  do_syscall_64+0x55/0x1b0
> > [ 7493.715177]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [ 7493.737697] RIP: 0033:0x7f43bcffec8e
> > [ 7493.753986] Code: Bad RIP value.
> > [ 7493.768721] RSP: 002b:00007ffe1b7c74f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> > [ 7493.803468] RAX: ffffffffffffffda RBX: 000055ba081c1310 RCX: 00007f43bcffec8e
> > [ 7493.837362] RDX: 000055ba081c1a00 RSI: 000055ba081c1a40 RDI: 000055ba081c1a20
> > [ 7493.872745] RBP: 00007f43bdda9184 R08: 000055ba081c1880 R09: 0000000000000003
> > [ 7493.905227] R10: 00000000c0ed0000 R11: 0000000000000246 R12: 0000000000000000
> > [ 7493.938152] R13: 00000000c0ed0000 R14: 000055ba081c1a20 R15: 000055ba081c1a00
> >
> > Bisect says the first bad commit is:
> >     [c21c839b8448dd4b1e37ffc1bde928f57d34c0db] ovl: whiteout inode sharing
> >
> > Minimal reproducer:
> > --------------------------------------------------
> > rm -rf l u w m
> > mkdir -p l u w m
> > mkdir -p l/testdir
> > touch l/testdir/testfile
> > mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> > echo 1 > m/testdir/testfile
> > umount m
> > rm -rf u/testdir
> > mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> > umount m
> > --------------------------------------------------
> >
> > When mount with nfs_export=on, and fail to verify an orphan index, we're
> > cleaning this index from indexdir by calling ovl_cleanup_and_whiteout,
> > in which we should clean indexdir rather than workdir. We start to use
> > ofs structure and only clean workdir since commit c21c839b8448
> > ("ovl: whiteout inode sharing"), breaking the nfs_export code path.
> >
> > Fixing this by passing additional explicit workdir argument to the cleanup
> > helper and passing indexdir as workdir argument in ovl_indexdir_cleanup and
> > ovl_cleanup_index.
> >
> > Suggested-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> > v2:
> >     Pass workdir as argument along with ofs to the helper instead of
> > checking availability of the dirs.
> >     Pass indexdir in ovl_indexdir_cleanup and ovl_cleanup_index.
> 
> Sorry for not looking closer before, I wasn't near my workstation.
> Here is another suggestion.
> I think Miklos will like this one better, because he was the one who removed
> the workdir from Chengguang's original patch.
> 
> The design was that ovl->workdir will point at ovl->indexdir, but we did
> it too late for ovl_indexdir_cleanup().
> No reason not to do it sooner, because once we get success from
> ofs->indexdir = ovl_workdir_create(... there is no turning back.
> 
> Feel free to re-post this with proper commit message after testing and
> verifying that moving the code didn't break any other error path.
> 
> Thanks,
> Amir.

> From 4e04457a1b616cc84331214017014bebd479461a Mon Sep 17 00:00:00 2001
> From: Amir Goldstein <amir73il@gmail.com>
> Date: Sat, 20 Jun 2020 19:04:35 +0300
> Subject: [PATCH] ovl: fix NULL ref while cleanup index when mount with
>  nfs_export

Test result looks good to go.

Thanks for the fix!
> 
> ...
> 
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
>  	ofs->indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
>  	if (ofs->indexdir) {
> +		/* index dir will act also as workdir */
> +		iput(ofs->workdir_trap);
> +		ofs->workdir_trap = NULL;
> +		dput(ofs->workdir);
> +		ofs->workdir = dget(ofs->indexdir);
> +
>  		err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
>  				     "indexdir");
>  		if (err)
> @@ -1843,20 +1849,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  		sb->s_flags |= SB_RDONLY;
>  
>  	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
> -		/* index dir will act also as workdir */
> -		dput(ofs->workdir);
> -		ofs->workdir = NULL;
> -		iput(ofs->workdir_trap);
> -		ofs->workdir_trap = NULL;
> -
>  		err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
>  		if (err)
>  			goto out_free_oe;
>  
>  		/* Force r/o mount with no index dir */
> -		if (ofs->indexdir)
> -			ofs->workdir = dget(ofs->indexdir);
> -		else
> +		if (!ofs->indexdir)
>  			sb->s_flags |= SB_RDONLY;
>  	}
>  
> -- 
> 2.17.1
> 


-- 
Murphy
