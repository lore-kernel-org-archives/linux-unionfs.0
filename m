Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D58C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 16:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71459206F7
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 16:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEIEMdVE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgDIQjM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 12:39:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55731 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgDIQjM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 12:39:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id e26so410506wmk.5
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Apr 2020 09:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bM7WRPD+QGir0mtxlsjrVuuGaoWc4lhJHa7Ns68K5qM=;
        b=dEIEMdVEtSb2tgPojS5MbfjDQLUzggoJR+uDr7kpY/DbJs+yURh7SafEg3SoXYh70c
         qlu8QHx6TMee0brW/zMbxPHMc0YqQZj2UZOnG/PvA/ZrBn4P2t1rIuUiZHgI5bPeX304
         nWtZXYO7i1nQM4R+zMssMLYXYSxo1TNhd5NXKFGx8UKubWrqf9tng5fYfbxDH8Y2vz2d
         232g3bosMr6LiJmR4MBkVFIqYRIG12jD7Ki1X4Qo4HJvipnyL9sZaCJ4mCy79Uq2R24P
         /7yARvHIAjSf1k6CXIyzh3HBbobomRnhzUvbYgADfZZ/toRCsP/tkHS1IYiNt7R1Cds8
         98ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bM7WRPD+QGir0mtxlsjrVuuGaoWc4lhJHa7Ns68K5qM=;
        b=JnLS8JKvTjb33AsMlu3kCyKc0UDButZOil9VR2G1NNG3g7rq6pzxKJz75jNWlD3has
         ZuDSgvQPJ6gX7ojGw8daL0oRTqdoaP+dGbLGBz2Mm7Im5gCzixyGKLKEa+xJlclrXzAM
         PaSkgp6tXKzJ8xz5MqQsnfy0teuL/iZibWSs3N/1U5Kq13P7bWlyKuLl6CryfAF9Mzsh
         Kyv3oayKTu8SHu28BfTMAQidrUPP7xch8kz+FltaeYb1pAUvbA7QHJuSstEu1IhuQPUp
         2rYvbERdl+Sj/5a+jDV7QZQjE4t5Rnlfb+7zpifmb0orWP9/Yr4/x/uObzJa4VswHpid
         DwRg==
X-Gm-Message-State: AGi0PuaNRqDxnZ6lV3GOBnZysixFOJreAT4zY9QMHvkjvI/+mh09t7is
        x1UtVDhWKYpyv18aZGerjfGDPUPw
X-Google-Smtp-Source: APiQypJV09Ay7t1+1IEy4a8nW2vnislVtmGCZ2oCwgLHSvORX2UjZ4ADC+oHV/yMdaoAVlAMPrr9Zw==
X-Received: by 2002:a1c:2705:: with SMTP id n5mr712961wmn.94.1586450350159;
        Thu, 09 Apr 2020 09:39:10 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id q143sm2359845wme.31.2020.04.09.09.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 09:39:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: resolve more conflicting mount options
Date:   Thu,  9 Apr 2020 19:39:02 +0300
Message-Id: <20200409163902.11404-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Similar to the way that a conflict between metacopy=on,redirect_dir=off
is resolved, also resolve conflicts between nfs_export=on,index=off and
nfs_export=on,metacopy=on.

An explicit mount option wins over a default config value.
Both explicit mount options result in an error.

Without this change the xfstests group overlay/exportfs are skipped if
metacopy is enabled by default.

Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst |  7 ++--
 fs/overlayfs/super.c                    | 48 +++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index c9d2bf96b02d..660dbaf0b9b8 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -365,8 +365,8 @@ pointed by REDIRECT. This should not be possible on local system as setting
 "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
 for untrusted layers like from a pen drive.
 
-Note: redirect_dir={off|nofollow|follow[*]} conflicts with metacopy=on, and
-results in an error.
+Note: redirect_dir={off|nofollow|follow[*]} and nfs_export=on mount options
+conflict with metacopy=on, and will result in an error.
 
 [*] redirect_dir=follow only conflicts with metacopy=on if upperdir=... is
 given.
@@ -560,6 +560,9 @@ When the NFS export feature is enabled, all directory index entries are
 verified on mount time to check that upper file handles are not stale.
 This verification may cause significant overhead in some cases.
 
+Note: the mount options index=off,nfs_export=on are conflicting and will
+result in an error.
+
 
 Testsuite
 ---------
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 732ad5495c92..fbd6207acdbf 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -470,6 +470,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 	char *p;
 	int err;
 	bool metacopy_opt = false, redirect_opt = false;
+	bool nfs_export_opt = false, index_opt = false;
 
 	config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
 	if (!config->redirect_mode)
@@ -519,18 +520,22 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 		case OPT_INDEX_ON:
 			config->index = true;
+			index_opt = true;
 			break;
 
 		case OPT_INDEX_OFF:
 			config->index = false;
+			index_opt = true;
 			break;
 
 		case OPT_NFS_EXPORT_ON:
 			config->nfs_export = true;
+			nfs_export_opt = true;
 			break;
 
 		case OPT_NFS_EXPORT_OFF:
 			config->nfs_export = false;
+			nfs_export_opt = true;
 			break;
 
 		case OPT_XINO_ON:
@@ -552,6 +557,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 		case OPT_METACOPY_OFF:
 			config->metacopy = false;
+			metacopy_opt = true;
 			break;
 
 		default:
@@ -601,6 +607,48 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		}
 	}
 
+	/* Resolve nfs_export -> index dependency */
+	if (config->nfs_export && !config->index) {
+		if (nfs_export_opt && index_opt) {
+			pr_err("conflicting options: nfs_export=on,index=off\n");
+			return -EINVAL;
+		}
+		if (index_opt) {
+			/*
+			 * There was an explicit index=off that resulted
+			 * in this conflict.
+			 */
+			pr_info("disabling nfs_export due to index=off\n");
+			config->nfs_export = false;
+		} else {
+			/* Automatically enable index otherwise. */
+			config->index = true;
+		}
+	}
+
+	/* Resolve nfs_export -> !metacopy dependency */
+	if (config->nfs_export && config->metacopy) {
+		if (nfs_export_opt && metacopy_opt) {
+			pr_err("conflicting options: nfs_export=on,metacopy=on\n");
+			return -EINVAL;
+		}
+		if (metacopy_opt) {
+			/*
+			 * There was an explicit metacopy=on that resulted
+			 * in this conflict.
+			 */
+			pr_info("disabling nfs_export due to metacopy=on\n");
+			config->nfs_export = false;
+		} else {
+			/*
+			 * There was an explicit nfs_export=on that resulted
+			 * in this conflict.
+			 */
+			pr_info("disabling metacopy due to nfs_export=on\n");
+			config->metacopy = false;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.17.1

