Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1904C433DB
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 16:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C08FC65237
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 16:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhCIQ1G (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 11:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhCIQ1C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Mar 2021 11:27:02 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A37C06174A
        for <linux-unionfs@vger.kernel.org>; Tue,  9 Mar 2021 08:27:01 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id dx17so29363390ejb.2
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Mar 2021 08:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=87fNclK47WUIwLK7clKFr9/KzWM3dTb0vERsT3szsSg=;
        b=vgKC/ZMpmfeoaaFgJIBcDNPQdE70+NNg7B7kr8zWxL6c+Bk4b2YqlopCUBM8Ob0jah
         U47QtQj6ag5Gb3jPoo8cXYitUhdyCjYE/5XfD9HUQR/NPFUCXRHhrT2jdQb1OSJ41mH4
         tuxMqwUTdMu+fdWTaMLCNujoWh/3YU+9XN1fppcg3cfeNoedmkbiR0LyBCRywTcb9DNR
         u2EQsDU1GvZ1ntNr6Q2swTG3JrXcwh5GZwg2445iym4FZsvjRGJ+xK24LtmtQfE/5JVG
         HFhtyfyj5UnnlkZEAXsKltnNj7bkDRKeN3uXuHxlu7MeLZrhvAA5VVx+ZZe3bSsFlvET
         1/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=87fNclK47WUIwLK7clKFr9/KzWM3dTb0vERsT3szsSg=;
        b=JKvBnU9L8bylN87PbghnMzPIn6iSmZjkeczRnrRUMwCK528stbBosRsLkihHVlzN8f
         Pbp3LzCyGGbi53DEBTIAeKORvgcPWtE9wBxI9dbV5CXm2Pu6gBhuJ/BaKvvNp9uvowfm
         e0NpSHDmFQ0VOcx5rAnhrFZJUOMmk5+fT5UxCeZNYIzqTWOwSX0PvevRqdvJjSX3ITP7
         DutU0tw6KLt/jV1P043o44ZnBu8DCOj3u48Orbn+OKTDdYuqFioETyMabENQtBK+vPCl
         HJEt24LNxpMOMXKb1sHVVcvFQpTlio/VdtexgT5pKzSXLYDZ0v6CM0fpdvaaPHpE2Sod
         dhFA==
X-Gm-Message-State: AOAM532v3U4Aw5YqoIdWquiFLsX8UFrWvYwMtWzkZHYyyuEJzS0JdxLA
        jdIx/fkcITWDCs+KYByg/Vk=
X-Google-Smtp-Source: ABdhPJwjvOuX2s1DbPNb6dxL2n0EbyVKot9zlkiNo+5Pmzx4r6Tvx6Abpnb94BO9oGMaF0Nqs6IJTg==
X-Received: by 2002:a17:907:9862:: with SMTP id ko2mr20793442ejc.222.1615307220397;
        Tue, 09 Mar 2021 08:27:00 -0800 (PST)
Received: from localhost.localdomain ([141.226.15.75])
        by smtp.gmail.com with ESMTPSA id n2sm8519679ejl.1.2021.03.09.08.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 08:26:59 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Fabian <godi.beat@gmx.net>, Kevin Locke <kevin@kevinlocke.name>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: restrict lower null uuid for "xino=auto"
Date:   Tue,  9 Mar 2021 18:26:54 +0200
Message-Id: <20210309162654.243184-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Commit a888db310195 ("ovl: fix regression with re-formatted lower
squashfs") attempted to fix a regression with existing setups that
use a practice that we are trying to discourage.

The discourage part was described this way in the commit message:
"To avoid the reported regression while still allowing the new features
 with single lower squashfs, do not allow decoding origin with lower null
 uuid unless user opted-in to one of the new features that require
 following the lower inode of non-dir upper (index, xino, metacopy)."

The three mentioned features are disabled by default in Kconfig, so
it was assumed that if they are enabled, the user opted-in for them.
Apparently, distros started to configure CONFIG_OVERLAY_FS_XINO_AUTO=y
some time ago, so users upgrading their kernels can still be affected
by said regression even though they never opted-in for any new feature.

To fix this, treat "xino=on" as "user opted-in", but not "xino=auto".
Since we are changing the behavior of "xino=auto" to no longer follow
to lower origin with null uuid, take this one step further and disable
xino in that corner case.  To be consistent, disable xino also in cases
of lower fs without file handle support and upper fs without xattr
support.

Update documentation w.r.t the new "xino=auto" behavior and fix the out
dated bits of documentation regarding "xino" and regarding offline
modifications to lower layers.

Link: https://lore.kernel.org/linux-unionfs/b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name/
Fixes: a888db310195 ("ovl: fix regression with re-formatted lower squashfs")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

What do you think about this?
I guess the chances of anyone complaining about the "regression"
with CONFIG_OVERLAY_FS_XINO_AUTO=y are pretty low, but I like the
end result w.r.t behavior and docuementation.

Do you think that "regressing" xino=auto for the case of no lower
file handles will create problems? If people complain, they can
move to use xino=on to get the behavior they wanted.

Fabian,

Would you be able to verify that this does not break anything with your
setup with and without CONFIG_OVERLAY_FS_XINO_AUTO?

Thanks,
Amir.

 Documentation/filesystems/overlayfs.rst | 26 ++++++++--------
 fs/overlayfs/super.c                    | 41 +++++++++++++++++++++----
 2 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 78240e29b0bb..455ca86eb4fc 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -40,17 +40,17 @@ On 64bit systems, even if all overlay layers are not on the same
 underlying filesystem, the same compliant behavior could be achieved
 with the "xino" feature.  The "xino" feature composes a unique object
 identifier from the real object st_ino and an underlying fsid index.
-
-If all underlying filesystems support NFS file handles and export file
-handles with 32bit inode number encoding (e.g. ext4), overlay filesystem
-will use the high inode number bits for fsid.  Even when the underlying
-filesystem uses 64bit inode numbers, users can still enable the "xino"
-feature with the "-o xino=on" overlay mount option.  That is useful for the
-case of underlying filesystems like xfs and tmpfs, which use 64bit inode
-numbers, but are very unlikely to use the high inode number bits.  In case
+The "xino" feature uses the high inode number bits for fsid, because the
+underlying filesystems rarely use the high inode number bits.  In case
 the underlying inode number does overflow into the high xino bits, overlay
 filesystem will fall back to the non xino behavior for that inode.
 
+The "xino" feature can be enabled with the "-o xino=on" overlay mount option.
+If all underlying filesystems support NFS file handles, the value of st_ino
+for overlay filesystem objects is not only unique, but also persistent over
+the lifetime of the filesystem.  The "-o xino=auto" overlay mount option
+enables the "xino" feature only if the persistent st_ino requirement is met.
+
 The following table summarizes what can be expected in different overlay
 configurations.
 
@@ -66,14 +66,13 @@ Inode properties
 | All layers   |  Y  |  Y   |  Y  |  Y   |  Y     |   Y    |  Y     |  Y    |
 | on same fs   |     |      |     |      |        |        |        |       |
 +--------------+-----+------+-----+------+--------+--------+--------+-------+
-| Layers not   |  N  |  Y   |  Y  |  N   |  N     |   Y    |  N     |  Y    |
+| Layers not   |  N  |  N   |  Y  |  N   |  N     |   Y    |  N     |  Y    |
 | on same fs,  |     |      |     |      |        |        |        |       |
 | xino=off     |     |      |     |      |        |        |        |       |
 +--------------+-----+------+-----+------+--------+--------+--------+-------+
 | xino=on/auto |  Y  |  Y   |  Y  |  Y   |  Y     |   Y    |  Y     |  Y    |
-|              |     |      |     |      |        |        |        |       |
 +--------------+-----+------+-----+------+--------+--------+--------+-------+
-| xino=on/auto,|  N  |  Y   |  Y  |  N   |  N     |   Y    |  N     |  Y    |
+| xino=on/auto,|  N  |  N   |  Y  |  N   |  N     |   Y    |  N     |  Y    |
 | ino overflow |     |      |     |      |        |        |        |       |
 +--------------+-----+------+-----+------+--------+--------+--------+-------+
 
@@ -81,7 +80,6 @@ Inode properties
 /proc files, such as /proc/locks and /proc/self/fdinfo/<fd> of an inotify
 file descriptor.
 
-
 Upper and Lower
 ---------------
 
@@ -461,7 +459,7 @@ enough free bits in the inode number, then overlayfs will not be able to
 guarantee that the values of st_ino and st_dev returned by stat(2) and the
 value of d_ino returned by readdir(3) will act like on a normal filesystem.
 E.g. the value of st_dev may be different for two objects in the same
-overlay filesystem and the value of st_ino for directory objects may not be
+overlay filesystem and the value of st_ino for filesystem objects may not be
 persistent and could change even while the overlay filesystem is mounted, as
 summarized in the `Inode properties`_ table above.
 
@@ -476,7 +474,7 @@ a crash or deadlock.
 
 Offline changes, when the overlay is not mounted, are allowed to the
 upper tree.  Offline changes to the lower tree are only allowed if the
-"metadata only copy up", "inode index", and "redirect_dir" features
+"metadata only copy up", "inode index", "xino" and "redirect_dir" features
 have not been used.  If the lower tree is modified and any of these
 features has been used, the behavior of the overlay is undefined,
 though it will not result in a crash or deadlock.
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fdd72f1a9c5e..2438f75df652 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -945,6 +945,16 @@ static int ovl_lower_dir(const char *name, struct path *path,
 		pr_warn("fs on '%s' does not support file handles, falling back to index=off,nfs_export=off.\n",
 			name);
 	}
+	/*
+	 * Decoding origin file handle is required for persistent st_ino.
+	 * Without persistent st_ino, xino=auto falls back to xino=off.
+	 */
+	if (ofs->config.xino == OVL_XINO_AUTO &&
+	    ofs->config.upperdir && !fh_type) {
+		ofs->config.xino = OVL_XINO_OFF;
+		pr_warn("fs on '%s' does not support file handles, falling back to xino=off.\n",
+			name);
+	}
 
 	/* Check if lower fs has 32bit inode numbers */
 	if (fh_type != FILEID_INO32_GEN)
@@ -1401,9 +1411,19 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	err = ovl_do_setxattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE, "0", 1);
 	if (err) {
 		ofs->noxattr = true;
-		ofs->config.index = false;
-		ofs->config.metacopy = false;
-		pr_warn("upper fs does not support xattr, falling back to index=off and metacopy=off.\n");
+		if (ofs->config.index || ofs->config.metacopy) {
+			ofs->config.index = false;
+			ofs->config.metacopy = false;
+			pr_warn("upper fs does not support xattr, falling back to index=off,metacopy=off.\n");
+		}
+		/*
+		 * xattr support is required for persistent st_ino.
+		 * Without persistent st_ino, xino=auto falls back to xino=off.
+		 */
+		if (ofs->config.xino == OVL_XINO_AUTO) {
+			ofs->config.xino = OVL_XINO_OFF;
+			pr_warn("upper fs does not support xattr, falling back to xino=off.\n");
+		}
 		err = 0;
 	} else {
 		ovl_do_removexattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE);
@@ -1580,7 +1600,8 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	 * user opted-in to one of the new features that require following the
 	 * lower inode of non-dir upper.
 	 */
-	if (!ofs->config.index && !ofs->config.metacopy && !ofs->config.xino &&
+	if (!ofs->config.index && !ofs->config.metacopy &&
+	    ofs->config.xino != OVL_XINO_ON &&
 	    uuid_is_null(uuid))
 		return false;
 
@@ -1609,6 +1630,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	dev_t dev;
 	int err;
 	bool bad_uuid = false;
+	bool warn = false;
 
 	for (i = 0; i < ofs->numfs; i++) {
 		if (ofs->fs[i].sb == sb)
@@ -1617,13 +1639,20 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 
 	if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
 		bad_uuid = true;
+		if (ofs->config.xino == OVL_XINO_AUTO) {
+			ofs->config.xino = OVL_XINO_OFF;
+			warn = true;
+		}
 		if (ofs->config.index || ofs->config.nfs_export) {
 			ofs->config.index = false;
 			ofs->config.nfs_export = false;
-			pr_warn("%s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
+			warn = true;
+		}
+		if (warn) {
+			pr_warn("%s uuid detected in lower fs '%pd2', falling back to xino=%s,index=off,nfs_export=off.\n",
 				uuid_is_null(&sb->s_uuid) ? "null" :
 							    "conflicting",
-				path->dentry);
+				path->dentry, ovl_xino_str[ofs->config.xino]);
 		}
 	}
 
-- 
2.30.0

