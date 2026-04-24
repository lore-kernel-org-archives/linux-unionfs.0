Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7DED531
	for <linux-unionfs@vger.kernel.org>; Fri, 24 Apr 2026 04:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777006251; cv=none; b=icwxmXM5THZfXKTLEDb5NBIcuBiF0+40hM6FzGSnBkqBbiDUhK+k0fjabkgS4DWbcpeJiZpKdloYILaw7Df6tw56Rwxjg/B3+YG6hZDTHdNFFjjxwMl+Us+k4+6efSQgN8N8AMl0zWzM4oVn6hryM6lGf3xpUz7fxJFAIh6r6ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777006251; c=relaxed/simple;
	bh=JGFyHr6p435RtbM+yR/LAQgNCWrAUbSszyisg4tAlPA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=jsrlFt5lX4CojhpOtR/lW1Va54SlE0ckexnfNxNN3wQ45/pmQhQbDcxYwj27PmQq9uWwjrgcppqPHTIqByq/awXTn7gDgQ5AyzKo9T4tu2nh+bFMzhXcR1I4iKYbfsK0XnxFbdifz87X9KqnhPJfR2vooLuqOnmXOVC3H/F79do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IEYMi4Nc; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IEYMi4Nc"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12c565dd3a7so11075102c88.1
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Apr 2026 21:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777006249; x=1777611049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EQ7aTx8P/1euFehikHjABWSZRRPQi7ezebfA8K4VyEA=;
        b=IEYMi4NcsccqLVWtLXpm2rXglaXcnf6MGLGTUJgAASflexvNFvTP6ZGgpe9xGjVFFd
         TibTz7nXwgU6QBCSoKHdfV/JLwmKj/ITfxV+V1+UydOxoMz8VB5Dv3prVXyceg4kKuMl
         x8hOxhD2rRq9qP7jln2yWL9JrO1I1ZrQSi5Fn+KqTb14CaugRZv7mD4s2TyI1Edj/gma
         S3nEagCO0b8RpkVHuGTffMa8rqTAPpiRYt+dkCwSYivtXquhlXA1IEmu6MSEu8nmJFXB
         cKLuuD4xYq7ei+Ycwb3EdN3zzOpb4Jic33O7WfJXBFc6om8Oc80RbIUD2WNSfvPlj/u6
         oTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777006249; x=1777611049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQ7aTx8P/1euFehikHjABWSZRRPQi7ezebfA8K4VyEA=;
        b=swN1USpqbswgbyB8Aqj5B2c+okNQxuFwKVjNivTjAah4yIwx+UmG2WDISBtAUfQxCs
         C0yLdko8Qgy3vYoVMawN+xi4K5aVHK3DmV+WPoTKpYD62mQxfTaVKJ9cUUYGtLKhqxiC
         h3EkwURAtWBog5khiF9pYeSz3Xb3UH3xFXRrRjKZYZhruUcNhvS5Q1zQgY1JXxG0oQiO
         DU55z2y/ITBg0yJ1b5KlSqI071bqZQXi8nMbKhVsz2e/uKjU5NtjqGFS9uiwgWUmX/i1
         VHj7QgvA6Ten/9MM66g88cDwcnBczy9L/CjoYeEAAf3kPpw21kMpQ3OpCdQwjru6tsH4
         IrnQ==
X-Gm-Message-State: AOJu0Yx19kBsdacMwk1ZVhXuji32dAqjv4PDIZ/AAXlQ5pud2xwnLsNA
	9S4Ktrdgj/8iOaHKzr9pAOZUG4HWRizxqwt6fNSPKheUT6kz1OXV6Rpl
X-Gm-Gg: AeBDietKAs2IAtzgOnCLwxmpewEUcv0qDpQq5SeWewy3umh6h1Ly7BZCbFwLdP1V/8g
	NOiEeQqBPUMlhGjhXeChnoLVLSjrgK8YMzDEziEjd3KDeM1XU8OHQRUr+tJoyOrrnS9sp1hGBQ+
	V9m48tErDSNV2Opv8tDNBq+LOBBHVFG77GVPNJkaHgHm905Bca5vxYPCGTVv98a6sfTLQfBjrXZ
	koRFEDaLvn+h7OowQVL3oBZ1C9d7kyoOK7ynqnzfy+KMYq5zddKMG/ZlAWxf9ctYq8WlwxofpvE
	0+BEWwv5MC0iPUKaZxcSwh3ziKz2qM/PWIwe3+z3Qc1xyxLAYF0ABMScUJjY/OuL5q2LmIp/boK
	yZ4aliWwCgIKdZMjTlx5opF/RI0NYA4PVBofo6IhJQ9Aj74LyvDpezXRcYfJmqsgOlGEIvtQQwR
	mfmtJRub6QCNIlpGoE7gGlj1K1CIzqAVqnienec7gOtIrzKeV/2o/j3JEEWcoVUdf5tlRKjfTJ2
	yQztiAb/WJmBEL+3QKlizjT1K9R
