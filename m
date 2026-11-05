Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876520;
	b=v6bexFUaeJtGH4DXfyINgdUpW+woD7CgKcH+/fl1nktTuUzYjzYDYYHtDyKGlTXjJKUY
	 oM0eAumzRTeUKQxgFVUNXEWFx2FjllZ+EgDgrJZauR8bzFusCI1zaPKNEBY4QR6G6FkUX
	 FKcff/om86ZQJCm9BNavHZm8mQur3JSG+KRTrWiwEAk4VK/w/VLhjLLhNS2rAE3WTWVSz
	 DnkKN6vmPNUOElEYxRDoHJDZYvY7vFkKLO7zvpJu1UzZp7m+EfASOVUDn/xlZ0VtHcauF
	 LMXt/MKQ+1A6N951Sx3mwPt+601EY6hq6OC/Yb8cmacriBV3CaSsDhhMznzmQtxD8vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876520;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SD8HOwk62tgZpS1kF+ga5KcNeoyj0h4UfxRaNn/qS6c=;
	b=c5tA9srxkjK/ZzowjIYmUTEHimwuD7kz1tEcdVN+4xKLVCy3qwGLmHSwMrHkYYU5sf5j
	 /k2FIC5fZR0eLwwBbs4YhJbNlb7KYcgkcTgBDo5/pOsSUWrlSHAjUo4eSIzHIcjfMCcFG
	 6k8PP3SLFT29KFqmQ7CTLLNk7rV3orxRGsPgUBXzIYfOUnf2joUByxK9qiCxZC1HOJkSk
	 GUcexUULY4zokjAnZbmQTC5Wyz9rDJvVk3mvNsbA1x4ZmW27nOyL2ZdGd1IWK/OMdMqP5
	 Di9/5NwjTEGwvUA+a6uCng0p+KGqzVKnPx006qAiePOgzsfId85NwUEHVW0Qd0a2K8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x+qT3FVF;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B70606A326
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Nov 2026 11:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7B70606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x+qT3FVF
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e46e449e8so1053613f8f.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 03:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793876518; x=1794481318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SD8HOwk62tgZpS1kF+ga5KcNeoyj0h4UfxRaNn/qS6c=;
        b=x+qT3FVF6j4/LLyZLmxkyDu6+yM0PbePY77VSB+JMReoKZH7ggyi1NemHnDHIWgDDu
         as+2RqKWrfj707RUZ5PtcFS++UYuTz+B6qtNPPOBncRGhVko9b6M2o/zDSBwQrGmJFPM
         X7bRWRrPkOSg8bIGami/ABYyLTB0a6MJhnqg1JX91wqU52yHDNEjHROrmTmr+QtI2uXu
         SH2xeJeOMbR8sylvPFSZANEmAz/RnhBz4k1U7U2BrQe0F6GFJcIY/OrUEu0thEtOR8r6
         Pim2S3eJVNZNJoviDJVG/TxM0lZUoEL0k3i8ni1tfJDb1oKy5KXQlykj/5KFvuoXJDXl
         bpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793876518; x=1794481318;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SD8HOwk62tgZpS1kF+ga5KcNeoyj0h4UfxRaNn/qS6c=;
        b=eCZowDMrMrMZSeY9bPiJEHfKF+OR2DXZd0BvCviGoO8pPpyXxAebPo7kmViEG1r+3r
         BzbsH3LnvVRbTDCVfY0XMkeVv9ft2R3xnD5Xt4tzBHts2sJwuidg4q4Y+s3/Pz8Fo3TO
         48sssHuFITVYGvMqYdHhHRieeQurBmiUOGXJj59ff3Rxq65uzyWBatVeIawlonRaa2Oc
         fs/4DtxMSHXEsIKJAWLF343PZMBAhQVKj7wUJ0ZlpFI6JZPhuMNoz5AYIpwWQkK/kMW6
         BERok2BmBktOJEBVtWqi9gAGj2H/UNg4cpd5cIs81FKhWjvLj2FuAZqaXTu3K9Egfhrn
         FM3g==
X-Forwarded-Encrypted: i=1; AKwUvBxHtX54iAgMDmFgom7EqTKR+g3rgfhG6GVUXUYcxr8QToUwvnWUaM0MIySvqNa8hfzBatCK7RQtNwLs4Xsi@vger.kernel.org
X-Gm-Message-State: APuU4Z8YqMycZTyzfcS7A/rE5NVPZzgr2epN/ZHvnybyKiOh3briqSAc
	HHilqI2KaCCBwcLaDQOF4XURhQdoM9I9a8TFhGgPs8VB28HzfBh+b39G
