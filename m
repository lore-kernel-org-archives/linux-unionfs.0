Return-Path: <SRS0=Xlr+=AB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C903DC433E0
	for <linux-unionfs@archiver.kernel.org>; Sat, 20 Jun 2020 10:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D40C23AFD
	for <linux-unionfs@archiver.kernel.org>; Sat, 20 Jun 2020 10:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qFnbMklf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgFTKSS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 06:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgFTKSR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 Jun 2020 06:18:17 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3610CC06174E
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 03:18:16 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so1007608plq.6
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 03:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=k50bi3lqzAflV+ZooVbSg7qNrWxso0l2TMTlmOq8VM4=;
        b=qFnbMklf4ZUDwktgf+2qWsxj8XnLTshIJpj+l9NO0VzbrO4PzudzIOa3IqUUy1udpI
         ql+vx0kZyLoAPEa9/le/vPBAbVSakeclkXP+cR+RFOpQU0Nyk9Csof/6oxhzRhQsiJLq
         Ernr315+G/uep5IIMAf9rf5Jy7B1JBQ8+vvbsRkHkWQ65AEd34fUAqZqp1Vcw1TsnopC
         mHPYuOHzE6D95bSuEDEbPmRcX93T1EOy8HUr7BpfJ5McsTCdoiATm+lY0fEvq6JJcDpR
         EaiwCcIFBcuawjkqkq6HW6pn5xbibg1j5uBRZoyo+/sZOoScBhRthY/F65j+RV+k9MLI
         F94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=k50bi3lqzAflV+ZooVbSg7qNrWxso0l2TMTlmOq8VM4=;
        b=cPtxW9piqk3BqeCPCpPAyarZi/9khxVVFZ4PEwTeW8Y4gQB0QzQzVgp9+RS20ckxAp
         Q1pLy81Omga1wbbNWJXYI9N/EF079WtEorv4ZUvp7hEzrOu1VODUjqH/heMy7FPwmL16
         Z6dQjEf2wuQkS5jBiaQRsZuOldfpzm3nP4RoyH1bF4xnsbitAcINb77tteYHYyB4hRWV
         MCaL9BUK8snrNfE/MdZP94t4r8d++EalPoCIRfgPMH3e5zmqicoVqys9VT9EXkeOvmPs
         Df7bgq/0RjpYwWt4Hq4+Z3AlWZQoEuwpGoxG2kpeFjfQ7ezYMg6TFQlLn1y9YMhb4O8I
         uNJg==
X-Gm-Message-State: AOAM533+ywDPWdzCj+UAUMNqJa625A/iKSOIOBhTp2fGdWjA1KLBcSHx
        UEdavxw5WNHvMMS17knP+68=
X-Google-Smtp-Source: ABdhPJwnEyFVxzzLxc3X4o1FKdAa108zdWN3Hx9nPTiA2lInaPJm54hqQKjHuOD9asFHzYKBxfri7g==
X-Received: by 2002:a17:90a:8c14:: with SMTP id a20mr7872667pjo.83.1592648296041;
        Sat, 20 Jun 2020 03:18:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u14sm9153758pfk.211.2020.06.20.03.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 03:18:15 -0700 (PDT)
Date:   Sat, 20 Jun 2020 18:18:07 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Cc:     amir73il@gmail.com, cgxu519@mykernel.net, mszeredi@redhat.com
Subject: [PATCH] ovl: fix NULL ref while cleanup index when mount with
 nfs_export
Message-ID: <20200620101807.hixlsktuax4xls2h@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Mounting with nfs_export=on, xfstests overlay/031 triggers panic
since v5.8-rc1 overlayfs updates.

