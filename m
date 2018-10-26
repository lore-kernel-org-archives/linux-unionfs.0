Return-Path: <vgoyal@redhat.com>
Date: Fri, 26 Oct 2018 09:43:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] overlayfs: Return error if metadata only copy-up can't be
 enabled
Message-ID: <20181026134333.GB17321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Daniel J Walsh <dwalsh@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

Assume a user wanted to enable metadata only copy-up and passes metacopy=on.
If this feature can't be enabled, we disable metacopy=off and just leave
a warning in logs. metacopy=on requires redirect_dir=on (for upper dir)
or redirect_dir=follow (for non-upper mount).

As user does not see mount failure, he/she assumes metadata only copy-up
has been enabled but that's not the case.

So instead of disabling metacopy, return an error to user and leave a
message in logs. That will allow user to fix mount options and retry.

Reported-by: Daniel Walsh <dwalsh@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: rhvgoyal-linux/fs/overlayfs/super.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/super.c	2018-10-26 09:07:46.474353806 -0400
+++ rhvgoyal-linux/fs/overlayfs/super.c	2018-10-26 09:28:23.195422393 -0400
@@ -574,11 +574,11 @@ static int ovl_parse_opt(char *opt, stru
 
 	/* metacopy feature with upper requires redirect_dir=on */
 	if (config->upperdir && config->metacopy && !config->redirect_dir) {
-		pr_warn("overlayfs: metadata only copy up requires \"redirect_dir=on\", falling back to metacopy=off.\n");
-		config->metacopy = false;
+		pr_err("overlayfs: metadata only copy up requires \"redirect_dir=on\".\n");
+		return -EINVAL;
 	} else if (config->metacopy && !config->redirect_follow) {
-		pr_warn("overlayfs: metadata only copy up requires \"redirect_dir=follow\" on non-upper mount, falling back to metacopy=off.\n");
-		config->metacopy = false;
+		pr_err("overlayfs: metadata only copy up requires either \"redirect_dir=follow\" or \"redirect_dir=on\" on non-upper mount.\n");
+		return -EINVAL;
 	}
 
 	return 0;
