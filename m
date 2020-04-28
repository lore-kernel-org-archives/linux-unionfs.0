Return-Path: <SRS0=REe/=6M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAC0C83000
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Apr 2020 12:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A0C82072A
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Apr 2020 12:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="FctDibY2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgD1MVM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726645AbgD1MVM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Apr 2020 08:21:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9263C03C1A9
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2020 05:21:11 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k13so24426097wrw.7
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2020 05:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zNI1xmIoStTIwCp3HS1RZd5D3eKBm7ZnsnV3GXWQQ64=;
        b=FctDibY2R59G6tlYJH7pSN/0jYnQq281oaxT6OiW0L09fvyXnASqIaz3ozmoBv4Bkg
         htSBafHMWzoSt6qUHq/N6Q16xxlyzrkt0vsBQLYy8n2vIdmQ30NPSqqrwXm9LeNKnLsi
         259U086JSclm0tMAwBPPq1RKddADfteaSak3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zNI1xmIoStTIwCp3HS1RZd5D3eKBm7ZnsnV3GXWQQ64=;
        b=czLsoq3eAr4np/Yy3ek93o0Lfg/0ZcAPEEF6ib5Z7UdYxzcZeug98mVMpMFzMfTs0z
         VKjtdwz2EieDT5bKj6OoBh9l2F/hrl9KR6rke/ydoUSQtnUFH79vQNuFKLfATdDNgVDm
         uOQ2VWvSJOQVmjSvOeeRdAgCsZHb7R4suUtoc4ozqbid4KIZPqE5LkqC8Xbwi5/YNYeI
         YbdGHgPcavti+Llcv9b0LeGceIzb0EFaehkod7hGhcEXj0MAKq/zVEj7tUFm6aCghn3W
         yh5p3C5dRlEokpuJqlpzUB4utbiZvlbvUoXJd37ZgeNngESQQRqqN+Rw2QxvpFCcNwn/
         FuKA==
X-Gm-Message-State: AGi0PubrHUG9PXsXbRAayMI5b8dognCC57gx27/RjoOHYrrkskOUB3cq
        POL5G3GLS766kTP/aLjYbcXoug==
X-Google-Smtp-Source: APiQypJf08yVu9XFls7VWg+R4Mtxq2Z9UHo0c235EVOaOmTM4BrmUDh1sqM078cU54NcazD6vaXMoQ==
X-Received: by 2002:adf:b310:: with SMTP id j16mr35051597wrd.95.1588076470551;
        Tue, 28 Apr 2020 05:21:10 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-212-96-48-140.catv.broadband.hu. [212.96.48.140])
        by smtp.gmail.com with ESMTPSA id k9sm26733853wrd.17.2020.04.28.05.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 05:21:09 -0700 (PDT)
Date:   Tue, 28 Apr 2020 14:21:04 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH v4] ovl: whiteout inode sharing
Message-ID: <20200428122104.GA13131@miu.piliscsaba.redhat.com>
References: <20200422102740.6670-1-cgxu519@mykernel.net>
 <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
 <171a49cb02a.e6962d897896.4484083556616944063@mykernel.net>
 <CAOQ4uxhowSRqD9kSoUHg+D8-RdxF8vBbTauTchgnpG5MoSNSEA@mail.gmail.com>
 <171aadd9966.100e576ad1248.8616898883060201949@mykernel.net>
 <CAOQ4uxi_zp45KrjnR4FJx56gsDPsoim4U0H7hj1ta4+gXAwQtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi_zp45KrjnR4FJx56gsDPsoim4U0H7hj1ta4+gXAwQtQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 24, 2020 at 05:49:00PM +0300, Amir Goldstein wrote:

> I didn't mean we need to check if link_max  is valid range for upper fs.
> We anyway use minimum of user requested value and upper fs max.
> 
> Frankly, I think there are only two sane options for system wide configuration:
> 1. disable whiteout link
> 2. enable whiteout link with ofs->workdir->d_sb->s_max_links

And that one doesn't work, see for example ext4, which defines EXT4_LINK_MAX but
doesn't set s_max_links.  This could be fixed, but using EMLINK to detect the
max-link condition is simpler and more reliable.

And I don't really see a reason to disable whiteout hard links.  What scenario
would that be useful in?

Updated patch below.  Changes from v5:

 - fix a missing dput on shutdown
 - don't poass workdir to ovl_cleanup_and_whiteout/ovl_whiteout
 - flatten out retry loop in ovl_whiteout
 - use EMLINK to distinguish max-links from misc failure

Thanks,
Miklos

---
From: Chengguang Xu <cgxu519@mykernel.net>
Subject: ovl: whiteout inode sharing
Date: Fri, 24 Apr 2020 10:55:17 +0800

Share inode with different whiteout files for saving inode and speeding up
delete operation.

If EMLINK is encountered when linking a shared whiteout, create a new one.
In case of any other error, disable sharing for this super block.

Note: ofs->whiteout is protected by inode lock on workdir.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c       |   49 +++++++++++++++++++++++++++++++++++------------
 fs/overlayfs/overlayfs.h |    2 -
 fs/overlayfs/ovl_entry.h |    3 ++
 fs/overlayfs/readdir.c   |    2 -
 fs/overlayfs/super.c     |    4 +++
 fs/overlayfs/util.c      |    3 +-
 6 files changed, 48 insertions(+), 15 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -62,35 +62,59 @@ struct dentry *ovl_lookup_temp(struct de
 }
 
 /* caller holds i_mutex on workdir */
