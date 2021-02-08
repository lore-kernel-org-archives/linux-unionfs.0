Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B4EC433E6
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Feb 2021 18:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C625464DE1
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Feb 2021 18:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhBHSFj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 13:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234926AbhBHSDe (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6976C64EF2;
        Mon,  8 Feb 2021 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807172;
        bh=YBqvqgp6PAHx6W9ojsyrbRpMv8DrvI2KfiN7xQINXmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6ItKUIdNGgapgdPffoxZZLmmChivL6y043UKuL9zWvmNjFXRe0lne6mG5gPRuYWV
         VWjTCydJEF57ZQ0qXUvU9lU9DMIy/EkXhUxx63YkLfsgWN/W8YyDoiFoA/PcLzhkOM
         AxcPux4A0xFXelbwI67lAlBsS8bBOhfgN35Nf71Ogyq0P74RfvxMVt/gNsr97ttGwu
         ObmU4wLazby8BhfwQXfLHVqLpN9XE3yrXcs3dSAgngd9XQqdwqanPhdn6J2O0ngnsd
         jrdk+Q+m23lmhQ8ATu0BD4ExIZU/hhDdLp5sQ6veTyzPo03MRXzNqkllj+IiTThjqZ
         GxBVm97Q32EGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/14] ovl: perform vfs_getxattr() with mounter creds
Date:   Mon,  8 Feb 2021 12:59:16 -0500
Message-Id: <20210208175926.2092211-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175926.2092211-1-sashal@kernel.org>
References: <20210208175926.2092211-1-sashal@kernel.org>
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
index 8b3c284ce92ea..08e60a6df77c3 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -340,7 +340,9 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
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

