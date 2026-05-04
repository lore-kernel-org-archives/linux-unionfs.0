Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8F93AA4F8;
	Mon,  4 May 2026 14:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903987; cv=none; b=PzvXVmHegxua/NP5ildNuLP2ircduH6bndZozC6vRu12B/D8cuh6bEtmB6Jlr25QacjcqdPvpOejSxB8ZhCy/8HROPMlouotEIWjJgJBmW5viIQf6CB+BMDaYzd+nhNQG//sI+HmTLxttZLh/DPWLXw9ntoE7vcZ+PUgsHRVumc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903987; c=relaxed/simple;
	bh=fVxatBOyuoatE86nVgoyS+6rOpAEFnaHEEm7A1C3n5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3e1N9Hv7pJ9/5hwXYTNY2e75eva04XJT8EgRCjBfwXm2rA8OTvmFNUhV9kl8YxWor2WjsdYV0y7P2a9KBiU2/u/fyyDeOKrGkkfbLk8YEwMbIjdx6m1mTxQaCWSPS94ijwbQGVtndYeUoMN/tz7N6uM+8CAWuawTd985xX4F/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nx1ojmap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nx1ojmap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3A7C2BCB8;
	Mon,  4 May 2026 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903987;
	bh=fVxatBOyuoatE86nVgoyS+6rOpAEFnaHEEm7A1C3n5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nx1ojmapYdPlMjz0y9y7/j796pjNKyr60qdlSHGIJg1u0aN8SObO8zR7R1lMmryad
	 szlmJcO/bPlO9bIwOGoFLtGBuZphTQMsmc1wSKE2YJRjwfixE29u48WlH4Xp0oGcB/
	 IRtuEVHQsdQqFx2prSsH8ACr0l09kzaa5fCX3lNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	Amir Goldstein <amir73il@gmail.com>,
	Serge Hallyn <serge@hallyn.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 140/275] fs: prepare for adding LSM blob to backing_file
Date: Mon,  4 May 2026 15:51:20 +0200
Message-ID: <20260504135148.103200544@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 880bd496ec72a6dcb00cb70c430ef752ba242ae7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file_table.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -66,6 +66,12 @@ void backing_file_set_user_path(struct f
 }
 EXPORT_SYMBOL_GPL(backing_file_set_user_path);
 
+static inline void backing_file_free(struct backing_file *ff)
+{
+	path_put(&ff->user_path);
+	kmem_cache_free(bfilp_cachep, ff);
+}
+
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
@@ -73,8 +79,7 @@ static inline void file_free(struct file
 		percpu_counter_dec(&nr_files);
 	put_cred(f->f_cred);
 	if (unlikely(f->f_mode & FMODE_BACKING)) {
-		path_put(backing_file_user_path(f));
-		kmem_cache_free(bfilp_cachep, backing_file(f));
+		backing_file_free(backing_file(f));
 	} else {
 		kmem_cache_free(filp_cachep, f);
 	}
@@ -283,6 +288,12 @@ struct file *alloc_empty_file_noaccount(
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
@@ -305,7 +316,14 @@ struct file *alloc_empty_backing_file(in
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
 


