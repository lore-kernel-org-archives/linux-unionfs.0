Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E584AC001B0
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343866AbjHPPa4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344178AbjHPPah (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:30:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2AC210D
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692199790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXCAiRFo3hv+PliTXHFriguolieXoKt3QF6iiQXuBKU=;
        b=Cz93f3ylAMV41F+qXAVZ7BN/R693+Uu4fzfQ5fTwVjYFwmTWGvBRn/dMGxLCyPc3TrHcLg
        kNMEEAp8ZvJ9OF/2sqqvcs1HCO55LS4MXLn3IfwC9z4F+fPqXYOTfZof+xhy9vG2EQffzg
        uVVRvAuc8emh+40QjP0WgkOnLDCiHhs=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-K9XNdPkwMNieYlKmbwGS0Q-1; Wed, 16 Aug 2023 11:29:48 -0400
X-MC-Unique: K9XNdPkwMNieYlKmbwGS0Q-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2bb8d47a022so17586701fa.3
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199787; x=1692804587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rXCAiRFo3hv+PliTXHFriguolieXoKt3QF6iiQXuBKU=;
        b=LxFMWhKFhMMmWARK7MdAOUCY3zsNoNH47kkcPuyhg8PqWrdEVMmeN0yiK9y7GNdllk
         W6mvblZT5NdNO9U3wNpKp/1odVfgiuzKNSDxSzZI8hPt0pO9G9Hai42Wtm5gbALyJP76
         ZtJzl+IIyKezj+a2YDlf1iUWHL//ClW946gTP7XBwqX19pYu2T0roATZs3GBZZSIzrcH
         7UyRx8jCh5TGlgWb9FlJIVZ2+DREfJ6ErmDLo05QDpbTZcM2ggkeCJnyPOoAjv1BR53h
         SxxPu+y3QzDLItRtWgOUzpB/zOfgrO+ANLaAAkTO9eFfprflGus1FufLQgRRFO/xSJDe
         I26A==
X-Gm-Message-State: AOJu0Yz9maen9xU12Xjnsj/4Q6P0qi4WbE6sIZpgZcf++SbXGs9QDkKk
        sDisQi+9r2cjHo8EgXVk/jR6ieXBZjIGPfzn2NUgqpXNs/VqPldvn0p5J9rlWGfd0JYFGebxju1
        iLfYMaxTeE9n6UAtRTEl+P5R0mg==
X-Received: by 2002:a2e:828b:0:b0:2b9:f13b:6135 with SMTP id y11-20020a2e828b000000b002b9f13b6135mr1724041ljg.18.1692199787383;
        Wed, 16 Aug 2023 08:29:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETi+zpzTOL/E8Y19HBxs2T6o19DJ7WXuXfWYYqZn5wExyarPKmvGGtoaGV+wXmbESR/PTgBA==
X-Received: by 2002:a2e:828b:0:b0:2b9:f13b:6135 with SMTP id y11-20020a2e828b000000b002b9f13b6135mr1724033ljg.18.1692199787092;
        Wed, 16 Aug 2023 08:29:47 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id c13-20020a2e9d8d000000b002b9f03729e2sm3523160ljj.36.2023.08.16.08.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 08:29:46 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 1/4] ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
Date:   Wed, 16 Aug 2023 17:29:39 +0200
Message-ID: <1f882030a25acb59d7e49f8e52359a97258a20b6.1692198910.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692198910.git.alexl@redhat.com>
References: <cover.1692198910.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

These match the ones for e.g. XATTR_TRUSTED_PREFIX_LEN.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/inode.c     | 4 ++--
 fs/overlayfs/overlayfs.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b395cd84bfce..2dccf3f7fcbe 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -345,10 +345,10 @@ bool ovl_is_private_xattr(struct super_block *sb, const char *name)
 
 	if (ofs->config.userxattr)
 		return strncmp(name, OVL_XATTR_USER_PREFIX,
-			       sizeof(OVL_XATTR_USER_PREFIX) - 1) == 0;
+			       OVL_XATTR_USER_PREFIX_LEN) == 0;
 	else
 		return strncmp(name, OVL_XATTR_TRUSTED_PREFIX,
-			       sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1) == 0;
+			       OVL_XATTR_TRUSTED_PREFIX_LEN) == 0;
 }
 
 int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 72f57d919aa9..33f88b524627 100644
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
-- 
2.41.0

