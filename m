Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751896AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 20/28] ovl: Do not set dentry type ORIGIN for broken hardlinks
Date: Thu, 29 Mar 2018 15:38:46 -0400
Message-Id: <20180329193854.13814-21-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

If a dentry has copy up origin, we set flag OVL_PATH_ORIGIN. So far
this decision was easy that we had to check only for oe->numlower
and if it is non-zero, we knew there is copy up origin. (For non-dir
we installed origin dentry in lowerstack[0]).

But we don't create ORGIN xattr for broken hardlinks (index=off). And
with metacopy feature it is possible that we will still install
lowerstack[0]. But that's lower data dentry of metacopy upper of broken
hardlink and not ORIGIN XATTR is not set.

So two differentiate between two cases, do not set OVL_PATH_ORIGIN if
we have a broken hardlink.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/util.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 29f7336ade88..961d65bd25c9 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -117,7 +117,14 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 		 * Non-dir dentry can hold lower dentry of its copy up origin.
 		 */
 		if (oe->numlower) {
-			type |= __OVL_PATH_ORIGIN;
+			/*
+			 * ORIGIN is created for everyting except broken
+			 * hardlinks
+			 */
+			if (!(d_inode(dentry)->i_nlink > 1 &&
+			    !ovl_test_flag(OVL_INDEX, d_inode(dentry))))
+				type |= __OVL_PATH_ORIGIN;
+
 			if (d_is_dir(dentry) || !ovl_has_upperdata(dentry))
 				type |= __OVL_PATH_MERGE;
 		}
-- 
2.13.6

