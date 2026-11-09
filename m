Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794225533;
	b=RPBY4P/uSfFMjIe8ZKe0nVLCKD9v+ariEdevaVz/5zENJ8VGIYmLsGnmf43Ith7J+DZq
	 UPzxwOt4J7wRAFE9p8bekcXAs3YCp2A2RBdmQZvECo7TVG6lgE3EoX3FDDiWlZ+r3pQdL
	 26vvwwWIy1FcOiGF9RvL4in+aH+vKpiWaTnKmHPLBvLRJAPpMglWOE6ZzV2K11w9OBpiw
	 q13tsapE0b9H+OU9kPEa3wGSPJjaxTXP9N1fbDm1NcInpKFt/o4jR2YOJMoVrqqs0aeVo
	 rQP57pri37pE8LBjC9pJtmtEWflfId5yfC4qNCDnaVHrBspak/QIYpbPj4UEgmfusNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794225533;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/nkLmGE++6Yg5VLLKkk/0LplysxV4+TeShfYq6rwv+w=;
	b=lXaHPtDt9ZfD4wCtLirS5lG2Ev9lXcDlOCGajU88hu1mzdEi4BRuk7lMnqdIM6PFLqpe
	 6fYy4fs6zJXOZWWCJ6ap0FfGQw+7pu1MufnWXAOxpA7p49QK822UB7yfo/WFUdps/XBR1
	 bwwjk2BymN/83Wa1LWPnp84yohRUhVIewfNVS7T+f6Bl0gf7EDXEGAEhMCDRSrrkq2kRL
	 dY41u4IhKS18pkIKtf8jgFrbcQqvM981sRMXCydTzdxIfzC6HxRibUiS3OP8L5ed/eBfW
	 OgVka+xvlQLjWYu8IzEbjIFPQUvPb20ZtHe/MoWW26l8Uyr09pUpKxpJzN4CYZVo/tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="SID/Ehjp";
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A93606A323
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2026 11:58:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8A93606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SID/Ehjp
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c43373ae89aso110263866b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2026 03:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794225531; x=1794830331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/nkLmGE++6Yg5VLLKkk/0LplysxV4+TeShfYq6rwv+w=;
        b=SID/Ehjp+vuo0w5TiFd1hQP6M1i1ffeclw4nHtwFH4FqVDuZAMddEykgLprGCrokLy
         wKhlZVWbV2AfEYbp8i88pCrp2Idpi5KrWe7Qp+rFx9Le0OmC9PglGyMVhefAlfO0j3DZ
         BwLfGC7ikxwgz1oZUNLODpoQ1oDMHhCjnDPE24fXV+NVdfchSY3/kg0Q9ksYzlIgktBX
         hLLNuPS3sGZ+baQvAaamUCLY3Cx/DHG+2TvpbEA+NMRjT+QE89XHOYuDx4zz1zOoPpdW
         kYY418J5c05Fv65o/FTRlGcJFKNmlDwPeB4tII97jUwMlg6EpPS8quMPkFQIGHdLWYfE
         FC0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794225531; x=1794830331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/nkLmGE++6Yg5VLLKkk/0LplysxV4+TeShfYq6rwv+w=;
        b=TXPzZ8qmdOLpQGumOlKEqQgrlXy6BcRCDdUy0w8a4ZfS3daZLeWDYaQ7rFKn0Z/roV
         JhQoePO57i5s+QAhLzzD556sw95CVEllQW5C8pZkvN+Zm84uJhzh2zTcIAGMLT5ixU69
         cvh3Et474KaGRy9Ow7uA6TwLwDqxZEAL42Ij5aT7rw70J7QTRLWtUXn+jWtaGd/rDzDn
         TDotihg1ZOBtDLgX6BkxZ/Sl+0Wg8lR3+UlKnOXy0JWgAUmQpAnE2h95lhF9u0zzidzB
         IMYzWtJGgEmeAbEbrt0zBSYRBtXyaBrRqVcGPbGcL7fZwR9RxgxsOEoretLqXMw4EN8k
         rmcA==
