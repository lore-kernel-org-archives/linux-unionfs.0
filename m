Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC934C77B75
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Apr 2023 23:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjDSXTJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 19:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjDSXTI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2023 19:19:08 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2AC1BD6;
        Wed, 19 Apr 2023 16:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681946343; x=1713482343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rdFlcKCkz/AhcGgbWYwQ2kHsg5ReFHAwr4zQdFbSYEk=;
  b=nfqqhP/ZIEcGi6bSuPJgjDkETO3EZvQm3oFaKU7iiuPz4joW6eyLWIQR
   3AuR75nDikLZKwWDTLY+7vQ42v81sR6NfgQ+pC8WzhPZN9+OP2kti54j7
   lcCxxN6cmOMXrkYqqYyAqPxPII8HtufVHyKnrSZm+5DMTxvwrVpVB1PEG
   k=;
X-IronPort-AV: E=Sophos;i="5.99,210,1677542400"; 
   d="scan'208";a="320418118"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 23:19:02 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com (Postfix) with ESMTPS id F29C481045;
        Wed, 19 Apr 2023 23:19:01 +0000 (UTC)
Received: from EX19D028UWA002.ant.amazon.com (10.13.138.248) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 19 Apr 2023 23:18:48 +0000
Received: from uda95858fd22f53.ant.amazon.com (10.187.171.36) by
 EX19D028UWA002.ant.amazon.com (10.13.138.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 19 Apr 2023 23:18:47 +0000
From:   Mengchi Cheng <mengcc@amazon.com>
To:     <casey@schaufler-ca.com>
CC:     <kamatam@amazon.com>, <linux-security-module@vger.kernel.org>,
        <linux-unionfs@vger.kernel.org>, <mengcc@amazon.com>,
        <miklos@szeredi.hu>, <yoonjaeh@amazon.com>,
        <roberto.sassu@huaweicloud.com>
Subject: [RFC PATCH] Set SMK_INODE_CHANGED inside smack_dentry_create_files_as
Date:   Wed, 19 Apr 2023 16:18:29 -0700
Message-ID: <20230419231829.881830-1-mengcc@amazon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <7d5c10b6-68da-dea9-b460-1427b17250b5@schaufler-ca.com>
References: <7d5c10b6-68da-dea9-b460-1427b17250b5@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.36]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D028UWA002.ant.amazon.com (10.13.138.248)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On the overlay fs with smack lsm enabled, new subdir did not inherit
transmute xattr form parent dir.

One solution that can solve it is passing inode into
smack_dentry_create_files_as. And Set SMK_INODE_CHANGED to smak_flags
if directory has transmute xattr.

Reported-by: Ryan Yoon <yoonjaeh@amazon.com>
---
 fs/overlayfs/dir.c            | 2 +-
 include/linux/lsm_hook_defs.h | 2 +-
 include/linux/security.h      | 4 ++--
 security/security.c           | 4 ++--
 security/selinux/hooks.c      | 2 +-
 security/smack/smack_lsm.c    | 8 ++++++--
 6 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index fc25fb95d5fc..1b3f7f3a5468 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -598,7 +598,7 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		override_cred->fsgid = inode->i_gid;
 		err = security_dentry_create_files_as(dentry,
 				attr->mode, &dentry->d_name, old_cred,
-				override_cred);
+				override_cred, inode);
 		if (err) {
 			put_cred(override_cred);
 			goto out_revert_creds;
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 094b76dc7164..96f1fdc21cbc 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -84,7 +84,7 @@ LSM_HOOK(int, -EOPNOTSUPP, dentry_init_security, struct dentry *dentry,
 	 int mode, const struct qstr *name, const char **xattr_name,
 	 void **ctx, u32 *ctxlen)
 LSM_HOOK(int, 0, dentry_create_files_as, struct dentry *dentry, int mode,
-	 struct qstr *name, const struct cred *old, struct cred *new)
+	 struct qstr *name, const struct cred *old, struct cred *new, struct inode *inode)
 
 #ifdef CONFIG_SECURITY_PATH
 LSM_HOOK(int, 0, path_unlink, const struct path *dir, struct dentry *dentry)
diff --git a/include/linux/security.h b/include/linux/security.h
index 5984d0d550b4..354d68dc69c5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -325,7 +325,7 @@ int security_dentry_init_security(struct dentry *dentry, int mode,
 int security_dentry_create_files_as(struct dentry *dentry, int mode,
 					struct qstr *name,
 					const struct cred *old,
-					struct cred *new);
+					struct cred *new, struct inode *inode);
 int security_path_notify(const struct path *path, u64 mask,
 					unsigned int obj_type);
 int security_inode_alloc(struct inode *inode);
@@ -756,7 +756,7 @@ static inline int security_dentry_init_security(struct dentry *dentry,
 static inline int security_dentry_create_files_as(struct dentry *dentry,
 						  int mode, struct qstr *name,
 						  const struct cred *old,
-						  struct cred *new)
+						  struct cred *new, struct inode *inode)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index cf6cc576736f..0ffe98cc57fe 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1110,10 +1110,10 @@ EXPORT_SYMBOL(security_dentry_init_security);
 
 int security_dentry_create_files_as(struct dentry *dentry, int mode,
 				    struct qstr *name,
-				    const struct cred *old, struct cred *new)
+				    const struct cred *old, struct cred *new, struct inode *inode)
 {
 	return call_int_hook(dentry_create_files_as, 0, dentry, mode,
-				name, old, new);
+				name, old, new, inode);
 }
 EXPORT_SYMBOL(security_dentry_create_files_as);
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a5bdfc21314..2addc513bbb0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2848,7 +2848,7 @@ static int selinux_dentry_init_security(struct dentry *dentry, int mode,
 static int selinux_dentry_create_files_as(struct dentry *dentry, int mode,
 					  struct qstr *name,
 					  const struct cred *old,
-					  struct cred *new)
+					  struct cred *new, struct inode *inode)
 {
 	u32 newsid;
 	int rc;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index cfcbb748da25..e929e3e131c2 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4739,12 +4739,14 @@ static int smack_inode_copy_up_xattr(const char *name)
 static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 					struct qstr *name,
 					const struct cred *old,
-					struct cred *new)
+					struct cred *new,
+					struct inode *inode)
 {
 	struct task_smack *otsp = smack_cred(old);
 	struct task_smack *ntsp = smack_cred(new);
 	struct inode_smack *isp;
 	int may;
+	struct inode_smack *issp = smack_inode(inode);
 
 	/*
 	 * Use the process credential unless all of
@@ -4769,8 +4771,10 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 		 * providing access is transmuting use the containing
 		 * directory label instead of the process label.
 		 */
-		if (may > 0 && (may & MAY_TRANSMUTE))
+		if (may > 0 && (may & MAY_TRANSMUTE)) {
 			ntsp->smk_task = isp->smk_inode;
+			issp->smk_flags |= SMK_INODE_CHANGED;
+		}
 	}
 	return 0;
 }
-- 
2.25.1

