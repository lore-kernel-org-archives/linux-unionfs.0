Return-Path: <SRS0=taqF=7L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413DEC433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 21:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC5420776
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 21:30:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QuUk2hy3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgE2VaU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 May 2020 17:30:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32517 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728166AbgE2VaU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 May 2020 17:30:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590787818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3RwqBJ8ZJQ2fvn7QKRbGbH4tWjQLmw6A0yf38xmg8s8=;
        b=QuUk2hy3ujzz1JD+/Jg0YImWQpx9EwpSzYE/hRY7qvJp6EkLba8UmaEyWQjvfmlD6CCKAY
        sfUre++2kYi9Zl6+Ijkt4t/HQJL42SlG3mILVmTg5Vl7WM4VaJUaV6pevTBwFElc0hlwKw
        XJNBfj3RFJMT10IxWRK9g0HsAeP2fv8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-RngRfbpFM1atBM83-4xNJA-1; Fri, 29 May 2020 17:30:16 -0400
X-MC-Unique: RngRfbpFM1atBM83-4xNJA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C67C3107ACF6;
        Fri, 29 May 2020 21:30:15 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-93.rdu2.redhat.com [10.10.115.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 800077A8A5;
        Fri, 29 May 2020 21:30:15 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id ED4DA22066D; Fri, 29 May 2020 17:30:14 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     amir73il@gmail.com
Cc:     miklos@szeredi.hu, yangerkun@huawei.com,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 2/3] overlayfs: ovl_lookup(): Use only uppermetacopy state
Date:   Fri, 29 May 2020 17:29:51 -0400
Message-Id: <20200529212952.214175-3-vgoyal@redhat.com>
In-Reply-To: <20200529212952.214175-1-vgoyal@redhat.com>
References: <20200529212952.214175-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Currently we use a variable "metacopy" which signifies that dentry
could be either uppermetacopy or lowermetacopy. Amir suggested that
we can move code around and use d.metacopy in such a way that we
don't need lowermetacopy and just can do away with uppermetacopy.

So this patch replaces "metacopy" with "uppermetacopy".

It also moves some code little higher to keep reading little simpler.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 57 ++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5d80d8cc0063..a1889a160708 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -823,7 +823,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
-	bool metacopy = false;
+	bool uppermetacopy = false;
 	struct ovl_lookup_data d = {
 		.sb = dentry->d_sb,
 		.name = dentry->d_name,
@@ -869,7 +869,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 				goto out_put_upper;
 
 			if (d.metacopy)
-				metacopy = true;
+				uppermetacopy = true;
 		}
 
 		if (d.redirect) {
@@ -906,6 +906,22 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (!this)
 			continue;
 
+		if ((uppermetacopy || d.metacopy) && !ofs->config.metacopy) {
+			err = -EPERM;
+			pr_warn_ratelimited("refusing to follow metacopy origin"
+					    " for (%pd2)\n", dentry);
+			goto out_put;
+		}
+
+		/*
+		 * Do not store intermediate metacopy dentries in chain,
+		 * except top most lower metacopy dentry
+		 */
+		if (d.metacopy && ctr) {
+			dput(this);
+			continue;
+		}
+
 		/*
 		 * If no origin fh is stored in upper of a merge dir, store fh
 		 * of lower dir and set upper parent "impure".
@@ -940,17 +956,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			origin = this;
 		}
 
-		if (d.metacopy)
-			metacopy = true;
-		/*
-		 * Do not store intermediate metacopy dentries in chain,
-		 * except top most lower metacopy dentry
-		 */
-		if (d.metacopy && ctr) {
-			dput(this);
-			continue;
-		}
-
 		stack[ctr].dentry = this;
 		stack[ctr].layer = lower.layer;
 		ctr++;
@@ -982,23 +987,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
-	if (metacopy) {
-		/*
-		 * Found a metacopy dentry but did not find corresponding
-		 * data dentry
-		 */
-		if (d.metacopy) {
-			err = -EIO;
-			goto out_put;
-		}
+	/* Found a metacopy dentry but did not find corresponding data dentry */
+	if (d.metacopy) {
+		err = -EIO;
+		goto out_put;
+	}
 
-		err = -EPERM;
-		if (!ofs->config.metacopy) {
-			pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n",
-					    dentry);
-			goto out_put;
-		}
-	} else if (!d.is_dir && upperdentry && !ctr && origin_path) {
+	/* For regular non-metacopy upper dentries, there is no lower
+	 * path based lookup, hence ctr will be zero. dentry found using
+	 * ORIGIN xattr on upper, install it in stack.
+	 */
+	if (!d.is_dir && upperdentry && !ctr && origin_path) {
 		if (WARN_ON(stack != NULL)) {
 			err = -EIO;
 			goto out_put;
-- 
2.25.4

