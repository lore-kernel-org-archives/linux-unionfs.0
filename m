Return-Path: <SRS0=Fd6Y=4J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F89AC35646
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAE25222C4
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SF1fl4J6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgBUOe5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:34:57 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44748 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgBUOe5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:34:57 -0500
Received: by mail-wr1-f66.google.com with SMTP id m16so2302976wrx.11
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Feb 2020 06:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qcKEvMeyAI9yPNDEeAaHX5ks9dRQj/xajWJ5mQh0A3Q=;
        b=SF1fl4J6GJOxCYyuiGRoMiIH4+xhEXk1gWkBtPUiOOF6SYIEY8tAUOIH5XDKUe6F2l
         ivOfktmTatW7Mt8YWbgnIOoSsMegm0BEDoMbVM01JdRnlusD7JMo0T4/qPcOaoSahShu
         I0iaEF0YnaFJ8j9e1QtrN5Zulw7s+k+iRLdQV50SJhkx8+arkwIDum9yiDhxzN9ItBD7
         emIV0328j4EPDbggVn+CKCtrZlcjQvKAycSLlCVSPkod1XmR07pXDu2tPPT+6NTGhF38
         seD5B5sj4RUtWFvfmTZxPFqw6flf8bpnZE+ExjzZUl83cUZsYGi6p3GMQuT4ruEWkfXg
         pD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qcKEvMeyAI9yPNDEeAaHX5ks9dRQj/xajWJ5mQh0A3Q=;
        b=FyrlwccnmUMvhbCni0o/em2kfHXw/C0OpAWWiIv8Usa97JAxIw59AQjYcCKR/CfoHK
         5lz6xZeu5CyDiFcgSfSay+/e9HmjXvKN/dBj6ZbcoXwkSWM4kbuqXqbZh6YAHF4Zhqmf
         xAj/4/wxevmje3E4GJxgFC1RI5TxBHt+iKrdePG5C8SRoOX9oEA7JRk8nPrIWq3OeWtL
         LN7XonFkdRfZtlmsrfs5F3LcY1i+55x43FZA0KKS5ElVkTMWFhF4EWmlw6kQv5qcM/Ps
         ZhY6F7onUegW054V5Nhfjqgs2LSNBP2ZCm3pkr3JCOW0UfGLLBpAfLdSIY/rbQBrcv6G
         osvQ==
X-Gm-Message-State: APjAAAWOYO4wnkbUXb9A5oAZs0xIAp7pR+bAhMWy4wPDctG+Olra7Zc6
        lbfybLsrkfOTUPsL+aa2k3vG9SMv
X-Google-Smtp-Source: APXvYqyZ2bUcEMm+UWWtIWDGmEWFQgK1ZFIZ+DWB5PSH+y67UYWOHXzbjzLryMSjFfJErSBmJGMfuA==
X-Received: by 2002:adf:df8f:: with SMTP id z15mr47585873wrl.282.1582295695226;
        Fri, 21 Feb 2020 06:34:55 -0800 (PST)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id a184sm4109014wmf.29.2020.02.21.06.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:34:54 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v2 1/5] ovl: fix some xino configurations
Date:   Fri, 21 Feb 2020 16:34:42 +0200
Message-Id: <20200221143446.9099-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221143446.9099-1-amir73il@gmail.com>
References: <20200221143446.9099-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Fix up two bugs in the coversion to xino_mode:
1. xino=off does not alway end up in disabled mode
2. xino=auto on 32bit arch should end up in disabled mode

Take a proactive approach to disabling xino on 32bit kernel:
1. Disable XINO_AUTO config during build time
2. Disable xino with a warning on mount time

As a by product, xino=on on 32bit arch also ends up in disabled mode.
We never intended to enable xino on 32bit arch and this will make the
rest of the logic simpler.

Fixes: 0f831ec85eda ("ovl: simplify ovl_same_sb() helper")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Kconfig | 1 +
 fs/overlayfs/super.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 444e2da4f60e..714c14c47ca5 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -93,6 +93,7 @@ config OVERLAY_FS_XINO_AUTO
 	bool "Overlayfs: auto enable inode number mapping"
 	default n
 	depends on OVERLAY_FS
+	depends on 64BIT
 	help
 	  If this config option is enabled then overlay filesystems will use
 	  unused high bits in undelying filesystem inode numbers to map all
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 6dc45bc7d664..f4c0ad69f9a6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1489,6 +1489,8 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		if (ofs->config.xino == OVL_XINO_ON)
 			pr_info("\"xino=on\" is useless with all layers on same fs, ignore.\n");
 		ofs->xino_mode = 0;
+	} else if (ofs->config.xino == OVL_XINO_OFF) {
+		ofs->xino_mode = -1;
 	} else if (ofs->config.xino == OVL_XINO_ON && ofs->xino_mode < 0) {
 		/*
 		 * This is a roundup of number of bits needed for encoding
@@ -1735,8 +1737,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_stack_depth = 0;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	/* Assume underlaying fs uses 32bit inodes unless proven otherwise */
-	if (ofs->config.xino != OVL_XINO_OFF)
+	if (ofs->config.xino != OVL_XINO_OFF) {
 		ofs->xino_mode = BITS_PER_LONG - 32;
+		if (!ofs->config.xino) {
+			pr_warn("xino not supported on 32bit kernel, falling back to xino=off.\n");
+			ofs->config.xino = OVL_XINO_OFF;
+		}
+	}
 
 	/* alloc/destroy_inode needed for setting up traps in inode cache */
 	sb->s_op = &ovl_super_operations;
-- 
2.17.1

