Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793988904;
	b=gDtze9fZwcD2qD5shLfmFBvnwyy73rEQVI73CemQmVgaOMTLJHsdq/0gm+kcUpSA1mgD
	 KNeYmdH1IiEcODPrciswNaoH70ujQRNw1ZIqVPqq1WswFRE6NriRHtE2PKYc2HMPJbZwy
	 FJz5kFAamakrZHiaVSBeiE4+mvd8pRuPLVoDi/gT6uZjistPneGch3m/imQdRmF5vVRrg
	 hBHNFGPzwx4Uoy2L0nRGc8g6WAG8sWb4K+et1vaDo2191pO/kZ5Jj3cinJ6kLIqi6ShsC
	 SjtAovvj1cHmvhz5xurVTt/FHWhgVjTnmvo+dcSdsMQC7dbJ5iWdQRfgLyy/e0T0QMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793988904;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=DfnthQGT530XBD4xK8fouGBMfFf3/AWAiNhXHcUmwcA=;
	b=SnrDtdTzb1alhracFmDT6zvSYlzzeiNaKjrh7Q3r7d6Bou+chklpzQcs380I+S1jN5bz
	 9dR/s3cFHKDIBWJ+QplBHenmYavEKWrQpn55xkXUZ8UawKGy8D0hlEiajzjJBIswFO8rI
	 PTLKCfOCubhPN1SsVOhHZ0AfBnZddC8WT9MmVTAYbrZDDESPIDpePIi+QRui9cL1bjzp9
	 2yD9YqnjTg/MOjfRj2kwynI1/i+H7XUkJciGNrHligKQJPorwKy1Jkw/ZLv7F9yvxCEPw
	 tkJ5neFvtu9FQu91H4P4PUuxZhTVDGckU4NfMOGctT2bs/cru4E+cudqJGHyjsBtUKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvz.org;
	spf=pass smtp.mailfrom=openvz.org;
	dkim=pass header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=NyWNLTh2;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA73606A32F
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 18:15:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AA73606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvz.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvz.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=NyWNLTh2
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a5720b0a57so12648235e9.0
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 10:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz.org; s=google; t=1793988903; x=1794593703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DfnthQGT530XBD4xK8fouGBMfFf3/AWAiNhXHcUmwcA=;
        b=NyWNLTh2KuNktgWrvexNqLWSKsigmjEJFnz7uOMCFLGNIU8KwqCL4Vs0HKShgn+vx1
         Qn/KQI28LgJV3lJidR1yF3kS3zjnNKU+wlyTyLPWHjTISQicY3Su0KmVTKEeAcv5EBzK
         m4Lf1Nmhep8RUC9dt/LN2OtJfKDeULe/8l300kQingBcSuRG2Xmrk7bMvR03g/CIijt3
         xD8uZRYYuTtlzP2b1x/BetuusQ10jCDMf/dZHjTWSaGXNG1GxyrszAfB1IWVf8xd5qJS
         lQiEhZtjWRuUY6Cy6uF2ucgk0Zhq0b/1aUz28uitWx0NAL4TYgkK8hiGRfK4dRu5QZVK
         x5BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793988903; x=1794593703;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DfnthQGT530XBD4xK8fouGBMfFf3/AWAiNhXHcUmwcA=;
        b=OBIZEes2bFIaLjyK08zaNALub3bVhwUYCXgFHMjUcxjypCZg/9VCzbNkd3NasQEOp1
         EodkhUcROy8gkHUBofK5YM2QNWHQAWN3BN7xk6ezcw2YdRr0yKTQmz1XP9JBF61OOSbS
         1v7GnGnZSJHmQXm94GM41Di4+DUAvaSmuwm39xf/N5LrJLKJcKJvIIx9zdlXMlwbWZ+t
         A7k+stAIfUBFnNK291QusL4NMiN1G5V0dwsHMB3gOB95ykLTQc2b3xkodPJ7UYPfQq/q
         RsSKMQsVUWdgHvtvMop1sWm0+miX2oL37zY3VY8ZhtfkW+ll+Op5sRogBYAS3+iZZ2+K
         TQRg==
X-Gm-Message-State: APuU4Z/w/YF4QZPGbZc+fSCoSe+/Rj30SGCgiezS/Mpt2fJRLDN4RNIO
	9ENjXIzyLgJ9mYeTsWD5/ws83X5HGh/LbdUUfo9aXTWDqMaOzB+6zCRVhhg4ZsGBF+CCyJq/tGe
	wdzeI
X-Gm-Gg: AYBFou00nf6Er/3bhhWaq7rWzNewmQh1LbUWYXhXPujuMkuDOcHGKJWNnRVuUbRF8UK
	J5pVBypHdgHH8YCTsP5j4rHHh82AFf9+aCrcQG2L+KefHUSctBlEhXogdHNsXaE7m9nhjx5tg10
	8P5l8xR0D4XX0jZAuV2qVIgMw0GWJc/DATMsrD3MM/LIXU39k6+O5IZPBSBmcrDZon5MNCVFwU3
	pi7mdNfl3NZ4GT0rLiX4Ft3RpitvA/U/UMNqlei+EyFVs9G5wmFpNsbqAsOZ/wxJ8vVh10G9t2A
	VXAW4OWwH4+FoPQlzPFnrig1NIP4cIpwA3zqTToE5LjoGsdqJNphBpJA/U4RpGmdKYhx2VKD5rP
	FxXLZ3TUZ7FBvwgvc5mRCDpEA4uX7av+CTnK79RtpgqbeC7baizND0ZludEcm0XUswcg1/oril7
	l9jhgvhU0N1xJ5wzPz8jE4/srwwOMpcLIgQXZBpf0zR2JMd8IcxsGgkr9Sw5ufsmLrWiIevb6iN
	TAvQlKjxLqtOV/OwysdBIJrWgdv2Xu2YnUI516UXEp3q1tz34CyCESJq4BD2OLbX3JWdJZnbYGE
	ODcCwQko2oU8t1Fjkw==
