Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794079190;
	b=VEHaAi6IffdofNU7v2p/gcO6LxagmL1WdqyZeBsrS38fUKBCKF7IYfqpAYvyel1HR9KJ
	 KFAyuFUkt6mb2uxY089NyrbOCDCSs8bJe9g29uHZ72FMwr9VfrFrMlazQz7TTNuqcASYt
	 8Sdeu/afDw+bxs3bF2DmNcC6WtJ+aFTbOaIlSVwX6yX7YfyAVUkYwV4lnWMKe6x3FlleA
	 4AES7Uj05tirwHgImJ7TDEbq09xYIeOuQ50oLbE5rneZcv7G0cZUqvjG3CYOcBGubUiSb
	 N3f07DmKrMJYpX7noSrHDN8ydBhpP3dgH7JHjPX6peZJFx9ZzBKL7zTAL1KAhCp1ivA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794079190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=AECngfj1kAfXiTFqlbWklHQFFBTR9hHj+ExNCNNt7RY=;
	b=bRg4KKX+WAIwzgLbrBDnVSe6XDkec825DMfgwc9rdUFEjHClE887SbXgq663EfxcVNui
	 G5uu6FxQ2Bm7oVnwJPrKGxqZ++k/YL7eMm84j80HTke+/MCehmI+4G84zHuYy+/zz6EHP
	 h/UeOVGHP4sG/HGYDg2l1utMaVrO6SrasLxIjLPmwWvp0p0lrF6TzYxRctls+zvvr+cTd
	 A6gE5q+2Ciap8K+VMNaehZ4htupCTqPi5WDupuzYyEhcvt5T7UIEhHfLH4K5LMKib6Fo1
	 GDTWJBOZxnsuBr0GzKvnaRz/7oDriTRgCeu9V8y2YaFt/BpBbzfrSxmQ3UimdNemGwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=atrO16bh;
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7213606D809
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 19:19:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7213606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=atrO16bh
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5430f70c827so41621cf.2
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 11:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794079189; x=1794683989; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AECngfj1kAfXiTFqlbWklHQFFBTR9hHj+ExNCNNt7RY=;
        b=atrO16bhGTnlbBlzeTBDk2KmB1FcnhP1847+LPPf7PentpW96epXS+BnF2Mog7Sp2f
         x0IU7mJaQaUHboxp+t6XS84V5ISAXWjErJgOksvKRgLJQ66OZgvI4aS9k5/JYmUB2137
         6T91RglWb2XB19K3e0BN9kOHWQmsX2VhZeJsj637xX0l3VR+i4kovvYJbdQBS9kUi5v5
         YK+9gSWOyWIGwikV1zj160sBMAZapuu6MBgqTlx9VPORxDLfNfmpznS7AFt244oJ2Pxe
         1L6P4xxOvLDGcTWBYozCF6+vOdWkqAr46Loisk+8e/ntl069d6HM6Jq+LgMXo4RoASVR
         zpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794079189; x=1794683989;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AECngfj1kAfXiTFqlbWklHQFFBTR9hHj+ExNCNNt7RY=;
        b=mYvhSTo6S3/BcTy/xev+wpvRYo6EbssXNv0St/005v/WjLXLl7AlYakd6ssEnBGsr0
         gPC3Emy0YxkrPysH45VdCLyaEfY9qlHfyVDUrbOWCLsGb8oXKb8C+IxuFIojZEW4E1+7
         f2OUSx+Ex9V9PvRhWS3dfqUFNTU166etAbKyQAEicNezDzCKXql81fgV6DeWYk8K6FcM
         13YyDrJoGp2dwymaNMauK0CWVMERKqlVNMJPXVqkajWdLlbk6PiPNwIwWhnoehdmeADg
         Nms/CouvAV/OCdVR4mcaA+NCM1XwonWnsW4l9iiMDhsraImtflau6psWVvTjMYDTzeap
         xZ7Q==
X-Forwarded-Encrypted: i=1; AKwUvBy+00wI2QAfDlw2o+naZmYa0XVW8+UvXobrswQMVc4WyNyoXATxmo0JCe5XaM5SGTxzubzJ4ZVhc9kLrsqM@vger.kernel.org
X-Gm-Message-State: APuU4Z8oBxxkQoZdmKvmmD4ivdUVY9zJIQ1cTMI3533wsWTvva8ALISA
	Y9eId5JnVlwdatK3BPTIzmaPHxXRLfVQocCyKJsEqXdhcx3afIA+Q+noGrO8M2Rpkwz8IZJdD9u
	dLkyc0ME=
X-Gm-Gg: AYBFou1AfsDRXN9hi+9/TM4aTP3q3TbJrZf6u7uV26BFjO6yYuj0XhWroyw6MuLGBrD
	9yz5Dzz1CFh05eQAarwRCzBZkzkLLhplJ3A70bjtohlBtV11/V8JYqbVzOWLYTIMEg3SH7UXASt
	i/fYKVTPtyoTuY8uizgTtPTKkMPCGxhv7kTgA1IgYhWpTqH5+9Q3zGxQ6wcngC6rqazo/KthkjP
	NIJPRU+DgOQn4RaZrLNXObZsMI2Wn6arBFlpC4Qy6OJl8nkRgjuxdpsH8XdLZqkGet4YAQ/p9g0
	LbalqEDIrLbQexuK8eSZUAM5+G/uw9fadSA98d8qmEk5WgyYvMFRfO2i+jNzOus98VkT4B0flpx
	10XB/S4bDXWD3ypPhOhfDzxn0opwEk/jkkJbFNWVH5ijYaNB+fmHg3uPgY9Dq12Ddw4ilmdNO3f
	xm/5orWUUWfFabt8AeHqYoCgG60DzYik6f4pmnXJ4TTXinffBCgkSV/pcVQnLVHXQCB/KhZvjuS
	YdHpHvli7M06IpJpANr9237ZETQgIoqY0TLu2sa/pgP94E76cIR9hPj4DRJ1HnVycv/l2QdS642
	NWqPqfHaSWmPFm9h2RGbRLNQqA3qx7lNYJ2lF+FEcKqT5A==
X-Received: by 2002:ac8:5dd2:0:b0:533:73b3:ab37 with SMTP id d75a77b69052e-54e1329a2b0mr97397381cf.21.1794079188925;
        Sat, 07 Nov 2026 11:19:48 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-552649354e5sm512041cf.24.2026.11.07.11.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 11:19:48 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Sat, 07 Nov 2026 19:19:31 +0000
Subject: [PATCH v5 2/8] fs: add sync_fs_and_bdev()
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
Message-Id: <20261107-b4-ovl-containerized-sync-v5-2-d34b4ae57fdf@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1794079181; l=3481;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=cFXSmoX1EdwKarrdrXPJnOWTPV4jjSodNuQRhzCnuDg=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDRMbUxYerOUaArqxan0a0HeWUTbsEZvv39oOmgsGk49VhAGuR+C7cpdQWs+rm7PPGT1IWcobnE
 jSjweAHWXeAI=
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

