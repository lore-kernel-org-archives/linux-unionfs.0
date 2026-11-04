Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793825120;
	b=cuwJ9wEuWpevvzWHmIOI5dJYSsOEXyyO0tJIahkwpkOwUjvc08tt9Zu617/l1JqM9snF
	 nAXHMll5ZRtmSNc0fIgNmNWBA2vwfWwqvqw6KGF9nN6ULaHw7DglKEayjqMEHsko9aAil
	 ncfWTtkc7Z4Fe1QgObpCfuaj9xTxMPUrvFP4l77cgD2a44P/svZH+lJgj+P7BKPMgFTQY
	 3MV64S0kh9trzqAknxMVd6KpFNGIwwKUU/BHL6Yt3316E5q5u9cHiP5oaWLvINw0y0f1C
	 Wje7bXS1yizayDLhl19gUI7aG7HXV+gwL8DefQUC+9xhzg9HEU6Y7v+/sER1u/I2jpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793825120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=Cygrim0+fZvvBzwHSs/vmoqm/PpQFOc600jt1WWJ6mI=;
	b=WKF9ePKyZ6scHI25nGlQRlD7WsJXGfxm/uPDg2te2cBC+z3SruZjU7BaCrxFWuTM2Mcp
	 zBiVH3sXtm/SbnsWvB7IP3iSKUijKfi5kaDFF1NKG4T6HnI1KNvLarN7Ptf/FN5dZzr8K
	 gCVwUQsHiSC8f4XCucmnvAYA8Ay6NslJtjM9QeTo3dmVQGBGJotsldmPZNzyfGQRAHrfq
	 DcBXwCwcNvEl9y/MknyKGgCZS6SQxY3ug1ZDXFHZN5EYXzWPIiukK3Icrfcp2ozpuIXh5
	 rU+PdzdojcqJEEVL1KP4FRaK08zq8gu0P4BMA/OgfZSwCuFI5UOJgtGiiwKjRAJV8tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=KJ6MN1SK;
	arc=none smtp.remote-ip=209.85.222.171
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25811606C594
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 20:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25811606C594
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=KJ6MN1SK
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93f2b8cf037so94929485a.1
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 12:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793825118; x=1794429918; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cygrim0+fZvvBzwHSs/vmoqm/PpQFOc600jt1WWJ6mI=;
        b=KJ6MN1SKZVsER6TxKrXkUKK6sGKMvC++LNDFq8TvtHI8PXrZcPM8FtZCan1gl95LbI
         Zsmj9PbkJmkJBjvtYT76++YkJ2Y8eCuWTzEfraivs3hLy2eGNGxaL8JgmjDatb0xMD8f
         NGfRaxmrui3DxhgrZaluYh4k3oNI+jYsri6esr24vpu1H9UNTI+7i0Timzb/AtwNfPiZ
         A8dN5gpjlTYsxKcdRPFqifrmsw8rz2QHfU4UOm/MogN50dc5GDcmx5rv2OfK/ahWqCOD
         uLRsTWM+TArLwXALc7xIP9My6peYleGW9RQHN3jhEAWTdEp2tilIzkxKPRTlbCbTEa/J
         hD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793825118; x=1794429918;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cygrim0+fZvvBzwHSs/vmoqm/PpQFOc600jt1WWJ6mI=;
        b=ZnLrcEDEDOxbqmVQLaAq1b9hK1KEQkwqzIkwQlqUPooxyzkC318HhhBPKfv4jSd5cQ
         PUxcRzZlv2aG2GtgPnRvnh66vQRQHhRQF0kmHboG9pIrzKpp8bzxLXi74qcZqR0BVrjQ
         nMxb+dtNfbgoj29yo0+6x8c2iI1Y4fTtPgSKLeRM2PqgGn0aar9cdMDRVeyBfuGUZ7r6
         q3woVsue7BrX+0gNVMRTSaZQHYLIUFHRhd92hpvwHp9JPTS1Y2b3B3FHsur42QJI2qE6
         4B85bA0dQONh/LEoOlJckqkOSiFq304l8wwZzjC99k+WJmeC4NNltnWZ9YtNdhqVHbRW
         ORrA==
X-Forwarded-Encrypted: i=1; AKwUvByagjnDJMJS7dTqeSaKQ1FlFGmYfw3nZt9qdszm2zklMElfBJJA4ifHT61smipovkYijJwZrov8RpfufXP4@vger.kernel.org
X-Gm-Message-State: APuU4Z8mxiBBaR5QOCfQhfmA+qRTznBWuxhulNR5FePMfUBRTz+Za/V+
	YyHzcmMzlsqrhJE2rS51ZSp/yaLfgHOayswLkV3OxVaJOi7bGqcvFisto1l6CXli8AY=
