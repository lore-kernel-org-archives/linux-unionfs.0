From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: check lower ancestry on encode of lower dir file handle
Date: Wed, 31 Jan 2018 13:27:54 +0200
Message-ID: <1517398074-28158-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:41014 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbeAaL0x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 06:26:53 -0500
Received: by mail-wr0-f180.google.com with SMTP id v15so14560288wrb.8
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 03:26:53 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eryu Guan <eguan@redhat.com>, linux-unionfs@vger.kernel.org

This change relaxes copy up on encode of merge dir with lower layer > 1
and handles the case of encoding a merge dir with lower layer 1, where an
ancestor is a non-indexed merge dir. In that case, decode of the lower
file handle will not have been possible if the non-indexed ancestor is
redirected before or after encode.

Before encoding a non-upper directory file handle from real layer N, we
need to check if it will be possible to reconnect an overlay dentry from
the real lower decoded dentry. This is done by following the overlay
ancestry up to a 'layer N connected' ancestor and verifying that all
parents along the way are 'layer N connectable'. If an ancestor that is
NOT 'layer N connectable' is found, we need to copy up an ancestor, which
is 'layer N connectable', thus making that ancestor 'layer N connected'.
For example:

 layer 1: /a
 layer 2: /a/b/c

The overlay dentry /a is NOT 'layer 2 connectable', because if dir /a is
copied up and renamed, upper dir /a will be indexed by lower dir /a from
layer 1. The dir /a from layer 2 will never be indexed, so the alrogithm
in ovl_lookup_real_ancestor() (*) will not be able to lookup a connected
overlay dentry from the connected lower dentry /a/b/c.

To avoid this problem on decode time, we need to copy up an ancestor of
/a/b/c, which is 'layer 2 connectable', on encode time. That ancestor is
/a/b. After copy up (and index) of /a/b, it will become 'layer 2 connected'
and when the time comes to decode the file handle from lower dentry /a/b/c,
ovl_lookup_real_ancestor() will find the indexed ancestor /a/b and decoding
a connected overlay dentry will be accomplished.

(*) the alrogithm in ovl_lookup_real_ancestor() can be improved to lookup
an entry /a in the lower layers above layer N and find the indexed dir /a
from layer 1. If that improvement is made, then the check for 'layer N
connected' will need to verify there are no redirects in lower layers above
layer N. In the example above, /a will be 'layer 2 connectable'. However,
if layer 2 dir /a is a target of a layer 1 redirect, then /a will NOT be
'layer 2 connectable':

 layer 1: /A (redirect = /a)
 layer 2: /a/b/c

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

I have written 2 xfstests [1] to cover the cases of ancestor with
lower redirect and ancestor with non-indexed upper.
The tests fail on overlayfs-next and pass with this patch.
One of the failures is just "unexpected copy up", because of the
strict rule to copy up every lower on layer > 1.
The other failure is a real failure to decode lower file handle
after rename of a non-indexed merge ancestor.

Thanks,
Amir.

Changes since v1 (RFC):
- Fix bug in checking for CONNECTED flag on parent
- Set CONNECTED flag on root dentry
- Change helper names and return values for readability
- Better documentation of helpers return values
- Fail encode if ancestor copy up fails

[1] https://github.com/amir73il/xfstests/commits/ovl-nfs-export

 fs/overlayfs/export.c    | 211 ++++++++++++++++++++++++++++++++++++-----------
 fs/overlayfs/overlayfs.h |   1 +
 fs/overlayfs/super.c     |   1 +
 3 files changed, 167 insertions(+), 46 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 07d70255095b..c5dcb08c3a77 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -19,6 +19,144 @@
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
 
