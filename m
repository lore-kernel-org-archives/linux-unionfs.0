Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BFCEC8743
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 17:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbjIGRSr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243012AbjIGRSn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 13:18:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77B6CC
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 10:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694106987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psIW52QgXH2AOvjLjUwb12+BmCd7MyaF4hBr2i6SMLI=;
        b=W2/XYsd8iIPMjVstgldUFYudk+pkt1KV32Yq+2WFSHRDVj3WBcZlRIssx2HpFhy6xKZJQx
        UORoGf1YOIM7QAT0MFhmKVBowBcyIxoSufp1eQiSdumNMznC+OqTSR2qVCypY9PXXmImXX
        rlXIs04b+q5gQUY35OD+cJY/xtwuF08=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-T-fuRr9CM2WvufSMX-KWWQ-1; Thu, 07 Sep 2023 04:44:22 -0400
X-MC-Unique: T-fuRr9CM2WvufSMX-KWWQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2bcb2990ba0so8511311fa.3
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 01:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694076260; x=1694681060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=psIW52QgXH2AOvjLjUwb12+BmCd7MyaF4hBr2i6SMLI=;
        b=GAa4f7V45AHvY0lzdh74ztaeT+Jvsv6rK/aRDGIOmyP4WHOmU99uh++KkTOMjaWsO3
         fjjlh5cGjw1owyLJos7imgIGgOf2sITRrmRlaspxHLfJaIAQTzkGChsQkqMKNMbqVe4E
         1t9/56wAxyKdZzuyoaQWywe8zVocnKDARzsTgY5AY/jlaDFLP06iO3PR2616sMSAnKN3
         Hp0iATWbdoLekYz2j6IuLr3dgzeY1IFfo3WxAwDHfOAf5PXTJfyl8AJbaZ07+W8CPQUG
         i8hw8LYG9KcxG308WOI27i/PDuWMWCXxBjPJKxR0WqMpgxMWiDhmCtXrXL5TbtpuVRDy
         JZKA==
X-Gm-Message-State: AOJu0YxVGd9h8eURNAz7g+WIZv5KF0x5JmkC+5SEJH3yMKrAQ5jZbbpU
        cX/RHZP8lurN7gbf9PiazzHkX7Ta8N3cXO/WUcAL1R1qUIsMNJCNOPR7QQJxZnk1z+c6yY3P9J/
        Sz4h3YEoMR6KnV+87lMjAeFf7nw==
X-Received: by 2002:a2e:818b:0:b0:2bc:e827:a4ff with SMTP id e11-20020a2e818b000000b002bce827a4ffmr4464543ljg.9.1694076260695;
        Thu, 07 Sep 2023 01:44:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5WC4lQoIY349YNO2FZSRCRm/FZXX8Nk6ubluSxgJmkyhqxvGEK66WOLg/KllNkzpbNulDig==
X-Received: by 2002:a2e:818b:0:b0:2bc:e827:a4ff with SMTP id e11-20020a2e818b000000b002bce827a4ffmr4464534ljg.9.1694076260505;
        Thu, 07 Sep 2023 01:44:20 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id o6-20020a2e9b46000000b002b70a64d4desm3812828ljj.46.2023.09.07.01.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 01:44:20 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 5/6] ovl: Handle escaped xwhiteouts across layers
Date:   Thu,  7 Sep 2023 10:44:10 +0200
Message-ID: <acb6243943171a353091fa92cf1ffbf92bcb26ba.1694075674.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694075674.git.alexl@redhat.com>
References: <cover.1694075674.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

We use the "overlay.whiteouts" to mark any directory in a lower dir that may
contain "overlay.whiteout" files (xwhiteouts). This works even if other layers
overlap that directory in a mount.

For example, take these files in three layers:

 layer2/dir/ - overlay.whiteouts
 layer2/dir/file - overlay.whiteout
 layer1/dir/
 layer1/dir/file

An overlayfs mount with -o lowerdir=layer2:layer1 would have a whiteout in
layer2.

