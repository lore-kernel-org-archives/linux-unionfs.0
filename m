From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] overlayfs: Warn instead of error if d_type is not supported
Date: Fri, 1 Jul 2016 10:02:44 -0400
Message-ID: <20160701140244.GG32616@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbcGAOCp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 1 Jul 2016 10:02:45 -0400
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

overlay needs underlying fs to support d_type. Recently I put in a
patch in to detect this condition and started failing mount if
underlying fs did not support d_type.

45aebea ovl: Ensure upper filesystem supports d_type

But this breaks existing configurations over kernel upgrade. Those who
are running docker (partially broken configuration) with xfs not
supporting d_type, are surprised that after kernel upgrade docker does
not run anymore.

https://github.com/docker/docker/issues/22937#issuecomment-229881315

So instead of erroring out, detect broken configuration and warn
about it. This should allow existing docker setups to continue
working after kernel upgrade.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/super.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: rhvgoyal-linux/fs/overlayfs/super.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/super.c	2016-07-01 09:25:48.642807088 -0400
+++ rhvgoyal-linux/fs/overlayfs/super.c	2016-07-01 09:31:58.194807088 -0400
@@ -1082,11 +1082,13 @@ static int ovl_fill_super(struct super_b
 			if (err < 0)
 				goto out_put_workdir;
 
-			if (!err) {
-				pr_err("overlayfs: upper fs needs to support d_type.\n");
-				err = -EINVAL;
-				goto out_put_workdir;
-			}
+			/*
+			 * We allowed this configuration and don't want to
+			 * break users over kernel upgrade. So warn instead
+			 * of erroring out.
+			 */
+			if (!err)
+				pr_warn("overlayfs: upper fs needs to support d_type.\n");
 		}
 	}
 
