Return-Path: <SRS0=Ny/S=6C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 650E5C38A2F
	for <linux-unionfs@archiver.kernel.org>; Sat, 18 Apr 2020 14:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 384EA20753
	for <linux-unionfs@archiver.kernel.org>; Sat, 18 Apr 2020 14:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587221516;
	bh=h1ql2/BDJX9O8+6Tedw2yO7TNwFdReVLH5QvEUZ2310=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pR4nKOr6V9OBeTxOrjIh66Dl2qXC05aIwQnnfbD4ZFr3wltOpEzKimKQaR1H8OQ82
	 21bkGZnwwdx19GBlBKJawmixPNpv8ImAlpYeEP47aHmR5k4N92GmKu76eE/ksCDYn0
	 vwz92xEL37hnez3FHk0TksUET0WwgCEtqSesM72A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgDROmd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 18 Apr 2020 10:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgDROmc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Apr 2020 10:42:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 001EA21974;
        Sat, 18 Apr 2020 14:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220951;
        bh=h1ql2/BDJX9O8+6Tedw2yO7TNwFdReVLH5QvEUZ2310=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0D09pC0ksr5pGwEU5i8SFNGFzlhM1CD9FYO39ylBpKpPs19OHudU3MT71v0DM/0z
         mNWXuIIWAmYblMKyOMGyvpyHwKSvnBc1ksATn9DdlczcbHXMgvNdmzhj9NVAxnXGCu
         gZGWLHpmytmNwzV48wF009+fk6tsIKqg+ZuXoraM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/47] ovl: fix value of i_ino for lower hardlink corner case
Date:   Sat, 18 Apr 2020 10:41:43 -0400
Message-Id: <20200418144227.9802-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144227.9802-1-sashal@kernel.org>
References: <20200418144227.9802-1-sashal@kernel.org>
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
index a138bb3bc2a5d..8b3c284ce92ea 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -884,7 +884,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
 					oip->index);
-	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
+	int fsid = bylower ? lowerpath->layer->fsid : 0;
 	bool is_dir, metacopy = false;
 	unsigned long ino = 0;
 	int err = oip->newinode ? -EEXIST : -ENOMEM;
@@ -934,6 +934,8 @@ struct inode *ovl_get_inode(struct super_block *sb,
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