X-Gm-Gg: AYBFou2wZS/iBds7kngVeizGOpHWi+3IRrENqzGJei0pz24mFwOBe3EQv+KLWUVKPpm
	Id21XAVoinzluQiK4RlmQmjSZe58tuJiLQy+AM+NdCqC0WDsjMN5kMeurrgSDSSeKByuI9iyLSG
	HaMhT0IQhBfFabHRQ9ULPvAAtV+zrsoNBN87/Yd+zy6Qvzqy6BT1r3jQGw8n/nZmDE8HtpaE3H2
	LO1I1u2NTGBLAp4DOHJ25dpWw/dHyYAxgtfANt6aX3EQwAA8e/e+ypOSVmMmSvlY7/wPM/w1hxt
	M0Yl2DMJyaXY/BCXKqoGmj4RQxuItMFkyGR4I6x8EqtqguzmxScjXjd3SeUwNpMugb5KKwWqaGq
	z78klP9+GcjsuXVUDgAVgs784n4BYMtqb9j8fVtlWHUcFG8L4uZUEioLnu4sIVPvVXtoNcyGKOe
	p54fGhZtPn+cQ8z9YfhKHlDjkc0covbzs3avcL1OGNJd/JqhJzgs2Wc3jSzsnRDUxHVaIzIy0Jr
	VAnh9LwsTPnaw9lfEMV08rSmh+U6ByFwV5dtAQM+qdYjRTsClmhCqNiFI9DKP7pC0SKYcodhZXv
	AxyClx8GdmO9OnV2E150VgxGnTLERiMpkN8OkkKZ/jSHnUfh/ktUASp3GfDc31CGRhVWBAFTpBt
	Z10wbAaNrWFA=
X-Received: by 2002:a05:6000:26c5:b0:48b:e50:714e with SMTP id ffacd0b85a97d-48e6e50d8a5mr38354041f8f.36.1793876517798;
        Thu, 05 Nov 2026 03:01:57 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feda20567sm10007065f8f.51.2026.11.05.03.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 03:01:57 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2] ovl: expand fsync mount options
Date: Thu,  5 Nov 2026 12:01:56 +0100
Message-ID: <20261105110156.3720670-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---

Josef,

There were some inconsistencies between my ovl_should_sync_upper_fs()
and your ovl_tracks_dirty() helpers which could cause problems going
forward, so I included my version of ovl_tracks_dirty() in my patch
and the tmpfs case is dealt with earlier in the mount to set the
correct fsync mode (never relaxed) and also avoid showing odd fsync
modes in mountinfo for tmpfs.

Thanks,
Amir.

Changes since v1:
- fsync=auto that is not resolved to "relaxed" stays "auto" (not shown
  in mountinfo) and behaves like "on", without a fallback warning
- With upper fs without writeback (e.g. tmpfs), "auto" is not resolved
  to "relaxed" and a non-default mode falls back to "off" with a warning
- ovl_should_sync_upper_fs() is false for "off" and "volatile"
- Add helper ovl_tracks_dirty() for "relaxed"
- Document the ubifs metadata durability requirement and the tmpfs
  fallback

v1: https://lore.kernel.org/r/20261104-b4-ovl-containerized-sync-v3-1-8daa20144f53@toxicpanda.com

 Documentation/filesystems/overlayfs.rst | 36 +++++++++++++++++++++----
 fs/overlayfs/Kconfig                    | 21 +++++++++++++++
 fs/overlayfs/overlayfs.h                | 24 ++++++++++++++---
 fs/overlayfs/params.c                   | 18 ++++++++++---
 fs/overlayfs/params.h                   |  2 ++
 fs/overlayfs/super.c                    | 22 +++++++++++++--
 6 files changed, 109 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 4c241d220bc23..620383fd26d1e 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -827,27 +827,53 @@ The fsync during copy up only guarantees that if a copy up is observed
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
index 2ac67e04a6fbe..f1b2f3784c761 100644
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
index e42543d4c1080..40912c2ca2ac9 100644
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
 
@@ -665,7 +668,8 @@ static inline bool ovl_xino_warn(struct ovl_fs *ofs)
 
 static inline bool ovl_should_sync(struct ovl_fs *ofs)
 {
-	return ofs->config.fsync_mode != OVL_FSYNC_VOLATILE;
+	return ofs->config.fsync_mode != OVL_FSYNC_OFF &&
+	       ofs->config.fsync_mode != OVL_FSYNC_VOLATILE;
 }
 
 static inline bool ovl_should_sync_metadata(struct ovl_fs *ofs)
@@ -673,9 +677,23 @@ static inline bool ovl_should_sync_metadata(struct ovl_fs *ofs)
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
index 5a15e5478a6b8..549fc1e83ac95 100644
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
index ffd53cdd84827..5f3572b270f36 100644
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
index 8bc970748b96b..7dbe138744374 100644
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
@@ -758,6 +759,11 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
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
@@ -810,9 +816,9 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
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
@@ -1476,6 +1482,18 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
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

