Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29406EC8742
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 17:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242293AbjIGRQa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbjIGRQ2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 13:16:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D141FCA
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 10:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694106859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BepCjTyKDBuMfPiRMkPfRUY6SOX6/lnxY5feg8LzzpI=;
        b=LtRpZvWFFu4DbuMIggAFvDcBW18KynJUPsYUqD69bv6V8DaV8edmy0dsRc2n5BBWcxJPRo
        53NPbK5g9js9ff6f9OFf2kHR9PuD5Honeaxb0M6EDGdDxCbh7lZuArgAb84c7JC62poWdM
        2a2KJU0hYx1ByWtmpLjeanV6IY/DJ78=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-4S86Z8w_NY-1YFXDuJxb7Q-1; Thu, 07 Sep 2023 04:44:19 -0400
X-MC-Unique: 4S86Z8w_NY-1YFXDuJxb7Q-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2bbc1d8011dso9069911fa.1
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 01:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694076258; x=1694681058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BepCjTyKDBuMfPiRMkPfRUY6SOX6/lnxY5feg8LzzpI=;
        b=It/WNGWRnGzc7UkfdtTpPgIQfBgqur/uE/msNmP0EL6asC2xBrNBHDQJK79Z0x1ZFD
         cY9LP4fEhN7t3mSXxYWb4KkWw6EL7BVYAS8kRpkby8fUtv62rOmifjsjmWo1zZc3Dmrd
         ePRUypGOd2F3SH5SsOk8mnKFxw+w9UlZEB4xybFQnBJrBJ1lcd+KlRj2xfq+1iAtaVod
         lQ2Xhv1gwL4KvT6fTxJXG3Yn4SA2z4N8huombLVH6QmOUSyXn9RH1XmJB23L5xHMmZ4X
         g5X5nsetw/6+oSecZ6vy0dxwBPuEZ8IkigSB3A/qm0qB3zi1olNKFCuDJEf7ER3EcAg7
         UooA==
X-Gm-Message-State: AOJu0YwdTDqHrFHzXQ9U9XHW/akV31R0DZ48qsWdoX/ybwu2+e9dg9k6
        M7Q1O9y1/t6UvsF3febWGyx4QXlm9wVv5O34zFJMwJSEpD9MtydN5FN1TBz7l+fH54IAmOkE/Mb
        ajEyY+i/ppj9Qz05clyik5iYHSQ==
X-Received: by 2002:a2e:7212:0:b0:2bc:b6ce:eab with SMTP id n18-20020a2e7212000000b002bcb6ce0eabmr4042845ljc.51.1694076258125;
        Thu, 07 Sep 2023 01:44:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4h3qShr/LLTqBngqkDnRMngIKMG7nOY23izrWewX21mRHlD7alf0CifjCjUKyqkZoBqdvDg==
X-Received: by 2002:a2e:7212:0:b0:2bc:b6ce:eab with SMTP id n18-20020a2e7212000000b002bcb6ce0eabmr4042836ljc.51.1694076257959;
        Thu, 07 Sep 2023 01:44:17 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id o6-20020a2e9b46000000b002b70a64d4desm3812828ljj.46.2023.09.07.01.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 01:44:17 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 2/6] ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
Date:   Thu,  7 Sep 2023 10:44:07 +0200
Message-ID: <64d90191ad9609e83ce6ddb15f5fd7ab96016dc8.1694075674.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694075674.git.alexl@redhat.com>
References: <cover.1694075674.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

These match the ones for e.g. XATTR_TRUSTED_PREFIX_LEN.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 2 ++
 fs/overlayfs/xattrs.c    | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7b2a309bd746..dff7232b7bf5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -28,7 +28,9 @@ enum ovl_path_type {
 
 #define OVL_XATTR_NAMESPACE "overlay."
 #define OVL_XATTR_TRUSTED_PREFIX XATTR_TRUSTED_PREFIX OVL_XATTR_NAMESPACE
+#define OVL_XATTR_TRUSTED_PREFIX_LEN (sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1)
 #define OVL_XATTR_USER_PREFIX XATTR_USER_PREFIX OVL_XATTR_NAMESPACE
+#define OVL_XATTR_USER_PREFIX_LEN (sizeof(OVL_XATTR_USER_PREFIX) - 1)
 
 enum ovl_xattr {
 	OVL_XATTR_OPAQUE,
diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
index edc7cc49a7c4..b8ea96606ea8 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -10,10 +10,10 @@ bool ovl_is_private_xattr(struct super_block *sb, const char *name)
 
 	if (ofs->config.userxattr)
 		return strncmp(name, OVL_XATTR_USER_PREFIX,
-			       sizeof(OVL_XATTR_USER_PREFIX) - 1) == 0;
+			       OVL_XATTR_USER_PREFIX_LEN) == 0;
 	else
 		return strncmp(name, OVL_XATTR_TRUSTED_PREFIX,
-			       sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1) == 0;
+			       OVL_XATTR_TRUSTED_PREFIX_LEN) == 0;
 }
 
 static int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
-- 
2.41.0

