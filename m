Return-Path: <SRS0=SU5x=77=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DD4C433E1
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Jun 2020 01:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0103A21924
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Jun 2020 01:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592445424;
	bh=QgJqeKVZ+fjCXw8+dUiiojzmxkkV0/sy5VDLp1bn+Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hAI3l+M+GjVtaBDzHodKXaTdKQJhqkubrs4DNzne7IVz2gXh52DvcuGiOeGA764Dw
	 M2CPBVo7fAdSzpYzIvCd0E0ezoc8KHqF+Kyo587Vp4oQCd3v0CfUGTrArCJ6nU+9oH
	 GcFfx6kWHK0cMzUaBf3mtWpP9aNXOkEgvShLO888=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbgFRBZP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731381AbgFRBZO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFEEC21D80;
        Thu, 18 Jun 2020 01:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443514;
        bh=QgJqeKVZ+fjCXw8+dUiiojzmxkkV0/sy5VDLp1bn+Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t21GHi9/J5gRnmGqOd7HQHQGAkBuL9m4SVGj31NA/Qg0C/46xlTb4P3u8T4k/PI+I
         TWHv7OYskbfcbkFg9frzz2ZkUbJ5HG/2Y2M485KuS9HVWh9ytlCdyOamUYwaF7R+zP
         4qb6fu7yBpOYbD98XCcRVtXlN6ov86nubsw1F/qk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 138/172] ovl: verify permissions in ovl_path_open()
Date:   Wed, 17 Jun 2020 21:21:44 -0400
Message-Id: <20200618012218.607130-138-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 56230d956739b9cb1cbde439d76227d77979a04d ]

Check permission before opening a real file.

ovl_path_open() is used by readdir and copy-up routines.

ovl_permission() theoretically already checked copy up permissions, but it
doesn't hurt to re-do these checks during the actual copy-up.

For directory reading ovl_permission() only checks access to topmost
underlying layer.  Readdir on a merged directory accesses layers below the
topmost one as well.  Permission wasn't checked for these layers.

Note: modifying ovl_permission() to perform this check would be far more
complex and hence more bug prone.  The result is less precise permissions
returned in access(2).  If this turns out to be an issue, we can revisit
this bug.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/util.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index db8bdb29b320..afbc6a97da2a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -479,7 +479,32 @@ bool ovl_is_whiteout(struct dentry *dentry)
 
 struct file *ovl_path_open(struct path *path, int flags)
 {
-	return dentry_open(path, flags | O_NOATIME, current_cred());
+	struct inode *inode = d_inode(path->dentry);
+	int err, acc_mode;
+
+	if (flags & ~(O_ACCMODE | O_LARGEFILE))
+		BUG();
+
+	switch (flags & O_ACCMODE) {
+	case O_RDONLY:
+		acc_mode = MAY_READ;
+		break;
+	case O_WRONLY:
+		acc_mode = MAY_WRITE;
+		break;
+	default:
+		BUG();
+	}
+
+	err = inode_permission(inode, acc_mode | MAY_OPEN);
+	if (err)
+		return ERR_PTR(err);
+
+	/* O_NOATIME is an optimization, don't fail if not permitted */
+	if (inode_owner_or_capable(inode))
+		flags |= O_NOATIME;
+
+	return dentry_open(path, flags, current_cred());
 }
 
 /* Caller should hold ovl_inode->lock */
-- 
2.25.1

