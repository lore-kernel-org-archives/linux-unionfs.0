Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320715;
	b=3s1pOdPoKNO7PPP/ds23ZHStfMUMfn4OWnSx7kLtSvaBZwceemK7QdR4TdZShyqdl389
	 XIC0nc6D4jFDnb45M21YQZmHawmgHEqq7yKzt6NaKocSvsbiBfSHDCwdVLPrMVLP4pLqn
	 R+a2VGQUDwLNngEFo+rAqj3OVrsCfH63k+AM8KP6PtSoi/3yx4dsFUN77Zm5p/a2Jpcbs
	 DcCZUdS/t1NgphycG3JdbhjMpIKEgPMsVXYfDLp3lWQOsQdPHoPYRG6Zbf2FAd77+duAr
	 Ad+f9FMXrCZW44rMA621NLyyTB2PNC/D6N3attZUwMkU1r0Ia6Nl63DgKaWwY5fGjJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320715;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=pcyTIIwBPjmyAElj9Plr/S42lIJXiadAytcA81h3A/U=;
	b=Ax7eFzpmoDjIsXTTzH9X0NgVfCVlOib3PURTCpYOvzpRd6tLiP4O2M+pZeUP81jQX/Sn
	 TVcPARs/b5uLqRHmIQmVFin6YMwpscqdP7ME06lxBtgxmZzRS5KmYLH80zZg8/VggBY+g
	 YTc8+4oI0SkobApjsjYNcmHLlY9yh0D2mdvrddb662dMJ++16DJJfW/nFn6AfYcEIrTn1
	 Zz/QqperiD098kmQYAMAAxjib2QPXIKkL3iXrhbSdyzX4W/u04pIjQRKN50XPRwg6NXxr
	 L8JXMEnCtZfN/1Qc52e7WbZGICvrw5UmqRSOGTs5Y8NbGZAbc7ju9NOePuD9X6yNiGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=fJd+3mar;
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65BC606A982
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:25:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E65BC606A982
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=fJd+3mar
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5366463571cso24524301cf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 06:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794320714; x=1794925514; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pcyTIIwBPjmyAElj9Plr/S42lIJXiadAytcA81h3A/U=;
        b=fJd+3marC+EMsRC/1xy8JJMSfX+zrYIEaqvT9qehJSqaYPV/tTmzr6PktTBIwPY6PF
         j2Z6auoTPzI4XNNqWS5IQp89CwMJvQ/2HY/PljtkoyzIw76HV3mme4JvPLmYXUltAkp6
         2e2pfjg6riBRJ7M3gVw+z8mnT939ypCmngLPYNXxxhoDlQgF9CqRhOLEozNvnCEu1P6p
         1iPXTiqHNGzBtudNJ6rNODrsnIhaN5i8/ALhjMWFf275ZMrcw1IBqPkYcxjgcYRwknrj
         elYn4H7d4XZBGrm/eH+eBrOKjmugEegPE6VZDFNToBPj3RPikmOO3bIy7QrELZPhVbwU
         /qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320714; x=1794925514;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pcyTIIwBPjmyAElj9Plr/S42lIJXiadAytcA81h3A/U=;
        b=tnvJYM79J/K2t9Xd84grDmljyZ8J5zMkP2N4sG60MNQX/GXwVEuifpgGn+4zTUCTDD
         HAvR3qgIZQGD88MPlcndzLaIVTwHHIJuZLjDzMWywOYOJhrHs+nRupc43jiQtPtVXFRl
         r9cMGDQcFgRHtYu8LDvsOPIJvk76tilO2p/TUcLCcriRVI+4jUv7qlpPM8zQWsObutaE
         ljGehOR85qeXUbOMeZbAV4Ys/cMeZIkG/b1OdH/qEm0Y/EP87pi2LzcThtKaI4LOZODb
         4nAIr2Zn9ifjjufp3EaEmWr5YpkuP9/NCD3HQqlQ/yyTfY4BOc3G1Y3tXBDQah5q6bRD
         5BrQ==