X-Gm-Gg: AYBFou0T9Ilhnuxj2nTc2EC9gyR1/z6iZs9PTcjUZED/cW+vhNm39K3SYPikzhYelaN
	k7P/kfEWff3nshtTBpXbPTr2KV56hgd3HPJMDJNJ488YzrLlZB85rrQPY5I3MWHRlt5i/kb7wj7
	k+PpoLV1HLqWGtKWkXdf2BT2Qj9eZ3WjX8gwfJZ4L6PGhmAYngzCEKDZIUctjL/3BZsRR6AABrX
	zeHBNqDiYhWIoUn/hs6rRlYsyugiwsb6Gxp2uvzkNQmMz3L7VcP4zyHAaaSAX3tDr+DJjtYBEnS
	Hg4gT/y+DwiTwpZHRI6djdx/4HYWIP6d2LmZnPuu+Ft2tZ+8RGYE4X6ladMgXzJz9hR1TFWfGp+
	isNzLLuYHzrqZf53n8Ht/3BjSEtAttWOEdnqrPx2iYpYoVFxSoQzl+5emi/N39ZomQfWX8gYIij
	BKrlS9hKQnp8IcwVbxq/ykRN5372RqR1mNmhDq9y/UPkRUajQcHqPrhHq+uvnVkHq5/Lsd1wg1c
	5CsPs/mpEvYe1rC9jNNunfoDDgr2K0eBE5Z7kChhTr+vyHvIv/wpf01sZiofWZgPddoTuRo3tkX
	sB3b7yH3W9A/T6xxXNTRuGI7gYzCqBgybAymN/VevWWxhw==
X-Received: by 2002:a05:620a:2849:b0:93f:175a:f4ce with SMTP id af79cd13be357-944217f7082mr2953442985a.80.1793825118005;
        Wed, 04 Nov 2026 12:45:18 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d48316f4sm291888885a.25.2026.11.04.12.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:45:17 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 04 Nov 2026 20:44:58 +0000
Subject: [PATCH v3 1/8] ovl: expand fsync mount options
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-b4-ovl-containerized-sync-v3-1-8daa20144f53@toxicpanda.com>
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
In-Reply-To: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793825112; l=10771;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=Onclt4mrmQ+uUVar7CcpE3WTR4yesfqlPQ2v6t00W5k=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QPlA401VGxpiOe3NT656UxoieDGJZiFryGwmgavBkuNwtmJWLmjRHO2tn5sirxmtji5xiP+Qf89
 ZQTA/kijOfAc=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Amir Goldstein <amir73il@gmail.com>

The fsync mount option currently accepts three values:
"volatile", "strict" and "auto".

All other "enum" mount options have "on" and "off" values and this is
used by the generic _check_overlay_feature helper in fstests to probe
for support for enabling overlayfs features.

This commit adds supports for values "on", "off" and "relax" and makes
the value of "auto" depend on a kconfig/module option fsync_auto.

The value of "off" behaves almost the same the "volatile", not
persisting changes to upper layer, but it does not create the directory
"$workdir/work/incompat/volatile", which prevent mount cycle of a
volatile overlayfs. Some users requested to opt-out of this rail guard.

The new value "relaxed" is a preparation for not syncing the entire
upper fs on syncfs(2) and unmount and instead syncing only the upper
inodes modified by this overlayfs.

The value of "on" is the traditional overlayfs behavior and it behaves
the same as the current value "auto", releasing the value of "auto" to
differ by the kconfig/module option fsync_auto.

By default, with kconfig/module option fsync_auto=Y, the meaning of the
value "auto" is that filesystems that support RENAME_WHITEOUT default to
"relaxed" and filesystems that do not support RENAME_WHITEOUT default to
the traditional "fsync=on".

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 Documentation/filesystems/overlayfs.rst | 32 +++++++++++++++++++++++++++-----
 fs/overlayfs/Kconfig                    | 21 +++++++++++++++++++++
 fs/overlayfs/overlayfs.h                | 16 +++++++++++++---
 fs/overlayfs/params.c                   | 16 +++++++++++++---
 fs/overlayfs/params.h                   |  1 +
 fs/overlayfs/super.c                    | 13 ++++++++++---
 6 files changed, 85 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 16c35b491dad..092806c620b6 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -826,27 +826,49 @@ The fsync during copy up only guarantees that if a copy up is observed
 after a crash, the observed data is not zeroes or intermediate values
 from the copy up staging area.
 
