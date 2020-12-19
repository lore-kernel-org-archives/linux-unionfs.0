Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FD6C4361B
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Dec 2020 10:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7738023B7B
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Dec 2020 10:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgLSKQx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 19 Dec 2020 05:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgLSKQw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 19 Dec 2020 05:16:52 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9ECC0617B0
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Dec 2020 02:16:12 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id j22so6758434eja.13
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Dec 2020 02:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WYsqJHVZvZL3RfY5aJVFmwP6AnI1Pl2+6urVhS/3VYw=;
        b=PpBp9s33PbkPaxJfDxmadtnCsnkEIiA7hNZyQqVqQnMRiWLA5hHsHkQ+81KJji3XA2
         7lZBAwb1ck5GixoTmd59Z1m7o7oybv+ERt/hnZXNqcPCS950dqykk1v/RgdC9u1LsPLY
         1Y9TR7BKNps9DaFLn31jZmbpmj1X9pVbyGNgbEmngT8Rz/9FD2dahkMuI7z26pvOUYCb
         9oM7H30aRqEcVYJC0Rj6ya/OiDsf95KnK81B/88wBq9OHAO21WNfkv8eVjTyktiXxSl9
         x2D2hEEA9GGJDW+06657a+tRTJUE2jDRYPUoVBSsl9azwzwNQWf5jhwmw8JFPsrSzE7r
         IcEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WYsqJHVZvZL3RfY5aJVFmwP6AnI1Pl2+6urVhS/3VYw=;
        b=X77U95NTMEpgOr8cKoe9D14AkGtpR2KEFVUhG4mshQrO3sYdwpvtCgJ0ZFpheaj//B
         nb537jAgO2FR/36/cprCvyCqkb1kz9DSrV6Z/EFEl1IJWH2VGVH6k1B/nBfGK+MyJPoY
         cPH3C0ly8ZFVN4n9x/XcM+ussOnUP63cU9KaRmdjpjaRjBFAOqT6SS486oTgEEATwvt+
         EUgfFIRBR3Mcyi/itmKPymktDnOq1R7e0ivzXhWhzJZYfpnkEAmYQCqoueQapMRItxr4
         y4wL307dSDezPUNSrInCSSy2qQvPV9bd4O9R89yIw478Suq+mc5cJguFUfda1B1PdJTe
         gJtw==
X-Gm-Message-State: AOAM5328itnBQuUoWFaZp68wWkZx32zdcdvTSHqIZCiE0aVXBJ6ydlu5
        dEGvfvdHALK5IQwhEjUGI/Z2jspUMqM=
X-Google-Smtp-Source: ABdhPJwloubIu6cGTb4R5UJrWLH9HFZiCUziwqQpIT6YSjZiYqT/qBwrNUZ+EE9yx/rPBapjNsnY+g==
X-Received: by 2002:a17:906:4f8d:: with SMTP id o13mr7978625eju.117.1608372970624;
        Sat, 19 Dec 2020 02:16:10 -0800 (PST)
Received: from localhost.localdomain ([31.210.181.203])
        by smtp.gmail.com with ESMTPSA id oq27sm6412778ejb.108.2020.12.19.02.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 02:16:09 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org,
        Michael Labriola <michael.d.labriola@gmail.com>
Subject: [PATCH] ovl: skip getxattr of security labels
Date:   Sat, 19 Dec 2020 12:16:08 +0200
Message-Id: <20201219101608.16535-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When inode has no listxattr op of its own (e.g. squashfs) vfs_listxattr
calls the LSM inode_listsecurity hooks to list the xattrs that LSMs will
intercept in inode_getxattr hooks.

When selinux LSM is installed but not initialized, it will list the
security.selinux xattr in inode_listsecurity, but will not intercept it
in inode_getxattr.  This results in -ENODATA for a getxattr call for an
xattr returned by listxattr.

This situation was manifested as overlayfs failure to copy up lower
files from squashfs when selinux is built-in but not initialized,
because ovl_copy_xattr() iterates the lower inode xattrs by
vfs_listxattr() and vfs_getxattr().

ovl_copy_xattr() skips copy up of security labels that are indentified by
inode_copy_up_xattr LSM hooks, but it does that after vfs_getxattr().
Since we are not going to copy them, skip vfs_getxattr() of the security
labels.

Reported-by: Michael Labriola <michael.d.labriola@gmail.com>
Tested-by: Michael Labriola <michael.d.labriola@gmail.com>
Link: https://lore.kernel.org/linux-unionfs/2nv9d47zt7.fsf@aldarion.sourceruckus.org/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This is a workaround for a v5.9 selinux related regression reported by
Michael that caused copy up failure is a very specific configuration
involving lower squashfs and built-in but disabled selinux.

I've sent the bug fix to selinux list, so this patch is complementary.
I removed the stable/Fixes tags, because this patch does not cleanly
apply to v5.9 and is not the real bug fix.

Thanks,
Amir.

 fs/overlayfs/copy_up.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e5b616c93e11..0fed532efa68 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -84,6 +84,14 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 
 		if (ovl_is_private_xattr(sb, name))
 			continue;
+
+		error = security_inode_copy_up_xattr(name);
+		if (error < 0 && error != -EOPNOTSUPP)
+			break;
+		if (error == 1) {
+			error = 0;
+			continue; /* Discard */
+		}
 retry:
 		size = vfs_getxattr(old, name, value, value_size);
 		if (size == -ERANGE)
@@ -107,13 +115,6 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 			goto retry;
 		}
 
-		error = security_inode_copy_up_xattr(name);
-		if (error < 0 && error != -EOPNOTSUPP)
-			break;
-		if (error == 1) {
-			error = 0;
-			continue; /* Discard */
-		}
 		error = vfs_setxattr(new, name, value, size, 0);
 		if (error) {
 			if (error != -EOPNOTSUPP || ovl_must_copy_xattr(name))
-- 
2.25.1

