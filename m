Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751941AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 18/28] ovl: Check redirects for metacopy files
Date: Thu, 29 Mar 2018 15:38:44 -0400
Message-Id: <20180329193854.13814-19-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Right now we rely on path based lookup for data origin of metacopy upper.
This will work only if upper has not been renamed. We solved this problem
already for merged directories using redirect. Use same logic for metacopy
files.

This patch just goes on to check redirects for metacopy files.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1dba89e9543f..a7a9588f64b7 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -260,18 +260,19 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			goto out_err;
 		d->stop = !err;
 		d->metacopy = !!err;
-		goto out;
-	}
-	if (last_element)
-		d->is_dir = true;
-	if (d->last)
-		goto out;
-
-	if (ovl_is_opaquedir(this)) {
-		d->stop = true;
+		if (!d->metacopy)
+			goto out;
+	} else {
 		if (last_element)
-			d->opaque = true;
-		goto out;
+			d->is_dir = true;
+		if (d->last)
+			goto out;
+		if (ovl_is_opaquedir(this)) {
+			d->stop = true;
+			if (last_element)
+				d->opaque = true;
+			goto out;
+		}
 	}
 	err = ovl_check_redirect(this, d, prelen, post);
 	if (err)
@@ -859,7 +860,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 		if (upperdentry && !d.is_dir) {
 			unsigned int origin_ctr = 0;
-			BUG_ON(d.redirect);
 			/*
 			 * Lookup copy up origin by decoding origin file handle.
 			 * We may get a disconnected dentry, which is fine,
-- 
2.13.6

