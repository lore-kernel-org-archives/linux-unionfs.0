Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FCDC4338F
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 12:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EC8560F41
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 12:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhHJMKF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:10:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233179AbhHJMIk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Aug 2021 08:08:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628597298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SZnHDMvqEZ3ftoZn+MNpXng+uKmXTfsGKZSP1UG7OKw=;
        b=hGKvIBNuoD1Qnq3h4wm+ZN7WYGzT7U5Q6wMcAlrcBqffIx1PboFdvylPtPZsUZW7H6npyq
        6fqsEJuMOWLl5jmYxb3zwxJ/2XH2NWYim8wWhr8r20rhf73c/fKeEDaZg416cXF/SE13BG
        R17a9KzJkr1kU8YgilCwQS8hU8xnBwQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-DFe5rBHnMjObi9AxjJcQfw-1; Tue, 10 Aug 2021 08:08:13 -0400
X-MC-Unique: DFe5rBHnMjObi9AxjJcQfw-1
Received: by mail-ej1-f72.google.com with SMTP id k21-20020a1709062a55b0290590e181cc34so5518010eje.3
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Aug 2021 05:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SZnHDMvqEZ3ftoZn+MNpXng+uKmXTfsGKZSP1UG7OKw=;
        b=E8adJIXHgkfNJw0MsSdvscMdwevXazdP1IeygZLdQObDFMB/YPEVqYLMIYujgIl/SN
         p74Sgac+u8F2jR/lORqvHr1jfceKUUnaSgbHVD8mMKRaMZTeo56R1wa44H1sSPX+kW8T
         4uyEzwXwN1wqRNvWazJ+f2Xn+1wbadtDNOEyDJ+5NxhMKbcsoZnJw5fvjL3y/NR9coy7
         MhaGC8s8zK8DNQkZGn6TPqap9blOAFYCGePIBIRDLsDCL0PELu4WXq8BwxJfk9Z4wvFL
         jddAiz7Tya9tXcBP6yKwk/ogVnIyJeBzj05OpY1+rsfGi2X31iKKLOpmsiGc7GUMbfYy
         /M3Q==
X-Gm-Message-State: AOAM533VYwvl2H6dhdwQSmAUX/Wxw54cfn/daz7xFIKC35SZb2k2lylQ
        qSQIi74IDRABFCDICnPHXgAM/vrSXl/Khau+f5GfhyHB3EdI4Vh36AXsRAaAyRIUCKgSsF6/98D
        AxvFf8Cirg8AyImHo3/ngcyMF5w==
X-Received: by 2002:aa7:c9d8:: with SMTP id i24mr4569643edt.79.1628597292402;
        Tue, 10 Aug 2021 05:08:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjiMeijZd9bsMjJ5xH+LY03YRHw4EuD9qOp1nZXwEbgue3oFf7aoDljP+KM73PQAFXm+EYWQ==
X-Received: by 2002:aa7:c9d8:: with SMTP id i24mr4569622edt.79.1628597292216;
        Tue, 10 Aug 2021 05:08:12 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-16.catv.broadband.hu. [86.101.169.16])
        by smtp.gmail.com with ESMTPSA id p5sm6804900ejl.73.2021.08.10.05.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:08:11 -0700 (PDT)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        garyhuang <zjh.20052005@163.com>
Subject: [PATCH 2/2] ovl: enable RCU'd ->get_acl()
Date:   Tue, 10 Aug 2021 14:08:07 +0200
Message-Id: <20210810120807.456788-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810120807.456788-1-mszeredi@redhat.com>
References: <20210810120807.456788-1-mszeredi@redhat.com>
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
 fs/overlayfs/inode.c | 7 ++++---
 fs/posix_acl.c       | 8 +++++++-
 include/linux/fs.h   | 5 +++++
 3 files changed, 16 insertions(+), 4 deletions(-)

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
-- 
2.31.1

