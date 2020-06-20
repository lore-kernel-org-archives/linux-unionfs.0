Return-Path: <SRS0=Xlr+=AB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36CDC433DF
	for <linux-unionfs@archiver.kernel.org>; Sat, 20 Jun 2020 13:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C585523BA6
	for <linux-unionfs@archiver.kernel.org>; Sat, 20 Jun 2020 13:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XO8W5al1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgFTN24 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 09:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgFTN2z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 Jun 2020 09:28:55 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9071CC06174E
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 06:28:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j12so3632167pfn.10
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 06:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=YUXTl7x/zTNO8GgoDgMk3FSKP+3Eoni98RQyX1MytqM=;
        b=XO8W5al1vwfOCayIJEt8yk5Peg+XnBDQlNWDrJ0O5Y+F6teXmpYoxpCiQSx+ls33FZ
         hGEHD6XvTIRhMCLUO+XH92kBQgs+GSUXjly6PiueRQnvL2eSCh4JgQ1aFWQ4rV4mVM1c
         2d84enGJocg4gbNsGQ2NxgZ4wjYQIHusNuBszxb7tTXFgmrxmTsz2TRLjQKqaysu5AAB
         pgdafMguqGI8tiEmtsz6gQEG4HXRvhieuBlqyRScbfLb4Y2UwqOylXeiO0lepfnojniV
         raFmybcGTpqtPmiNQQPh8XkvPMrnHF8B0hytK5MZ/I5XxcRmX/I+2uo3k5xJ/JQnE5yQ
         xxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=YUXTl7x/zTNO8GgoDgMk3FSKP+3Eoni98RQyX1MytqM=;
        b=MAsNmheq0eM5I07INTMqLdZXehFmgSTuvAdsVSg4o6Y/22tTFi8LJlvHpm0u0AXky8
         xuFHksHlYWQsuk2OAi2GgjYgMcmOWaVKILiCu061fsZrYH9tCszKvhQivsxWt6u14uSy
         b0cfF1FmuQZ762RE34nHTXwktpcIFak/qqFEJsQ6EaTci7wdx5jm/BxQqXj3lzZqhW6i
         Squr4otIAWi2wWQOQhgisgrxT4J/4uRcN4mHmBC6u+3gMXjqrsScsqCSv5N3ZsFzq1i5
         lxBVKY8EmunJ4G5xDk0Dzo+fquz2eHuljdv68ePJ5z0JzuJROvyNO0oBNxPhzowIdg3y
         RFdA==
X-Gm-Message-State: AOAM531pdwz6eKbK40dA3Tp2h+MheF5mokPE7ukLMI7oUwEFWBS32Sqn
        +w6zsDKyKSmwMdrleBkXa68=
X-Google-Smtp-Source: ABdhPJx+hKpTKotbCcZM4ofByoPWa7a7VawZRN/ciLjLWZdqxB1lINsN7MwuKsMWOusK8S5CMRExIw==
X-Received: by 2002:a63:724a:: with SMTP id c10mr6490997pgn.130.1592659733951;
        Sat, 20 Jun 2020 06:28:53 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d5sm7843355pjo.20.2020.06.20.06.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 06:28:53 -0700 (PDT)
Date:   Sat, 20 Jun 2020 21:28:45 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com
Cc:     cgxu519@mykernel.net, mszeredi@redhat.com
Subject: [PATCH v2] ovl: fix NULL ref while cleanup index when mount with
 nfs_export
Message-ID: <20200620132845.w34h6y2p5txrsd73@xzhoux.usersys.redhat.com>
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
echo 1 > m/testdir/testfile
umount m
rm -rf u/testdir
mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
umount m
--------------------------------------------------

When mount with nfs_export=on, and fail to verify an orphan index, we're
cleaning this index from indexdir by calling ovl_cleanup_and_whiteout,
in which we should clean indexdir rather than workdir. We start to use
ofs structure and only clean workdir since commit c21c839b8448
("ovl: whiteout inode sharing"), breaking the nfs_export code path.

Fixing this by passing additional explicit workdir argument to the cleanup
helper and passing indexdir as workdir argument in ovl_indexdir_cleanup and
ovl_cleanup_index.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
v2:
    Pass workdir as argument along with ofs to the helper instead of
checking availability of the dirs.
    Pass indexdir in ovl_indexdir_cleanup and ovl_cleanup_index.

 fs/overlayfs/dir.c       | 13 ++++++-------
 fs/overlayfs/overlayfs.h |  4 ++--
 fs/overlayfs/readdir.c   |  2 +-
 fs/overlayfs/util.c      |  2 +-
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1bba4813f9cb..f83d28a37bc3 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -62,11 +62,10 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
 }
 
 /* caller holds i_mutex on workdir */
-static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
+static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry *workdir)
 {
 	int err;
 	struct dentry *whiteout;
-	struct dentry *workdir = ofs->workdir;
 	struct inode *wdir = workdir->d_inode;
 
 	if (!ofs->whiteout) {
@@ -106,15 +105,15 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 }
 
 /* Caller must hold i_mutex on both workdir and dir */
-int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct inode *dir,
-			     struct dentry *dentry)
+int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workdir,
+			     struct inode *dir, struct dentry *dentry)
 {
-	struct inode *wdir = ofs->workdir->d_inode;
+	struct inode *wdir = workdir->d_inode;
 	struct dentry *whiteout;
 	int err;
 	int flags = 0;
 
-	whiteout = ovl_whiteout(ofs);
+	whiteout = ovl_whiteout(ofs, workdir);
 	err = PTR_ERR(whiteout);
 	if (IS_ERR(whiteout))
 		return err;
@@ -775,7 +774,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 		goto out_dput_upper;
 	}
 
-	err = ovl_cleanup_and_whiteout(ofs, d_inode(upperdir), upper);
+	err = ovl_cleanup_and_whiteout(ofs, workdir, d_inode(upperdir), upper);
 	if (err)
 		goto out_d_drop;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b725c7f15ff4..4421299bec67 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -458,8 +458,8 @@ static inline void ovl_copyflags(struct inode *from, struct inode *to)
 
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
-int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct inode *dir,
-			     struct dentry *dentry);
+int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workdir,
+			     struct inode *dir, struct dentry *dentry);
 struct ovl_cattr {
 	dev_t rdev;
 	umode_t mode;
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 6918b98faeb6..7501441a9d52 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1175,7 +1175,7 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 			 * Whiteout orphan index to block future open by
 			 * handle after overlay nlink dropped to zero.
 			 */
-			err = ovl_cleanup_and_whiteout(ofs, dir, index);
+			err = ovl_cleanup_and_whiteout(ofs, indexdir, dir, index);
 		} else {
 			/* Cleanup orphan index entries */
 			err = ovl_cleanup(dir, index);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 56c1f89f20c9..bda40c73c1c7 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -733,7 +733,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	} else if (ovl_index_all(dentry->d_sb)) {
 		/* Whiteout orphan index to block future open by handle */
 		err = ovl_cleanup_and_whiteout(OVL_FS(dentry->d_sb),
-					       dir, index);
+					       indexdir, dir, index);
 	} else {
 		/* Cleanup orphan index entries */
 		err = ovl_cleanup(dir, index);
-- 
2.18.1

