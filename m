Return-Path: <SRS0=BIrA=6S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9062AC3A5A9
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 May 2020 19:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E36720721
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 May 2020 19:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=dolezel.info header.i=@dolezel.info header.b="qRwH10qW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgEDTuE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 May 2020 15:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726111AbgEDTuE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 May 2020 15:50:04 -0400
X-Greylist: delayed 585 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 May 2020 12:50:03 PDT
Received: from zeus.dolezel.info (zeus.dolezel.info [IPv6:2001:1ae9:25f:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9788C061A0E
        for <linux-unionfs@vger.kernel.org>; Mon,  4 May 2020 12:50:03 -0700 (PDT)
Received: by zeus.dolezel.info (Postfix, from userid 1000)
        id 0830950049D; Mon,  4 May 2020 21:40:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dolezel.info;
        s=default; t=1588621214;
        bh=d+xa89BDi/Js8+RERbI+cuoGqWt2MZD0Ebq9nnSkJv0=;
        h=From:To:Cc:Subject:Date;
        b=qRwH10qWvOMyj0yeTH8nedI8on9KwL+54di8/dhugh/c05a9tsNHF7OnDf6KcNuHC
         zp0fmal0PE+/s+zqIxZfBh/ah04Prb+1bZIgr4ZT2syOypB//FjdFGMJ9AVp80mHVG
         0yIGjb0jeJnMEa8FhQoHaIbtAU+/idn7GEX3gAro=
From:   Lubos Dolezel <lubos@dolezel.info>
To:     linux-unionfs@vger.kernel.org
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Lubos Dolezel <lubos@dolezel.info>
Subject: [PATCH] overlay: return required buffer size for file handles
Date:   Mon,  4 May 2020 21:35:09 +0200
Message-Id: <20200504193508.10519-1-lubos@dolezel.info>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

overlayfs doesn't work well with the fanotify mechanism.

Fanotify first probes for the required buffer size for the file handle,
but overlayfs currently bails out without passing the size back.

That results in errors in the kernel log, such as:

[527944.485384] overlayfs: failed to encode file handle (/, err=-75, buflen=0, len=29, type=1)
[527944.485386] fanotify: failed to encode fid (fsid=ae521e68.a434d95f, type=255, bytes=0, err=-2)

Lubos

Signed-off-by: Lubos Dolezel <lubos@dolezel.info>
---
 fs/overlayfs/export.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 475c61f53..0068bf3a0 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -231,12 +231,9 @@ static int ovl_dentry_to_fid(struct dentry *dentry, u32 *fid, int buflen)
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
-	err = -EOVERFLOW;
 	len = OVL_FH_LEN(fh);
-	if (len > buflen)
-		goto fail;
-
-	memcpy(fid, fh, len);
+	if (buflen >= len)
+		memcpy(fid, fh, len);
 	err = len;
 
 out:
@@ -255,6 +252,7 @@ static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
 {
 	struct dentry *dentry;
 	int bytes = *max_len << 2;
+	int bytes_used;
 
 	/* TODO: encode connectable file handles */
 	if (parent)
@@ -264,12 +262,14 @@ static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
 	if (WARN_ON(!dentry))
 		return FILEID_INVALID;
 
-	bytes = ovl_dentry_to_fid(dentry, fid, bytes);
+	bytes_used = ovl_dentry_to_fid(dentry, fid, bytes);
 	dput(dentry);
-	if (bytes <= 0)
+	if (bytes_used <= 0)
 		return FILEID_INVALID;
 
-	*max_len = bytes >> 2;
+	*max_len = bytes_used >> 2;
+	if (bytes_used > bytes)
+		return FILEID_INVALID;
 
 	return OVL_FILEID_V1;
 }
-- 
2.26.2

