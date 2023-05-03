Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A546C77B7F
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 May 2023 08:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjECIwu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 May 2023 04:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjECIwt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2023 04:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C60E57
        for <linux-unionfs@vger.kernel.org>; Wed,  3 May 2023 01:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683103919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QiUYoZhsO38yQi5Z+ZT4TmEZo+0EwfXvmiSU1oG1sMU=;
        b=jWeWzGEEmQMW/+5+KF9xzW9oXmPyDO9vbXW6lbQr8AKeWEJ7oRwQH7QaUWv29T3mIpVlOp
        /EnyFhh2rPkTy3kAvXurjI6IUrgLrc2KpDTAFlgsTbWBdcHVmbjKHHaiDam7VUPsnwEkN1
        iJ9ddwg6SNI5bqxNT4t31t27qUaaqlU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-JY4K4cDhMcemR9MV4ahVhA-1; Wed, 03 May 2023 04:51:58 -0400
X-MC-Unique: JY4K4cDhMcemR9MV4ahVhA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4f020caac60so2551220e87.0
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2023 01:51:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683103916; x=1685695916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QiUYoZhsO38yQi5Z+ZT4TmEZo+0EwfXvmiSU1oG1sMU=;
        b=Ttd54aBGT1I7P3ABfQCRUzPl7v7KjUqVDrqA2W/YNL2uXUSOOoVIYMic1Xfacdsx8/
         mCAlLwhtIZ1shCBCHIKJ0YAhCBa26bMARajUoV4roviVeSWOky5K4ODSa9OTZT9ns0fY
         XvMblFtHIC0LZ2XQ2rFsAPRGDrPhFCpN1K3fQi3SRkvhB/2nmcPrjRePQ78k0dB2Z3O2
         wYO9aRGc7d9qco6dz2MkynBdR5ABXd7Tjnj+PTPk7d6jKIbDoLyFt3drJ8Ew5xJQaBWF
         muYRVheUjRD2FmHyONejquj9TcPc4+8GTkh3zdHLwgPw+SXoCLN9uh7T2d+FKkeztD9E
         g2wA==
X-Gm-Message-State: AC+VfDxUNTeLIE7/MvbvfBzTyyqgXBpjzcFzouKU7fD+Cgb8aR2ZKrc9
        DmfJABetw0WiGlwQfxSy7p+/VN2cPvEyokQ/7GqCUPmhne2n55JIPSHt401rr9S/oNdjKDVPKDB
        H5xacI4dFbi5Q/ZeuTBSQrJOIsw==
X-Received: by 2002:a05:6512:3744:b0:4ec:9ef9:e3d with SMTP id a4-20020a056512374400b004ec9ef90e3dmr584539lfs.26.1683103916609;
        Wed, 03 May 2023 01:51:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7gg4av5X822rtZVLUAVe8lkkygabGEWSRqdxCBuGCAzot3kNC76Sn92ME672RYhMYqQiFpHg==
X-Received: by 2002:a05:6512:3744:b0:4ec:9ef9:e3d with SMTP id a4-20020a056512374400b004ec9ef90e3dmr584534lfs.26.1683103916372;
        Wed, 03 May 2023 01:51:56 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id j6-20020ac24546000000b004ed4fa5f20fsm5907089lfm.25.2023.05.03.01.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 01:51:55 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 2/6] ovl: Break out ovl_e_path_real() from ovl_i_path_real()
Date:   Wed,  3 May 2023 10:51:35 +0200
Message-Id: <86b9adf5b011a17fc51016fa7a66cb8f87578c0e.1683102959.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1683102959.git.alexl@redhat.com>
References: <cover.1683102959.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This allows us to get the real path from the ovl_entry in ovl_lookup()
before having finished setting up the resulting inode.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/util.c      | 25 ++++++++++++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c1233eec2d40..6ce1c7906bb9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -391,6 +391,8 @@ void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 void ovl_i_path_real(struct inode *inode, struct path *path);
+void ovl_e_path_real(struct ovl_fs *ofs, struct ovl_entry *oe,
+		     struct dentry *upperdentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index e526ab059872..c32252153e5e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -331,19 +331,30 @@ struct dentry *ovl_i_dentry_upper(struct inode *inode)
 	return ovl_upperdentry_dereference(OVL_I(inode));
 }
 
-void ovl_i_path_real(struct inode *inode, struct path *path)
-{
-	struct ovl_path *lowerpath = ovl_lowerpath(OVL_I_E(inode));
+void ovl_e_path_real(struct ovl_fs *ofs,
+		     struct ovl_entry *oe,
+		     struct dentry *upperdentry,
+		     struct path *path)
+{
+	if (upperdentry) {
+		path->dentry = upperdentry;
+		path->mnt = ovl_upper_mnt(ofs);
+	} else {
+		struct ovl_path *lowerpath = ovl_lowerpath(oe);
 
-	path->dentry = ovl_i_dentry_upper(inode);
-	if (!path->dentry) {
 		path->dentry = lowerpath->dentry;
 		path->mnt = lowerpath->layer->mnt;
-	} else {
-		path->mnt = ovl_upper_mnt(OVL_FS(inode->i_sb));
 	}
 }
 
+void ovl_i_path_real(struct inode *inode, struct path *path)
+{
+	ovl_e_path_real(OVL_FS(inode->i_sb),
+			OVL_I_E(inode),
+			ovl_i_dentry_upper(inode),
+			path);
+}
+
 struct inode *ovl_inode_upper(struct inode *inode)
 {
 	struct dentry *upperdentry = ovl_i_dentry_upper(inode);
-- 
2.39.2

