Received: from neil.brown.name (neil.brown.name [103.29.64.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54AF2980BF;
	Thu, 10 Jul 2025 23:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.29.64.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752189689; cv=none; b=NaJQhcEqeK4MiG92IxxyIXVhz9T+9AFDaZi1KoKt+M2IYCvYBG9N1u0wj2PE6s1nWY22xDx7ZCvhTnLLBpjxNli+wjyeYD5T/cGLC/UoEG3AsLxDBcL0b1iX9w5GcKTgA9V0TGUeVpV6MBIGuVHeGBsfqBUaouSmVgi4/g14QZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752189689; c=relaxed/simple;
	bh=w7XGick/okVxT8PYBVWNuwfMHZfGOgrT0jOTVmIuFQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqlSbFQJTNsp/NQB5liSOfL0E5kxwjDVzY+TNfBfYMZjPyhwLee9y5R6cKCZsgJHdgDtdkFnO0zk67PFWEnxZBZ69gYSNQ/lBIKfne7tCS78q62XJi5+DcR5kWYfSD1/LOWJASMWkGM5uLV8dK3AzeZ6ycZIxvKAmuA6EQDJ8+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name; spf=pass smtp.mailfrom=neil.brown.name; arc=none smtp.client-ip=103.29.64.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=neil.brown.name
Received: from 196.186.233.220.static.exetel.com.au ([220.233.186.196] helo=home.neil.brown.name)
	by neil.brown.name with esmtp (Exim 4.95)
	(envelope-from <mr@neil.brown.name>)
	id 1ua0Zw-001XH4-57;
	Thu, 10 Jul 2025 23:21:25 +0000
From: NeilBrown <neil@brown.name>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 15/20] ovl: narrow locking on ovl_remove_and_whiteout()
Date: Fri, 11 Jul 2025 09:03:45 +1000
Message-ID: <20250710232109.3014537-16-neil@brown.name>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250710232109.3014537-1-neil@brown.name>
References: <20250710232109.3014537-1-neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normally it is ok to include a lookup with the subsequent operation on
the result.  However in this case ovl_cleanup_and_whiteout() already
(potentially) creates a whiteout inode so we need separate locking.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/overlayfs/dir.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index d01e83f9d800..8580cd5c61e4 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -769,15 +769,11 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 			goto out;
 	}
 
-	err = ovl_lock_rename_workdir(workdir, NULL, upperdir, NULL);
-	if (err)
-		goto out_dput;
-
-	upper = ovl_lookup_upper(ofs, dentry->d_name.name, upperdir,
-				 dentry->d_name.len);
+	upper = ovl_lookup_upper_unlocked(ofs, dentry->d_name.name, upperdir,
+					  dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
-		goto out_unlock;
+		goto out_dput;
 
 	err = -ESTALE;
 	if ((opaquedir && upper != opaquedir) ||
@@ -786,6 +782,10 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 		goto out_dput_upper;
 	}
 
+	err = ovl_lock_rename_workdir(workdir, NULL, upperdir, upper);
+	if (err)
+		goto out_dput_upper;
+
 	err = ovl_cleanup_and_whiteout(ofs, upperdir, upper);
 	if (err)
 		goto out_d_drop;
@@ -793,10 +793,9 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 	ovl_dir_modified(dentry->d_parent, true);
 out_d_drop:
 	d_drop(dentry);
+	unlock_rename(workdir, upperdir);
 out_dput_upper:
 	dput(upper);
-out_unlock:
-	unlock_rename(workdir, upperdir);
 out_dput:
 	dput(opaquedir);
 out:
-- 
2.49.0

