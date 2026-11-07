Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794079197;
	b=zecJnHxCvyc2SwlrZcqz1v4bCmlcc8/aikYkDycagL8pUH7vQuiD8lBge7MoVaTjfJEQ
	 0L54LDUYsbYK9mSWTeJDCuXlOChIHaakdn9TCt0vMJfmADf5SiBRFa3b2tF9aH2eGoBqS
	 +Sc1MYc4fuPBcmOH7v09B4DFfdc74jCI/HZtbjwP+1tLwMm9bDN0tMxLFsoerbovcd9+S
	 9DV63bOsJ4eioXyBSkoTT0bzei/5h6b8G/Y6/ezQtbn+lEeyBS+W382NSEMwc6M2YJpVl
	 4BZUFGRT+bHNGcrzNvl+ccZL/pzdhDygPMYXjLJmvksA2a761z3w4yyRDVTbxGO0yMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794079197;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=tSgquXwr/HzowPSw0CcNwelS2rBBKKasUYdOd6dLaGM=;
	b=RKQwR9fB/8o9Goq9wbYr7tZjZ0DRUtityesbjamqBznMS5oW/6mFi2ovLWOvfmqasIhu
	 a7YW7mjLsyiswpFZQ71kR1IF1Gc4NAU9sAw1X1PmZGGjCofRW0ZntEgonVm0FtyfpBKda
	 bmnEExYqOwBoiX6zhElcHZfNwsjw4WYE4k/Am9+9ZnOqQvg8ERQg0vtOE3J6aORGwPc7N
	 uPBn6iS5+/Nxkrmm1fltTrBBMy/hJfdKhA6hECVo0+0nlSJHzINp2VvC9V9oVSKvzdUUV
	 tKkpZPGhv74K9lIkftj9tygf6LqrUxtJvCelz880pzp1zQYeoszmsU9L69nVzEbQDPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=PCta5vgI;
	arc=none smtp.remote-ip=209.85.160.182
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9036A606A333
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 19:19:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9036A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=PCta5vgI
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5363316fa0cso32961cf.3
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 11:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794079197; x=1794683997; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tSgquXwr/HzowPSw0CcNwelS2rBBKKasUYdOd6dLaGM=;
        b=PCta5vgIP4YfnO3iqVfYY9551bxqkklLPfWEZAy8L/8OsQQL+viixu32N+w5MRyBw+
         CApjJtmaQcOblafdC0DZk8FKbQiooA9Oj9Oic6KS1K7MHdDJ0p1+EdzvqbN8mPbWJPJ/
         mbRJTuONsMtM27cbMlHKA+rEG9oIg/f8Ak+mOamcPAUdpPjXHks0DP5oAKKOZWj/qXdF
         ScVKqR7XqEegn3HZVmUN7V/cNm/w9evgeUl35GJu/bJ6ptH4CeT3b45AqC71Rt9eIwKe
         R7IuqAEX3X7A4KyExNie0a4r+ShQKz8ViaU58cOR1r/KTYFTcvgnNn8BF/SjnMiVV6Ec
         rCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794079197; x=1794683997;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tSgquXwr/HzowPSw0CcNwelS2rBBKKasUYdOd6dLaGM=;
        b=Axf745hUPe5wHU10nihv7YIsTsTZEiCqaIlMHdWPuy5YU75r/EHmJlQv9OJSxNel01
         futSYhrdLA7Fovbq1UPgxMA7a39YKXD1bMf0nQ7SWJtslAHXDjkgPTq+5b8/0R5kt/O5
         eyjqg+bfDbDwT3n5rMMdtMNaiJWlKm69xfeOV/RvvAqpPNEahJ6c4Pf/9gjXKTpSIb49
         T7g5rkTyidCa2FsiyQa62bViMGC0VnidnK6M0we2wpW8eStRNNoiOXLY7DOTWE5sBMJ7
         K96nRH1x7rpYWvWbXJA4UwwMyoz7YBa53BrosYXpD9s8IWhvlbm2ZRmQL4nZlVCunWum
         lFhA==