[ 7492.110430] run fstests overlay/031 at 2020-06-10 00:25:16
[ 7492.487300] overlayfs: disabling metacopy due to nfs_export=on
[ 7492.514270] overlayfs: "xino=on" is useless with all layers on same fs, ignore.
[ 7492.648049] overlayfs: disabling metacopy due to nfs_export=on
[ 7492.675189] overlayfs: "xino=on" is useless with all layers on same fs, ignore.
[ 7492.781437] overlayfs: disabling metacopy due to nfs_export=on
[ 7492.808608] overlayfs: "xino=on" is useless with all layers on same fs, ignore.
[ 7492.842132] overlayfs: orphan index entry (index/00fb1d000175e1f1e51e134b75b98d1f572f21252d030004002ae1559a, ftype=4000, nlink=2)
[ 7492.895298] BUG: kernel NULL pointer dereference, address: 0000000000000030
[ 7492.926984] #PF: supervisor read access in kernel mode
[ 7492.950703] #PF: error_code(0x0000) - not-present page
[ 7492.974243] PGD 0 P4D 0
[ 7492.985754] Oops: 0000 [#1] SMP PTI
[ 7493.001771] CPU: 11 PID: 951781 Comm: mount Not tainted 5.7.0+ #1
[ 7493.029799] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 09/18/2013
[ 7493.059809] RIP: 0010:ovl_cleanup_and_whiteout+0x28/0x220 [overlay]
[ 7493.087978] Code: 00 00 0f 1f 44 00 00 41 57 41 56 49 89 f6 41 55 41 54 49 89 d4 55 48 89 fd 53 48 83 ec 08 4c 8b 47 20 48 83 bf a8 00 00 00 00 <4d> 8b 68 30 0f 84 41 01 00 00 80 7d 7c 00 0f 85 b7 00 00 00 48 8b
[ 7493.173542] RSP: 0018:ffffbb8409a7fc20 EFLAGS: 00010246
[ 7493.197332] RAX: 00000000fffffffe RBX: ffff9425aa44ee40 RCX: 0000000000000000
[ 7493.230058] RDX: ffff9420f64c5a40 RSI: ffff9425a25d91c8 RDI: ffff94259dfc9680
[ 7493.262699] RBP: ffff94259dfc9680 R08: 0000000000000000 R09: 000000000000000b
[ 7493.295568] R10: 0000000000000000 R11: ffffbb8409a7fab8 R12: ffff9420f64c5a40
[ 7493.328117] R13: ffff94259dfc9680 R14: ffff9425a25d91c8 R15: ffff9420f64c5a40
[ 7493.360681] FS:  00007f43bdfc2080(0000) GS:ffff9425af740000(0000) knlGS:0000000000000000
[ 7493.397797] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7493.424340] CR2: 0000000000000030 CR3: 000000082bd18001 CR4: 00000000001606e0
[ 7493.456765] Call Trace:
[ 7493.467695]  ovl_indexdir_cleanup+0x1ab/0x330 [overlay]
[ 7493.491605]  ? ovl_cache_entry_find_link.constprop.18+0x80/0x80 [overlay]
[ 7493.522754]  ovl_fill_super+0x1031/0x11d0 [overlay]
[ 7493.545183]  ? sget+0x1c7/0x220
[ 7493.559242]  ? get_anon_bdev+0x40/0x40
[ 7493.576593]  ? ovl_show_options+0x230/0x230 [overlay]
[ 7493.599407]  mount_nodev+0x48/0xa0
[ 7493.615187]  legacy_get_tree+0x27/0x40
[ 7493.632193]  vfs_get_tree+0x25/0xb0
[ 7493.647926]  do_mount+0x7ae/0x9d0
[ 7493.662996]  ? _copy_from_user+0x2c/0x60
[ 7493.681534]  __x64_sys_mount+0xc4/0xe0
[ 7493.698370]  do_syscall_64+0x55/0x1b0
[ 7493.715177]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 7493.737697] RIP: 0033:0x7f43bcffec8e
[ 7493.753986] Code: Bad RIP value.
[ 7493.768721] RSP: 002b:00007ffe1b7c74f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[ 7493.803468] RAX: ffffffffffffffda RBX: 000055ba081c1310 RCX: 00007f43bcffec8e
[ 7493.837362] RDX: 000055ba081c1a00 RSI: 000055ba081c1a40 RDI: 000055ba081c1a20
[ 7493.872745] RBP: 00007f43bdda9184 R08: 000055ba081c1880 R09: 0000000000000003
[ 7493.905227] R10: 00000000c0ed0000 R11: 0000000000000246 R12: 0000000000000000
[ 7493.938152] R13: 00000000c0ed0000 R14: 000055ba081c1a20 R15: 000055ba081c1a00

Bisect says the first bad commit is:
    [c21c839b8448dd4b1e37ffc1bde928f57d34c0db] ovl: whiteout inode sharing

Minimal reproducer:
--------------------------------------------------
rm -rf l u w m
mkdir -p l u w m
mkdir -p l/testdir
touch l/testdir/testfile
mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
# copy up dir and index it
echo 1 > m/testdir/testfile
umount m
# remove dir in upper, mount again and panic
rm -rf u/testdir
mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
umount m
--------------------------------------------------

When mount with nfs_export=on, and fail to verify an orphan index, we're
cleaning this index from indexdir by calling ovl_cleanup_and_whiteout,
in which we should clean indexdir rather than workdir. We start to use
ofs structure and only clean workdir since commit c21c839b8448
("ovl: whiteout inode sharing"), breaking the nfs_export code path.

Fixing this by checking the availability of workdir of ofs first, then
indexdir. If the anyone is available, use it. This patch has been tested
by LTP/xfstests on overlayfs based on ext4 or xfs.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 fs/overlayfs/dir.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1bba4813f9cb..99bf1f698abb 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -66,8 +66,18 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 {
 	int err;
 	struct dentry *whiteout;
-	struct dentry *workdir = ofs->workdir;
-	struct inode *wdir = workdir->d_inode;
+	struct dentry *workdir = NULL;
+	struct inode *wdir;
+
+	if (ofs->workdir)
+		workdir = ofs->workdir;
+	else if (ofs->indexdir)
+		workdir = ofs->indexdir;
+
+	if (!workdir)
+		return -EINVAL;
+
+	wdir = workdir->d_inode;
 
 	if (!ofs->whiteout) {
 		whiteout = ovl_lookup_temp(workdir);
@@ -109,11 +119,19 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct inode *dir,
 			     struct dentry *dentry)
 {
-	struct inode *wdir = ofs->workdir->d_inode;
+	struct inode *wdir = NULL;
 	struct dentry *whiteout;
 	int err;
 	int flags = 0;
 
+	if (ofs->workdir)
+		wdir = ofs->workdir->d_inode;
+	else if (ofs->indexdir)
+		wdir = ofs->indexdir->d_inode;
+
+	if (!wdir)
+		return -EINVAL;
+
 	whiteout = ovl_whiteout(ofs);
 	err = PTR_ERR(whiteout);
 	if (IS_ERR(whiteout))
-- 
2.18.1

