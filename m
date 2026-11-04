Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793825120;
	b=M7M5jm9WwYJraNa7XW78ZG90LnXTgOGRxMkgtY6Ypg7NXMjcWyHMSVz8QBhAvnIzqYRM
	 AXKpu6cT2pciB5WJ8bM+bATu87Ate+LR7XJeNoAYa/6IP6/q4yJTAK93QKlTcH6Or2kTx
	 zCzKis74AB1IVqMwAGKMaNflVRGnrcseQcubpsLUy9EOIzmWpZh1pYm/UPlbNU4IyzFkz
	 9VTJlO0CQuJvxIQICaSIih3vG0h2Z6GoAOjwmGFeMSK1ZJ24w0PZDpou9HVy3JbJYWN1p
	 uqQU6mGnoYFvxJ7DCzQvppM9UUM+FhUGD7aEUBI1gjsDQ4LXyuUklhj/za6xaCf0hZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793825120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=pUOEmvqO2nPBs/vnRBag0ZBAjgukU/6mXvtGVbPIGHA=;
	b=UKncAv4x3rhDmfyPX0xY1sEyieYWVG5ut7WBexuJAixlyi8WNGLeKnxOOoo9lFWhjNi0
	 /7w9a/a/3yee0Grt+ij48ML9SHTh3jUZWTxMWnLYdo8pIwjCFOdckQjSJUby+BGv9BfQt
	 khuJ877D5gdiCcCt7Lqf2kF9gBpjxQzIlAPrFLgeYiUNjsj0hVnC06egeHDRNwd5kl37S
	 RzzZpFL8tJFOiEhYADgCFbZ7czHNYSsK5sQBAX8qHxnf4u+PjfFid+75ditxSSzFnHPWz
	 uRzPVnLg5tp31HYzB5vcLus2pZKiq7ncyYOj1NNh5pyspuWEi8nqfy+JtcKnGxljVeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=XdahK+Ox;
	arc=none smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C766076CFC
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 20:45:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53C766076CFC
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=XdahK+Ox
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91c76540d0bso12559786d6.0
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 12:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793825119; x=1794429919; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pUOEmvqO2nPBs/vnRBag0ZBAjgukU/6mXvtGVbPIGHA=;
        b=XdahK+OxvWskvQuwZQoNHS7NFnEUFydl4Bea3kRKy9OvgwyeJ1/wZ4OQpo4uvCfo47
         Sr89WXguo4m2ezDpc6y2va9IEM4dCr/5fTO2HKKLOWPtSHeJk8vS+ERii6av5aOwVddS
         eKlOcXc1eznAYRBYsz4YWpH0ciGrFXmwo8By1ZaHGJIeR+Xm2yR5wlQOYBu8jo0OkDVe
         u0SSGI8smKTBJcxWTqFmqFgmM6+CPeXjLaARsQZczxaj6ZN7Xgghm5PC8PD5qQCsHZZ3
         8h2u/i4jQAC3nInv53GAJNuYJDue1Zg+oAhPJW3c8moWQF9Mx4XG1I4iZyiJlhxMWjs7
         8uWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793825119; x=1794429919;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pUOEmvqO2nPBs/vnRBag0ZBAjgukU/6mXvtGVbPIGHA=;
        b=0+jBGc5NhF0/vQ3SQGhXvsHxMnm65hMQQspEbUz6DTj1OVOntVb3B3DKiDMF98STF5
         kjWPNxbmgV4xkB4ZGbE8nYGGw73TGfov32Sjui4XYkSAyJfy/2wglPsOD3K1NP39wo8N
         VwfdyrkpGOVbTBbII/C0/g6TIEbaymS7R56wST2zWoarqjmVjrke4oS/z4wdf67XJM7M
         DSJKtxFfl0G9d9LjVwxB9OnWY5Jb5c9G5razJ8JfFujxool5c+EPUt2STyU5JlCIBKud
         uiKtOLv1jsJmqyWLusSp4dX0aZUKFQqBCGZ1sOdwiu0qovER9poVr//eDlSOKmT/pzSx
         3u1A==
X-Forwarded-Encrypted: i=1; AKwUvBwRANzC0FlbFMkwc6RpjyVJ2BRuH+aZhkYc4BRmWLT+GAh8QUHFpeFDCCgx7ug7l+e74B4hTYZKPA6I4J/8@vger.kernel.org
X-Gm-Message-State: APuU4Z/5SNFi11cMXerAPaeBnLohyncvq/Jj87Z350EwG5G8UiQKcs+f
	pIzdIPajAiuJYjiU33xc6EWLMAxcHIYj5rLwm4pTNn1PaqO+MMjFN3CJZJBw8uRUJLg=
