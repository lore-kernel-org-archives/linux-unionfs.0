Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972223;
	b=o+uT1G+p7m8tIGAAlEO1i4sPI55jZkavD//3fXmvIsoUrW33Nb96sW43/tG6fNv8wKq+
	 Zm6wT3lq40yzgff7myOUEWvcV5HX2OSyrn3MiiEWvsi0eRcNa7M+sP0GWOTyETgX0VEcy
	 kElBidJ/SMkEbbdee7On9S2KhE9mTv0rIDu59zwwoW0CuUjYjWqb9kkro4cYmA/OE7BQE
	 lwVlmqH/ie1NuXQ3JVCAv+/u8gxo0EsKWfb/+41UuTcnA8oFKS9SVmMleeesPB0y9X54M
	 sE+JALwPqx8NHrQHRN9TtdLdzP7lfNZASwAltOe5NkZW01CmbS5sCHp2t4rwsx0j/tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=R22Hkg58AODA+U2Qc/D03rkLftDWo9zEEkg5H+BLiYE=;
	b=lGUyKC80kbBnjCBN6d62HcFQrDXNubIJxtEVsyDm3ezdzaJqXBdmsMRXxvWXFjdmWt0K
	 Nkyth2P9WQ8vgOEuEdyYRBnF7AOO/JYZ29W3/C8PPaZp/LOF/l8j9oaixXJ1OclZBKITy
	 3vSmyMGvzlTrTFgggAHpU3py7dh3eYPDl5qieerfiH3YN7rSeE4ZpKcnSWi0CpnMZAnXA
	 5q6axruduHZcfw0ivtvijGTVW1TDWHSTe8ipDrS7sCAN2pUZzR9vaF3axn8X8qvfPawxZ
	 +/xL3x3cVXynM7embQlHd5cJL5wmf7wXBNdlM8WhlrgRXl1Qrlq+iA86FPLPyKcskaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=gkWNNu78;
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2DE606A336
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:37:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C2DE606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=gkWNNu78
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91c79f306e9so7490216d6.3
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 05:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793972221; x=1794577021; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R22Hkg58AODA+U2Qc/D03rkLftDWo9zEEkg5H+BLiYE=;
        b=gkWNNu78khkp2N7JJzNw53OIVvJ8eQ5FFYZDHuquu9acu4HQLITZ6DV74RUI3eTFjB
         gINFXaPzBbO3l06TUdPY7eNhpvCgTP7NRMk1aAKAxvBog3XyaP7BjSFN1I6OdNPi9Zkw
         eQ2wKzfQptD3t3P5A9b3qjpkYMbAJhrs0uJPBb3L1d1AVWmZfqT5PIIcl31vz+My7RLH
         1WVOtQmjbc+6COqdaEIyebDCTaREyh5Cqv/xiP4xeX0KO26184ygoCvKZJzSJ9ihtAK3
         7p4juAISXuw7pdAuTQ/T0/oLXH76vCjtkXve8yrCnDCmptT0kFMEBwEScuDMKf/xnYG1
         KiWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972221; x=1794577021;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R22Hkg58AODA+U2Qc/D03rkLftDWo9zEEkg5H+BLiYE=;
        b=L737YYjmdv1n5YJCRxZon7Dr0bTU6hpeyAt/koaSgWGfd1Bf70fPPUr3elaA7KvNg3
         oYh3izRDiPV9FIoufltB4DgGpSipOhAiqYQNok13muv2EAfh+H+ByaAREsDCT8bFBBPR
         FTIzwm64rFdAUVKR1qKsIfv7cJ3KQ6L1DnnFaWztVDSY443NLk/KNaU/ctayLL9chKMO
         6UGV//cB9SnSopPIe8FN5VEXZF2hp9X8Owb95M/l5zuJeA+X0M12oESv8AI3MKTZw5Pu
         Cz5BOY50tgI59AiMQpsVPiTtetdupcd3I8FOkzl3I/aZviLoGjhVuX6yGrJWFRxX9spB
         Y2BA==
