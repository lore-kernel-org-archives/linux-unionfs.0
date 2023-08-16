Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6D0C04E69
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbjHPPYX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344199AbjHPPYH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:24:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF86A1BE7
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:23:42 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3197a71a9c0so1925696f8f.1
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692199421; x=1692804221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1thXDZkV6ANfVJ8+NsXMVwbvrZ0/56kZVteiMQNWnE=;
        b=n4Xvx4Sr0MdLlHrmKtp8CQfr/5ORMqqogdbGv0CUwc4vfFQRuYtqfu/h67/T7aM3fC
         ws8ow8RnGhRnwQcqibxlO6DyEepx8A7d6Ooz+YpjhvX5MBNqSWfWWfuDYPhaToPUgetO
         3R/K4h5MyEum34gnwuLpQDJyTvrTAkrH1XrHjqebl5S6sr+jmeCppXSc/AhCzl9UZdoz
         fsvZJDFPP8tOJ2rF7+T5cdH3EVoOdPRXcqa6NEzgST317PrfTN7WrSGrGFyF9sFVuKbI
         8bsLbvOmKMIeXoF5cOkieqUMtay72e4P4wJm+hYX2e8w7qJFDkZ+WmntM0KCNsQEJ1To
         QMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199421; x=1692804221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O1thXDZkV6ANfVJ8+NsXMVwbvrZ0/56kZVteiMQNWnE=;
        b=Z6ebqUppEQegxK/CmF3wgeRqQEOzFgrNyC0GwiYxQeOWphNFao+54D077lHnjEOm07
         q6fZPxkKQjD2u8b6+fpxfyYrm6nsRDxEki5Nankibe+tTJMZyANMqZ+1ulV40Yg+qwJu
         MULbhK5vjAECsOSxwo6ywRb/8FxFBMg8ZbE9f1IUxB/G2p+gFmAt3PZb1YGhn7UQk1Nd
         aoUDXZ8LeCQtv78NyLDoLMMXjp79IBAhufZT9xnUZRyrToe2z9dWI0KLAHsbHiGZcmud
         DcSLDjykLrBYPZ+plRx5A5fX1kHYz2NKZfIMA5t9FgKkFFmB1ckFE0IC/ewtYNELT7aJ
         BZAw==
X-Gm-Message-State: AOJu0Yy2Z34eRTmhFeG7dSB8bbKFdBTpGjSLRqgEElFNqdTl9kGo9xMm
        lpWtTT9dBZI4ELJJAUs+YNXuili6dds=
X-Google-Smtp-Source: AGHT+IHe107rS8rFlTEL47AxuFT9NcukASseeOrpOM+KpxQh2St74qk1EkPn1Vhl9QRHm1N36Qbw1Q==
X-Received: by 2002:adf:decb:0:b0:319:6e54:a49b with SMTP id i11-20020adfdecb000000b003196e54a49bmr4176663wrn.7.1692199421184;
        Wed, 16 Aug 2023 08:23:41 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k7-20020adfe3c7000000b003176c6e87b1sm21701988wrm.81.2023.08.16.08.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 08:23:40 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v3 2/4] ovl: split ovl_want_write() into two helpers
Date:   Wed, 16 Aug 2023 18:23:32 +0300
Message-Id: <20230816152334.924960-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230816152334.924960-1-amir73il@gmail.com>
References: <20230816152334.924960-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl_get_mnt_write() gets write access to upper mnt without taking freeze
protection on upper sb and ovl_start_write() only takes freeze
protection on upper sb.

These helpers will be used to breakup the large ovl_want_write() scope
during copy up into finer grained freeze protection scopes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  4 ++++
 fs/overlayfs/util.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 72f57d919aa9..6da49bf78b90 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -398,7 +398,11 @@ static inline bool ovl_open_flags_need_copy_up(int flags)
 }
 
 /* util.c */
+int ovl_get_mnt_write(struct dentry *dentry);
+void ovl_start_write(struct dentry *dentry);
 int ovl_want_write(struct dentry *dentry);
+void ovl_put_mnt_write(struct dentry *dentry);
+void ovl_end_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
 const struct cred *ovl_override_creds(struct super_block *sb);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 753734c55647..980e128ba0a4 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -17,12 +17,38 @@
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
 
+/* Get write access to upper mnt - may fail if upper sb was remounted ro */
+int ovl_get_mnt_write(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+	return __mnt_want_write(ovl_upper_mnt(ofs));
+}
+
+/* Get write access to upper sb - may block if upper sb is frozen */
+void ovl_start_write(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+	sb_start_write(ovl_upper_mnt(ofs)->mnt_sb);
+}
+
 int ovl_want_write(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	return mnt_want_write(ovl_upper_mnt(ofs));
 }
 
+void ovl_put_mnt_write(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+	__mnt_drop_write(ovl_upper_mnt(ofs));
+}
+
+void ovl_end_write(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+	sb_end_write(ovl_upper_mnt(ofs)->mnt_sb);
+}
+
 void ovl_drop_write(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
-- 
2.34.1