-static struct dentry *ovl_whiteout(struct dentry *workdir)
+static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 {
 	int err;
 	struct dentry *whiteout;
+	struct dentry *workdir = ofs->workdir;
 	struct inode *wdir = workdir->d_inode;
 
-	whiteout = ovl_lookup_temp(workdir);
-	if (IS_ERR(whiteout))
-		return whiteout;
+	if (!ofs->whiteout) {
+		whiteout = ovl_lookup_temp(workdir);
+		if (IS_ERR(whiteout))
+			return whiteout;
+
+		err = ovl_do_whiteout(wdir, whiteout);
+		if (err) {
+			dput(whiteout);
+			return ERR_PTR(err);
+		}
+		ofs->whiteout = whiteout;
+	}
 
-	err = ovl_do_whiteout(wdir, whiteout);
-	if (err) {
+	if (ofs->share_whiteout) {
+		whiteout = ovl_lookup_temp(workdir);
+		if (IS_ERR(whiteout))
+			goto fallback;
+
+		err = ovl_do_link(ofs->whiteout, wdir, whiteout);
+		if (!err)
+			goto success;
+
+		if (err != -EMLINK) {
+			pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%i)\n",
+				ofs->whiteout->d_inode->i_nlink, err);
+			ofs->share_whiteout = false;
+		}
 		dput(whiteout);
-		whiteout = ERR_PTR(err);
 	}
-
+fallback:
+	whiteout = ofs->whiteout;
+	ofs->whiteout = NULL;
+success:
 	return whiteout;
 }
 
 /* Caller must hold i_mutex on both workdir and dir */
-int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
+int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct inode *dir,
 			     struct dentry *dentry)
 {
-	struct inode *wdir = workdir->d_inode;
+	struct inode *wdir = ofs->workdir->d_inode;
 	struct dentry *whiteout;
 	int err;
 	int flags = 0;
 
-	whiteout = ovl_whiteout(workdir);
+	whiteout = ovl_whiteout(ofs);
 	err = PTR_ERR(whiteout);
 	if (IS_ERR(whiteout))
 		return err;
@@ -715,6 +739,7 @@ static bool ovl_matches_upper(struct den
 static int ovl_remove_and_whiteout(struct dentry *dentry,
 				   struct list_head *list)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *workdir = ovl_workdir(dentry);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
 	struct dentry *upper;
@@ -748,7 +773,7 @@ static int ovl_remove_and_whiteout(struc
 		goto out_dput_upper;
 	}
 
-	err = ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper);
+	err = ovl_cleanup_and_whiteout(ofs, d_inode(upperdir), upper);
 	if (err)
 		goto out_d_drop;
 
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -455,7 +455,7 @@ static inline void ovl_copyflags(struct
 
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
-int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
+int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct inode *dir,
 			     struct dentry *dentry);
 struct ovl_cattr {
 	dev_t rdev;
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -68,6 +68,7 @@ struct ovl_fs {
 	/* Did we take the inuse lock? */
 	bool upperdir_locked;
 	bool workdir_locked;
+	bool share_whiteout;
 	/* Traps in ovl inode cache */
 	struct inode *upperdir_trap;
 	struct inode *workbasedir_trap;
@@ -77,6 +78,8 @@ struct ovl_fs {
 	int xino_mode;
 	/* For allocation of non-persistent inode numbers */
 	atomic_long_t last_ino;
+	/* Whiteout dentry cache */
+	struct dentry *whiteout;
 };
 
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1154,7 +1154,7 @@ int ovl_indexdir_cleanup(struct ovl_fs *
 			 * Whiteout orphan index to block future open by
 			 * handle after overlay nlink dropped to zero.
 			 */
-			err = ovl_cleanup_and_whiteout(indexdir, dir, index);
+			err = ovl_cleanup_and_whiteout(ofs, dir, index);
 		} else {
 			/* Cleanup orphan index entries */
 			err = ovl_cleanup(dir, index);
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -707,7 +707,8 @@ static void ovl_cleanup_index(struct den
 		index = NULL;
 	} else if (ovl_index_all(dentry->d_sb)) {
 		/* Whiteout orphan index to block future open by handle */
-		err = ovl_cleanup_and_whiteout(indexdir, dir, index);
+		err = ovl_cleanup_and_whiteout(OVL_FS(dentry->d_sb),
+					       dir, index);
 	} else {
 		/* Cleanup orphan index entries */
 		err = ovl_cleanup(dir, index);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -217,6 +217,7 @@ static void ovl_free_fs(struct ovl_fs *o
 	iput(ofs->indexdir_trap);
 	iput(ofs->workdir_trap);
 	iput(ofs->upperdir_trap);
+	dput(ofs->whiteout);
 	dput(ofs->indexdir);
 	dput(ofs->workdir);
 	if (ofs->workdir_locked)
@@ -1776,6 +1777,9 @@ static int ovl_fill_super(struct super_b
 	if (!cred)
 		goto out_err;
 
+	/* Is there a reason anyone would want not to share whiteouts? */
+	ofs->share_whiteout = true;
+
 	ofs->config.index = ovl_index_def;
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