X-Forwarded-Encrypted: i=1; AL+hErEYhF1806VDNh/v68sYaIaG2G1sAhAJewzpfiNjfnMCW6A4SZTzS5B0fV9enpOtS2U8XqXtzIQV/wnHOEx+@vger.kernel.org
X-Gm-Message-State: APuU4Z/NKvnE2a2e+9nVC9f0MLT7ibATcQ5ArUFX0Af880dqXSAJ3VyT
	ig6rmaV34m71GiBS7HEq2tGE+TYyIVEkmXcRcAg3Wp+v83JK1BVOtifgY0ibR895jMA=
X-Gm-Gg: AYBFou0OlY2tjFhKCAkWjKW/mUpYjS2gKgEVxqlFArYsWSW8HOZWAjUWkZZzWLLBmkg
	gObtOEbg+vsQm6i37r20ZcjB0sDvAd8yWI/5fmeABYoiEc5fK6ximpXyWFEgqZ40RX//i7cqn66
	NOThBCYemg5MMY1btJrHnxZc9Ir7X4hUlWxJBFytWKRUriOroqwgtmXtiPx4M9eVhzxFydp9air
	uTnQIwVe9NdnLKIPtb6mXEKnu7w9Z9XlqiLqmD1+dvkEQIhayCRCgtiP2qiQe48RAO0qjopVZF/
	VQYnRBer0fGuOZS8rGN0hw6ZU/VJ4QZZz9C2IS2Ch7R3hbJpf+3dkQVihpVftLuPPMDKEKZ8IrI
	peHY6ctCuknGTz/a2ogWfeUpNRuNn/zuV0rKp+N6xwaMtPKkXZeMagBmEB5/L+yM0cm3S43bfkp
	wWZcYJutQBduziI0PdAeRYmwsgrtEWQGzl9YduuJ1LdXQ38swstDK4pPRuiPg9Svm2sBqGpZqAd
	gmQuvb+VrTNil2cCLUNGxSZHpAcq9J/TnMPOeq7EeUh2DkakTAywoWLGujJD8LouQ4GZZEt5bbB
	F0GyQ1IguxIyvOj6fixmpRv5ZrwVfM4v+3Ug5m6sfiU77QeTg3FjcYaz4W+X90Du3nE=
X-Received: by 2002:a05:6214:4b13:b0:91e:87a9:beec with SMTP id 6a1803df08f44-91ea88636fcmr30751606d6.0.1793972221400;
        Fri, 06 Nov 2026 05:37:01 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ea6a638a7sm20768656d6.22.2026.11.06.05.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:37:00 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 06 Nov 2026 13:36:43 +0000
Subject: [PATCH v4 1/8] ovl: expand fsync mount options
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
Message-Id: <20261106-b4-ovl-containerized-sync-v4-1-6ddde0b7dd8a@toxicpanda.com>
References: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
In-Reply-To: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793972217; l=12726;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=zAKuXkDringwd4Kp10q8DoNDDNPh2S1hdJ7wVREgXkc=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBEq63KkvULzXOvOmdf6QM0AQwvVzv6RQQRMA6HSdDHk3tRfhv5HCaFAycFgvNFc+vi2wIChMr4
 qukNlOF7OGgs=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Amir Goldstein <amir73il@gmail.com>

The fsync mount option currently accepts three values:
"volatile", "strict" and "auto".

All other "enum" mount options have "on" and "off" values and this is
used by the generic _check_overlay_feature helper in fstests to probe
for support for enabling overlayfs features.

This commit adds support for values "on", "off" and "relaxed" and makes
the value of "auto" depend on a kconfig/module option fsync_auto.

The value of "off" behaves almost the same as "volatile", not
persisting changes to upper layer, but it does not create the directory
"$workdir/work/incompat/volatile", which prevents a mount cycle of a
volatile overlayfs. Some users requested to opt-out of this guard rail.

With upperdir on tmpfs, overlayfs now falls back to "fsync=off", because
the other fsync modes are futile on tmpfs.