+Traditionally, syncfs(2) and unmount of an overlay sync the entire upper
+filesystem, including the dirty data of other overlays that share it.
+Overlayfs can be told to only write back the files that were modified
+through the overlay, and then ask the upper filesystem to commit its
+metadata.
+
 On traditional local filesystems with a single journal (e.g. ext4, xfs),
 fsync on a file also persists the parent directory changes, because they
 are usually modified in the same transaction, so metadata durability during
-data copy up effectively comes for free.  Overlayfs further limits risk by
-disallowing network filesystems as upper layer.
+data copy up and the persistence of other upper changes such as whiteouts
+effectively come for free.
 
 Overlayfs can be tuned to prefer performance or durability when storing
 to the underlying upper layer.  This is controlled by the "fsync" mount
 option, which supports these values:
 
-- "auto": (default)
+- "volatile": [*]
+    Prefer performance over durability (see `Volatile mount`_)
+- "off":
+    Same as "volatile", but does not prevent mounting the overlay again
+    after unmount (see `Volatile mount`_)
+- "relaxed":
     Call fsync(2) on upper file before completion of data copy up.
     No explicit fsync(2) on directory or metadata-only copy up.
+    syncfs(2) and unmount only write back the files that were modified
+    through the overlay.
+- "auto": (default)
+    "relaxed" if the upper filesystem supports RENAME_WHITEOUT,
+    otherwise "on".
+- "on":
+    syncfs(2) syncs the entire upper filesystem.
+    Copy up behaves like "relaxed".
 - "strict":
+    syncfs(2) syncs the entire upper filesystem.
     Call fsync(2) on upper file and directories before completion of any
     copy up.
-- "volatile": [*]
-    Prefer performance over durability (see `Volatile mount`_)
 
 [*] The mount option "volatile" is an alias to "fsync=volatile".
 
+The default is "fsync=on" instead of "fsync=auto" with the module option
+"fsync_auto=N" or with the kernel config option
+CONFIG_OVERLAY_FS_FSYNC_AUTO=n.
+
 
 Volatile mount
 --------------
diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 2ac67e04a6fb..f1b2f3784c76 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -108,6 +108,27 @@ config OVERLAY_FS_XINO_AUTO
 
 	  If unsure, say N.
 
+config OVERLAY_FS_FSYNC_AUTO
+	bool "Overlayfs: auto select the fsync mode by default"
+	default y
+	depends on OVERLAY_FS
+	help
+	  If this config option is enabled then overlay filesystems will use
+	  "fsync=auto" by default, which selects "fsync=relaxed" if the upper
+	  filesystem supports RENAME_WHITEOUT and "fsync=on" otherwise.
+	  With "fsync=relaxed", syncfs(2) and unmount of an overlay only write
+	  back the files that were modified through the overlay, instead of
+	  syncing the entire upper filesystem.
+
+	  If this config option is disabled then overlay filesystems will use
+	  "fsync=on" by default.  It is still possible to change the default
+	  with the "fsync_auto" module option or on a filesystem instance
+	  basis with the "fsync" mount option.
+
+	  For more information, see Documentation/filesystems/overlayfs.rst
+
+	  If unsure, say Y.
+
 config OVERLAY_FS_METACOPY
 	bool "Overlayfs: turn on metadata only copy up feature by default"
 	depends on OVERLAY_FS
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 92da556598da..444e28c09145 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -102,8 +102,11 @@ enum {
 };
 
 enum {
+	OVL_FSYNC_OFF,
 	OVL_FSYNC_VOLATILE,
+	OVL_FSYNC_RELAXED,
 	OVL_FSYNC_AUTO,
+	OVL_FSYNC_ON,
 	OVL_FSYNC_STRICT,
 };
 
@@ -660,7 +663,8 @@ static inline bool ovl_xino_warn(struct ovl_fs *ofs)
 
 static inline bool ovl_should_sync(struct ovl_fs *ofs)
 {
-	return ofs->config.fsync_mode != OVL_FSYNC_VOLATILE;
+	return ofs->config.fsync_mode != OVL_FSYNC_OFF &&
+	       ofs->config.fsync_mode != OVL_FSYNC_VOLATILE;
 }
 
 static inline bool ovl_should_sync_metadata(struct ovl_fs *ofs)
@@ -668,9 +672,15 @@ static inline bool ovl_should_sync_metadata(struct ovl_fs *ofs)
 	return ofs->config.fsync_mode == OVL_FSYNC_STRICT;
 }
 
