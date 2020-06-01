Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311B1C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DA4620734
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I82wAy8x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgFAP5M (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 11:57:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55952 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726128AbgFAP5M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 11:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591027030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p30eHv/hOLNLU1QIPmrXx5EkoAKgABRyE7zID306P/8=;
        b=I82wAy8xpLxia3O9ZXEEU+Srt/ajy5i5G1Th+JD4eatfvJIK8tT32dMd+qkBEppfVXlGNx
        +P2SK9/UM5LcgvGz4MR2vv8OW8CJX4CQHWpbzX4/w+KGvXVaMyDna+h3GPseyS0M+zJF+/
        uSpxQYDxuJ6UWhgSDwzGch3uh0g75zE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-7y_JueWxMFWCanFd5XiRFQ-1; Mon, 01 Jun 2020 11:57:07 -0400
X-MC-Unique: 7y_JueWxMFWCanFd5XiRFQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 489C38018A7;
        Mon,  1 Jun 2020 15:57:06 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-117.rdu2.redhat.com [10.10.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 294855C1B2;
        Mon,  1 Jun 2020 15:57:06 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id B5DBE220B2A; Mon,  1 Jun 2020 11:57:05 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     amir73il@gmail.com, miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, yangerkun@huawei.com,
        vgoyal@redhat.com
Subject: [PATCH v2 2/3] overlayfs: ovl_lookup(): Use only uppermetacopy state
Date:   Mon,  1 Jun 2020 11:56:51 -0400
Message-Id: <20200601155652.17486-3-vgoyal@redhat.com>
In-Reply-To: <20200601155652.17486-1-vgoyal@redhat.com>
References: <20200601155652.17486-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 fs/overlayfs/namei.c | 58 ++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c6208f84129f..3625d6633f50 100644
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
@@ -982,22 +987,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
-
-		err = -EPERM;
-		if (!ofs->config.metacopy) {
-			pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n",
-					    dentry);
-			goto out_put;
-		}
+	/*
+	 * For regular non-metacopy upper dentries, there is no lower
+	 * path based lookup, hence ctr will be zero. If a dentry is found
+	 * using ORIGIN xattr on upper, install it in stack.
+	 *
+	 * For metacopy dentry, path based lookup will find lower dentries.
+	 * Just make sure a corresponding data dentry has been found.
+	 */
+	if (d.metacopy || (uppermetacopy && !ctr)) {
+		err = -EIO;
+		goto out_put;
 	} else if (!d.is_dir && upperdentry && !ctr && origin_path) {
 		if (WARN_ON(stack != NULL)) {
 			err = -EIO;
-- 
2.25.4