X-Forwarded-Encrypted: i=1; AL+hErFaurbsKOx+Xf6nAfpFREfdyGi5nAyPOZwJ1lRFX4UWSCosUhor5W5/El05Dfx0Wt4lrZYPedHHP6RLSk7u@vger.kernel.org
X-Gm-Message-State: APuU4Z8SNyBQQNbwMJynVAQV8f956qpr49rGrKg8WC0k7joQK08Lc0Os
	OqUBPKTGVD+sdKSx9TwHfE1xyWsVYUb3gN/jHq0Sj5uQyGyC8TnfzZnOY897YaicKKA=
X-Gm-Gg: AYBFou34BD4fjT1rulIHvRg5JtOFvi4keqEKaS/qK9Lo3QpgJ0WnsBtqsHkzl6JJJ1k
	HLiK9jXb56+Tm8WjWYZopCBlPqPP9PkEDT6I5qmZsipAuIMuQKfa5MGE0HjeJ8UcpnwxMumzDPA
	oEtdOgbmnqTSmu1szK/B7aV5LJu4fWFt2L0glsI4x7CR3z4fuJGf0cnOfjCAW+qqh0guACEp/Hq
	7dWdy2Sku4IAeaS6r0XSQuj85yC1nK+utlbf2VpQB9WEN1U3SEq+Sr9mrt4ChKdm4wETB6XwoFi
	SDXZJjRx3g09cxt/s53Bd28nN6+L+nJy6IjRERnQquG8wjGKObgdDDc6XXOFPXh2Kxei5bsCGS0
	Hrizi+kBS1VQ4YhjY7U+UDPpRlKSoNWAKnaETKYssnrYVSTmfzUk2pVD/RL5w8BgEcA6OhQfPie
	jYr7haHTZ3l9dr5qDG+zbVpoQx9Zd6+S+eciSUr9LPPBZZl8jo5XB+mCuQPn+lcf3LbI8IiyFcN
	F2VwWTZhm983NUvynQmDVDY39z+gwu5K32il0COT1j6w/mQJuFg4CeaUJLp7pGB7Vc6ml1h7wgD
	hynBEitFj9s4+pjVUJEBF9YqtPVb4b/y5mPryiYn7PG6IA==
X-Received: by 2002:a05:622a:8842:b0:536:91bf:b540 with SMTP id d75a77b69052e-54e1329addamr93105611cf.23.1794079196644;
        Sat, 07 Nov 2026 11:19:56 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.251])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ecedbefb2sm496736d6.17.2026.11.07.11.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 11:19:55 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Sat, 07 Nov 2026 19:19:36 +0000
Subject: [PATCH v5 7/8] ovl: write the timestamps that lazytime defers
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
Message-Id: <20261107-b4-ovl-containerized-sync-v5-7-d34b4ae57fdf@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1794079181; l=5521;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=9AHm45iPL9xMQ/MU/5eyp57lFw+X1sZFu/GzN0eYJ54=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QO6oQ6I4bXteBk+CKlPdvgdMOZ7FgA4dT/6hslZezUe6rhV+QwaC6fv/81Mq+wiyJBZC+MFJW8H
 NI9xZHZeHEwU=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

With lazytime on the upper filesystem new timestamps stay in memory for up
to 12 hours, and syncfs() has to write them.  So the overlay inode must not
become clean during that time, or syncfs() on the overlay would miss them.
It should not stay dirty for that long either, because the flusher would
visit it on every pass and it could not be reclaimed.

When overlayfs writes an upper inode, or looks at it in ->write_inode(),
and it has deferred timestamps, hand them to the upper filesystem.  They
go out with that write, or with the next pass of the flusher of the upper
filesystem, and the overlay inode becomes clean after that.

This takes the benefit of lazytime away from inodes that are modified or
read through an overlay with fsync=relaxed.  The flusher looks at the inode
of a file that is open for writing up to every 5 seconds.

A syncfs() that meets a freeze of the upper filesystem leaves the
timestamps to the freeze.  One that meets a read-only remount of it that
fails leaves them to the next pass.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/super.c     | 10 +++++++---
 fs/overlayfs/util.c      | 29 +++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1d7b102a1127..676520ff026f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -523,6 +523,7 @@ enum ovl_write_mode {
 	OVL_WRITE_COMMIT,
 };
 
