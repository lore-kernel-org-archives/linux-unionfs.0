Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7D1C433DB
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Feb 2021 18:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A864864EB6
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Feb 2021 18:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhBHSAj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 13:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235126AbhBHR7o (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Feb 2021 12:59:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33CA864EAC;
        Mon,  8 Feb 2021 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807102;
        bh=isb9zgb2+0gn6NjrTFPIALuDXciAPnGUWAd1SuK9L/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3SbzwAQk0cULUxSxIoe/ZWNX7UJqO3mcAgO5eV1eWXe/+5Br4+rbx7xuZsRXLK5N
         33UYlMrXfYQQ++qvXbk33qK6QRKz8rVEitZ/OCQp2VM1u1xbWR+sBOVYhSFiMiGbdV
         Dq4p1qkrhKY5u4IsVTRqvaKw6sLeALNna4OIJK7vQmAqYQSA6HcON0Z5fcS1mP+ImI
         bRrAPgHbD0OP07Fw9O9+GeW8cq0+d/vPWpaAt2mhZczKBTN+5W3zr05DrnTL2rklGP
         lTRlOQWeLJFVysvzqwdwkZwFRHqcv33ejuGc0Za9uM0Xg+rTGsh7eXwVnlIFdZ/fqT
         7oA1E0wnl22Ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/36] ovl: perform vfs_getxattr() with mounter creds
Date:   Mon,  8 Feb 2021 12:57:41 -0500
Message-Id: <20210208175806.2091668-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 554677b97257b0b69378bd74e521edb7e94769ff ]

The vfs_getxattr() in ovl_xattr_set() is used to check whether an xattr
exist on a lower layer file that is to be removed.  If the xattr does not
exist, then no need to copy up the file.

This call of vfs_getxattr() wasn't wrapped in credential override, and this
is probably okay.  But for consitency wrap this instance as well.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b584dca845baa..4fadafd8bdc12 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -346,7 +346,9 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 		goto out;
 
 	if (!value && !upperdentry) {
+		old_cred = ovl_override_creds(dentry->d_sb);
 		err = vfs_getxattr(realdentry, name, NULL, 0);
+		revert_creds(old_cred);
 		if (err < 0)
 			goto out_drop_write;
 	}
-- 
2.27.0

