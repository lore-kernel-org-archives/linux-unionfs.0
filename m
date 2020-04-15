Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EA5C2BA19
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45889206D5
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586955311;
	bh=eOjHPZ2hM8yY0lMQEmFgXJ6RCmnDAUY8hOw/b5roVIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kklsqYEh6Dz9h0uO5PRMIEJSv/Og2cKxpXT8qXy/khXXLsyg7IU9Q3vru9xXoIke8
	 ITYMc/bKF0gibY2e5OD/7+du8saPvoOP54Sm3wVW21LKdkR4gbe6ZVmEQtPM3MyWli
	 E2kz1o4WanyNzxnDkvOMSyZ/mLZhctHZAJZyk/rI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441304AbgDOMzH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897207AbgDOLhG (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 07:37:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A50214AF;
        Wed, 15 Apr 2020 11:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950626;
        bh=eOjHPZ2hM8yY0lMQEmFgXJ6RCmnDAUY8hOw/b5roVIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFKRXdbidmVfYJiFlIgYZFZXJzwme/vKCZUUf2mVV6vuDPoQDwmWgF4IydPsaTnTx
         f/lb7Y/b/wje1BNWzPe6ns/Bok/WJQeyxIF1EOe/mkF8MjuzRTm72mpvQCAq1O7VLg
         1jQMb2Wfxq0Y50Mz0ollNxfCD2X7BBs2/68dkJfo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 117/129] ovl: fix value of i_ino for lower hardlink corner case
Date:   Wed, 15 Apr 2020 07:34:32 -0400
Message-Id: <20200415113445.11881-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 300b124fcf6ad2cd99a7b721e0f096785e0a3134 ]

Commit 6dde1e42f497 ("ovl: make i_ino consistent with st_ino in more
cases"), relaxed the condition nfs_export=on in order to set the value of
i_ino to xino map of real ino.

Specifically, it also relaxed the pre-condition that index=on for
consistent i_ino. This opened the corner case of lower hardlink in
ovl_get_inode(), which calls ovl_fill_inode() with ino=0 and then
ovl_init_inode() is called to set i_ino to lower real ino without the xino
mapping.

Pass the correct values of ino;fsid in this case to ovl_fill_inode(), so it
can initialize i_ino correctly.

Fixes: 6dde1e42f497 ("ovl: make i_ino consistent with st_ino in more ...")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 79e8994e3bc1a..3f993c114829e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -891,7 +891,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
 					oip->index);
-	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
+	int fsid = bylower ? lowerpath->layer->fsid : 0;
 	bool is_dir, metacopy = false;
 	unsigned long ino = 0;
 	int err = oip->newinode ? -EEXIST : -ENOMEM;
@@ -941,6 +941,8 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			err = -ENOMEM;
 			goto out_err;
 		}
+		ino = realinode->i_ino;
+		fsid = lowerpath->layer->fsid;
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
 	ovl_inode_init(inode, upperdentry, lowerdentry, oip->lowerdata);
-- 
2.20.1

