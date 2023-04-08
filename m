Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE164C77B6F
	for <linux-unionfs@archiver.kernel.org>; Sat,  8 Apr 2023 16:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjDHQnP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 8 Apr 2023 12:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDHQnO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2023 12:43:14 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC08630D7
        for <linux-unionfs@vger.kernel.org>; Sat,  8 Apr 2023 09:43:12 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o18so1202233wro.12
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2023 09:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680972191; x=1683564191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVRWp3X3kZIg1bE7BppydruHqCBXdlExhcYDN94GxuI=;
        b=VF4mQ7u3QeZH4bpK7Lg31paUrxZ3swJpKE8UDlHRDdS9slt8LhdMVxjbTT7wgVVynL
         DSDCRb4syzNb2a1vvgGtlCpHY+UeuS1t/DtBbEYR+WIJd/7z9JtEGz7elngLq9pc9hEl
         tpqq4geGHbifBVT//HzqVh7gpiXMwr71ZICuYbZZC858sRu1j5uRHnV7Mh12N6cMMvig
         dmI9oerSJyzmCr6iBJ/NNBmhyolbHoCU2dnyLnNpaJbjIxmLlYaMmw+SujqhrfFXBqLg
         740T+FmVSH2psAgWfJOTm9dYkDiLdU4qCSBoUheS0Ll/y7IgSKbQONPrMydtjMTMsqok
         d6DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680972191; x=1683564191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xVRWp3X3kZIg1bE7BppydruHqCBXdlExhcYDN94GxuI=;
        b=MpZvSb9jntlH7HrbqkOjal31TmRZlDUCTtG5DSW5j6UMaIeBMyOvT+fnQ6v6Nx1b8y
         fMal1RES7QoPrWNOrNiH2wnI+EypZJ5eBh4iFwb8wcMfHiOUk409uw0w7he7v2r9vduS
         uZ5m0Z6mUEUZKec1fPaF+Fbes/vepQZnD8WwdIhyzyGk7cJowJ28biu0K8O57xg89Ul9
         E16ILEQb2b8anNhPFwmE5qj/vO/JkLSXDA5nGRH74O7IrXhY0SCUq7brm9fXuESmJSeQ
         SvofKsk6UJbt9vRtQ1G7gZIG/hOeEOK6YqpTk7OYSCBCw+QB5N1yTdEK13UaxX6VSMWs
         NcSw==
X-Gm-Message-State: AAQBX9eQcipDidB+OKQl8ZCoiipUsYyV1J4GqBGpQYR9Az9FhI+tIRW6
        qOHHrVyTGSscQ67jy/y2Cc89ccZftlU=
X-Google-Smtp-Source: AKy350Y+EtfiuBSxbOUKsTMAVjgWlxK3FRUTfVCsb5XgI6czlJtP8Og6Z/v5TS1noEx0EkDpA/t4yA==
X-Received: by 2002:adf:db4d:0:b0:2e5:1da2:2a06 with SMTP id f13-20020adfdb4d000000b002e51da22a06mr3790978wrj.5.1680972190846;
        Sat, 08 Apr 2023 09:43:10 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id w9-20020adfec49000000b002cde25fba30sm7370438wrn.1.2023.04.08.09.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 09:43:10 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 2/7] ovl: use OVL_E() and OVL_E_FLAGS() accessors