X-Forwarded-Encrypted: i=1; AL+hErHH1a5HeLBRSQPLyS+WL04A518ZXmYQvNYMMBbCORUcDvvu+l7qNY2Y4YoMf57MrDA2E1Jjcl01HgOrYZMO@vger.kernel.org
X-Gm-Message-State: APuU4Z+B1cM535kPRYySMY9KHQoqZK2hzG2vMLSaXH27qxHmFMpvbq7v
	ku27deTPdWI2wm5TB7gXiYMPmZOpQ+SKJDTYlyOQdicTkUqBROW0VVvFoEtR5DUaf58=
X-Gm-Gg: AYBFou1xq6Tb67GJlmqCtJ6ZfQjeDz1ZXPL/oVo6tcR/rPtbzyUJuuwnmWGtmiIx3zE
	LwS0qjvkYnDh91fXZJYeR9kdlPN80c/8og9Wwej9KV0FlX0efMbIOdLxMLIKeD42KBEk8ednGNM
	B603xw0vBLuJAgfi6jZ0DfYgOpibecK8Kumkc0P2MhcnNiXlG11eW7FqB1I/BesazcPr/5M9c8X
	A1TzjdJ3MP2v1K2ScSXqvE7CH+idvN3+ulMMfedIi36QHgzAziQbrQEUKST7oYMUBBqZKmF9rAi
	m7k+/JmEt5rmxRebTIHG8155Tok1BQCyVoDwHKrPgjdzPqupwBtjM6zgm9gi8CFi3v0qrNTWu0P
	QDjcwzgpVIC1t9wGO5L1aTIEwFgBPwKCBu9DnKn1reDIYI6cPBHCoDywQWcxIZYbtZgFYlehc/q
	rCsLl4f7ARb/vKKp1GMp9NCLv0HLAbnDK1nIvQxKtQWPiemtOcsp14P815VphOIzh7F27HnrSqO
	5s6psJh3IoJUIBNZOeKuvRhmbL5lIhWlu7E7GsTfixZ0Mo4qg3OsbTariw8Whnm8ffwKVOSE+F4
	H4UzoyFPWFAnFBK+68T87aYV8qmp8k5Yn4TuIm/JJJBTdZaPPFnTe19ZSBJhnRhordc=
X-Received: by 2002:a05:622a:53cc:b0:535:a20:8277 with SMTP id d75a77b69052e-5552609b27fmr38562291cf.10.1794320713629;
        Tue, 10 Nov 2026 06:25:13 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef0543c8esm22168616d6.40.2026.11.10.06.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:25:13 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 10 Nov 2026 14:24:57 +0000
Subject: [PATCH v6 9/9] ovl: implement containerized syncfs for overlayfs
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
Message-Id: <20261110-b4-ovl-containerized-sync-v6-9-43d1be16a4d6@toxicpanda.com>
References: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
In-Reply-To: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794320698; l=4798;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=Xo2M5cHMBoiidKt8p5NTtHZ9BfQZnZy1FRZYhPiv9Fw=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHLN7kEC1SQEmeJVgeJNARdJzVGyGiG5xdAwugZHdHFZRG/vffQgzIfpxxH0BSODqWKaSmXur4L
 +1nj/jncZDg8=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Now overlayfs can only sync own dirty inodes during syncfs,
so remove unnecessary sync_filesystem() on upper file system.

Do that with fsync=relaxed only.  Call sync_fs_and_bdev() on the upper
filesystem instead, which is what sync_filesystem() does after it has
written the inodes.  Do the same for a read-only remount.

The root inode of an overlay is not hashed and cannot be on a dirty list,
so write its upper inode every time.

Upper inodes that have no overlay inode, like whiteouts and the work
directories, are not tracked.  It is up to ->sync_fs() and the block device
to get them to disk.  ext4, xfs and btrfs log all metadata, and ext4
without a journal keeps it in the buffers of the block device.

