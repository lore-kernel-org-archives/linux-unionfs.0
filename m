Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BB6C4708A
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 14:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A17A610A0
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 14:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhE0OHl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 May 2021 10:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbhE0OHl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 May 2021 10:07:41 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098EAC061574
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 07:06:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso2676936wmh.4
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 07:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SbdpySWXY5jm4qIy3BvjJY2bHFByabYMhRsLjtdu600=;
        b=EkJN1rMlP4a/eG+tyG4kHoovev0P0oflynwQ3qcuN5BFohOmehiy92t9Qh5wZKkxrD
         iH/bn8WsekVIsQvfigEviQ5Kw/vg/TzafJ9BRdbkc5+907ZmY3fRgwuWdaY69R/7Ol4A
         nxQuqE9Rp3bOrR8nhz/hDDVaaFO9Rx+ncMg6pnyiip48Las/dvMFCN3uM7T9VDlrtueK
         7fqthMMzXUWdwc5bpg9PxwLwMVZMj0Jf9aGqXD5CX57fhTmDzB4zPoGwalYky8RUGV2c
         azXLX/LWg/9jmVfUXgyQC4BfdbC9baFKeAogXD7z0XOYiFUg0/gPquKwNRF5kdVIzTgu
         UOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SbdpySWXY5jm4qIy3BvjJY2bHFByabYMhRsLjtdu600=;
        b=nY4sVrov2w0oB9HffOA60PS6iHqSlyb5FDq5YVGek6hITDb1W4vXshJSBMHBvp+1Rp
         ODFEirSlEwWz8pfiR6oADhG0Zt+oAq7yAZkwGUfDqQGg5xR1QKtURNOEnLeP/e4ujTqg
         +RJ9iV/vq3SkAa6hxW6UAGSFB5QuKkSqfE2SmOkdUcgmK2Zbtokhz9dkhSGquDj+hWG4
         JkGt4PDoJuHlg4v014eU6lW4xa5+QY7cc81sRnJyZ+cpkdpsBo/L8DQNb5HgRyOWFyQn
         PkVEr4oFEOankUAzWFRJAS5KwKiSHNi0P05sGZdCJO8SA5i57vVeuph0P8ybjlwsSA3T
         XxNA==
X-Gm-Message-State: AOAM5335eII6o/mqFnt95szBn4P5n6t0YvhHq3xCbIEplAehmX2PhOr1
        xeLfEDufDnA7m1Sk2//4NJ8=
X-Google-Smtp-Source: ABdhPJzFsT3VohTDxpgF8sKZsSaxYbgJFMxRVpGaWp6O77dk1cLU6eW2BIZctrm0vuxWM/65ncZiHQ==
X-Received: by 2002:a1c:2743:: with SMTP id n64mr8546125wmn.76.1622124365606;
        Thu, 27 May 2021 07:06:05 -0700 (PDT)
Received: from uvv-2004-vm.localdomain (dslb-002-205-242-053.002.205.pools.vodafone-ip.de. [2.205.242.53])
        by smtp.gmail.com with ESMTPSA id x24sm10582754wmi.13.2021.05.27.07.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 07:06:04 -0700 (PDT)
From:   Vyacheslav Yurkov <uvv.mail@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Subject: [PATCH v2 2/3] ovl: add ovl_allow_offline_changes() helper
Date:   Thu, 27 May 2021 16:05:33 +0200
Message-Id: <20210527140534.107607-2-uvv.mail@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527140534.107607-1-uvv.mail@gmail.com>
References: <20210527140534.107607-1-uvv.mail@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>

Allows to check whether any of extended features are enabled

Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
---
 fs/overlayfs/overlayfs.h | 12 ++++++++++++
 fs/overlayfs/super.c     |  4 +---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6ec73db4bf9e..29d71f253db4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -262,6 +262,18 @@ static inline bool ovl_open_flags_need_copy_up(int flags)
 	return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
 }
 
+static inline bool ovl_allow_offline_changes(struct ovl_fs *ofs)
+{
+	/*
+	 * To avoid regressions in existing setups with overlay lower offline
+	 * changes, we allow lower changes only if none of the new features
+	 * are used.
+	 */
+	return (!ofs->config.index && !ofs->config.metacopy &&
+		!ofs->config.redirect_dir && ofs->config.xino != OVL_XINO_ON);
+}
+
+
 /* util.c */
 int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 97ea35fdd933..a248cbad9a8c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1599,9 +1599,7 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	 * user opted-in to one of the new features that require following the
 	 * lower inode of non-dir upper.
 	 */
-	if (!ofs->config.index && !ofs->config.metacopy &&
-	    !ofs->config.redirect_dir && ofs->config.xino != OVL_XINO_ON &&
-	    uuid_is_null(uuid))
+	if (!ovl_allow_offline_changes(ofs) && uuid_is_null(uuid))
 		return false;
 
 	for (i = 0; i < ofs->numfs; i++) {
-- 
2.25.1

