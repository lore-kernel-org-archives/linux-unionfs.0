Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37438 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752872AbeDZTKk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 22/31] ovl: Do not set dentry type ORIGIN for broken hardlinks
Date: Thu, 26 Apr 2018 15:10:04 -0400
Message-Id: <20180426191013.13219-23-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

If a dentry has copy up origin, we set flag OVL_PATH_ORIGIN. So far
this decision was easy that we had to check only for oe->numlower
and if it is non-zero, we knew there is copy up origin. (For non-dir
we installed origin dentry in lowerstack[0]).

But we don't create ORGIN xattr for broken hardlinks (index=off). And
with metacopy feature it is possible that we will install lowerstack[0]
but ORIGIN xattr is not there. It is data dentry of upper metacopy dentry
which has been found using regular name based lookup or using REDIRECT.
So with addition of this new case, just presence of oe->numlower is
not sufficient to guarantee that ORIGIN xattr is present.

So two differentiate between two cases, look at OVL_CONST_INO flag. If
this flag is set and upperdentry is there, that means ORIGIN xattr
must be present. OVL_CONST_INO is not set if lower hardlink is broken
or will be broken over copy up.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f85ff5714852..69acce1c9026 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -133,7 +133,8 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 		 * Non-dir dentry can hold lower dentry of its copy up origin.
 		 */
 		if (oe->numlower) {
-			type |= __OVL_PATH_ORIGIN;
+			if (ovl_test_flag(OVL_CONST_INO, d_inode(dentry)))
+				type |= __OVL_PATH_ORIGIN;
 			if (d_is_dir(dentry) ||
 			    !ovl_has_upperdata(d_inode(dentry)))
 				type |= __OVL_PATH_MERGE;
-- 
2.13.6

