Return-Path: <SRS0=T6lg=3U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A264C47409
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47278206F0
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dUpspe9v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgAaLuX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 06:50:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27664 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728513AbgAaLuX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jan 2020 06:50:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580471421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFQinq7lbM8X1ugDYdWFA1VKBJHOWbYtqUqc3Robc/U=;
        b=dUpspe9vLbFhFPg7/Uk3CPbv7VvrCHXXnjGL4kqRm8wPnPwyMRdskrnSSY+aYHjCkHxzK9
        mEH3VZ3f1G4gGqITZKYS8FjpbMJViiFzp5Q5SpHe+x60kWt9Xutfujr4krPAkVzWNlqcDY
        qCiTc4pi/WYXW4otCE9/pxPHCvbzJcE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-ooOLkBU5PBG35J51oS_UaA-1; Fri, 31 Jan 2020 06:50:19 -0500
X-MC-Unique: ooOLkBU5PBG35J51oS_UaA-1
Received: by mail-wr1-f71.google.com with SMTP id z14so3277880wrs.4
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jan 2020 03:50:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFQinq7lbM8X1ugDYdWFA1VKBJHOWbYtqUqc3Robc/U=;
        b=U0zCyslfHH+D4WNdoPEceB+NG8RSXaVzFdrenTDTAbSWZ0tbXiHb7AnTvLtFn/w22W
         dfSjNb3evdJk9DO4PAcMgIfn3wVoGblEenoJltmFIvm4v4UL91MkChBbK/TD539AFd+o
         KxgXVHjt36zMLwFKD7u5+BrQRqzJXmoObu6w1FKZb64QmHqdE6YdWcnn6zF2sbnERhLH
         eITojNJVpaHgeAownHiwK1IRxKFs7n2RjTb4KYm+UMAtOw+IVHNT6hcmeLbAL33sONpk
         tR1kk4E0zknRF1zIAAonaYeknUthi+19PuFwBgp0SxUkr5LyO76Iw43NRBSMBBDi35H1
         bPhw==
X-Gm-Message-State: APjAAAVn9caY2oQPJkwZX79R27SqGslUyBmo2LW9AC+lwsONw06JWEVl
        tVplE13HJ/juMkC5uf6VAHz4nzH1PiPCPcZZlqWJcdFYqDonYelgu/7EM9xg7cCip8N6ak1ijfR
        ebFR2xUaedzM5b2vhG9K9sLqp8A==
X-Received: by 2002:a1c:8086:: with SMTP id b128mr11160851wmd.80.1580471416557;
        Fri, 31 Jan 2020 03:50:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqzC8wk9ehLS4CTz4yXT0vWkebv2Q+kfM4w5h1WFFvNRqsV/MuExO4wiNwQljLvCfF0JMbhQGA==
X-Received: by 2002:a1c:8086:: with SMTP id b128mr11160827wmd.80.1580471416205;
        Fri, 31 Jan 2020 03:50:16 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (84-236-74-45.pool.digikabel.hu. [84.236.74.45])
        by smtp.gmail.com with ESMTPSA id s1sm2746622wro.66.2020.01.31.03.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 03:50:15 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     linux-unionfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 3/4] ovl: decide if revalidate needed on a per-dentry bases
Date:   Fri, 31 Jan 2020 12:50:03 +0100
Message-Id: <20200131115004.17410-4-mszeredi@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200131115004.17410-1-mszeredi@redhat.com>
References: <20200131115004.17410-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Allow completely skipping ->revalidate() on a per-dentry bases, in case the
underlying layers used for a dentry do not themselves have ->revalidate().

E.g. negative overlay dentry has no underlying layers, hence revalidate is
unnecessary.  Or if lower layer is remote but overlay dentry is pure-upper,
then can skip revalidate.

The following places need to update whether the dentry needs revalidate or
not:

 - fill-super (root dentry)
 - lookup
 - create
 - fh_to_dentry

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c       |  3 +++
 fs/overlayfs/export.c    |  2 ++
 fs/overlayfs/namei.c     |  3 +++
 fs/overlayfs/overlayfs.h |  3 ++-
 fs/overlayfs/super.c     | 23 +++++++----------------
 fs/overlayfs/util.c      | 15 ++++++++++++---
 6 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 8e57d5372b8f..b3471ef51440 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -243,6 +243,9 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 
 	ovl_dir_modified(dentry->d_parent, false);
 	ovl_dentry_set_upper_alias(dentry);