X-Received: by 2002:a05:7022:4199:b0:128:bc19:813d with SMTP id a92af1059eb24-12c73f9c8aemr15314940c88.27.1777006249217;
        Thu, 23 Apr 2026 21:50:49 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:c01:ca00:45b2:2071:1eb4:e2ce])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c831d5b29sm32780615c88.8.2026.04.23.21.50.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Apr 2026 21:50:48 -0700 (PDT)
From: Tamil Mathi <9tamilmathi@gmail.com>
To: paullawrence@google.com
Cc: linux-unionfs@vger.kernel.org,
	kernel-team@android.com,
	syzbot+64a5c9ae57720239f5c6@syzkaller.appspotmail.com,
	Tamil Mathi <9tamilmathi@gmail.com>
Subject: [PATCH] incfs: fix use-after-eviction in incfs_kill_sb()
Date: Thu, 23 Apr 2026 21:50:47 -0700
Message-Id: <20260424045047.3072-1-9tamilmathi@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

incfs_kill_sb() called kill_anon_super() before vfs_rmdir() on the
special .index and .incomplete backing directories. kill_anon_super()
calls generic_shutdown_super(), which evicts all inodes. When
vfs_rmdir() is subsequently called on the already-evicted directory
inodes, drop_nlink() is invoked on an inode with i_nlink already 0,
triggering a WARNING in shmem_rmdir() and a null-ptr-deref in ihold().

Fix this by moving the vfs_rmdir() cleanup calls to before
kill_anon_super(), so the directory inodes are still valid when
removed. The existing constraint — that kill_anon_super() must precede
incfs_free_mount_info() — is preserved.

Reported-by: syzbot+64a5c9ae57720239f5c6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=64a5c9ae57720239f5c6
Signed-off-by: Tamil Mathi <9tamilmathi@gmail.com>
---
 fs/incfs/vfs.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/incfs/vfs.c b/fs/incfs/vfs.c
index 4faf2c2..b45533b 100644
--- a/fs/incfs/vfs.c
+++ b/fs/incfs/vfs.c
@@ -1953,15 +1953,14 @@ void incfs_kill_sb(struct super_block *sb)
 	pr_debug("incfs: unmount\n");
 
 	/*
-	 * We must kill the super before freeing mi, since killing the super
-	 * triggers inode eviction, which triggers the final update of the
-	 * backing file, which uses certain information for mi
+	 * Clean up the special backing directories before kill_anon_super(),
+	 * since kill_anon_super() evicts all inodes via generic_shutdown_super().
+	 * Calling vfs_rmdir() after inode eviction causes drop_nlink() to be
+	 * called on an inode with i_nlink already 0, triggering a WARNING in
+	 * shmem_rmdir() and a subsequent null-ptr-deref in ihold().
 	 */
-	kill_anon_super(sb);
-
-	if (mi) {
-		if (mi->mi_backing_dir_path.dentry)
-			dinode = d_inode(mi->mi_backing_dir_path.dentry);
+	if (mi && mi->mi_backing_dir_path.dentry) {
+		dinode = d_inode(mi->mi_backing_dir_path.dentry);
 
 		if (dinode) {
 			if (mi->mi_index_dir && mi->mi_index_free)
@@ -1972,7 +1971,16 @@ void incfs_kill_sb(struct super_block *sb)
 				vfs_rmdir(&nop_mnt_idmap, dinode,
 					  mi->mi_incomplete_dir);
 		}
+	}
 
+	/*
+	 * We must kill the super before freeing mi, since killing the super
+	 * triggers inode eviction, which triggers the final update of the
+	 * backing file, which uses certain information for mi
+	 */
+	kill_anon_super(sb);
+
+	if (mi) {
 		incfs_free_mount_info(mi);
 		sb->s_fs_info = NULL;
 	}
-- 
2.39.5 (Apple Git-154)

