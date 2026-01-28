Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7301C2F0C45
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769606655; cv=none; b=dn9+QnD6FMGzWWF1p5wp63VSYEndXxjfEUiz1OJQ6JaVtb9+7k5UUugr/TWW5FRRMSAW9AMUmP2G3wczc2SjvxeQORSw2AMzq3Coo60F0Xmnm0nvHXMIyQhhFIJJ8IDO2gXw3cMZXD7hSCA7EQw+pcPw/fVnCstWOC30kTlKDrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769606655; c=relaxed/simple;
	bh=Og0yUsffNdz+0Ckbusdu1EaznuC6uspuTdFy0bPsuf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbLGDQ2cagz9+gF6iQyFtqFBdnYyAqvtfczoTfK8/524WMzacYBDyTP+rRn8DfEOZWIz1Wb5R4kPk59SwK1XuKdLK1m6CCGkSp/uaD9EodOxwTL8iVZk17Bj/Rz02QfvcGyDEqxwGHIDFyP4j/r5tVvPs1JOnserjUdSq8OyGnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OShHKG5C; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OShHKG5C"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65808d08423so10270612a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 05:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769606652; x=1770211452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7bTbQqX4By4dCHLXfdzqYTwBL6gPTmqwLaEkWBU140=;
        b=OShHKG5C57u9tZplHFBWQ1sSuhbzven8rAy9PmSVk2jeYYriRFT/9C7HIPDMcFG6O9
         Zu2IF7SZ2ckBtCaClZBD7Um75WFwMt/W2A9M6hFVqyt57Zu3BEL08iq0nkh/wON8bIKy
         K3Oe5Vhvtw0mKk20wtvy5e22GnHjDjVio+v3QOFPi3AEL8aMAayhcUqkI8AzcC/a22zS
         18VKVJBm2CIk9lTi+3EY0BCNrI9vRQ2xKSJNcmSx5iIseYFUdIeuBWWes3Ozwdc8lW2a
         ciC3r4c6FTR9kIxVVYpTdaPmlUBTng+K7H8BmfiqxdludldCAy1YHo9bSHgA8tDgr1ZJ
         mKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769606652; x=1770211452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/7bTbQqX4By4dCHLXfdzqYTwBL6gPTmqwLaEkWBU140=;
        b=wyoqCgUVEzesyXJBqWgD8ZTOVtXBSLpWGZDCcaFlPW+klAmSeIpo3X3o6KZT+8xWHq
         EtSABxa+fummEgis1tgvYYYO8ANEF1O7Mh6K3Lqp8t2kiU3rpVPT8EzfjNZtOdZ8kC9I
         xX1vwFNPZnsJ3B9uKEuyA4MYS3oh9NjPyxGPY5cFNhTHiiPR04qxZI/VFXGszZA2yioo
         32rUAIWMMPn0tDXo9OmEVkcyTsc7RC9fFV3NqP0HgvJz7v80rT853r8nvGRHP08ivkND
         MhcyldmVQHfy9TgqScxxY2uMDMYzbYLVDDkoS4CwvuxnsMhk7BCa8TAUEY7wavK8TeL2
         RlFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCbEjBWYHP1OFsh97nblINrLXc8lu0eMlEXL/jPlH8mReW+szERdemUot/onTAXsSlO4akRzweAYoZfvL7@vger.kernel.org
X-Gm-Message-State: AOJu0YxgSsr8g89r80Nt+HdYH+aIHO+Z12Kb/9AAt3HkbshSFr7ZXSDF
	3P24RgAb81abikxArhLhi674yJJtw5UCe2v1NfkvNF9tKpf2qTy4gCCEVvG6cIpr
X-Gm-Gg: AZuq6aLSv4LF9LUOT/0Q5bOMXspCMUwm06VzFyinj7SRXwu6Nd1gXv0HtF8HXnzm47Z
	4yu/j1Qjh7WHwt3WvSpLXDYZ/FJGgz6YDWvkQBenwafnNQc3bm5eU4rzCdbfCZoSo6qlEWv3exE
	dTJ7zCq1NcejW2irum2cZMpjh7F1Ymr7Qa4fGKfONSgJ99N6sl2YyBVT1NLC5J71uCoqlWKTEjd
	Rft4RKSf5c82tQr7KeEfz93teC+wzsGjYoq3SO4hdJzFhQZ9e7/pY5ueKM/gDY3k/r0/VlUl+NE
	5t3xu16CS5o6Cr31hMTkF85sWUQe7B4c93JpvnO4f087mpWOQe6LeIzKgU5KmFRMpxonXEtSlHc
	E0ZVmfv0iFZxRXpNdf9+oDz39FJnsCK8WzWrtYt5BADHu7wWpJFLf4o9Qwng5VccO9LvdZNvy6O
	/qcGVzlolUVd5zh4Xg6DI9B1xqz5M0O5cPj8BV0x0IOoWuIq+WTnKpjIyrPGBqkzmrkW0wSmHsH
	z3GNZKCHP5zp+k7lMIQ8BFKhpA=
