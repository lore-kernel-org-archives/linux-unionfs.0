Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C4332ED3A;
	Mon, 17 Nov 2025 09:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763372109; cv=none; b=DLuWO1bxUtMtOwbK7PhaN2NeYX1gyYztMXTm8Q1n/U22txUnMBkMHXOKfryMggXpaas/p6RvX25f5EMnAqU794vu2fd3J6bPXi8BMvMchuJ9CCuPvA0Lag2parCOzeJhxq+53asrDzlXNkdfgt7CYmMsKJx5FQtizM8Y/XgozZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763372109; c=relaxed/simple;
	bh=5cCYsblWD5tSU+CVXR6b4rcZVCNU2ki0A+2b0MA7KEI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gx2tmubxloMdVhcfmu11psxG0y2Zx9jLuCaJwBWNK5aS/CeNO/URWBPJSyW1thXuVwbly4KvwMyaY7aaKGQ4tQMN51fKzxRNopTwu+dxfIjx0q9RwrWkIJBzOnRFNpWaND77yaPaT/94y7tK1+HA3ebcllhP0ZH1U1n//YN4N6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyDWHlzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyDWHlzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93658C4CEF1;
	Mon, 17 Nov 2025 09:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763372108;
	bh=5cCYsblWD5tSU+CVXR6b4rcZVCNU2ki0A+2b0MA7KEI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WyDWHlzEtOML1OLU87mJa94+CcAGTSolqOq6/Wh90Hgqna4F93Pm0AdG2IyBJLZRi
	 AqGtFNfgX61X/k/SA4qG54ojJBDX/lgNYNumSCGZEEIHFevypDtOyEaJdClO/8mzbu
	 QE1MdNd6Eg3zbF+IRfQg3PZGZdlqLa2fFx+/3n/ecc3ml+FdG1PW0/rSqiQxo0Jy3u
	 8ihDq1TbgPydBwDKi5eFIhhVS3NBW/lxD0g78hhCbferanN4pN5kjPqTl56XdLCcmy
	 81c+H1U6UjpwMP02gbnB0pAghFYp9g03ibQFhbtp9F7PnmtZTvTW/lTlP/OG3PLg5a
	 LEUoh0/lfpUzg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 17 Nov 2025 10:34:40 +0100
Subject: [PATCH v2 3/6] ovl: reflow ovl_create_or_link()
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-work-ovl-cred-guard-prepare-v2-3-bd1c97a36d7b@kernel.org>
References: <20251117-work-ovl-cred-guard-prepare-v2-0-bd1c97a36d7b@kernel.org>
In-Reply-To: <20251117-work-ovl-cred-guard-prepare-v2-0-bd1c97a36d7b@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-a6db3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1847; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5cCYsblWD5tSU+CVXR6b4rcZVCNU2ki0A+2b0MA7KEI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRKvXG9K6bsvvBJ4e7Ja2SYeBe9m/HWNd1ne3pV6uOHH
 5f37jCc3lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARwzRGhunst1yzrmZdi5W8
 WXLlxuYnHW7dZ7lnTNDzelvRf+R90U5GhtP7L16fwPSPv8J1vaKU0IJWwar9KQ7nOldL3r/YvO+
 rCSsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Reflow the creation routine in preparation of porting it to a guard.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/overlayfs/dir.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index dad818de4386..150d2ae8e571 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -644,6 +644,15 @@ static const struct cred *ovl_setup_cred_for_create(struct dentry *dentry,
 	return override_cred;
 }
 
+static int do_ovl_create_or_link(struct dentry *dentry, struct inode *inode,
+				 struct ovl_cattr *attr)
+{
+	if (!ovl_dentry_is_whiteout(dentry))
+		return ovl_create_upper(dentry, inode, attr);
+
+	return ovl_create_over_whiteout(dentry, inode, attr);
+}
+
 static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 			      struct ovl_cattr *attr, bool origin)
 {
@@ -662,7 +671,6 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 				return err;
 		}
 
-		if (!attr->hardlink) {
 		/*
 		 * In the creation cases(create, mkdir, mknod, symlink),
 		 * ovl should transfer current's fs{u,g}id to underlying
@@ -676,16 +684,15 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		 * create a new inode, so just use the ovl mounter's
 		 * fs{u,g}id.
 		 */
+
+		if (attr->hardlink)
+			return do_ovl_create_or_link(dentry, inode, attr);
+
 		new_cred = ovl_setup_cred_for_create(dentry, inode, attr->mode, old_cred);
 		if (IS_ERR(new_cred))
 			return PTR_ERR(new_cred);
-		}
-
-		if (!ovl_dentry_is_whiteout(dentry))
-			return ovl_create_upper(dentry, inode, attr);
-
-		return ovl_create_over_whiteout(dentry, inode, attr);
 
+		return do_ovl_create_or_link(dentry, inode, attr);
 	}
 	return err;
 }

-- 
2.47.3

