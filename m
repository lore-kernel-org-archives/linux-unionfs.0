Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CC5C432BE
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 13:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBBE260F4C
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 13:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbhHRNep (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 09:34:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237705AbhHRNen (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Aug 2021 09:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629293648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sdI0zO0U4tESozCIhpT5qJCrx4O9+KHKjI6mFEcj2rg=;
        b=XBOZgGBWlHAtcHHtReimf/kzvMtItMuoy8EvYFzo8+ydZbEZOMXnUQZpN30L2zUY0KmDZ2
        jQRzqs4yrMUpeRSjKFDiEftRYzQr7RNRqopVqRe4HAngHQvAIxHG6SojrUhBl8ZhdP8+DK
        exF0tCuXuRXeX4ANXqsNJ4tCeSc2nQY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-5R2U0rixO7yClmFrqt5QOg-1; Wed, 18 Aug 2021 09:34:07 -0400
X-MC-Unique: 5R2U0rixO7yClmFrqt5QOg-1
Received: by mail-ej1-f69.google.com with SMTP id q19-20020a1709064cd3b02904c5f93c0124so864460ejt.14
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Aug 2021 06:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sdI0zO0U4tESozCIhpT5qJCrx4O9+KHKjI6mFEcj2rg=;
        b=ogmpfE4K5f+rmdCUu2ZJimjbPwJRUoTa0kJ4Z/zWO2imquN1aPkS1t6txOlmMh5eM/
         KVR7XhXtyWTHvdiGkt3dVrg9oylO/yZqRXF26F1+5AxeZUrpV7Dwyd2DkSBTvqNVFgSH
         ir3qxWWrjC2u9CAjN3oaxLNH62ZFz0+Cu2K2VP22SH4Yr5A0is41JWYAH/hIAJ43FKGy
         dJi4DYMzaP4OdT9fGYXVo3LbiSlfNp10LpRdT+JlvZDs9HcifKXrOCorOJD7KNjL0leL
         z9q6pEdOqIi96Tffv9jX2BKtZTFS22Lvwt88fplA48Z3PwvZV5iW6pbN4erT+mSzRwpA
         bHUw==
X-Gm-Message-State: AOAM532sw9xYStPEd1Iqu4ucdY2YGj3X9asVfeCZwLwfezYkzsaVUZpa
        T7atAwaQANBCLjlUconSUhk9e3E9DdWc7bc9nAKXE+roQOqChCXe6bwo3g4enkP91qCWslyB/P/
        dlhpUkAHw6B5a5uSicT6xDLtU2Q==
X-Received: by 2002:a17:906:85d0:: with SMTP id i16mr9993255ejy.552.1629293645977;
        Wed, 18 Aug 2021 06:34:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOL3cCbGxWnE+tgrrzO5dzEtwXXaw2YaTmo1Qg/eVh4C6krWPbBo+gKKyyvsYpFmAPIJ7sjw==
X-Received: by 2002:a17:906:85d0:: with SMTP id i16mr9993227ejy.552.1629293645756;
        Wed, 18 Aug 2021 06:34:05 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-16.catv.broadband.hu. [86.101.169.16])
        by smtp.gmail.com with ESMTPSA id kg18sm2090922ejc.9.2021.08.18.06.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 06:34:05 -0700 (PDT)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        garyhuang <zjh.20052005@163.com>
Subject: [PATCH v2 2/2] ovl: enable RCU'd ->get_acl()
Date:   Wed, 18 Aug 2021 15:34:00 +0200
Message-Id: <20210818133400.830078-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818133400.830078-1-mszeredi@redhat.com>
References: <20210818133400.830078-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs does not cache ACL's (to avoid double caching).  Instead it just
calls the underlying filesystem's i_op->get_acl(), which will return the
cached value, if possible.

In rcu path walk, however, get_cached_acl_rcu() is employed to get the
value from the cache, which will fail on overlayfs resulting in dropping
out of rcu walk mode.  This can result in a big performance hit in certain
situations.

Fix by calling ->get_acl() with LOOKUP_RCU flag in case of ACL_DONT_CACHE
(which indicates pass-through)

Reported-by: garyhuang <zjh.20052005@163.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c      | 7 ++++---
 fs/posix_acl.c            | 8 +++++++-
 include/linux/fs.h        | 5 +++++
 include/linux/posix_acl.h | 3 ++-
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 727154a1d3ce..6a55231b262a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -13,6 +13,7 @@
 #include <linux/fiemap.h>
 #include <linux/fileattr.h>
 #include <linux/security.h>
+#include <linux/namei.h>
 #include "overlayfs.h"
 
 
@@ -454,12 +455,12 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type, int flags)
 	const struct cred *old_cred;
 	struct posix_acl *acl;
 
-	if (flags)
-		return ERR_PTR(-EINVAL);
-
 	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL) || !IS_POSIXACL(realinode))
 		return NULL;
 
+	if (flags & LOOKUP_RCU)
+		return get_cached_acl_rcu(realinode, type);
+
 	old_cred = ovl_override_creds(inode->i_sb);
 	acl = get_acl(realinode, type);
 	revert_creds(old_cred);
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 6b7f793e2b6f..4d1c6c266cf0 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -22,6 +22,7 @@
 #include <linux/xattr.h>
 #include <linux/export.h>
 #include <linux/user_namespace.h>
+#include <linux/namei.h>
 
 static struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
@@ -56,7 +57,12 @@ EXPORT_SYMBOL(get_cached_acl);
 
 struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type)
 {
-	return rcu_dereference(*acl_by_type(inode, type));
+	struct posix_acl *acl = rcu_dereference(*acl_by_type(inode, type));
+
+	if (acl == ACL_DONT_CACHE)
+		acl = inode->i_op->get_acl(inode, type, LOOKUP_RCU);
+
+	return acl;
 }
 EXPORT_SYMBOL(get_cached_acl_rcu);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1c56d4fc4efe..20b7db2d0a85 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -581,6 +581,11 @@ static inline void mapping_allow_writable(struct address_space *mapping)
 
 struct posix_acl;
 #define ACL_NOT_CACHED ((void *)(-1))
+/*
+ * ACL_DONT_CACHE is for stacked filesystems, that rely on underlying fs to
+ * cache the ACL.  This also means that ->get_acl() can be called in RCU mode
+ * with the LOOKUP_RCU flag.
+ */
 #define ACL_DONT_CACHE ((void *)(-3))
 
 static inline struct posix_acl *
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 307094ebb88c..b65c877d92b8 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -72,6 +72,8 @@ extern struct posix_acl *get_posix_acl(struct inode *, int);
 extern int set_posix_acl(struct user_namespace *, struct inode *, int,
 			 struct posix_acl *);
 
+struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type);
+
 #ifdef CONFIG_FS_POSIX_ACL
 int posix_acl_chmod(struct user_namespace *, struct inode *, umode_t);
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
@@ -84,7 +86,6 @@ extern int simple_set_acl(struct user_namespace *, struct inode *,
 extern int simple_acl_create(struct inode *, struct inode *);
 
 struct posix_acl *get_cached_acl(struct inode *inode, int type);
-struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type);
 void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl);
 void forget_cached_acl(struct inode *inode, int type);
 void forget_all_cached_acls(struct inode *inode);
-- 
2.31.1

