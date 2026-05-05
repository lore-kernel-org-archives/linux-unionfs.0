Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E2838DD3;
	Tue,  5 May 2026 00:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777940180; cv=none; b=LKeew1/n77XniKOA/Px/emi3cQZZmXGLELurjwnLexekb3+9xuNFq2RjklKK549CDI1GsznleNOWIx5FvE78+pxT9Y8KdWJm+UefD1dJGcPD6i3ozJ5W5NXu0arlANbsgS5hDFQqV+568QSHx6NOL1fcGwKlCqF88CyfEKHS+dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777940180; c=relaxed/simple;
	bh=r0FoTB4Qm9DDsZd69wtvRoYlFr/kq/fGjIA+u/xIp20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZP3WQrQGOwNpNo5mWac7pPs7us8TiEaXu1h/k3LbQFi6bZ7Bdeogo4sL3kVDrr5jA60tg4zHvCVT+CdeKqG7jzRozF+2p76706N9gdBuat2UqaUXYeLhuWABsg1gg7/1a0H8ZksGg0+hEEKQ/uDkH+zzboa+dTMLEb2+IKLH7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFcwqZYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFcwqZYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17732C2BCB8;
	Tue,  5 May 2026 00:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777940180;
	bh=r0FoTB4Qm9DDsZd69wtvRoYlFr/kq/fGjIA+u/xIp20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFcwqZYQUU+L9w79KOPcaSF3BPDokKxZ9bZ7uSRsV2edkXlsp3qWA2+t2Br9PFZlj
	 Gb3B5WP7GW/LfTPYrxVffumt8KX6Aw4P/uVM0HWBw3ODz6Uu1bAk/UKaiHBoz8kcP0
	 BUVQiyGp9lTkLGQ3dSsb2tNG1aFt+rSPKhp+s+I33ahlXcrYVxG/zgXvphGfSN3YLR
	 vfXzLZO7geW7V8wFtjoyoqz+tEFgFxqHCqKccrdH4RD9H5q3uN3me80GC3MCv9gXlc
	 gIDfe8Azs06yWEykLDXr0DJ3gq3P0bxLVWulZAu/JAPZ0sFJPjRApkc18aLf2KB1JD
	 0rAVGsu2SrDRA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	Serge Hallyn <serge@hallyn.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y] fs: prepare for adding LSM blob to backing_file
Date: Mon,  4 May 2026 20:16:14 -0400
Message-ID: <20260505001614.127730-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026050104-spotter-moody-9d29@gregkh>
References: <2026050104-spotter-moody-9d29@gregkh>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 880bd496ec72a6dcb00cb70c430ef752ba242ae7 ]

In preparation to adding LSM blob to backing_file struct, factor out
helpers init_backing_file() and backing_file_free().

Cc: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: linux-erofs@lists.ozlabs.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
[PM: use the term "LSM blob", fix comment style to match file]
Signed-off-by: Paul Moore <paul@paul-moore.com>
[ Used kfree() instead of kmem_cache_free(bfilp_cachep, ff) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_table.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index cf3422edf737c..f7661a7087464 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -60,6 +60,12 @@ struct path *backing_file_user_path(struct file *f)
 }
 EXPORT_SYMBOL_GPL(backing_file_user_path);
 
+static inline void backing_file_free(struct backing_file *ff)
+{
+	path_put(&ff->user_path);
+	kfree(ff);
+}
+
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
@@ -67,8 +73,7 @@ static inline void file_free(struct file *f)
 		percpu_counter_dec(&nr_files);
 	put_cred(f->f_cred);
 	if (unlikely(f->f_mode & FMODE_BACKING)) {
-		path_put(backing_file_user_path(f));
-		kfree(backing_file(f));
+		backing_file_free(backing_file(f));
 	} else {
 		kmem_cache_free(filp_cachep, f);
 	}
@@ -255,6 +260,12 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
 	return f;
 }
 
+static int init_backing_file(struct backing_file *ff)
+{
+	memset(&ff->user_path, 0, sizeof(ff->user_path));
+	return 0;
+}
+
 /*
  * Variant of alloc_empty_file() that allocates a backing_file container
  * and doesn't check and modify nr_files.
@@ -277,7 +288,14 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
 		return ERR_PTR(error);
 	}
 
+	/* The f_mode flags must be set before fput(). */
 	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
+	error = init_backing_file(ff);
+	if (unlikely(error)) {
+		fput(&ff->file);
+		return ERR_PTR(error);
+	}
+
 	return &ff->file;
 }
 
-- 
2.53.0