+void ovl_flush_lazytime(struct super_block *sb, struct inode *upper);
 int ovl_write_upper_inode(struct super_block *sb, struct inode *upper,
 			  enum ovl_write_mode mode);
 struct inode *ovl_inode_lower(struct inode *inode);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ccfbaf9d8797..f38c6dd2ae47 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -331,6 +331,7 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
  * all, see ovl_write_inode().  And a write_inode_now() that does not wait does
  * nothing if the flusher of the upper filesystem is writing @upper.  A
  * modification that was made during that pass is only recorded in the flags.
+ * I_DIRTY_TIME is only left if ovl_flush_lazytime() could not get rid of it.
  *
  * i_writecount has to be read first.  If it is seen at zero, the tag of a page
  * that was dirtied through a mapping must be seen as well.  The tag is set when
@@ -344,7 +345,7 @@ static bool ovl_upper_unfinished(struct inode *upper)
 	return atomic_read_acquire(&upper->i_writecount) > 0 ||
 	       mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
 	       mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
-	       (inode_state_read_once(upper) & (I_DIRTY | I_SYNC));
+	       (inode_state_read_once(upper) & (I_DIRTY_ALL | I_SYNC));
 }
 
 static enum ovl_write_mode ovl_write_mode(struct inode *inode,
@@ -375,12 +376,15 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 	/*
 	 * Leave periodic and background writeback to the flusher of the upper
 	 * filesystem.  @upper is on its dirty list, and it knows when the data
-	 * is old enough to be written.  All there is to do here is to find out
-	 * whether the overlay inode can be clean again.
+	 * is old enough to be written.  All there is to do here is to hand over
+	 * deferred timestamps, and to find out whether the overlay inode can be
+	 * clean again.
 	 */
 	if (!wbc->for_kupdate && !wbc->for_background)
 		ret = ovl_write_upper_inode(inode->i_sb, upper,
 					    ovl_write_mode(inode, wbc));
+	else
+		ovl_flush_lazytime(inode->i_sb, upper);
 
 	if (ovl_upper_unfinished(upper))
 		ovl_mark_inode_dirty(inode);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index d7b08a46cb76..16ca33e2b794 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1528,6 +1528,33 @@ void ovl_copyattr(struct inode *inode)
 	ovl_mark_inode_dirty(inode);
 }
 
+/*
+ * With lazytime the upper filesystem keeps new timestamps in memory for up to
+ * 12 hours.  syncfs() has to write them, so the overlay inode could not become
+ * clean for that long.  It would be pinned, and the flusher would visit it on
+ * every pass.  Do not wait.  Hand the timestamps to the upper filesystem, which
+ * then writes the inode like after any other change.
+ *
+ * Like touch_atime(), leave a filesystem alone that is being frozen or
+ * remounted read-only.  Both write the timestamps, and the overlay inode stays
+ * dirty until then, see ovl_upper_unfinished().
+ */
+void ovl_flush_lazytime(struct super_block *sb, struct inode *upper)
+{
+	struct vfsmount *mnt = ovl_upper_mnt(OVL_FS(sb));
+
+	if (!(inode_state_read_once(upper) & I_DIRTY_TIME))
+		return;
+
+	if (!sb_start_write_trylock(upper->i_sb))
+		return;
+	if (!mnt_get_write_access(mnt)) {
+		mark_inode_dirty_sync(upper);
+		mnt_put_write_access(mnt);
+	}
+	sb_end_write(upper->i_sb);
+}
+
 /*
  * Do what sync_inodes_sb() does to an inode: wait for the data, hand the inode
  * to the filesystem, and leave it to ->sync_fs() to commit it.  It gets there
@@ -1565,6 +1592,8 @@ int ovl_write_upper_inode(struct super_block *sb, struct inode *upper,
 {
 	int err;
 
+	ovl_flush_lazytime(sb, upper);
+
 	/* sync_inodes_sb() does not wait for such a filesystem either */
 	if (upper->i_sb->s_iflags & SB_I_NO_DATA_INTEGRITY)
 		mode = OVL_WRITE_START;

-- 
2.55.0

