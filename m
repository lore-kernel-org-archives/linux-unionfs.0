From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 9/9] ovl: add support for 'xino' mount option
Date: Tue,  7 Nov 2017 18:58:09 +0200
Message-ID: <1510073889-11657-10-git-send-email-amir73il@gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54323 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754954AbdKGQ5n (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:43 -0500
Received: by mail-wm0-f66.google.com with SMTP id r68so5340199wmr.3
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:43 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

With mount option 'xino', mounter declares that there are enough
free high bits in underlying fs to hold the layer id.
If overlayfs does encounter underlying inodes using the high xino
bits reserved for layer id, stat(2) will return -EOVERLFLOW.

The mount option name 'xino' goes after a similar meaning mount option
of aufs, but in overlayfs case, the mapping is stateless.

An example for a use case of 'xino' is when upper/lower is on an xfs
filesystem mounted with mount option 'inode32' or on an xfs filesystem
that is not huge.  If xfs filesystem AG count is limited by device size
to under 2^(31-x), then it is safe to use x high blocks for the overlay
layer id.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 226cf94838a3..13140028f2bb 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -15,6 +15,7 @@ struct ovl_config {
 	bool default_permissions;
 	bool redirect_dir;
 	bool index;
+	bool xino;
 };
 
 struct ovl_layer {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ddedfca9305c..3f41ddf6bd0d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -308,6 +308,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ufs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s",
 			   ufs->config.index ? "on" : "off");
+	if (ufs->config.xino)
+		seq_puts(m, ",xino");
 	return 0;
 }
 
@@ -341,6 +343,7 @@ enum {
 	OPT_REDIRECT_DIR_OFF,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
+	OPT_XINO,
 	OPT_ERR,
 };
 
@@ -353,6 +356,7 @@ static const match_table_t ovl_tokens = {
 	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
+	{OPT_XINO,			"xino"},
 	{OPT_ERR,			NULL}
 };
 
@@ -433,6 +437,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->index = false;
 			break;
 
+		case OPT_XINO:
+			config->xino = true;
+			break;
+
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
@@ -1085,9 +1093,18 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
 		ufs->same_sb = NULL;
 
-	/* When all layers on same fs, overlay can use real inode numbers */
+	/*
+	 * When all layers on same fs, overlay can use real inode numbers.
+	 * With mount option 'xino', mounter declares that there are enough
+	 * free high bits in underlying fs to hold the layer id.
+	 * If overlayfs does encounter underlying inodes using the high xino
+	 * bits reserved for layer id, stat(2) will return -EOVERLFLOW.
+	 */
+	BUILD_BUG_ON(ilog2(OVL_MAX_STACK) > 31);
 	if (ufs->same_sb)
 		ufs->xino_bits = 0;
+	else if (ufs->config.xino && !ufs->xino_bits)
+		ufs->xino_bits = ilog2(ufs->numlower) + 1;
 
 	err = -ENOMEM;
 	oe = ovl_alloc_entry(numlower);
-- 
2.7.4