However, suppose you wanted to put this inside an overlayfs layer (say
"layerA"). I.e. you want to escape the whiteouts above so that when the new
layer is mounted using overlayfs the mount shows the above content. The natural
approach is to just take each layer and escape it:

 layerA/layer2/dir/ - overlay.overlay.whiteouts
 layerA/layer2/dir/file - overlay.overlay.whiteout
 layerA/layer1/dir/
 layerA/layer1/dir/file

This initially seems to work, however if there is another lowerdir (say
"layerB") that overlaps the xwhiteouts dir, then this runs into problem:

 layerB/layer2/dir/ - **NO overlay.overlay.whiteouts **
 layerA/layer2/dir/ - overlay.overlay.whiteouts
 layerA/layer2/dir/file - overlay.overlay.whiteout
 layerA/layer1/dir/
 layerA/layer1/dir/file

If you mount this with -o lowerdir=layerB:layerA, then in the final mount,
there will be no overlay.whiteouts xattrs on the "layer2/dir" merged
directory, because the topmost lower dir xattrs win.

We would like this to work as is, to avoid having layer escaping depend on other
layers. So, to fix this up we special case the reading of escaped
"overlay.whiteouts" xattrs by looking in all layers for the first hit.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/xattrs.c | 46 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
index 27b31f812eb1..9e5f50ba333d 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -92,6 +92,25 @@ static int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char
 	return res;
 }
 
+static int ovl_xattr_get_first(struct dentry *dentry, struct inode *inode, const char *name,
+			       void *value, size_t size)
+{
+	const struct cred *old_cred;
+	struct path realpath;
+	int idx, next;
+	int res = -ENODATA;
+
+	old_cred = ovl_override_creds(dentry->d_sb);
+	for (idx = 0; idx != -1; idx = next) {
+		next = ovl_path_next(idx, dentry, &realpath);
+		res = vfs_getxattr(mnt_idmap(realpath.mnt), realpath.dentry, name, value, size);
+		if (res != -ENODATA && res != -EOPNOTSUPP)
+			break;
+	}
+	revert_creds(old_cred);
+	return res;
+}
+
 static bool ovl_can_list(struct super_block *sb, const char *s)
 {
 	/* Never list non-escaped private (.overlay) */
@@ -176,6 +195,18 @@ static char *ovl_xattr_escape_name(const char *prefix, const char *name)
 	return escaped;
 }
 
+
+static int str_ends_with(const char *s, const char *sub)
+{
+	int slen = strlen(s);
+	int sublen = strlen(sub);
+
+	if (sublen > slen)
+		return 0;
+
+	return !memcmp(s + slen - sublen, sub, sublen);
+}
+
 static int ovl_own_xattr_get(const struct xattr_handler *handler,
 			     struct dentry *dentry, struct inode *inode,
 			     const char *name, void *buffer, size_t size)
@@ -187,7 +218,20 @@ static int ovl_own_xattr_get(const struct xattr_handler *handler,
 	if (IS_ERR(escaped))
 		return PTR_ERR(escaped);
 
-	r = ovl_xattr_get(dentry, inode, escaped, buffer, size);
+	/*
+	 * Escaped "overlay.whiteouts" directories need to be combined across layers.
+	 * For example, if a lower layer contains an escaped "overlay.whiteout"
+	 * its parent directory will be marked with an escaped "overlay.whiteouts".
+	 * The merged directory will contain a (now non-escaped) whiteout, and its
+	 * parent should therefore be marked too. However, if a layer above the marked
+	 * one has covers the same directory but without whiteouts the covering directory
+	 * would not be marged, and thus the merged directory would not be marked.
+	 */
+	if (d_is_dir(dentry) &&
+	    str_ends_with(escaped, "overlay.whiteouts"))
+		r = ovl_xattr_get_first(dentry, inode, escaped, buffer, size);
+	else
+		r = ovl_xattr_get(dentry, inode, escaped, buffer, size);
 
 	kfree(escaped);
 
-- 
2.41.0

