From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 06/15] ovl: pass the stack index on ovl_lookup_data
Date: Mon,  1 May 2017 16:41:57 +0300
Message-ID: <1493646126-10101-7-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35561 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035208AbdEANmJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:09 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

This is needed for looking up copy up origin.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 7c2b038..6fabbc1 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -21,6 +21,7 @@ struct ovl_lookup_data {
 	bool opaque;
 	bool stop;
 	bool last;
+	int idx;
 	char *redirect;
 };
 
@@ -258,6 +259,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.opaque = false,
 		.stop = false,
 		.last = !poe->numlower,
+		.idx = 0,
 		.redirect = NULL,
 	};
 
@@ -299,6 +301,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		struct path lowerpath = poe->lowerstack[i];
 
 		d.last = i == poe->numlower - 1;
+		d.idx = i + 1;
 		err = ovl_lookup_layer(lowerpath.dentry, &d, &this);
 		if (err)
 			goto out_put;
-- 
2.7.4
