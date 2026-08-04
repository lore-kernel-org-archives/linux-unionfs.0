Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C480323395C;
	Tue,  4 Aug 2026 03:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785814947; cv=none; b=XwIc0Zc3NZHAESy3+MuX1boM3xm3PXvHW0zy7y2KQxey/+xjjYRYDlW4WrsnXHLsWGcHvw/IdCAbspWrFIvoRvs1vQb5Lq2hoSKlIhMiYtsrU6NjnjGgtdYJP5Ra5IhStBuYZ8xBeWgn+pqsKDcFyGZFZAqZp+hTvuRfllSEGds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785814947; c=relaxed/simple;
	bh=HY+wc+h7ZqyfDwRCBo7DarwuJjO+rxgVoerLchOhDP4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=StHnAi87uKa4NuwhgPHUBT8IKVxcy60su4zcVmvFyBlnFAVVGT/47sVnpULDcF3Lf7BsRz+SU1MLGhUJj1n8HdfQ5eInyEl08xx7oSP0ebwoERMc8U7TTMTDX24Ag1gFPkCwnTfp3VzBTSpEvXrMrHkMpNIQBg64Jrhizkv00do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rzJuelgA; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rzJuelgA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785814935; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=hyIxI4f5S72ocCkgfTlMm04f5fzfsAi2imhvD9eLIrs=;
	b=rzJuelgAWdOSKMay0Vu/g5UZi//1lQCNRH37l5JTVqkKnPiXnYzp8fBjENkuAdDl+N29w0z89ilQtxIB0L7S3g05ForHZYwluebjswcqqqLWbZt/LxojEvErltOhS5/zBIHutM2p6L+dM5ca28MMoFjSKTKb9yRVJPfhbJVBjWs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X8MUTlI_1785814925;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X8MUTlI_1785814925 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Aug 2026 11:42:14 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-fsdevel@vger.kernel.org
Cc: miklos@szeredi.hu,
	amir73il@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	paul@paul-moore.com,
	serge@hallyn.com,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] fs: fix user path of nested backing files
Date: Tue,  4 Aug 2026 11:42:04 +0800
Message-ID: <20260804034204.3487077-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

backing_file_open() derives the path to be stored in the new backing
file from user_file->f_path.  This is incorrect when user_file itself
is a backing file, which is the case for nested stacking filesystems,
e.g. overlayfs mounts where the lowerdir of one overlayfs is the merged
directory of another.  Since commit def3ae83da02 ("fs: store real path
instead of fake path in backing file f_path") the f_path of a backing
file holds the real path of the intermediate layer, not the path that
the user opened.

Commit 924577e4f6ca ("ovl: Fix nested backing file paths") fixed this
for such configurations by passing file_user_path() from
ovl_open_realfile().  However, commit 6af36aeb147a ("lsm: add
backing_file LSM hooks") changed the first argument of
backing_file_open() from the user path back to the user file and
derived the path from user_file->f_path again, silently re-introducing
the problem.

As a result, files mapped through a nested overlayfs show the wrong
path in /proc/<pid>/maps and in perf/ftrace mmap records.  For example,
with two nested overlayfs mounts:

  mkdir -p /ovl/{lower,upper,work,merged} /ovl/nested
  echo hello > /ovl/lower/foo
  mount -t overlay overlay \
	-o lowerdir=/ovl/lower,upperdir=/ovl/upper,workdir=/ovl/work \
	/ovl/merged
  # at least two lowerdirs are needed when upperdir is nonexistent
  mount -t overlay overlay \
	-o lowerdir=/ovl/merged:/ovl/lower /ovl/nested

mapping /ovl/nested/foo shows a disconnected path instead of the user
path:

  # readlink /proc/self/fd/3
  /ovl/nested/foo
  # grep foo /proc/self/maps
  7f6e2c100000-7f6e2c101000 r--s 00000000 00:24 15813027 /foo

The bogus path is derived from the f_path of the intermediate backing
file, whose mount is a private clone that d_path() cannot resolve.

Fix this by using file_user_path(), which returns the outermost
user-visible path for backing files and falls back to
&user_file->f_path for regular files.  This restores the behavior of
commit 924577e4f6ca ("ovl: Fix nested backing file paths") for
overlayfs and also fixes the same problem for the other
backing_file_open() callers, fuse passthrough and erofs ishare, when
their user file is itself a backing file.

backing_tmpfile_open() has the same pattern but is not affected: it is
only called by ovl_create_tmpfile() for the upper layer, and another
overlayfs is rejected as upperdir by the DCACHE_OP_REAL check in
ovl_mount_dir_check(), so its user_file can never be a backing file.

Fixes: 6af36aeb147a ("lsm: add backing_file LSM hooks")
Cc: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/backing-file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 080c99696cd0..cc101143f921 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -35,7 +35,7 @@ struct file *backing_file_open(const struct file *user_file, int flags,
 			       const struct path *real_path,
 			       const struct cred *cred)
 {
-	const struct path *user_path = &user_file->f_path;
+	const struct path *user_path = file_user_path(user_file);
 	struct file *f;
 	int error;
 
-- 
2.43.7