X-Forwarded-Encrypted: i=1; AL+hErFIv6JQw9G37AtcmSlpRaKdOlo3lFTi0qmRbkb/F9qwgYsd8tUdJ3YEHA5Kj/olZnQCqmiWOXZ5efVA7bE6@vger.kernel.org
X-Gm-Message-State: APuU4Z+a2qsH0JUNdyCzVZM1kOpkOE2W5lhDIL2oVaE/x+GNlL3rbfRs
	fMooMfhJE2uMfdcotL/XFLojmnmHDwI42XS7Jvor2kDbO/P5AJl+cU1vsz6oYBRM
X-Gm-Gg: AYBFou2xgtZmxFEW/pdEicx9+AwiT2b+FaQFl2mI+ulxBMOMWY4KCHRvh/qFUcBcFK/
	kykHg5sEYlSPHKFjT++SYIhCkhpZ4G88k+uGkp19BSdby+ugoUsKSBvVE51uKMx/uiDkxPMp4fn
	bgECNTVZ4vP6HsLzfKrxPO7+feB9iMr6i7M39dvOTB1iBNGKO6I+Mt4xST1L6/x3HjPB5ESQPRn
	hgrcTcHUCAkP1ZHwm0KGfJZWJySbF3LuRTWLLzFyJICA88vGLXH6+N32m0SgirxIuXXEwm+NeCY
	nYVEz1XOVL882KmQipujhZIvN2DaPbbvW8SriLPndI4322N1VUaKblKht+j/kcjRnn8wOoXDJyi
	cBAVYwq/l9g8gLyCr1a0GABEB5yaGiwus3QSNSpnSll+lJ1KYoNTpOrwQPpHmzni+9LmIiNde73
	+/4pNxTh+h2xKeqMamqIxly7/w+gBpJl9dbK41L7xri7oEtPR/x32XWBAwVTMV4qWCcVSy659lR
	HnUWVjU37Dgp/z/VDw4EiRVeiL3aFr0LN8rZ3vS/MvdZTMGT1fSlAXCOPUVz4ZgY3W0SAygp57N
	M8XGgYlJ7hmTjEcWfxDzk6DbbFLfZexbYpVp5Iqd7F9LTs1wY9H77EZUCSc9KDMavjfAiupakTb
	SQz/i7AVqfulDJMFS2Fb8mSCkuboTW2a7
X-Received: by 2002:a17:907:ea8a:b0:c45:d8aa:6ae5 with SMTP id a640c23a62f3a-c4d6d7ecd22mr281803966b.42.1794225530840;
        Mon, 09 Nov 2026 03:58:50 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d69f943fasm153644166b.16.2026.11.09.03.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:58:50 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Giuseppe Scrivano <giuseppe@scrivano.org>,
	linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] ovl: follow lower to lowerdata redirects from any lower layer
Date: Mon,  9 Nov 2026 12:58:49 +0100
Message-ID: <20261109115849.4032575-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Giuseppe Scrivano <giuseppe@scrivano.org>

Commit 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower
-> data redirect") allowed following redirects from a lower layer to a
data-only layer without redirect_dir=follow and metacopy=on, so that
data-only layers can be used with userxattr.

That fix was incomplete.  Without metacopy=on, a metacopy file with an
absolute redirect into a data-only layer is followed only from the lowest
lower layer.  From any other lower layer, the lookup fails with EPERM.

That commit also changed the behavior of redirect_dir=nofollow without
making it visible to users.  With data-only layers, some redirects are
followed, although the mount options show redirect_dir=nofollow, or
show nothing when that is the default.

Add redirect_dir=followdata, which follows only redirects from lower to
lowerdata, and select it when there are data-only layers, unless
redirect_dir=follow or redirect_dir=on is in effect, so the redirect
follow mode in effect is shown in /proc/self/mountinfo.

Without metacopy=on, the absolute redirect of a lower metacopy file stops
the lookup in the lower layers and the data is looked up in the data-only
layers.  Data-only layers cannot be used without following redirects,
so reject an explicit redirect_dir=nofollow with data-only layers.

Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower -> data redirect")
Cc: stable@vger.kernel.org
Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Giuseppe,

This is your v2 rebased over some related fixes I found,
All are applied to my ovl-fixes branch in github.

Also made some cosmetic changes to helper names and comments.

Thanks,
Amir.

