Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320704;
	b=Wrww5Ge6DV1c9EkjR0xalFq38c/j1qEbJS/+/HFRYuEQj4rQRf/SllNNMt+8S3bnTHcs
	 nPwZKaQieADo3ef0lDeTD0Hy55skKr8lvOwfyr77YxCoY2vZfAdUCyyV67AWdJQSnGRbI
	 qGOIpgVc1f+/04/f2IcLDnKaDRhf2hRfirhsLfcc+5edHh6V4EEfcktTkMoYXv3wgW9/g
	 9Hx6/ymcRZ9oTH1vQ6wpA6hxQtr7AYQ+xX0bHFisL0t/astu1Z52+f3rofE1gW0RAtckl
	 O8lp47SIKAffyA0Nyt38dIa1Q9NdsTc9zBiHi5bh/8dOW4Dpb8ppKdPwu69aTvI2utA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320704;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=AECngfj1kAfXiTFqlbWklHQFFBTR9hHj+ExNCNNt7RY=;
	b=Zkac8YdCw5NVp1Ih08Gni4oynIeyiEUwBLdPimY/ywqVWKssfcoEpw6azL2PPTNEo46G
	 L7mh+XG2fPQlLb19VVQEJB5NuZPZk3beK0j372cUVdA9MPEbYTV+1r081P7y3JOfiQvYi
	 ut+Hut6+xZ9bN9+nWWf8ccmHthBwf+vUYarqOdyQa6+DhuWO7Y4YQQ1LI8TMT3BwNxq38
	 rRd9FAkf23QFR5AJ/6UkLQoJU+mhk3W6PWE5ZWhyDpldsQi2bY4Ri7mBRVajDoszkPvyH
	 9S5RjpOTlB0vfagiURdBru0j7qQr+5O6l2Hdf7GiiKjQ1k5iTv/CVvWZDO6u56RM80w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Y1j0sgIk;
	arc=none smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE3F60A2603
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:25:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BE3F60A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Y1j0sgIk
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-53644b28706so29794141cf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 06:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794320704; x=1794925504; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AECngfj1kAfXiTFqlbWklHQFFBTR9hHj+ExNCNNt7RY=;
        b=Y1j0sgIke1EnPt7QGEx04D8rwApGJK4wopPxBRDZ43IbZJOxZaVoHP98k4Cdx+mJWM
         nrLdyakyGPL+2l5hndn8IkdTHQeQSitXIo3DYeaccutEj1GBUnGlBxNs1uVB7k6WtJak
         sequH1FfwmzMFfsdR4PzxFu00Mfp5TXwBGmdemJByUYy4X9AQxmWvXMXQMF9PYjxnURB
         AmDmllfhz2POnMEyx+T8a/aZfqvUr5GRhsFur++ttbkMnc8OUx0XQzMg9Od5U5IBLmCs
         dTQtSM5GixpTIwVP5U+H8o/GFHta97YjHXb0q8knOSoH7ggWlPLINjCUIIl4ScnHL59e
         RCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320704; x=1794925504;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AECngfj1kAfXiTFqlbWklHQFFBTR9hHj+ExNCNNt7RY=;
        b=zxD9HuFnDJ6DkTC8V9Tj9+neOQgVUDyp7q/TCnP59ciovgueb7ZjgRrW8xR0BFYTGN
         +wWAECnYRqH4hI+hVbwAkXXpmPCXKkmJSiR6juyn99SFREcZ3ed9OIMmjLqYO42/NHA9
         sYOJijNvmV63aJaiqaeIUb9EGYwbacD+c6rLQCfOlPCTEAY8Iif5h5h/zHCD5eIMemN6
         PS/M1mZiGjyxIdfWtvlrM/eAU5R0RgHZWsx1s4PwUsJAt5xZOj4KJcRHS+geMYiN9/hQ
         RfiAAoBcCEFFkw1G27W/LPHI+d8uikm9dwlUh2foU5vnwzZS9BgrGKIwBVetloofKfQe
         bM+w==
X-Forwarded-Encrypted: i=1; AL+hErHGNuT5zVO6znqdK5GJNikiJ7NdzXb3cvOuX6M2PiqdRXI+h53Ohgh9DqEY2GEXKcjdcANAkHnJHlojSY+f@vger.kernel.org
X-Gm-Message-State: APuU4Z9R8BAcQ8bYOCovoHumV+dj7XgtYfGsPgrxX9Rsjv8i6pyFY73T
	O6ryeZmGPAylppiLRG3MRrd2/xgcrmhI9ZDPVfwo0Rhfi26nIRFptDnITM+Oub3BHDc=