X-Received: by 2002:a05:6402:5246:b0:658:3b8c:9f25 with SMTP id 4fb4d7f45d1cf-658a60a03bamr3087593a12.26.1769606651726;
        Wed, 28 Jan 2026 05:24:11 -0800 (PST)
Received: from localhost (2001-1c00-570d-ee00-c84e-f30e-bdab-df5a.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:c84e:f30e:bdab:df5a])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b46abea5sm1543914a12.31.2026.01.28.05.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 05:24:10 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>
Cc: Qing Wang <wangqing7171@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 3/3] ovl: use name_is_dot* helpers in readdir code
Date: Wed, 28 Jan 2026 14:24:06 +0100
Message-ID: <20260128132406.23768-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128132406.23768-1-amir73il@gmail.com>
References: <20260128132406.23768-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the helpers in place of all the different open coded variants.
This makes the code more readable and robust.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 9f6b36f3d4cf8..5727948d6566a 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -154,7 +154,7 @@ static bool ovl_calc_d_ino(struct ovl_readdir_data *rdd,
 		return true;
 
 	/* Always recalc d_ino for parent */
-	if (strcmp(p->name, "..") == 0)
+	if (name_is_dotdot(p->name, p->len))
 		return true;
 
 	/* If this is lower, then native d_ino will do */
@@ -165,7 +165,7 @@ static bool ovl_calc_d_ino(struct ovl_readdir_data *rdd,
 	 * Recalc d_ino for '.' and for all entries if dir is impure (contains
 	 * copied up entries)
 	 */
-	if ((p->name[0] == '.' && p->len == 1) ||
+	if (name_is_dot(p->name, p->len) ||
 	    ovl_test_flag(OVL_IMPURE, d_inode(rdd->dentry)))
 		return true;
 
@@ -561,12 +561,12 @@ static int ovl_cache_update(const struct path *path, struct ovl_cache_entry *p,
 	if (!ovl_same_dev(ofs) && !p->check_xwhiteout)
 		goto out;
 
-	if (p->name[0] == '.') {
+	if (name_is_dot_dotdot(p->name, p->len)) {
 		if (p->len == 1) {
 			this = dget(dir);
 			goto get;
 		}
-		if (p->len == 2 && p->name[1] == '.') {
+		if (p->len == 2) {
 			/* we shall not be moved */
 			this = dget(dir->d_parent);
 			goto get;
@@ -666,8 +666,7 @@ static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
 		return err;
 
 	list_for_each_entry_safe(p, n, list, l_node) {
-		if (strcmp(p->name, ".") != 0 &&
-		    strcmp(p->name, "..") != 0) {
+		if (!name_is_dot_dotdot(p->name, p->len)) {
 			err = ovl_cache_update(path, p, true);
 			if (err)
 				return err;
@@ -756,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 	bool res;
 
-	if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", 2)) {
+	if (rdt->parent_ino && name_is_dotdot(name, namelen)) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
@@ -1097,11 +1096,8 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 			goto del_entry;
 		}
 
-		if (p->name[0] == '.') {
-			if (p->len == 1)
-				goto del_entry;
-			if (p->len == 2 && p->name[1] == '.')
-				goto del_entry;
+		if (name_is_dot_dotdot(p->name, p->len)) {
+			goto del_entry;
 		}
 		err = -ENOTEMPTY;
 		break;
@@ -1146,7 +1142,7 @@ static bool ovl_check_d_type(struct dir_context *ctx, const char *name,
 		container_of(ctx, struct ovl_readdir_data, ctx);
 
 	/* Even if d_type is not supported, DT_DIR is returned for . and .. */
-	if (!strncmp(name, ".", namelen) || !strncmp(name, "..", namelen))
+	if (name_is_dot_dotdot(name, namelen))
 		return true;
 
 	if (d_type != DT_UNKNOWN)
@@ -1209,11 +1205,8 @@ static int ovl_workdir_cleanup_recurse(struct ovl_fs *ofs, const struct path *pa
 	list_for_each_entry(p, &list, l_node) {
 		struct dentry *dentry;
 
-		if (p->name[0] == '.') {
-			if (p->len == 1)
-				continue;
-			if (p->len == 2 && p->name[1] == '.')
-				continue;
+		if (name_is_dot_dotdot(p->name, p->len)) {
+			continue;
 		} else if (incompat) {
 			pr_err("overlay with incompat feature '%s' cannot be mounted\n",
 				p->name);
@@ -1278,11 +1271,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 		goto out;
 
 	list_for_each_entry(p, &list, l_node) {
-		if (p->name[0] == '.') {
-			if (p->len == 1)
-				continue;
-			if (p->len == 2 && p->name[1] == '.')
-				continue;
+		if (name_is_dot_dotdot(p->name, p->len)) {
+			continue;
 		}
 		index = ovl_lookup_upper_unlocked(ofs, p->name, indexdir, p->len);
 		if (IS_ERR(index)) {
-- 
2.52.0