Changes since v2:
- Rebase over fixes
- Simplify code with ovl_redirect_follow_lower() helper
- Simplify code with ovl_redirect_nofollow_mode() helper
- Explain the problems with the Fixes commit


 Documentation/filesystems/overlayfs.rst | 16 ++++++++-----
 fs/overlayfs/namei.c                    | 24 ++++++++++++++++---
 fs/overlayfs/overlayfs.h                | 21 ++++++++++++++--
 fs/overlayfs/params.c                   | 32 +++++++++++++++++++------
 fs/overlayfs/params.h                   |  1 +
 fs/overlayfs/super.c                    | 16 +++++++------
 6 files changed, 85 insertions(+), 25 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 4c241d220bc23..b498c8e56c5ad 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -239,6 +239,9 @@ Mount options:
     Redirects are enabled.
 - "redirect_dir=follow":
     Redirects are not created, but followed.
+- "redirect_dir=followdata":
+    Redirects are not created.
+    Only redirects from lower to lowerdata are followed.
 - "redirect_dir=nofollow":
     Redirects are not created and not followed.
 - "redirect_dir=off":
@@ -418,8 +421,8 @@ pointed by REDIRECT. This should not be possible on local system as setting
 "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
 for untrusted layers like from a pen drive.
 
-Note: redirect_dir={off|nofollow|follow[*]} and nfs_export=on mount options
-conflict with metacopy=on, and will result in an error.
+Note: redirect_dir={off|nofollow|followdata|follow[*]} and nfs_export=on
+mount options conflict with metacopy=on, and will result in an error.
 
 [*] redirect_dir=follow only conflicts with metacopy=on if upperdir=... is
 given.
@@ -460,10 +463,11 @@ to the absolute path of the "lower data" file in the "data-only" lower layer.
 
 Instead of explicitly enabling "metacopy=on" it is sufficient to specify at
 least one data-only layer to enable redirection of data to a data-only layer.
-In this case other forms of metacopy are rejected.  Note: this way, data-only
-layers may be used together with "userxattr", in which case careful attention
-must be given to privileges needed to change the "user.overlay.redirect" xattr
-to prevent misuse.
+In this case other forms of metacopy are rejected.  A data-only layer selects
+"redirect_dir=followdata", unless "redirect_dir=follow" or "redirect_dir=on" is
+in effect.  Note: this way, data-only layers may be used together with
+"userxattr", in which case careful attention must be given to privileges needed
+to change the "user.overlay.redirect" xattr to prevent misuse.
 
 Since kernel version v6.8, "data-only" lower layers can also be added using
 the "datadir+" mount options and the fsconfig syscall from new mount api.
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b7fb5bb2e597f..d846c8d15b1cc 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1079,7 +1079,8 @@ static bool ovl_check_follow_redirect(struct ovl_lookup_data *d)
 		pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n", d->dentry);
 		return false;
 	}
-	if ((d->redirect || d->upperredirect) && !ovl_redirect_follow(ofs)) {
+	/* Check follow to lower layer, redirects to lowerdata are not checked here */
+	if ((d->redirect || d->upperredirect) && !ovl_redirect_follow_lower(ofs)) {
 		pr_warn_ratelimited("refusing to follow redirect for (%pd2)\n", d->dentry);
 		return false;
 	}
@@ -1097,13 +1098,26 @@ struct ovl_lookup_ctx {
 	unsigned int ctr;
 };
 
+/*
+ * Without metacopy=on, the absolute redirect of a lower metacopy file is
+ * followed only into the data-only layers.
+ */
+static bool ovl_is_lowerdata_redirect(struct ovl_lookup_ctx *ctx,
+				      struct ovl_lookup_data *d)
+{
+	struct ovl_fs *ofs = OVL_FS(d->sb);
+
+	return ofs->numdatalayer && !ofs->config.metacopy && ctx->ctr &&
+	       d->metacopy && d->absolute_redirect;
+}
+
 static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data *d)
 {
 	struct dentry *dentry = ctx->dentry;
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct ovl_entry *poe = OVL_E(dentry->d_parent);
 	struct ovl_entry *roe = OVL_E(dentry->d_sb->s_root);
-	bool check_redirect = (ovl_redirect_follow(ofs) || ofs->numdatalayer);
+	bool check_redirect = ovl_redirect_follow(ofs);
 	struct dentry *upperdir;
 	struct dentry *this;
 	struct dentry *origin = NULL;
@@ -1234,6 +1248,10 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 			ctx->ctr++;
 		}
 
