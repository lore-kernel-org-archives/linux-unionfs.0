Return-Path: <SRS0=r5kD=AY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4F6C433E5
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 10:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26EB320758
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 10:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7KfOB5R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgGMK5r (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 06:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgGMK5q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 06:57:46 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632A0C061755
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 03:57:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so15858331wrw.1
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 03:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OoJ+oXirKYTaYOCxXlqJbPrCOA8K7IQDhVr4KDzKRjY=;
        b=P7KfOB5Rc5ildJzOLZ7ATlhrKwP1O2e9dMYbgO9OzuMXEI1DB6bS7cmQV01xOGtJ9j
         GgnwJj7vb7xIC8S/RzTF6LhsgHeAixOv4InND7RSmcRp+uCN0+Vxe43Oo/k/V83NKJJ6
         H570t1D0CugzPJc6Bt629Umo8l4qFEWZ9cZITHcJ5W6ii7DE4OFxesUXwszddg0wpp37
         ne0KZZHBIQ7oNmMI1LB4haFVsMTrSz+mBjqSsy/+SEkf/QvVULNRenKcPXd5TCbSwR4M
         Ep/9KAQSjYzL/nG258XUfKqeOX2+qKftzZ57H83cpfDRMOugFw2L9Oj+f4AkwuytyB5k
         xfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OoJ+oXirKYTaYOCxXlqJbPrCOA8K7IQDhVr4KDzKRjY=;
        b=B3AFHgnEbQdJgnokjWrSMyGr4xcndFPkQFNOIMrDfzZJJJk3wiu+jc3Y3vIapQo24m
         TVMymtXR3JcBb1eySn54vFQj7+GwHi4jjnFvQfnUf8dutMcPnYXXV5M6LK8fjr+ccgJ7
         eFZUPw3mVBD5RijO3UXwgivIxjmBcC1Nf0YqMbKrMVzb55o1CQg4S0j5FNnoJXsZTzhU
         PLhP1GJP0njntiCklkuKLfQuDZ7kL5kPBOWtL7tY6CJM/p1mtLdOfzRFLusKV6LQNiQo
         akIrI9DoO7oHe6xzamQrjgCnbFZ4K/5Dicipyr65PK/vtLfkXjem0y3P5arskkVB33Dl
         mxgg==
X-Gm-Message-State: AOAM533wVqxxia4xlJaW6Xn5NjDsAqf66IURq2v8APq6FzYkoFlcHB0L
        Sas32BowxaSXAghPCwBaC31Totme
X-Google-Smtp-Source: ABdhPJzOHF6iwQHCrnDTKxHZTmx41jQCZ5A8XINTSGysIroz0lyJBOMsnlyilfK719JrQK8+nMEcFg==
X-Received: by 2002:a5d:6907:: with SMTP id t7mr79070452wru.329.1594637865154;
        Mon, 13 Jul 2020 03:57:45 -0700 (PDT)
Received: from localhost.localdomain ([141.226.183.23])
        by smtp.gmail.com with ESMTPSA id r1sm23099330wrw.24.2020.07.13.03.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 03:57:44 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Josh England <jjengla@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH RFC 2/2] ovl: invalidate dentry if lower was renamed
Date:   Mon, 13 Jul 2020 13:57:32 +0300
Message-Id: <20200713105732.2886-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713105732.2886-1-amir73il@gmail.com>
References: <20200713105732.2886-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Changes to lower layer while overlay in mounted result in undefined
behavior.  Therefore, we can change the behavior to invalidate the
overlay dentry on dcache lookup if one of the dentries in the lowerstack
was renamed since the lowerstack was composed.

To be absolute certain that lower dentry was not renamed we would need to
know the redirect path that lead to it, but that is not necessary.
Instead, we just store the hash of the parent/name from when we composed
the stack, which gives a good enough probablity to detect a lower rename
and is much less complexity.

We do not provide this protection for upper dentries, because that would
require updating the hash on overlay initiated renames and that is harder
to implement with lockless lookup.

This doesn't make live changes to underlying layers valid, because
invalid dentry stacks may still be referenced by open files, but it
reduces the window for possible bugs caused by lower rename, because
lookup cannot return those invalid dentry stacks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    |  1 +
 fs/overlayfs/namei.c     |  4 +++-
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     | 17 ++++++++++-------
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 0e696f72cf65..7221b6226e26 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -319,6 +319,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (lower) {
 		oe->lowerstack->dentry = dget(lower);
 		oe->lowerstack->layer = lowerpath->layer;
+		oe->lowerstack->hash = lower->d_name.hash_len;
 	}
 	dentry->d_fsdata = oe;
 	if (upper_alias)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 3566282a9199..ae1c1216a038 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -375,7 +375,8 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 	}
 	**stackp = (struct ovl_path){
 		.dentry = origin,
-		.layer = &ofs->layers[i]
+		.layer = &ofs->layers[i],
+		.hash = origin->d_name.hash_len,
 	};
 
 	return 0;
@@ -968,6 +969,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		} else {
 			stack[ctr].dentry = this;
 			stack[ctr].layer = lower.layer;
+			stack[ctr].hash = this->d_name.hash_len;
 			ctr++;
 		}
 
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b429c80879ee..557f1782f53b 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -42,6 +42,8 @@ struct ovl_layer {
 struct ovl_path {
 	const struct ovl_layer *layer;
 	struct dentry *dentry;
+	/* Hash of the lower parent/name when we found it */
+	u64 hash;
 };
 
 /* private information held for overlayfs's superblock */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f2c74387e05b..4b7cb2d98203 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -119,13 +119,13 @@ static bool ovl_dentry_is_dead(struct dentry *d)
 }
 
 static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak,
-			       bool is_upper)
+			       bool is_upper, u64 hash)
 {
 	bool strict = !weak;
 	int ret = 1;
 
-	/* Invalidate dentry if real was deleted since we found it */
-	if (ovl_dentry_is_dead(d)) {
+	/* Invalidate dentry if real was deleted/renamed since we found it */
+	if (ovl_dentry_is_dead(d) || (hash && hash != d->d_name.hash_len)) {
 		ret = 0;
 		/* Raced with overlay unlink/rmdir? */
 		if (is_upper)
@@ -156,17 +156,18 @@ static int ovl_dentry_revalidate_common(struct dentry *dentry,
 					unsigned int flags, bool weak)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_path *lower = oe->lowerstack;
 	struct dentry *upper;
 	unsigned int i;
 	int ret = 1;
 
 	upper = ovl_dentry_upper(dentry);
 	if (upper)
-		ret = ovl_revalidate_real(upper, flags, weak, true);
+		ret = ovl_revalidate_real(upper, flags, weak, true, 0);
 
-	for (i = 0; ret > 0 && i < oe->numlower; i++) {
-		ret = ovl_revalidate_real(oe->lowerstack[i].dentry, flags,
-					  weak, false);
+	for (i = 0; ret > 0 && i < oe->numlower; i++, lower++) {
+		ret = ovl_revalidate_real(lower->dentry, flags, weak, false,
+					  lower->hash);
 	}
 	return ret;
 }
@@ -1652,6 +1653,8 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	for (i = 0; i < numlower; i++) {
 		oe->lowerstack[i].dentry = dget(stack[i].dentry);
 		oe->lowerstack[i].layer = &ofs->layers[i+1];
+		/* layer root should not be invalidated by rename */
+		oe->lowerstack->hash = 0;
 	}
 
 out:
-- 
2.17.1

