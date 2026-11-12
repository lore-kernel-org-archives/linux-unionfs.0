Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794455890;
	b=r7LfmLKhGWOp3I2cx8BVr9Elt56AmAffMTD+cw5v6OJouxNA0j3Fik+t/97Wab+b50yn
	 qiErAI03ipwa7klT/ECsCT2JVFuGg2nVmiPzNDu2jgufxI9dI/u+tVY9MhPvtpP8jfQgJ
	 YgYwD34wEr90nlcghBza2j7yJVxdQVBXjIUIDeFLBhk74D14g034Es0QAALZhXSpD2G1G
	 Eh5HVABYe8DsPJr5jYUDQlIiJdEAU60sio34BKfbP8ZVOSpKm3sPxS7Rb2NA8kY8gWMdt
	 UU2gDxdZIw+NuOfgYBS4v/3GXfMLh4+1kD1In3lgNgLwrAWVUli2FERQKR1GMdD1c/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794455890;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=WH4pdt08cs8iJPVsI9HZb4QxuC1IttM/V55RvcEfuvk=;
	b=TEzU2CkooeXgPyudZgYSdjU/eV2uEei7TzEJBmji/Xo2qCpLrfxubRVDS97mOrKsoZbF
	 vbIAgRpXNGEyb1gwYBzsxstGt3IGMgREP4bQ6xiBl7xfRjIphvjQFAd/+sDE8vh1OTNeh
	 X7cakwfcNUImlFXRekpyc1QnF9zseHXBHzowN4pa3N8YANnW/cBIFE2atHvdKVWkIJvb1
	 45mlhpJBCXgVtAYAlJWcDJrpMOC5FuR90gh2tEVmJsYPRjOSSK+DdQorYbdc2WRd+hRdd
	 f546Gu9ptBuzULldxlqGGuZWQdwL70SFSm72tPiAXChmfnO18vg2m0vXvnppCn4eWAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dd2Db+eQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB487606A31C;
	Thu, 12 Nov 2026 03:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dd2Db+eQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794455890;
	b=Xzuts3lbebK/G+xnS8mkV3/o8ODbY590dzpQI86KGF660f1EO+ba/soNgVk/03G+T7Vo
	 e2sOn7NzulmQXrDU4UqLWl2vO+rmxKfyK/UXvI6NEgD+b3/inOzhQMWvQQNdXZGKl6CG/
	 ssrXyE6JcRa1KAMZdgYeFnq5voPV8X430Dyh/eR8qsa+NOjjKBvSur4+pNDvM63A0SatU
	 tkavPtMCA4xVdt7M1bcClVhC/7Cou92wDt4luJV3j40C5Wf8v8fxfDqz5kz5cudQhrGXq
	 veUNH/dZgf+vqryjeNyNA3UzyIBRV2TpfEFjt3dVoQfzefEDgPSmpcf+z4xCyA/Z5og==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794455890;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=WH4pdt08cs8iJPVsI9HZb4QxuC1IttM/V55RvcEfuvk=;
	b=kEsN3VIToys7Uq/lIo02/hibxMQVNn1MX8TeYp11sowaBhH9c0M1po0UZpFaJqjC1Of1
	 NXgo6/ABzzMlTllPNMKG6/ecQJG3Wbdb98jMFtPZ/arNkDo3/CVpwfdcSy1EpHocES8Cw
	 U0UJkeJth5UQCrUf5f0oUP+ensrX2C5w2gtSqHVwxxKdf1TTdU4SiHW1/sJP+naaIreia
	 qs1a9fVcBYE8j+QqnNvmnifLY5la2C/AHnzeeCibnoVcPK3dkWG/wBS5cUFlmcuz+E5At
	 8OOfDBqA9y9lTaGN1BpwaEIquHr2HDNoUihBflWwgBCoMhGcMKAlrWsxZgF18OCiQLA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CCB511F00A05;
	Thu, 12 Nov 2026 03:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794455890;
	bh=WH4pdt08cs8iJPVsI9HZb4QxuC1IttM/V55RvcEfuvk=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=dd2Db+eQDu/f59m99hkTXNER2RPukDhSAnIlzNNlTK8+Po3FDFKovc9EorEVyBxew
	 RmkQ0ZvezoAogsb1DJ8jEjNR7Z9jD3vvPk+kjWFJ5HhuWbW9IadvOV1a0YUuUsWU6Z
	 njZBt7tYnj2tduTP1ZTjgNgAm0QUSUW84Ar/r6bw5KhKESOnyxySp9ExRI95Cy17DR
	 /vQPNYgFcAbqeWF/MgU5zQH4WX8R2sNsOGhzFNbWhMuCUs9XPWlMhVHaPbm3qsbHLB
	 u6vfVOtxJ7ONt6Q8W/pgZPdBR9AlfB0a6Kv8rBhIZKRv9dG4vBUGwFx19QmHT0aaB0
	 cuNt0SembKlZw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2DFA649261;
	Thu, 12 Nov 2026 03:58:09 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 12 Nov 2026 12:58:09 +0900