+		/* Lookup of lowerdata in the data-only layers only */
+		if (ovl_is_lowerdata_redirect(ctx, d))
+			d->stop = true;
+
 		if (d->stop)
 			break;
 
@@ -1404,7 +1422,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 {
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct ovl_entry *poe = OVL_E(dentry->d_parent);
-	bool check_redirect = (ovl_redirect_follow(ofs) || ofs->numdatalayer);
+	bool check_redirect = ovl_redirect_follow(ofs);
 	int err;
 	struct ovl_lookup_ctx ctx = {
 		.dentry = dentry,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2c65056ae9361..9f8c25fdffeda 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -77,11 +77,13 @@ enum ovl_entry_flag {
 
 enum {
 	/*
-	 * "off" mode is never used after mount options are verified. In effect
-	 * it translates to either "follow" or "nofollow".
+	 * "off" mode is never used after mount options are verified.
+	 * In effect it translates to either "follow", "nofollow" or
+	 * "followdata" (with data-only layers).
 	 */
 	OVL_REDIRECT_OFF,
 	OVL_REDIRECT_FOLLOW,
+	OVL_REDIRECT_FOLLOWDATA,
 	OVL_REDIRECT_NOFOLLOW,
 	OVL_REDIRECT_ON,
 };
@@ -637,11 +639,26 @@ static inline char ovl_get_opaquedir_val(struct ovl_fs *ofs,
 	return ovl_get_dir_xattr_val(ofs, path, OVL_XATTR_OPAQUE);
 }
 
+/* Data-only layers cannot be used without following redirects to them */
+static inline int ovl_redirect_nofollow_mode(size_t nr_data)
+{
+	return nr_data ? OVL_REDIRECT_FOLLOWDATA : OVL_REDIRECT_NOFOLLOW;
+}
+
+/* Are redirects followed into lower layers? */
+static inline bool ovl_redirect_follow_lower(struct ovl_fs *ofs)
+{
+	return ofs->config.redirect_mode == OVL_REDIRECT_FOLLOW ||
+	       ofs->config.redirect_mode == OVL_REDIRECT_ON;
+}
+
+/* Are redirects followed into lower or lowerdata layers? */
 static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
 {
 	return ofs->config.redirect_mode != OVL_REDIRECT_NOFOLLOW;
 }
 
+/* Are redirects created in upper dir? */
 static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
 {
 	return ofs->config.redirect_mode == OVL_REDIRECT_ON;
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 27ef3b0651e2a..4f07f04136aff 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -107,6 +107,7 @@ static int ovl_xino_def(void)
 const struct constant_table ovl_parameter_redirect_dir[] = {
 	{ "off",	OVL_REDIRECT_OFF      },
 	{ "follow",	OVL_REDIRECT_FOLLOW   },
+	{ "followdata",	OVL_REDIRECT_FOLLOWDATA },
 	{ "nofollow",	OVL_REDIRECT_NOFOLLOW },
 	{ "on",		OVL_REDIRECT_ON       },
 	{}
@@ -117,21 +118,26 @@ static const char *ovl_redirect_mode_name(int redirect_mode)
 	return ovl_parameter_redirect_dir[redirect_mode].name;
 }
 
-static const char *ovl_redirect_mode(struct ovl_config *config)
+const char *ovl_redirect_mode(struct ovl_config *config)
 {
 	return ovl_redirect_mode_name(config->redirect_mode);
 }
 
-static int ovl_redirect_follow_mode(void)
+static int ovl_redirect_follow_mode(size_t nr_data)
 {
 	return ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
-					    OVL_REDIRECT_NOFOLLOW;
+					    ovl_redirect_nofollow_mode(nr_data);
 }
 
+/*
+ * The default for show_options() is resolved as if there are no data-only layers,
+ * so that redirect_dir=followdata, which is auto selected with data-only layers,
+ * is displayed in mount options.
+ */
 static int ovl_redirect_mode_def(void)
 {
 	return ovl_redirect_dir_def ? OVL_REDIRECT_ON :
-				      ovl_redirect_follow_mode();
+				      ovl_redirect_follow_mode(0);
 }
 
 static const struct constant_table ovl_parameter_verity[] = {
@@ -918,7 +924,7 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 
 	/* Resolve redirect_dir=off to the default redirect follow mode */
 	if (config->redirect_mode == OVL_REDIRECT_OFF)
-		config->redirect_mode = ovl_redirect_follow_mode();
+		config->redirect_mode = ovl_redirect_follow_mode(ctx->nr_data);
 
 	/*
 	 * This is to make the logic below simpler.  It doesn't make any other
@@ -1015,7 +1021,8 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	/* Resolve userxattr -> !redirect && !metacopy dependency */
 	if (config->userxattr) {
 		if (set.redirect &&
-		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
+		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW &&
+		    config->redirect_mode != OVL_REDIRECT_FOLLOWDATA) {
 			pr_err("conflicting options: userxattr,redirect_dir=%s\n",
 			       ovl_redirect_mode_name(redirect_opt));
 			return -EINVAL;
@@ -1030,10 +1037,21 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		 * options must be explicitly enabled if used together with
 		 * userxattr.
 		 */
-		config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
+		if (!set.redirect)
+			config->redirect_mode = ovl_redirect_nofollow_mode(ctx->nr_data);
 		config->metacopy = false;
 	}
 
+	/* Data-only layers are reached through redirects */
+	if (ctx->nr_data && config->redirect_mode == OVL_REDIRECT_NOFOLLOW) {
+		pr_err("redirect_dir=nofollow is not supported with data-only layers\n");
+		return -EINVAL;
+	}
+	if (!ctx->nr_data && config->redirect_mode == OVL_REDIRECT_FOLLOWDATA) {
+		pr_err("redirect_dir=followdata requires data-only layers\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * Fail if we don't have trusted xattr capability and a feature was
 	 * explicitly requested that requires them.
diff --git a/fs/overlayfs/params.h b/fs/overlayfs/params.h
index ffd53cdd84827..3161aa1ee9ddc 100644
--- a/fs/overlayfs/params.h
+++ b/fs/overlayfs/params.h
@@ -42,3 +42,4 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			 struct ovl_config *config);
 int ovl_show_options(struct seq_file *m, struct dentry *dentry);
 const char *ovl_xino_mode(struct ovl_config *config);
+const char *ovl_redirect_mode(struct ovl_config *config);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b93b1675098ec..58f2994a6bece 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -701,7 +701,7 @@ static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
 }
 
 static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
-			    const struct path *workpath)
+			    const struct path *workpath, size_t nr_data)
 {
 	struct vfsmount *mnt = ovl_upper_mnt(ofs);
 	struct dentry *workdir;
@@ -765,9 +765,10 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err) {
 		pr_warn("failed to set xattr on upper\n");
 		ofs->noxattr = true;
-		if (ovl_redirect_follow(ofs)) {
-			ofs->config.redirect_mode = OVL_REDIRECT_NOFOLLOW;
-			pr_warn("...falling back to redirect_dir=nofollow.\n");
+		if (ovl_redirect_follow_lower(ofs)) {
+			ofs->config.redirect_mode = ovl_redirect_nofollow_mode(nr_data);
+			pr_warn("...falling back to redirect_dir=%s.\n",
+				ovl_redirect_mode(&ofs->config));
 		}
 		if (ofs->config.metacopy) {
 			ofs->config.metacopy = false;
@@ -844,7 +845,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
 static int ovl_get_workdir(struct super_block *sb, struct ovl_fs *ofs,
 			   const struct path *upperpath,
-			   const struct path *workpath)
+			   const struct path *workpath, size_t nr_data)
 {
 	int err;
 
@@ -873,7 +874,7 @@ static int ovl_get_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err)
 		return err;
 
-	return ovl_make_workdir(sb, ofs, workpath);
+	return ovl_make_workdir(sb, ofs, workpath, nr_data);
 }
 
 static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
@@ -1485,7 +1486,8 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 			}
 		}
 
-		err = ovl_get_workdir(sb, ofs, &ctx->upper, &ctx->work);
+		err = ovl_get_workdir(sb, ofs, &ctx->upper, &ctx->work,
+				      ctx->nr_data);
 		if (err)
 			return err;
 
-- 
2.56.0

