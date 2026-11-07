Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794079189;
	b=wVAxzEDc6BtGmgsqdF6HSPdzjGXJBV/ZxZQ67AfML6IbyS50PcS2snBFhg4FJFZc8Zy8
	 dO3mieLpUL08MtryR5tGSq687hl0htH4vnrzHAb8NLQgBO7hICHHO662rs43gE5dWrWGg
	 XWMuFTBRbJZZ5wdtt13/62mA2bcamGyHewWvos4nSqci66B1FZaRVplqA2I3VlvqmYwbW
	 5JqWJ+MvHHIrxJDGPQy1tscJYGbqtu99wxedGcljiobzLsAy9iEHzD+iBHqU6dgFsFrV2
	 YzsYy/9jchO4iOAWIPqFbBZj9dJFWaLfMysbW1HN0iqPhV5Q2epvkQfBQRrhJm7zolw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794079189;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=R22Hkg58AODA+U2Qc/D03rkLftDWo9zEEkg5H+BLiYE=;
	b=lxqRuDRna72lLawXLhZZ1pRh9ba/QEeKHcsznLRYViSJJOKxpdjef0a+HmzZRfWPfILK
	 WA8sOOvJq1pkUrzwrwNqY6GUrKL8T8Kb5y1+Avb3+/xiFLtaDxd7nyjjif/KJ5KAs0Dxz
	 0A06oMEDZaSMlM1O84+34Th/1ZmjRthwCn6lIK9wGng637fKY3E9Vaw2dAhoBacW6jIlO
	 adio7iqnsd1Qa78XZ7nEbBsrg9pUTqcaLAuBgaIzqBsx8L1SZu/MLixsrlOMIP5pEiNEU
	 0VBN+8ASl9g+i4uTKneO9qqBPI2Hw2voHJuqD1sZQtdlvdNnp5Okk6gyKoIQqHtRXog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b="H0/Wxx7h";
	arc=none smtp.remote-ip=209.85.222.173
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5B5606A335
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 19:19:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D5B5606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=H0/Wxx7h
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-930c0f9c1b1so194948485a.1
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 11:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794079187; x=1794683987; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R22Hkg58AODA+U2Qc/D03rkLftDWo9zEEkg5H+BLiYE=;
        b=H0/Wxx7h8swA2utQ8Uv0yapkZD1GFXaLvCbAYVYLfck1Bn2g1oGJTUGDwsHciDbPVI
         gsoDWJ/ZSXkXH1L0sL2C6ljN4zM1yO4BzMJWK9i3Gp/55ACxkrjdIb7QhBO5xzpQXQkh
         6D602QPHpLOYtrSA1Ziu12NVPY+IP385v1gVe+6Z3Kj98DorcQH/b6RpaLAeDZNLxJ+O
         B/OEp+fvmKlmrfABiQ8eFbhcQ1CoiuD42WF7zsDVa91i1sDw2VPwehPmj6ImshRU8jQT
         Mk0GSpa409u84ua9nrzEj4Igz6gikJW0/toSl+CVpAuor6xgIw6yCIIvbUNzFrtfkruy
         JrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794079187; x=1794683987;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R22Hkg58AODA+U2Qc/D03rkLftDWo9zEEkg5H+BLiYE=;
        b=RH+PUG3qYtADONy1V+FBXi15rv3Lj+nFQsLR42K+vH7VvvlcvHgcKo2B+Kw+bxRceL
         O7R7j4lZ4U1UGnLZhcXvMeQJxuNduBbZpdxWDN+z4+706r8w2urkaLRlBB5TWCjRgB08
         CIvw01jVBFTV4kspQpfUurtsycVgeU17b6ZaFJWPRbu9hqCRD6NDCJNieLX4x0UnuUPc
         QQzuxB41SnLOY6n+R4GBJti3C/PNPD7XNpaJlKJUsyPE4Yx5Neaq9nScT5PEf3xirqUe
         QflE8yrdAY3B41NWpJXbNivEsT5C1xKoCcJ/PAnaYr71+7wjloUt5FFMMKcEn5wyljZs
         tJow==
X-Forwarded-Encrypted: i=1; AKwUvBwJepnGIT01Dfm1JwEjhsBixWWjOr3sQMvthgMvCov+EcIZQBD0qHf/Uj9OCxMe3LSZsqG5yBCwsyAwu3qt@vger.kernel.org
X-Gm-Message-State: APuU4Z+P9dS32r5mlf+fy/lc+AK8xDolfibiIgGDQ26BmP2+FWOHWvse
	S9p1mzzSBZePggyDAXaxJG3PpUZbbDYiZxbDEkI7T080+DEO2kmvVETmg5NifhFe4yc=
X-Gm-Gg: AYBFou3mKszalZhSvMG+GksCx+o4cj/qfHfTvX+kKC3TEUFElycny1CO6OmqMdCQuLB
	DcHoXVED6XpxQ+RVOMfinjwI692HIc1GYEeioMM+eMtbb9v4c3kb89dVUpNHXSRgTPir8D3GvGh
	xpDukXFJP0lMJnYH4xCDwG6KVXPzJZUnOXS0ZAC61aaAZ7mcb4wtgQSe6CEFq8MXdT6DBC6n4qY
	jw7UXrlGHOHwmgh5m4sCnF795E5jGW03vEWOig8Vn+nRG2vaR4V/k37/NmjhylQDKIpAYdLQp62
	Ai0Eq1YXXdM4gkz0644J/K1D8nfbRZyzUu1P8PNN7I9jdCxkTz586JxeolIGi8psiL+Vh/YysLW
	u2Bs541B4X066I/IlaEbpyUbiCCRJHcXpXevfJNq3GL81lgioJrbLbxk0fH4lUblrxsASpE6K+6
	5PKm3QuuxOmgfESYDOz0BNUBwEISsyXy4ypH2IE6Z3xpAzXCQFgmqe3C3YQ+PyMfFgc3YDSrspO
	mP2mRh6n8+g4t0E9Shjl6QVgUf7DhpI7ZpgdyPxm9uOBC2hVYhELF/nDF+MNzB7dowCgt7bxHmf
	Uu6NhHuKTrNjbR275E8yDs1Pm37/qkPYa4diLLaAJYdKjw==
X-Received: by 2002:a05:620a:808d:b0:93c:7a5c:77d8 with SMTP id af79cd13be357-945f32f726emr992240185a.4.1794079186954;
        Sat, 07 Nov 2026 11:19:46 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94782d61911sm3427785a.8.2026.11.07.11.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 11:19:46 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Sat, 07 Nov 2026 19:19:30 +0000
Subject: [PATCH v5 1/8] ovl: expand fsync mount options
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
Message-Id: <20261107-b4-ovl-containerized-sync-v5-1-d34b4ae57fdf@toxicpanda.com>
References: <20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com>
In-Reply-To: <20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794079181; l=12726;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=zAKuXkDringwd4Kp10q8DoNDDNPh2S1hdJ7wVREgXkc=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QB5sfdF3Jgwd3bstBJhFyt+nmEYz/q+mrWgTDdHsEEYvZOTUd7Xw7DDmqayphJEQiA+780iQXmd
 VYrojtAI3zA4=
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