X-Gm-Gg: AYBFou0CkIiH0h4CS0hOSgMjxoLKeEWADdUtdPg2E2mfq20/AESogpdqIzgE037+EZc
	9xzp+g9A81BUDinow5D2Jqj2UhiFqPsyOIahT+4LAun1e/cLnAtdyTkmAkFFOEp2+njqnOyE//I
	hW/6qqa5k9p7m9zFOklEmoJW95y35bPA+Qly45kihKPXbk6rKnw0w6lpYlV6lKOORqNp9uAytsk
	sAo6AbqVrrGounOGs2tPSzr2mFoxaEXIX5VeDPwOcxx+SBruXvxZFNN+Pp5brwc1LNnobu/V19u
	1OHSABeHJY1QzWjordr+4AALyQ3p7mJYwbB36nwJ4lMn4HZNq9Y8xwABGsE47np4w1A2CxVk7kA
	GWgZxWdDZybdQ28UAjlMtDHntxgUN8U9IUB9SWSWcmWssW33mL9KMPov+vyNcdlzKCaPrhWN1gm
	8opavBbnuuqmms4CXU+U4eK8r4Trb268KCduF1jrl/AZIxGr+7UQNbvxyCMoekio888GzRMiRe0
	3XmMBRrm13PPLo4gUoDY4+OO57hCE55wUuSvCWIa3bAyNzXyfsN4KoLUElZCFbS3IJadOQUewgz
	yWW+wFBHxboLoAGsMlk+dBsTR8x3y36blHqVPPBa1rzEvg==
X-Received: by 2002:a05:622a:653:b0:535:15a9:2516 with SMTP id d75a77b69052e-555291c2894mr41649641cf.53.1794320703461;
        Tue, 10 Nov 2026 06:25:03 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.243])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550c21e1fbsm24834331cf.27.2026.11.10.06.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:25:02 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 10 Nov 2026 14:24:50 +0000
Subject: [PATCH v6 2/9] fs: add sync_fs_and_bdev()
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
Message-Id: <20261110-b4-ovl-containerized-sync-v6-2-43d1be16a4d6@toxicpanda.com>
References: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
In-Reply-To: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794320698; l=3481;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=cFXSmoX1EdwKarrdrXPJnOWTPV4jjSodNuQRhzCnuDg=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJ7Xh6/QCyzvojjwCLy3DO4GMiUz+R8OGkR0vYdjGesZqw+SMpDnXvivajMC5tvY86ahnHIHU3e
 WVsd64FGGzgY=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

sync_filesystem() writes the inodes, calls ->sync_fs() and writes the block
device, first without waiting and then with.

overlayfs is about to write the inodes of its upper filesystem by itself,
only those that were modified through the overlay, and needs the other two
steps as they are.  Move them to a helper so that overlayfs does not have
to know what they are.

sync_filesystem() calls the inner helper, so it still tests for a read-only
filesystem and for s_umount once.  The exported function does both tests
for its callers.

No functional change intended.

Suggested-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/sync.c          | 52 +++++++++++++++++++++++++++++++++++++++-------------
 include/linux/fs.h |  1 +
 2 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 0681bfcb2da6..c5e49914918a 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -22,6 +22,42 @@
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
 
+static int __sync_fs_and_bdev(struct super_block *sb, bool wait)
+{
+	int ret;
+
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, wait);
+		if (ret)
+			return ret;
+	}
+	if (!wait)
+		return sync_blockdev_nowait(sb->s_bdev);
+	return sync_blockdev(sb->s_bdev);
+}
+
+/**
+ * sync_fs_and_bdev - call ->sync_fs() and write the block device
+ * @sb: the superblock, the caller holds s_umount
+ * @wait: wait for the I/O to complete
+ *
+ * These are the steps of sync_filesystem() that follow the writing of the
+ * inodes.  This is for a caller that has already written the inodes it cares
+ * about.  Like sync_filesystem() it does nothing on a read-only filesystem.
+ *
+ * Return: 0 on success, a negative error code otherwise.
+ */
+int sync_fs_and_bdev(struct super_block *sb, bool wait)
+{
+	WARN_ON(!rwsem_is_locked(&sb->s_umount));
+
+	if (sb_rdonly(sb))
+		return 0;
+
+	return __sync_fs_and_bdev(sb, wait);
+}
+EXPORT_SYMBOL_GPL(sync_fs_and_bdev);
+
 /*
  * Write out and wait upon all dirty data associated with this
  * superblock.  Filesystem data as well as the underlying block
@@ -29,7 +65,7 @@
  */
 int sync_filesystem(struct super_block *sb)
 {
-	int ret = 0;
+	int ret;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -52,22 +88,12 @@ int sync_filesystem(struct super_block *sb)
 	 * at a time.
 	 */
 	writeback_inodes_sb(sb, WB_REASON_SYNC);
-	if (sb->s_op->sync_fs) {
-		ret = sb->s_op->sync_fs(sb, 0);
-		if (ret)
-			return ret;
-	}
-	ret = sync_blockdev_nowait(sb->s_bdev);
+	ret = __sync_fs_and_bdev(sb, false);
 	if (ret)
 		return ret;
 
 	sync_inodes_sb(sb);
-	if (sb->s_op->sync_fs) {
-		ret = sb->s_op->sync_fs(sb, 1);
-		if (ret)
-			return ret;
-	}
-	return sync_blockdev(sb->s_bdev);
+	return __sync_fs_and_bdev(sb, true);
 }
 EXPORT_SYMBOL(sync_filesystem);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5485f2c1f2b..094a4be6828c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2617,6 +2617,7 @@ extern void __init vfs_caches_init(void);
 
 void emergency_thaw_all(void);
 extern int sync_filesystem(struct super_block *);
+int sync_fs_and_bdev(struct super_block *sb, bool wait);
 extern const struct file_operations def_blk_fops;
 extern const struct file_operations def_chr_fops;
 

-- 
2.55.0

