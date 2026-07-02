Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756E435FF6C;
	Thu,  2 Jul 2026 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010927; cv=none; b=rimp8qK6a+Hnj7TZ7282dRblkMQb/BtOJXhhGzMzpRaZ3GmjTJm9FnOcgfMzSblud8kHpbpAtDZ9jMx4m27lNd4dZiiv6BcB9Lxby07qoUbHH3ED4wuF0VPGEkTVvwWrCj6n5miMANgzcssB7J9w9JyUF9sf/WGg9TBS5gYMOck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010927; c=relaxed/simple;
	bh=AHQsC5Sl8lhXd1l/PFoZdioz272TMpy3Z7kvtkb8DvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qo4Kh5+EobSpMvvH+0609eN+hEhP5jVBOn53t7LWSrnXAE/Ndtf3iiUg8SNgnHQZc26SgzfGKvEbQpnG7lchTkM5fP/ENfMbky7+gC9xSFFgyHHAmB4vo0LQEe2cktQJmSUXmC7hAuSdv6AQ8WjCN1mhzks7/06agcB+I16kqQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxp8+s4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxp8+s4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68F71F000E9;
	Thu,  2 Jul 2026 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010926;
	bh=lxaEB9ivtd1cudx/QItx/MaDYy56jhVPw1crZ3vhZXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxp8+s4a/1t16bjQIi64OJGP/2GUxkMe8nXbm/UnfMo+6cBEf/1v+FjqvNL2kTl5L
	 02HDKGQWLoWdWETIW2AQwkkt9M+GEU9L9E/Jxa9q3aIreOZhaElBrAaAdJFLN1O/OF
	 T7754V6c44Pw6+MqQf/jCh3RCQv/MCe8jGD+vlZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	Amir Goldstein <amir73il@gmail.com>,
	Serge Hallyn <serge@hallyn.com>,
	Paul Moore <paul@paul-moore.com>,
	Cai Xinchen <caixinchen1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/175] fs: prepare for adding LSM blob to backing_file
Date: Thu,  2 Jul 2026 18:19:49 +0200
Message-ID: <20260702155117.633809919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
[1. The commit def3ae83da02
("fs: store real path instead of fake path in backing file f_path")
is not merged, The 6.6 LTS version accordingly operates on
&ff->real_path instead of &ff->user_path.

2. Mainline's file_free() does both the backing_file cleanup and the
kmem_cache_free() synchronously.  Linux 6.6.y defers the actual kfree()
to file_free_rcu() via call_rcu(), so only path_put() is done
synchronously in file_free().]
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_table.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 234284ef72a9a5..b4c208a771539d 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -72,11 +72,16 @@ static void file_free_rcu(struct rcu_head *head)
 		kmem_cache_free(filp_cachep, f);
 }
 
+static inline void backing_file_free(struct backing_file *ff)
+{
+	path_put(&ff->real_path);
+}
+
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
 	if (unlikely(f->f_mode & FMODE_BACKING))
-		path_put(backing_file_real_path(f));
+		backing_file_free(backing_file(f));
 	if (likely(!(f->f_mode & FMODE_NOACCOUNT)))
 		percpu_counter_dec(&nr_files);
 	call_rcu(&f->f_rcuhead, file_free_rcu);
@@ -252,6 +257,12 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
 	return f;
 }
 
+static int init_backing_file(struct backing_file *ff)
+{
+	memset(&ff->real_path, 0, sizeof(ff->real_path));
+	return 0;
+}
+
 /*
  * Variant of alloc_empty_file() that allocates a backing_file container
  * and doesn't check and modify nr_files.
@@ -274,7 +285,14 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
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



