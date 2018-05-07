Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752494AbeEGRlM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 13:41:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 18/30] ovl: Do not expose metacopy only dentry from d_real()
Date: Mon,  7 May 2018 13:40:50 -0400
Message-Id: <20180507174102.24086-19-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Metacopy dentry/inode is internal to overlay and is never exposed
outside of it. Modify d_real() to look for only dentries/inode which
have data and which are not metacopy.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ce90b6e3ce76..c97b5abda954 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -101,10 +101,11 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	}
 
 	real = ovl_dentry_upper(dentry);
-	if (real && (!inode || inode == d_inode(real)))
+	if (real && ovl_has_upperdata(d_inode(dentry)) &&
+	    (!inode || inode == d_inode(real)))
 		return real;
 
-	real = ovl_dentry_lower(dentry);
+	real = ovl_dentry_lowerdata(dentry);
 	if (!real)
 		goto bug;
 
-- 
2.13.6