Subject: [PATCH] ovl: bump the impure dir version when linking a file with
 origin
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
Message-Id: <20261112-ovl-link-impure-v1-1-7804905610a9@samsung.com>
X-B4-Tracking: v=1; b=H4sIAFA59WoC/x3MQQqAIBBA0avErBtopES6SrSInGqoVJQkiO6et
 HyL/x9IHIUT9NUDkbMk8a6A6grmbXIro9hiUI3SRKTQ5wMPcTvKGa7IaLRqDTXUaWugVCHyIvd
 /HMb3/QAmDAOQYQAAAA==
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Sashiko <sashiko-bot@kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794455888; l=4013;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=KL4nutV0WdP0jvfIHdlIIHren54/dSp9jeM8NnkBbQ8=;
 b=4tIZe/ic11x6dFKJ6OaClDWqN40yI94UC+AbRPlyd3ElduWhwW/8/ITGrDjl7U7/2I/k/o0bf
 yzNoRM2imq6Ac29GzZYFO6Xt3X3KzDu8LpYdGUHPWFAnTxeiPmJ+GhH
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Linking a file with copy up origin into a non-merge impure dir does
not bump the dir version. readdir then reuses the impure dir cache
built before the link. It reports the upper inode number as d_ino of
the new link, not st_ino.

Pass whether the linked file has an origin to ovl_dir_modified(), as
rename and unlink do.

Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-98f207b6-3936-48e9-a40f-88f20be4db7b
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested on ext4 and xfs with default overlay options: the new fstests
test overlay/013 fails without this patch and passes with it. So does
a script that puts a whiteout in a non-merge upper dir before mount
and links over it (ovl_create_over_whiteout()). Apart from
overlay/013, only 079, 085 and 088 fail in overlay/auto on ovl-fixes,
with and without this patch.
---
 fs/overlayfs/dir.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index e0a164e22d67..8fec18dc5fc7 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -368,7 +368,7 @@ static bool ovl_type_origin(struct dentry *dentry)
 }
 
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
-			    struct ovl_cattr *attr)
+			    struct ovl_cattr *attr, bool origin)
 {
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
@@ -393,7 +393,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 		ovl_set_opaque(dentry, newdentry);
 	}
 
-	ovl_dir_modified(dentry->d_parent, false);
+	ovl_dir_modified(dentry->d_parent, origin);
 	err = ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink, NULL);
 	if (err)
 		goto out_cleanup;
@@ -491,7 +491,7 @@ static int ovl_set_upper_acl(struct ovl_fs *ofs, struct dentry *upperdentry,
 }
 
 static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
-				    struct ovl_cattr *cattr)
+				    struct ovl_cattr *cattr, bool origin)
 {
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *workdir = ovl_workdir(dentry);
@@ -582,7 +582,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		if (err)
 			goto out_cleanup_unlocked;
 	}
-	ovl_dir_modified(dentry->d_parent, false);
+	ovl_dir_modified(dentry->d_parent, origin);
 	err = ovl_instantiate(dentry, inode, newdentry, hardlink, NULL);
 	if (err) {
 		ovl_cleanup(ofs, upperdir, newdentry);
@@ -647,12 +647,12 @@ DEFINE_CLASS(ovl_override_creator_creds,
 
 static int ovl_create_handle_whiteouts(struct dentry *dentry,
 				       struct inode *inode,
-				       struct ovl_cattr *attr)
+				       struct ovl_cattr *attr, bool origin)
 {
 	if (!ovl_dentry_is_whiteout(dentry))
-		return ovl_create_upper(dentry, inode, attr);
+		return ovl_create_upper(dentry, inode, attr, origin);
 
-	return ovl_create_over_whiteout(dentry, inode, attr);
+	return ovl_create_over_whiteout(dentry, inode, attr, origin);
 }
 
 static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
@@ -687,12 +687,14 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		 */
 
 		if (attr->hardlink)
-			return ovl_create_handle_whiteouts(dentry, inode, attr);
+			return ovl_create_handle_whiteouts(dentry, inode, attr,
+							   origin);
 
 		scoped_class(ovl_override_creator_creds, cred, original_creds, dentry, inode, attr->mode) {
 			if (IS_ERR(cred))
 				return PTR_ERR(cred);
-			return ovl_create_handle_whiteouts(dentry, inode, attr);
+			return ovl_create_handle_whiteouts(dentry, inode, attr,
+							   origin);
 		}
 	}
 	return err;

---
base-commit: 0d5e729c515f4ae4eacc179dbcf350d9b499a161
change-id: 20261112-ovl-link-impure-8624810156d8

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