-static inline bool ovl_is_volatile(struct ovl_config *config)
+/*
+ * With fsync=on or fsync=strict, syncfs(2) and unmount sync the entire upper
+ * filesystem.  Otherwise they only write back the files that were modified
+ * through the overlay.
+ */
+static inline bool ovl_should_sync_upper_fs(struct ovl_fs *ofs)
 {
-	return config->fsync_mode == OVL_FSYNC_VOLATILE;
+	return ofs->config.fsync_mode == OVL_FSYNC_ON ||
+	       ofs->config.fsync_mode == OVL_FSYNC_STRICT;
 }
 
 /*
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 5a15e5478a6b..9ff266c38cd5 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -28,6 +28,11 @@ module_param_named(xino_auto, ovl_xino_auto_def, bool, 0644);
 MODULE_PARM_DESC(xino_auto,
 		 "Auto enable xino feature");
 
+static bool ovl_fsync_auto_def = IS_ENABLED(CONFIG_OVERLAY_FS_FSYNC_AUTO);
+module_param_named(fsync_auto, ovl_fsync_auto_def, bool, 0644);
+MODULE_PARM_DESC(fsync_auto,
+		 "Default to fsync=auto instead of fsync=on");
+
 static bool ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
 module_param_named(index, ovl_index_def, bool, 0644);
 MODULE_PARM_DESC(index,
@@ -142,8 +147,11 @@ static int ovl_verity_mode_def(void)
 }
 
 static const struct constant_table ovl_parameter_fsync[] = {
+	{ "off",	OVL_FSYNC_OFF      },
 	{ "volatile",	OVL_FSYNC_VOLATILE },
+	{ "relaxed",	OVL_FSYNC_RELAXED  },
 	{ "auto",	OVL_FSYNC_AUTO     },
+	{ "on",		OVL_FSYNC_ON       },
 	{ "strict",	OVL_FSYNC_STRICT   },
 	{}
 };
@@ -155,7 +163,7 @@ static const char *ovl_fsync_mode(struct ovl_config *config)
 
 static int ovl_fsync_mode_def(void)
 {
-	return OVL_FSYNC_AUTO;
+	return ovl_fsync_auto_def ? OVL_FSYNC_AUTO : OVL_FSYNC_ON;
 }
 
 const struct fs_parameter_spec ovl_parameter_spec[] = {
@@ -689,9 +697,11 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		break;
 	case Opt_fsync:
 		config->fsync_mode = result.uint_32;
+		ctx->set.fsync = true;
 		break;
 	case Opt_volatile:
 		config->fsync_mode = OVL_FSYNC_VOLATILE;
+		ctx->set.fsync = true;
 		break;
 	case Opt_userxattr:
 		config->userxattr = true;
@@ -896,8 +906,8 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->index = false;
 	}
 
-	if (!config->upperdir && ovl_is_volatile(config)) {
-		pr_info("option \"volatile\" is meaningless in a non-upper mount, ignoring it.\n");
+	if (!config->upperdir && set.fsync) {
+		pr_info("options \"fsync\" and \"volatile\" are meaningless in a non-upper mount, ignoring them.\n");
 		config->fsync_mode = ovl_fsync_mode_def();
 	}
 
diff --git a/fs/overlayfs/params.h b/fs/overlayfs/params.h
index ffd53cdd8482..3c864b874af2 100644
--- a/fs/overlayfs/params.h
+++ b/fs/overlayfs/params.h
@@ -15,6 +15,7 @@ struct ovl_opt_set {
 	bool redirect;
 	bool nfs_export;
 	bool index;
+	bool fsync;
 };
 
 #define OVL_MAX_STACK 500
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 19b6d54c4500..4500038d6941 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -734,8 +734,15 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		goto out;
 
 	rename_whiteout = err;
-	if (!rename_whiteout)
+	if (!rename_whiteout) {
 		pr_warn("upper fs does not support RENAME_WHITEOUT.\n");
+		if (ofs->config.fsync_mode == OVL_FSYNC_AUTO)
+			pr_warn("...falling back to fsync=on.\n");
+	}
+
+	if (ofs->config.fsync_mode == OVL_FSYNC_AUTO)
+		ofs->config.fsync_mode = rename_whiteout ? OVL_FSYNC_RELAXED :
+							   OVL_FSYNC_ON;
 
 	/*
 	 * Check if upper/work fs supports (trusted|user).overlay.* xattr
@@ -789,9 +796,9 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
 	/*
 	 * For volatile mount, create a incompat/volatile/dirty file to keep
-	 * track of it.
+	 * track of it.  fsync=off allows mounting the overlay again.
 	 */
-	if (ovl_is_volatile(&ofs->config)) {
+	if (ofs->config.fsync_mode == OVL_FSYNC_VOLATILE) {
 		err = ovl_create_volatile_dirty(ofs);
 		if (err < 0) {
 			pr_err("Failed to create volatile/dirty file.\n");

-- 
2.55.0