With many containers on one upper filesystem, stopping one of them no
longer writes out the dirty data of all the others.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: everything after the first paragraph, no wait_sb_inodes() on the
 upper filesystem]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 Documentation/filesystems/overlayfs.rst |  2 +-
 fs/overlayfs/params.c                   | 14 +++----------
 fs/overlayfs/super.c                    | 36 +++++++++++++++++++++++++--------
 3 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 1a59500834a1..34fc4e6f8a84 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -830,7 +830,7 @@ Traditionally, syncfs(2) and unmount of an overlay sync the entire upper
 filesystem, including the dirty data of other overlays that share it.
 Overlayfs can be told to only write back the files that were modified
 through the overlay, and then ask the upper filesystem to commit its
-metadata.
+metadata and write its block device.
 
 On traditional local filesystems with a single journal (e.g. ext4, xfs),
 fsync on a file also persists the parent directory changes, because they
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 549fc1e83ac9..6de99e79eb6b 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -774,22 +774,14 @@ static int ovl_reconfigure(struct fs_context *fc)
 {
 	struct super_block *sb = fc->root->d_sb;
 	struct ovl_fs *ofs = OVL_FS(sb);
-	struct super_block *upper_sb;
-	int ret = 0;
 
 	if (!(fc->sb_flags & SB_RDONLY) && ovl_force_readonly(ofs))
 		return -EROFS;
 
-	if (fc->sb_flags & SB_RDONLY && !sb_rdonly(sb)) {
-		upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
-		if (ovl_should_sync(ofs)) {
-			down_read(&upper_sb->s_umount);
-			ret = sync_filesystem(upper_sb);
-			up_read(&upper_sb->s_umount);
-		}
-	}
+	if (fc->sb_flags & SB_RDONLY && !sb_rdonly(sb) && ovl_should_sync(ofs))
+		return sync_filesystem(sb);
 
-	return ret;
+	return 0;
 }
 
 static const struct fs_context_operations ovl_context_ops = {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a0fb85405f68..570e2ea6af93 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -270,18 +270,38 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	/*
 	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
 	 * All the super blocks will be iterated, including upper_sb.
-	 *
-	 * If this is a syncfs(2) call, then we do need to call
-	 * sync_filesystem() on upper_sb, but enough if we do it when being
-	 * called with wait == 1.
 	 */
-	if (!wait)
-		return 0;
-
 	upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
 
+	if (ovl_should_sync_upper_fs(ofs)) {
+		/* Enough if we do it when being called with wait == 1 */
+		if (!wait)
+			return 0;
+
+		down_read(&upper_sb->s_umount);
+		ret = sync_filesystem(upper_sb);
+		up_read(&upper_sb->s_umount);
+
+		return ret;
+	}
+
+	/*
+	 * sync_filesystem() has already written the dirty inodes of this
+	 * overlay through ovl_write_inode().  What is left are the last two
+	 * steps of sync_filesystem() on the upper filesystem.  They have to
+	 * take care of the upper inodes that have no overlay inode, like
+	 * whiteouts and the work directories.  Do not write the inodes that
+	 * others have dirtied on the upper filesystem.
+	 *
+	 * The root inode is not hashed, so it is never on the dirty list.
+	 * Write its upper inode every time.  sb->s_root is gone during an
+	 * unmount.  An error ends up in s_wb_err, like for any other inode.
+	 */
+	ovl_write_upper_inode(sb, d_inode(ovl_upper_mnt(ofs)->mnt_root),
+			      wait ? OVL_WRITE_WAIT : OVL_WRITE_START);
+
 	down_read(&upper_sb->s_umount);
-	ret = sync_filesystem(upper_sb);
+	ret = sync_fs_and_bdev(upper_sb, wait);
 	up_read(&upper_sb->s_umount);
 
 	return ret;

-- 
2.55.0