+	ovl_dentry_update_reval(dentry, newdentry,
+			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+
 	if (!hardlink) {
 		/*
 		 * ovl_obtain_alias() can be called after ovl_create_real()
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 6f54d70cef27..a58b3d9b06b9 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -324,6 +324,8 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 		if (upper_alias)
 			ovl_dentry_set_upper_alias(dentry);
 	}
+	ovl_dentry_update_reval(dentry, upper,
+			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
 
 	return d_instantiate_anon(dentry, inode);
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a5b998a93a24..76e61cc27822 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1077,6 +1077,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_free_oe;
 	}
 
+	ovl_dentry_update_reval(dentry, upperdentry,
+			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+
 	revert_creds(old_cred);
 	if (origin_path) {
 		dput(origin_path->dentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 3623d28aa4fa..68124a4f8f9b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -229,7 +229,8 @@ struct dentry *ovl_indexdir(struct super_block *sb);
 bool ovl_index_all(struct super_block *sb);
 bool ovl_verify_lower(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
-bool ovl_dentry_remote(struct dentry *dentry);
+void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
+			     unsigned int mask);
 bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7e294bf719ff..26d4153240a8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -158,11 +158,6 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_release = ovl_dentry_release,
 	.d_real = ovl_d_real,
-};
-
-static const struct dentry_operations ovl_reval_dentry_operations = {
-	.d_release = ovl_dentry_release,
-	.d_real = ovl_d_real,
 	.d_revalidate = ovl_dentry_revalidate,
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 };
@@ -779,7 +774,7 @@ static int ovl_check_namelen(struct path *path, struct ovl_fs *ofs,
 }
 
 static int ovl_lower_dir(const char *name, struct path *path,
-			 struct ovl_fs *ofs, int *stack_depth, bool *remote)
+			 struct ovl_fs *ofs, int *stack_depth)
 {
 	int fh_type;
 	int err;
@@ -794,9 +789,6 @@ static int ovl_lower_dir(const char *name, struct path *path,
 
 	*stack_depth = max(*stack_depth, path->mnt->mnt_sb->s_stack_depth);
 
-	if (ovl_dentry_remote(path->dentry))
-		*remote = true;
-
 	/*
 	 * The inodes index feature and NFS export need to encode and decode
 	 * file handles, so they require that all layers support them.
@@ -1439,7 +1431,6 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	char *lowertmp, *lower;
 	struct path *stack = NULL;
 	unsigned int stacklen, numlower = 0, i;
-	bool remote = false;
 	struct ovl_entry *oe;
 
 	err = -ENOMEM;
@@ -1471,7 +1462,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	lower = lowertmp;
 	for (numlower = 0; numlower < stacklen; numlower++) {
 		err = ovl_lower_dir(lower, &stack[numlower], ofs,
-				    &sb->s_stack_depth, &remote);
+				    &sb->s_stack_depth);
 		if (err)
 			goto out_err;
 
@@ -1499,11 +1490,6 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		oe->lowerstack[i].layer = &ofs->layers[i+1];
 	}
 
-	if (remote)
-		sb->s_d_op = &ovl_reval_dentry_operations;
-	else
-		sb->s_d_op = &ovl_dentry_operations;
-
 out:
 	for (i = 0; i < numlower; i++)
 		path_put(&stack[i]);
@@ -1597,6 +1583,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	struct cred *cred;
 	int err;
 
+	sb->s_d_op = &ovl_dentry_operations;
+
 	err = -ENOMEM;
 	ofs = kzalloc(sizeof(struct ovl_fs), GFP_KERNEL);
 	if (!ofs)
@@ -1724,6 +1712,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
 		       ovl_dentry_lower(root_dentry), NULL);
 
+	ovl_dentry_update_reval(root_dentry, upperpath.dentry,
+				DCACHE_OP_WEAK_REVALIDATE);
+
 	sb->s_root = root_dentry;
 
 	return 0;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 67cd2866aaa2..3ad8fb291f7d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -90,10 +90,19 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 	return oe;
 }
 
-bool ovl_dentry_remote(struct dentry *dentry)
+void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
+			     unsigned int mask)
 {
-	return dentry->d_flags &
-		(DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+	struct ovl_entry *oe = OVL_E(dentry);
+	unsigned int i, flags = 0;
+
+	for (i = 0; i < oe->numlower; i++)
+		flags |= oe->lowerstack[i].dentry->d_flags;
+
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags &= ~mask;
+	dentry->d_flags |= flags & mask;
+	spin_unlock(&dentry->d_lock);
 }
 
 bool ovl_dentry_weird(struct dentry *dentry)
-- 
2.21.1