+
+static int ovl_encode_maybe_copy_up(struct dentry *dentry)
+{
+	int err;
+
+	if (ovl_dentry_upper(dentry))
+		return 0;
+
+	err = ovl_want_write(dentry);
+	if (!err) {
+		err = ovl_copy_up(dentry);
+		ovl_drop_write(dentry);
+	}
+
+	if (err) {
+		pr_warn_ratelimited("overlayfs: failed to copy up on encode (%pd2, err=%i)\n",
+				    dentry, err);
+	}
+
+	return err;
+}
+
+/*
+ * Before encoding a non-upper directory file handle from real layer N, we need
+ * to check if it will be possible to reconnect an overlay dentry from the real
+ * lower decoded dentry. This is done by following the overlay ancestry up to a
+ * 'layer N connected' ancestor and verifying that all parents along the way are
+ * 'layer N connectable'. If an ancestor that is NOT 'layer N connectable' is
+ * found, we need to copy up an ancestor, which is 'layer N connectable', thus
+ * making that ancestor 'layer N connected'. For example:
+ *
+ * layer 1: /a
+ * layer 2: /a/b/c
+ *
+ * The overlay dentry /a is NOT 'layer 2 connectable', because if dir /a is
+ * copied up and renamed, upper dir /a will be indexed by lower dir /a from
+ * layer 1. The dir /a from layer 2 will never be indexed, so the alrogithm (*)
+ * in ovl_lookup_real_ancestor() will not be able to lookup a connected overlay
+ * dentry from the connected lower dentry /a/b/c.
+ *
+ * To avoid this problem on decode time, we need to copy up an ancestor of
+ * /a/b/c, which is 'layer 2 connectable', on encode time. That ancestor is
+ * /a/b. After copy up (and index) of /a/b, it will become 'layer 2 connected'
+ * and when the time comes to decode the file handle from lower dentry /a/b/c,
+ * ovl_lookup_real_ancestor() will find the indexed ancestor /a/b and decoding
+ * a connected overlay dentry will be accomplished.
+ *
+ * (*) the alrogithm in ovl_lookup_real_ancestor() can be improved to lookup an
+ * entry /a in the lower layers above layer N and find the indexed dir /a from
+ * layer 1. If that improvement is made, then the check for 'layer N connected'
+ * will need to verify there are no redirects in lower layers above N. In the
+ * example above, /a will be 'layer 2 connectable'. However, if layer 2 dir /a
+ * is a target of a layer 1 redirect, then /a will NOT be 'layer 2 connectable':
+ *
+ * layer 1: /A (redirect = /a)
+ * layer 2: /a/b/c
+ */
+
+/* Return the lowest layer for encoding a connectable file handle */
+static int ovl_connectable_layer(struct dentry *dentry)
+{
+	struct ovl_entry *oe = OVL_E(dentry);
+
+	/* We can get overlay root from root of any layer */
+	if (dentry == dentry->d_sb->s_root)
+		return oe->numlower;
+
+	/* We cannot get upper/overlay path from non-indexed lower dentry */
+	if (ovl_dentry_upper(dentry) &&
+	    !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
+		return 0;
+
+	/* Pure upper cannot be ancestor of non pure upper */
+	if (WARN_ON(!oe->numlower))
+		return 0;
+
+	/* We can get upper/overlay path from indexed/lower dentry */
+	return oe->lowerstack[0].layer->idx;
+}
+
+/*
+ * @dentry is 'connected' if all ancestors up to root or a 'connected' ancestor
+ * have the same uppermost lower layer as the origin's layer. We may need to
+ * copy up a 'connectable' ancestor to make it 'connected'. A 'connected' dentry
+ * cannot become non 'connected', so cache positive result in dentry flags.
+ *
+ * Return the connected origin layer or < 0 on error.
+ */
+static int ovl_connect_layer(struct dentry *dentry)
+{
+	struct dentry *next, *parent = NULL;
+	int origin_layer;
+	int err = 0;
+
+	if (WARN_ON(dentry == dentry->d_sb->s_root) ||
+	    WARN_ON(!ovl_dentry_lower(dentry)))
+		return -EIO;
+
+	origin_layer = OVL_E(dentry)->lowerstack[0].layer->idx;
+	if (ovl_dentry_test_flag(OVL_E_CONNECTED, dentry))
+		return origin_layer;
+
+	/* Find the topmost origin layer connectable ancestor of @dentry */
+	next = dget(dentry);
+	for (;;) {
+		parent = dget_parent(next);
+		if (WARN_ON(parent == next)) {
+			err = -EIO;
+			break;
+		}
+
+		/*
+		 * If @parent is not origin layer connectable, then copy up
+		 * @next which is origin layer connectable and we are done.
+		 */
+		if (ovl_connectable_layer(parent) < origin_layer) {
+			err = ovl_encode_maybe_copy_up(next);
+			break;
+		}
+
+		/* If @parent is connected or indexed we are done */
+		if (ovl_dentry_test_flag(OVL_E_CONNECTED, parent) ||
+		    ovl_test_flag(OVL_INDEX, d_inode(parent)))
+			break;
+
+		dput(next);
+		next = parent;
+	}
+
+	dput(parent);
+	dput(next);
+
+	if (!err)
+		ovl_dentry_set_flag(OVL_E_CONNECTED, dentry);
+
+	return err ?: origin_layer;
+}
+
 /*
  * We only need to encode origin if there is a chance that the same object was
  * encoded pre copy up and then we need to stay consistent with the same
@@ -41,73 +179,54 @@
  * L = lower file handle
  *
  * (*) Connecting an overlay dir from real lower dentry is not always
- * possible when there are redirects in lower layers. To mitigate this case,
- * we copy up the lower dir first and then encode an upper dir file handle.
+ * possible when there are redirects in lower layers and non-indexed merge dirs.
+ * To mitigate those case, we may copy up the lower dir ancestor before encode
+ * a lower dir file handle.
+ *
+ * Return 0 for upper file handle, > 0 for lower file handle or < 0 on error.
  */
-static bool ovl_should_encode_origin(struct dentry *dentry)
+static int ovl_check_encode_origin(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
+	/* Upper file handle for pure upper */
 	if (!ovl_dentry_lower(dentry))
-		return false;
-
-	/*
-	 * Decoding a merge dir, whose origin's parent is under a redirected
-	 * lower dir is not always possible. As a simple aproximation, we do
-	 * not encode lower dir file handles when overlay has multiple lower
-	 * layers and origin is below the topmost lower layer.
-	 *
-	 * TODO: copy up only the parent that is under redirected lower.
-	 */
-	if (d_is_dir(dentry) && ofs->upper_mnt &&
-	    OVL_E(dentry)->lowerstack[0].layer->idx > 1)
-		return false;
+		return 0;
 
-	/* Decoding a non-indexed upper from origin is not implemented */
+	/* Upper file handle for non-indexed upper */
 	if (ovl_dentry_upper(dentry) &&
 	    !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
-		return false;
-
-	return true;
-}
-
-static int ovl_encode_maybe_copy_up(struct dentry *dentry)
-{
-	int err;
-
-	if (ovl_dentry_upper(dentry))
 		return 0;
 
-	err = ovl_want_write(dentry);
-	if (err)
-		return err;
-
-	err = ovl_copy_up(dentry);
+	/*
+	 * Decoding a merge dir, whose origin's ancestor is under a redirected
+	 * lower dir or under a non-indexed upper is not always possible.
+	 * ovl_connect_layer() will try to make origin's layer 'connected' by
+	 * copying up a 'connectable' ancestor.
+	 */
+	if (d_is_dir(dentry) && ofs->upper_mnt)
+		return ovl_connect_layer(dentry);
 
-	ovl_drop_write(dentry);
-	return err;
+	/* Lower file handle for indexed and non-upper dir/non-dir */
+	return 1;
 }
 
 static int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
 {
-	struct dentry *origin = ovl_dentry_lower(dentry);
 	struct ovl_fh *fh = NULL;
 	int err;
 
 	/*
-	 * If we should not encode a lower dir file handle, copy up and encode
-	 * an upper dir file handle.
+	 * Check if we should encode a lower or upper file handle and maybe
+	 * copy up an ancestor to make lower file handle connectable.
 	 */
-	if (!ovl_should_encode_origin(dentry)) {
-		err = ovl_encode_maybe_copy_up(dentry);
-		if (err)
-			goto fail;
-
-		origin = NULL;
-	}
+	err = ovl_check_encode_origin(dentry);
+	if (err < 0)
+		goto fail;
 
-	/* Encode an upper or origin file handle */
-	fh = ovl_encode_fh(origin ?: ovl_dentry_upper(dentry), !origin);
+	/* Encode an upper or lower file handle */
+	fh = ovl_encode_fh(err ? ovl_dentry_lower(dentry) :
+				 ovl_dentry_upper(dentry), !err);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh))
 		goto fail;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 0df25a9c94bd..225ff1171147 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -40,6 +40,7 @@ enum ovl_inode_flag {
 enum ovl_entry_flag {
 	OVL_E_UPPER_ALIAS,
 	OVL_E_OPAQUE,
+	OVL_E_CONNECTED,
 };
 
 /*
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9ee37c76091d..7c24619ae7fc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1359,6 +1359,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Root is always merge -> can have whiteouts */
 	ovl_set_flag(OVL_WHITEOUTS, d_inode(root_dentry));
+	ovl_dentry_set_flag(OVL_E_CONNECTED, root_dentry);
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
 		       ovl_dentry_lower(root_dentry));
 
-- 
2.7.4