The new value "relaxed" is a preparation for not syncing the entire
upper fs on syncfs(2) and unmount and instead tracking and syncing only
the upper inodes modified by this overlayfs.

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
 Documentation/filesystems/overlayfs.rst | 36 ++++++++++++++++++++++++++++-----
 fs/overlayfs/Kconfig                    | 21 +++++++++++++++++++
 fs/overlayfs/overlayfs.h                | 24 +++++++++++++++++++---
 fs/overlayfs/params.c                   | 18 +++++++++++++----
 fs/overlayfs/params.h                   |  2 ++
 fs/overlayfs/super.c                    | 22 ++++++++++++++++++--
 6 files changed, 109 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 16c35b491dad..1a59500834a1 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -826,27 +826,53 @@ The fsync during copy up only guarantees that if a copy up is observed
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
+effectively come for free.  Other filesystems (e.g. ubifs) require an explicit
+fsync(2) on the copied up files and directories to persist their metadata.
 
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
+If the upper filesystem has no writeback (e.g. tmpfs), a non-default mode
+falls back to "fsync=off".
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
index 92da556598da..5b1a097ce543 100644
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
@@ -668,9 +672,23 @@ static inline bool ovl_should_sync_metadata(struct ovl_fs *ofs)
 	return ofs->config.fsync_mode == OVL_FSYNC_STRICT;
 }
 
-static inline bool ovl_is_volatile(struct ovl_config *config)
+/*
+ * With fsync=relaxed, track the files that were modified through the overlay,
+ * so that syncfs(2) and unmount only write back those.
+ */
+static inline bool ovl_tracks_dirty(struct ovl_fs *ofs)
+{
+	return ofs->config.fsync_mode == OVL_FSYNC_RELAXED;
+}
+
+/*
+ * With fsync=relaxed, syncfs(2) and unmount only write back the files that were
+ * modified through the overlay.  Otherwise they sync the entire upper
+ * filesystem.
+ */
+static inline bool ovl_should_sync_upper_fs(struct ovl_fs *ofs)
 {
-	return config->fsync_mode == OVL_FSYNC_VOLATILE;
+	return ovl_should_sync(ofs) && !ovl_tracks_dirty(ofs);
 }
 
 /*
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 5a15e5478a6b..549fc1e83ac9 100644
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
@@ -153,9 +161,9 @@ static const char *ovl_fsync_mode(struct ovl_config *config)
 	return ovl_parameter_fsync[config->fsync_mode].name;
 }
 
-static int ovl_fsync_mode_def(void)
+int ovl_fsync_mode_def(void)
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
index ffd53cdd8482..5f3572b270f3 100644
--- a/fs/overlayfs/params.h
+++ b/fs/overlayfs/params.h
@@ -15,6 +15,7 @@ struct ovl_opt_set {
 	bool redirect;
 	bool nfs_export;
 	bool index;
+	bool fsync;
 };
 
 #define OVL_MAX_STACK 500
@@ -42,3 +43,4 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			 struct ovl_config *config);
 int ovl_show_options(struct seq_file *m, struct dentry *dentry);
 const char *ovl_xino_mode(struct ovl_config *config);
+int ovl_fsync_mode_def(void);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 19b6d54c4500..81da70fd53a6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
+#include <linux/backing-dev.h>
 #include <linux/file.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
@@ -737,6 +738,11 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (!rename_whiteout)
 		pr_warn("upper fs does not support RENAME_WHITEOUT.\n");
 
+	/* fsync=auto that is not resolved to fsync=relaxed means fsync=on */
+	if (ofs->config.fsync_mode == OVL_FSYNC_AUTO && rename_whiteout &&
+	    mnt->mnt_sb->s_bdi != &noop_backing_dev_info)
+		ofs->config.fsync_mode = OVL_FSYNC_RELAXED;
+
 	/*
 	 * Check if upper/work fs supports (trusted|user).overlay.* xattr
 	 */
@@ -789,9 +795,9 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
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
@@ -1456,6 +1462,18 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 			return err;
 
 		upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
+		/*
+		 * An upper fs without writeback has nothing to sync and nothing
+		 * to lose, so every fsync mode behaves like fsync=off.  Keep the
+		 * default mode, which is not shown in mountinfo.
+		 */
+		if (upper_sb->s_bdi == &noop_backing_dev_info &&
+		    ofs->config.fsync_mode != ovl_fsync_mode_def() &&
+		    ofs->config.fsync_mode != OVL_FSYNC_OFF) {
+			pr_warn("upper fs does not support writeback, falling back to fsync=off.\n");
+			ofs->config.fsync_mode = OVL_FSYNC_OFF;
+		}
+
 		if (!ovl_should_sync(ofs)) {
 			ofs->errseq = errseq_sample(&upper_sb->s_wb_err);
 			if (errseq_check(&upper_sb->s_wb_err, ofs->errseq)) {

-- 
2.55.0

