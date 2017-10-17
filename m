From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 13/14] ovl: wire up NFS export support
Date: Tue, 17 Oct 2017 19:44:30 +0300
Message-ID: <1508258671-10800-14-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:44337 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937029AbdJQQoP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:44:15 -0400
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Currently, overlayfs file handles decoding is guarantied to
work if all the following conditions are met:
 1. All underlying layers support file handles
 2. All lower files and directories are indexed on copy up (index=all)
 3. A merge directory lower dir must match copy up origin (verify_dir)
 4. A merge directory is limited to single lower layer

With all conditions met, enable NFS export support.

All but the first condition can be relaxed in the future with
some extra work.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 3c98991eebcd..36d6ed20d496 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1124,6 +1124,27 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 
+	/*
+	 * NFS export requires that all layers support file handles and
+	 * that all files and dirs are indexed on copy up (index=all).
+	 * We check that all layers support file handles for enabling index.
+	 *
+	 * A directory index has all the information to instantiate the
+	 * encoded overlay directory dentry IFF a merge directory is limited
+	 * to a single lower dir and the lower dir matches the copy up origin
+	 * stored in upper dir (verify_dir).
+	 *
+	 * XXX: index=all can be relaxed by indexing on rename and looking
+	 *      up non-indexed overlay dentries by lower dentry path.
+	 *      verify_dir can be relaxed by updating index when mismatch
+	 *      lower merge dir is found and update index generation.
+	 *      single lower layer can be relaxed by looking up overlay
+	 *      directory dentries by lower or upper dentry path.
+	 */
+	if (ufs->config.index == OVL_INDEX_ALL &&
+	    ufs->config.verify_dir && ufs->numlower == 1)
+		sb->s_export_op = &ovl_export_operations;
+
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
 	else
-- 
2.7.4
