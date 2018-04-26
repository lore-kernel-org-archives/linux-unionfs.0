Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753205AbeDZTKl (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 18/31] ovl: Move some dir related ovl_lookup_single() code in else block
Date: Thu, 26 Apr 2018 15:10:00 -0400
Message-Id: <20180426191013.13219-19-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Move some directory related code in else block. This is pure code
reorganization and no functionality change.

Next patch enables redirect processing on metacopy files and needs this
change.  By keeping non-functional changes in a separate patch, next patch
looks much smaller and cleaner.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b25e32cf5916..880c7faea41a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -269,22 +269,23 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		d->stop = !err;
 		d->metacopy = !!err;
 		goto out;
-	}
-	if (last_element) {
-		if (d->metacopy) {
-			err = -ESTALE;
-			goto out_err;
+	} else {
+		if (last_element) {
+			if (d->metacopy) {
+				err = -ESTALE;
+				goto out_err;
+			}
+			d->is_dir = true;
 		}
-		d->is_dir = true;
-	}
-	if (d->last)
-		goto out;
+		if (d->last)
+			goto out;
 
-	if (ovl_is_opaquedir(this)) {
-		d->stop = true;
-		if (last_element)
-			d->opaque = true;
-		goto out;
+		if (ovl_is_opaquedir(this)) {
+			d->stop = true;
+			if (last_element)
+				d->opaque = true;
+			goto out;
+		}
 	}
 	err = ovl_check_redirect(this, d, prelen, post);
 	if (err)
-- 
2.13.6

