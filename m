Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754035AbeCFUyR (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Mar 2018 15:54:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v12 13/17] ovl: Check redirects for metacopy files
Date: Tue,  6 Mar 2018 15:54:04 -0500
Message-Id: <20180306205408.23383-14-vgoyal@redhat.com>
In-Reply-To: <20180306205408.23383-1-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
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
 fs/overlayfs/namei.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 220e754c974b..a4a5c5f5540d 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -265,22 +265,22 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto put_and_out;
 	}
 	if (!d_can_lookup(this)) {
-		if (d->is_dir)
-			goto put_and_out;
+		d->is_dir = false;
 		err = ovl_check_metacopy_xattr(this);
 		if (err < 0)
 			goto out_err;
 		if (!err) {
 			d->stop = true;
 			d->metacopy = false;
+			goto out;
 		} else
 			d->metacopy = true;
-		goto out;
-	}
-	d->is_dir = true;
-	if (!d->last && ovl_is_opaquedir(this)) {
-		d->stop = d->opaque = true;
-		goto out;
+	} else {
+		d->is_dir = true;
+		if (!d->last && ovl_is_opaquedir(this)) {
+			d->stop = d->opaque = true;
+			goto out;
+		}
 	}
 	err = ovl_check_redirect(this, d, prelen, post);
 	if (err)
@@ -868,7 +868,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 		if (upperdentry && !d.is_dir) {
 			unsigned int origin_ctr = 0;
-			BUG_ON(d.redirect);
 			/*
 			 * Lookup copy up origin by decoding origin file handle.
 			 * We may get a disconnected dentry, which is fine,
-- 
2.13.6

