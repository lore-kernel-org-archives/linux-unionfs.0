From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 03/15] ovl: use an auxiliary var for overlay root entry
Date: Mon,  1 May 2017 16:41:54 +0300
Message-ID: <1493646126-10101-4-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35528 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162464AbdEANmE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:04 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b8b0778..d0a3e4a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -220,6 +220,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	const struct cred *old_cred;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
+	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
 	struct path *stack = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	unsigned int ctr = 0;
@@ -259,7 +260,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			if (!upperredirect)
 				goto out_put_upper;
 			if (d.redirect[0] == '/')
-				poe = dentry->d_sb->s_root->d_fsdata;
+				poe = roe;
 		}
 		upperopaque = d.opaque;
 	}
@@ -290,10 +291,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (d.stop)
 			break;
 
-		if (d.redirect &&
-		    d.redirect[0] == '/' &&
-		    poe != dentry->d_sb->s_root->d_fsdata) {
-			poe = dentry->d_sb->s_root->d_fsdata;
+		if (d.redirect && d.redirect[0] == '/' && poe != roe) {
+			poe = roe;
 
 			/* Find the current layer on the root dentry */
 			for (i = 0; i < poe->numlower; i++)
-- 
2.7.4