Date:   Sat,  8 Apr 2023 19:42:57 +0300
Message-Id: <20230408164302.1392694-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408164302.1392694-1-amir73il@gmail.com>
References: <20230408164302.1392694-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Instead of open coded instances, because we are about to split
the two apart.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    |  2 +-
 fs/overlayfs/namei.c     |  8 ++++----
 fs/overlayfs/ovl_entry.h |  5 +++++
 fs/overlayfs/super.c     |  2 +-
 fs/overlayfs/util.c      | 20 ++++++++++----------
 5 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 5c36fb3a7bab..2cfdfcca5659 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -341,7 +341,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 /* Get the upper or lower dentry in stack whose on layer @idx */
 static struct dentry *ovl_dentry_real_at(struct dentry *dentry, int idx)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 	int i;
 
 	if (!idx)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 100a492d2b2a..e66352f19755 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -790,7 +790,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
  */
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 
 	BUG_ON(idx < 0);
 	if (idx == 0) {
@@ -833,8 +833,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_entry *oe;
 	const struct cred *old_cred;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
-	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
-	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
+	struct ovl_entry *poe = OVL_E(dentry->d_parent);
+	struct ovl_entry *roe = OVL_E(dentry->d_sb->s_root);
 	struct ovl_path *stack = NULL, *origin_path = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	struct dentry *origin = NULL;
@@ -1157,7 +1157,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 bool ovl_lower_positive(struct dentry *dentry)
 {
-	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
+	struct ovl_entry *poe = OVL_E(dentry->d_parent);
 	const struct qstr *name = &dentry->d_name;
 	const struct cred *old_cred;
 	unsigned int i;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index fd11fe6d6d45..4c7312126b3b 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -124,6 +124,11 @@ static inline struct ovl_entry *OVL_E(struct dentry *dentry)
 	return (struct ovl_entry *) dentry->d_fsdata;
 }
 
+static inline unsigned long *OVL_E_FLAGS(struct dentry *dentry)
+{
+	return &OVL_E(dentry)->flags;
+}
+
 struct ovl_inode {
 	union {
 		struct ovl_dir_cache *cache;	/* directory */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 49b6956468f9..108824b359e6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -138,7 +138,7 @@ static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak)
 static int ovl_dentry_revalidate_common(struct dentry *dentry,
 					unsigned int flags, bool weak)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 	struct inode *inode = d_inode_rcu(dentry);
 	struct dentry *upper;
 	unsigned int i;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6a0652bd51f2..01e6b4ec3074 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -143,7 +143,7 @@ bool ovl_dentry_weird(struct dentry *dentry)
 
 enum ovl_path_type ovl_path_type(struct dentry *dentry)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 	enum ovl_path_type type = 0;
 
 	if (ovl_dentry_upper(dentry)) {
@@ -176,7 +176,7 @@ void ovl_path_upper(struct dentry *dentry, struct path *path)
 
 void ovl_path_lower(struct dentry *dentry, struct path *path)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 
 	if (oe->numlower) {
 		path->mnt = oe->lowerstack[0].layer->mnt;
@@ -188,7 +188,7 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 
 	if (oe->numlower) {
 		path->mnt = oe->lowerstack[oe->numlower - 1].layer->mnt;
@@ -231,14 +231,14 @@ struct dentry *ovl_dentry_upper(struct dentry *dentry)
 
 struct dentry *ovl_dentry_lower(struct dentry *dentry)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 
 	return oe->numlower ? oe->lowerstack[0].dentry : NULL;
 }
 
 const struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 
 	return oe->numlower ? oe->lowerstack[0].layer : NULL;
 }
@@ -251,7 +251,7 @@ const struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
  */
 struct dentry *ovl_dentry_lowerdata(struct dentry *dentry)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 
 	return oe->numlower ? oe->lowerstack[oe->numlower - 1].dentry : NULL;
 }
@@ -329,17 +329,17 @@ void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache)
 
 void ovl_dentry_set_flag(unsigned long flag, struct dentry *dentry)
 {
-	set_bit(flag, &OVL_E(dentry)->flags);
+	set_bit(flag, OVL_E_FLAGS(dentry));
 }
 
 void ovl_dentry_clear_flag(unsigned long flag, struct dentry *dentry)
 {
-	clear_bit(flag, &OVL_E(dentry)->flags);
+	clear_bit(flag, OVL_E_FLAGS(dentry));
 }
 
 bool ovl_dentry_test_flag(unsigned long flag, struct dentry *dentry)
 {
-	return test_bit(flag, &OVL_E(dentry)->flags);
+	return test_bit(flag, OVL_E_FLAGS(dentry));
 }
 
 bool ovl_dentry_is_opaque(struct dentry *dentry)
@@ -1015,7 +1015,7 @@ int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path)
 
 bool ovl_is_metacopy_dentry(struct dentry *dentry)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_entry *oe = OVL_E(dentry);
 
 	if (!d_is_reg(dentry))
 		return false;
-- 
2.34.1