X-Gm-Gg: AYBFou0R740BkdxS9MEfGimQs3PeUYe3AwKy2wpw467Gl4EDG9JkRO4aOV4qDEdja0F
	YK9C4vm5KZRAENKJiPVl6GLQMwxj4w7EU9RuH6RcpiwQ9ufQAAqt+QQL8uMXPFbE+hedPzoUthf
	pFlCfpEaK8JU/FXX+MtjI4OA0W9VEdDm6gZ/Xw5IdbTyQxNIIhZ/apFApV4t6s6k9ylZNGUKjF0
	29PoWmSoKviUeiuQAAnXtKzaHJQOEOhePEdAZdCpE5rt6tcfwkbPu1s/ZZ9btrTM5+424imHRor
	bQaLUjwAubjM9EYiMgmXAtgsDlF+nrl1nsaKG7SPM66wsAfRd2+fhdLm2vEevriqrKB01JfytQ4
	s18PvDfanl5sseMtd2xI7yh9i5yEhb5uAF3BTMAbqIdmPmbVG43BGNfYWOwGAXkpHcQQMKZpL/W
	th0oNoSNwsQXM8f05zwdptL/ukAGJZewBiQiHrM1WyVdspyVS8AdLbeNpMYBtHf41pmplR1RCwc
	N2+dgWrc1WbuS4XjAnjE7w/lJrBpByvbjY5FSs4Uj6zYFeuCSg7gCjr7W06ZjaxcKlYFHvSYniz
	UPWtWRQhRp3Tk/tZu23Sn6u6zGkpOh0spNZjREYMccM3Gg==
X-Received: by 2002:a05:6214:3203:b0:91c:6497:3934 with SMTP id 6a1803df08f44-91ca4a0bca1mr291406456d6.3.1793825119143;
        Wed, 04 Nov 2026 12:45:19 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.249])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7dfdfb5fsm28726516d6.16.2026.11.04.12.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:45:18 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 04 Nov 2026 20:44:59 +0000
Subject: [PATCH v3 2/8] ovl: setup overlayfs' private bdi
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
Message-Id: <20261104-b4-ovl-containerized-sync-v3-2-8daa20144f53@toxicpanda.com>
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
In-Reply-To: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793825112; l=2470;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=4pu7R2zhZWqJzX02Nwqs+oVBvyO3UOflxOy+/AYsBAY=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QGPEyMYPRfd1VbM0h1ipRpFKiZ0SiOEPnYocC4wRCYEdauw50igLApV9oTS618EtMnW7HaznROK
 nSMEkE5RBjw0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Setup overlayfs' private bdi so that we can collect
overlayfs' own dirty inodes.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: only for an overlay that tracks dirty inodes, add
 ovl_tracks_dirty()]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/overlayfs.h | 18 ++++++++++++++++++
 fs/overlayfs/super.c     | 10 ++++++++++
 2 files changed, 28 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 444e28c09145..0ef81c7a9701 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/uuid.h>
 #include <linux/fs.h>
+#include <linux/backing-dev.h>
 #include <linux/fsverity.h>
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
@@ -683,6 +684,23 @@ static inline bool ovl_should_sync_upper_fs(struct ovl_fs *ofs)
 	       ofs->config.fsync_mode == OVL_FSYNC_STRICT;
 }
 
+/*
+ * Does this overlay track the upper inodes that are modified through it, so
+ * that syncfs() and unmount only have to sync those?
+ *
+ * Only with fsync=relaxed.  In the other modes the overlay never syncs, or it
+ * syncs the entire upper filesystem.  fsync=auto does not count until it has
+ * been resolved.  sync_filesystem() does not write any inodes of a filesystem
+ * that has no writeback, like tmpfs, and nothing ever clears their dirty flags.
+ */
+static inline bool ovl_tracks_dirty(struct ovl_fs *ofs)
+{
+	if (!ovl_upper_mnt(ofs) || ofs->config.fsync_mode != OVL_FSYNC_RELAXED)
+		return false;
+
+	return ovl_upper_mnt(ofs)->mnt_sb->s_bdi != &noop_backing_dev_info;
+}
+
 /*
  * To avoid regressions in existing setups with overlay lower offline changes,
  * we allow lower changes only if none of the new features are used.
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4500038d6941..efa4d862039c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1479,6 +1479,16 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 		if (!ofs->workdir)
 			sb->s_flags |= SB_RDONLY;
 
+		/*
+		 * Dirty overlay inodes go on the lists of this bdi.
+		 * ovl_get_workdir() has resolved fsync=auto.
+		 */
+		if (ovl_tracks_dirty(ofs)) {
+			err = super_setup_bdi(sb);
+			if (err)
+				return err;
+		}
+
 		sb->s_stack_depth = upper_sb->s_stack_depth;
 		sb->s_time_gran = upper_sb->s_time_gran;
 	}

-- 
2.55.0

