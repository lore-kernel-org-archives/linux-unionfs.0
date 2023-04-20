Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A068C77B78
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 07:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbjDTHpS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 03:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjDTHpQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 03:45:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64A340F5
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681976672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xN6AqEpfmVjYvG0OhUB3hiPDQCXbC+IJ+pstcsNq1Nw=;
        b=ff3NGvL4zs1dvqZs4pTeUrmDATSrmfdE+4dTSlma5aH9hCRtXUW7MS+5i++phCpYwOugUF
        ZFRgmm9LsSTzwHwKbodEkhX7D8sCpyKtcjT9TlUbHLvVzCtjxQUlfMWk9qy1Dxw0UDOcnc
        9FfbMWL4LZI81YWWrPY8BWWvmcDArPI=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-KOjXK8sUPASczOi6CPROFA-1; Thu, 20 Apr 2023 03:44:31 -0400
X-MC-Unique: KOjXK8sUPASczOi6CPROFA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2a76e612fbfso1732161fa.2
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681976669; x=1684568669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xN6AqEpfmVjYvG0OhUB3hiPDQCXbC+IJ+pstcsNq1Nw=;
        b=X1HAQMlPdadkHWJHNloYSe5w1RIR04BjRgaXeOKJrplxbtuwYvluJpIlVCcMZyDlN1
         t8suL799p8vG5eVJ80Xv5XdtyI/NfwlscgNSdTNXxee/t32QAlQVn9M+vpy+NwG9hz/Q
         96PpYgdH6oANEUNm7iLx1TqolFY7CYxD8FddtVyRQyjRw+wOjMr0j8gV3Vi1Kd+grXYd
         7lVrl0XgRmUPLeixcsluWbF9ju8g0UV0V0Yz/fvU0lAtBKaHL0xbVbCQF/EnYxUFP+wW
         A+0a4w+/rOgfPGmRazao7zbRMddc827VaTN/+S1yKy6F29TEVtd6px5xV9Yd83mVPAKb
         IMzQ==
X-Gm-Message-State: AAQBX9fVHndN1bb1DhbPH8OhogDMvJCo698AI+s6pbXdFQmgxMoOURv6
        xz0geUbYsIfRKnazaEJasPkmgImbiTupdptI2g9C98GRkj8QhnQaKmVSEfaOTVdJw6YQAuMqb5i
        9G4+sJwGwfivsJzp99+/X1hQIfOIfnhv/EA==
X-Received: by 2002:ac2:415a:0:b0:4b5:178f:a14c with SMTP id c26-20020ac2415a000000b004b5178fa14cmr141389lfi.16.1681976669389;
        Thu, 20 Apr 2023 00:44:29 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y5TnQWQVXrxaYR7XlAeeWpFAOT4dk0n7uhnsiswCgbwrGDYzd29Nz60slBTRnB2usl6kqryA==
X-Received: by 2002:ac2:415a:0:b0:4b5:178f:a14c with SMTP id c26-20020ac2415a000000b004b5178fa14cmr141381lfi.16.1681976669093;
        Thu, 20 Apr 2023 00:44:29 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id x24-20020ac24898000000b004edc7247778sm129468lfc.79.2023.04.20.00.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 00:44:28 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 2/6] ovl: Break out ovl_entry_path_real() from ovl_i_path_real()
Date:   Thu, 20 Apr 2023 09:44:01 +0200
Message-Id: <4c5c62c05a00a97dce0ce5fbee020e82ee76c202.1681917551.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681917551.git.alexl@redhat.com>
References: <cover.1681917551.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This allows us to get the real path from the ovl_entry in ovl_lookup()
before having finished setting up the resulting inode.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/util.c      | 25 ++++++++++++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 4e327665c316..477008186d18 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -395,6 +395,8 @@ void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 void ovl_i_path_real(struct inode *inode, struct path *path);
+void ovl_entry_path_real(struct ovl_fs *ofs, struct ovl_entry *oe,
+			 struct dentry *upperdentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 9a042768013e..77c954591daa 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -351,19 +351,30 @@ struct dentry *ovl_i_dentry_upper(struct inode *inode)
 	return ovl_upperdentry_dereference(OVL_I(inode));
 }
 
-void ovl_i_path_real(struct inode *inode, struct path *path)
-{
-	struct ovl_path *lowerstack = ovl_lowerstack(OVL_I_E(inode));
+void ovl_entry_path_real(struct ovl_fs *ofs,
+			 struct ovl_entry *oe,
+			 struct dentry *upperdentry,
+			 struct path *path)
+{
+	if (upperdentry) {
+		path->dentry = upperdentry;
+		path->mnt = ovl_upper_mnt(ofs);
+	} else {
+		struct ovl_path *lowerstack = ovl_lowerstack(oe);
 
-	path->dentry = ovl_i_dentry_upper(inode);
-	if (!path->dentry) {
 		path->dentry = lowerstack->dentry;
 		path->mnt = lowerstack->layer->mnt;
-	} else {
-		path->mnt = ovl_upper_mnt(OVL_FS(inode->i_sb));
 	}
 }
 
+void ovl_i_path_real(struct inode *inode, struct path *path)
+{
+	ovl_entry_path_real(OVL_FS(inode->i_sb),
+			    OVL_I_E(inode),
+			    ovl_i_dentry_upper(inode),
+			    path);
+}
+
 struct inode *ovl_inode_upper(struct inode *inode)
 {
 	struct dentry *upperdentry = ovl_i_dentry_upper(inode);
-- 
2.39.2

