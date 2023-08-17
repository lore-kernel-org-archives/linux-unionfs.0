Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8BAC41513
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 11:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350100AbjHQLGW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350153AbjHQLGT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 07:06:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72AE2D71
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692270331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UxhcRejCXK93nvN/syqaScKqTPzEQGELVrDz20SPCOo=;
        b=htN3gT3nXL8LvBd7byPWPOzjTnm4WBofFZmMepoUKLpnjEuC2WyeBNW9SZxxF9U9iJ98C9
        +rggbhdiqNYzOCx02g6QV8a7TJbPBlAXpOcTyz98p50+CwltB+1edG14z/UQBMK+pNzvxk
        OG3c8dyO/AOn8EkbcECRgRHS+ORRxSs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-kdhWMswqN12opAbYY_imuQ-1; Thu, 17 Aug 2023 07:05:30 -0400
X-MC-Unique: kdhWMswqN12opAbYY_imuQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2b9dc1bfddcso5277071fa.0
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692270329; x=1692875129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UxhcRejCXK93nvN/syqaScKqTPzEQGELVrDz20SPCOo=;
        b=PvMwlXE/l0OJCndsF1FvU6S/7iCVEEB7IWXTUU6Hf0oRstsqcbd9h5lVXkvOJO3Knz
         FKA2O89aZ/cOPDQf4DlAhRPNTCi+e0yq7jc4HoZqFj/kA3xB7W3sreuJVvpNqHXC3OpL
         S6mUQW3VmmNzFbht/5r7UGwB0Qt3cbK3087raM/2dbt4bFDwT9yCCzdXWJHAaEig/C38
         SGcoZRQ6mqdADC5538lMBjBAiVEq/uU1Sav0RjrU90xNQfAXEThWw0YMzXTApSE1OmwZ
         tbr2OTwymA7LvU4tyRtne+67om/oNGZAePj3O2G9RJGNILPtIHbkKvCWwfj0cFyxH6bB
         1GsA==
X-Gm-Message-State: AOJu0YxC+xAVvdeKnoEVf7MuGyTHJM4RNIiyC9GMcMx7JcsnDw9RzONh
        WvoFaiL9UM+Kc2JoU2pVOj9xR/tiOepIHE1/mujOJU1Wa54+cW8h6yxYtPMxKIC/n0vxtucj9xn
        tMzRkZTwl+uTuDHBWSCyQDFTWdCGcNj/LSw==
X-Received: by 2002:a2e:8952:0:b0:2b6:f85a:20af with SMTP id b18-20020a2e8952000000b002b6f85a20afmr992698ljk.4.1692270328941;
        Thu, 17 Aug 2023 04:05:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4zhmRo7nX2Gwwh5fobdiU1pkHwhaOh5fdDG7bLCtRr2RcQtDS9S0rsJQZDItJHXK5zTBObQ==
X-Received: by 2002:a2e:8952:0:b0:2b6:f85a:20af with SMTP id b18-20020a2e8952000000b002b6f85a20afmr992689ljk.4.1692270328759;
        Thu, 17 Aug 2023 04:05:28 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id l20-20020a2e8694000000b002ba15c272e8sm69010lji.71.2023.08.17.04.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 04:05:28 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 2/5] ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
Date:   Thu, 17 Aug 2023 13:05:21 +0200
Message-ID: <2e308a817498e248e4a8085b50cfb12e4fd28be2.1692270188.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692270188.git.alexl@redhat.com>
References: <cover.1692270188.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

These match the ones for e.g. XATTR_TRUSTED_PREFIX_LEN.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/overlayfs.h | 2 ++
 fs/overlayfs/xattrs.c    | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1283b7126b94..ef993a543b2a 100644
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