X-Received: by 2002:a05:600c:8b05:b0:4a1:efbe:529c with SMTP id 5b1f17b1804b1-4b6dff855a6mr64101605e9.12.1793988902485;
        Fri, 06 Nov 2026 10:15:02 -0800 (PST)
Received: from athena ([2a06:5b06:b600:300:1983:68c3:80e8:4ae2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b6ed5b8159sm71788845e9.2.2026.11.06.10.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 10:15:01 -0800 (PST)
From: "Denis V. Lunev" <den@openvz.org>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Denis V. Lunev" <den@openvz.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH] ovl: release the upperdir/workdir in-use locks before the umount sync
Date: Fri,  6 Nov 2026 19:14:59 +0100
Message-ID: <20261106181459.4166343-1-den@openvz.org>
X-Mailer: git-send-email 2.53.0
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

From: Denis V. Lunev <den@openvz.org>

The in-use locks on upperdir and workdir are released by ovl_free_fs()
from ->put_super(). generic_shutdown_super() calls sync_filesystem()
before that, and ovl_sync_fs() syncs the whole upper filesystem, so the
locks stay held across a journal commit and a cache flush of the upper
fs after the overlay is gone. With index=on a new overlay that uses the
same upperdir, or uses it as a lowerdir, fails to mount in that window:

  overlayfs: upperdir is in-use as upperdir/workdir of another mount,
  mount with '-o index=off' to override exclusive upperdir protection.

Userspace hits this when the last reference is not dropped by umount(2)
itself. Docker with the containerd snapshotter mounts a snapshot on a
thread with a private mount namespace for docker cp and for buildkit,
and the superblock dies when that thread exits, after the reply to the
client has gone out. The next request then gets EBUSY. The window grows
with the flush latency of the upper fs and is there even if nothing was
written through the overlay, as the mount itself dirties the upper.

->kill_sb() is called once s_active drops to zero, with no mount and no
open file left. Release the locks there, before generic_shutdown_super()
runs. What the dying superblock still does to the upper fs, the sync and
dropping its references to upper dentries and inodes, does not touch the
contents of upperdir or workdir. ovl_free_fs() still releases the locks
for a failed mount, so clear the *_locked flags to keep it from
unlocking a second time and dropping the lock of a newer mount.

This takes the sync out of the window but does not close it: the final
mntput of a dying mount namespace runs from task_work, after the exiting
thread may have reported completion. Userspace that needs the
directories free should umount(2) before saying the job is done.

Fixes: 2cac0c00a6cd ("ovl: get exclusive ownership on upper/work dirs")
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
Tested on a 6.12-based distribution kernel, where this code is the
same, with a reproducer built on unshare(1) and with docker cp and
docker build in a container. Built and checked on master.

 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/params.c    |  5 +----
 fs/overlayfs/super.c     | 12 +++++++++++-
 fs/overlayfs/util.c      | 12 ++++++++++++
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 901335026a20..85e167a060f4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -583,6 +583,7 @@ static inline int ovl_set_impure_dir(struct dentry *dentry)
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_is_inuse(struct dentry *dentry);
+void ovl_inuse_unlock_all(struct ovl_fs *ofs);
 bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry);
 void ovl_nlink_end(struct dentry *dentry);
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 5a15e5478a6b..82e270711dbc 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -849,11 +849,8 @@ void ovl_free_fs(struct ovl_fs *ofs)
 	iput(ofs->workdir_trap);
 	dput(ofs->whiteout);
 	dput(ofs->workdir);
-	if (ofs->workdir_locked)
-		ovl_inuse_unlock(ofs->workbasedir);
+	ovl_inuse_unlock_all(ofs);
 	dput(ofs->workbasedir);
-	if (ofs->upperdir_locked)
-		ovl_inuse_unlock(ovl_upper_mnt(ofs)->mnt_root);
 
 	/* Reuse ofs->config.lowerdirs as a vfsmount array before freeing it */
 	mounts = (struct vfsmount **) ofs->config.lowerdirs;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d9174eaccce2..c7018dde1228 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1609,13 +1609,23 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	return err;
 }
 
+static void ovl_kill_sb(struct super_block *sb)
+{
+	struct ovl_fs *ofs = OVL_FS(sb);
+
+	/* Nothing can modify them now, do not hold them across the sync */
+	if (ofs)
+		ovl_inuse_unlock_all(ofs);
+	kill_anon_super(sb);
+}
+
 struct file_system_type ovl_fs_type = {
 	.owner			= THIS_MODULE,
 	.name			= "overlay",
 	.init_fs_context	= ovl_init_fs_context,
 	.parameters		= ovl_parameter_spec,
 	.fs_flags		= FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
-	.kill_sb		= kill_anon_super,
+	.kill_sb		= ovl_kill_sb,
 };
 MODULE_ALIAS_FS("overlay");
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 521717209b2e..517d503fc557 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1050,6 +1050,18 @@ bool ovl_is_inuse(struct dentry *dentry)
 	return inuse;
 }
 
+void ovl_inuse_unlock_all(struct ovl_fs *ofs)
+{
+	if (ofs->workdir_locked) {
+		ovl_inuse_unlock(ofs->workbasedir);
+		ofs->workdir_locked = false;
+	}
+	if (ofs->upperdir_locked) {
+		ovl_inuse_unlock(ovl_upper_mnt(ofs)->mnt_root);
+		ofs->upperdir_locked = false;
+	}
+}
+
 /*
  * Does this overlay dentry need to be indexed on copy up?
  */
-- 
2.53.0

