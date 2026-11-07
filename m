Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083681;
	b=BrJ6g/I1Z6mtoL166V4JCK/2uaSQ+T0v33R8A+sAg9Na9DOTmPoB/tfU/hAFGuyr0VSn
	 YvG7AEUln92rtZ3zuvvq4HgwynHkiICvy3ajRqY5wYqwSePYLtrinbOpQQBitP4Hq2N6l
	 gu8ACRJhvGfv/fJANXI5nqIcuDtUqW/WJVOKAvO3optdvE6MUdnVIhGI6ymasxhV8jPvr
	 pOoevq3jJFXqJEDLxNjtSPUd7LEl/iotewTQXP9jAjnZAzJWLgtD1zMsBAQUMT0Ktq53N
	 UGjghwAB+lmasOi+8Td6x/mxl7Np9nrpmrR6vkYxOKTEm4klD0EPA/WGa4qVqNxLR2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083681;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=X+j2eWcXgNaKfldPlzCzNNlBU1uEYJGYEjLoR5fNXtY=;
	b=AaZZeMag/zRxILNFgOHIh7yvBsgkqfARgWs4WZsjCrwNJ2UpijznFX36vVXCNFdMdBxb
	 Im9UKWYIeFSdqSdb83THLMGnW3dqIJEJPaO3N5YXc1bYaPOVq9NJRTQGE0LDNoWNcQ/Nx
	 Hy59wkUCebJdQxLeb/uPGaFlxQZdB0BtpsnFwxab97i5jsdLhvs5sX1QVEH/mmLY1tNJe
	 CMpXOIMKamkYtFz18Bd1s8+3DzVMbu+Jun9Fr+rf8UKOYXYyKvbKG9J5cS4DRI4C7nnR0
	 kCH6odyRbLj9/wnfECySEfTgyU2ouoAUk3c8Tlb+4e/gCvZZCC1TiAZ+gh8kuVpgrvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=38eEXn0b;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=JTTq5+F8;
	arc=none smtp.remote-ip=103.168.172.151
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5C0606A32D
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 20:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A5C0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=38eEXn0b;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=JTTq5+F8
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 49A46EC01E7
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 15:34:39 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Sat, 07 Nov 2026 15:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794083679; x=1794170079; bh=X+j2eWcXgNaKfldPlzCzN
	NlBU1uEYJGYEjLoR5fNXtY=; b=38eEXn0bptH734gr4P31HBC656sK7BMqdKHp3
	GW4QwQelm8vtGhjQPx5WUWmR1EFMjpqmZSmxdcC967EEmEFEFKUcBC7birTdbo2h
	lcqzaahXXVLfcvzhczxmjawYa8zlhUu4ZMJ2fZy+8oj2fQxV2qPzmyzAPPbmfpVp
	BBvKAMomxEjfESG7yEHqJxg2LC2VaiPqY2st9mjhhQl6mMCYiqkWi3M3vRxTpCCM
	jw3cyM2HKEsNzRP9k6/C1tJaVxSTgaVclcW8Vj8MtDLNSarGRg8nVFu6N/nyTWVC
	wThT4SnWhQVBFO0T/ca+ZhQSuN3dHG8RlAvptKI8/M4ra9DZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794083679; x=1794170079; bh=X+j2eWcXgNaKfldPlzCzNNlBU1uEYJGYEjL
	oR5fNXtY=; b=JTTq5+F8Z0++2pr9Eo3quuYFuWE/rBD+WI/WZCjR4eQtVATo3nR
	FlUzdNrf7D4dvAltVCGRJWYM3FqX+FhhE5gD0+8LFRu9yR6qQJnyZcJUFzCwnQDh
	OhQQfj8dOmcdB6sIupzIAafd6E2vr/8iGzyOQ0C91GjRBetrH8hibjP8jrxjt8xc
	qnh4fIFfPmL3Cvrdi2wzQGktjr0TbtXS21ie6pJaETsQNJgli7x6CdIkMAd2XwId
	EIoLt26ZP0n1An5eatq8rKJwBHkrVKtFF5+a1g1l0fYMn9rAKPEAqC6vlNtUtRD9
	JCjE00iCxrKxbsQwDGyENVuUOtBYdf4g6bw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794083679; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:jbjgt2VEzus3rq8GfFm2jtIuO7bQDNVGqMqI3+qJOt3VdS5
	qnFmy7GtwBOANTRxygzQzU10gDDLcDLbtN7gkoNY46IJ+TH7zvlx9jFl183tyBSj
	3iHuuVFMPMTlPcQ3oWetWf8T7bPi933waYiA3bniIguDtp3xQcQi2YcCOe5Qygfm
	y4jz78CtDzKWzu204+CgE2JZ1yPzTzxRVmoKb5Ew72B/XkQR1iQ7W3kkqBLcjPPC
	p1D/EBbrLj7GE7nB9Dk+9LQ4fZl1vx4Aix2urQ3GCINwbtjVUxyA8WxYpDIGENH6
	dReRZh4dN0qwoxfQncEYUIUjobVW7wINLtavRBA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:uIH+nP7boXHhxtgP+2b0p0AKPD4BYyu6z89+GhXd2pQ=:QMv2RkecLZvylU7W24uzVRa0uTWXx8ZvcEri556JzCw=;
X-ME-Sender: <xms:X4vvaqbJQafVPi28jzZ6hLGAUeNdL7ri-sl6pq_UBbR-7QvmdwHFhg>
    <xme:X4vvak33B91MrJ69z4KEriAjV-lbiBe_evn-9cyIBDP_RjT_VE5dn6dQEwv3lSbuw
    M9P3AajJJGtKRm7CtvIyQOSaOJiUlszQ-fGg1CjCzBp8UmkTtS_5VE2>
X-ME-Received: <xmr:X4vvaiWCDTpCdYWozaV4jZwOxKxJENJkgsnvDSOg3dmnRHWGz0XYBHzS0DqHrjDn-Gvm4HOATCfNkAHYS_RWi4i5wXZ6>
X-ME-Proxy-Cause: dmFkZTGsAANNsP8YK2M3DzN74PjwchXXshNjVQUJZyeUsC7qRqkWmKvOfo21y30MJOrwBx
    qreNRE6QV1yxbh93fNCIrO5V2s1uuqZI/0diK71XwMFrNeAsbmD1uvA4mjw53DDdKSxjQa
    sMmnOZnPIXKpGZvVPexYzPkV9Md7x9rABjN0R66qTUgaCdz94UddDZrqBwt3qWuk1WylOi
    QiYyKD+Ocr6WwdSPRoAVN6w4kxIrS9CKA7INhNkGzDe9jRR9DwU8fhqKQwILEiySZk67yA
    7k4uMNPXeLi0cgMf2p88kcrtDqW3/RJ0RqyDUdcxIiD5O6yxMuJ2bueyVlEXdE8/TkJfML
    QAn/MCs8+OvPkZgk6IHLcahiD3n+BtXmO72sMg//aFxawBJZPS/MmbHtx8vCylHT0jyK5x
    n+24YOJuIXV56pt7rfHcaUTnEqltRQiXoSF/TWDlaVJrkLGBK6yxYjIiR+7xyPGHDnpZ0H
    ZZYNEDh2c6P/XxPLfsadEKeEdWKCpTQlDCaC0rx10RvuBUsMxkktO3LitIKPlKBaGEyoWu
    P8TqvpNBHjDJi0uDQOlp7rSixxhj9REm+qTtkYN4ntbK8+uaKKC5KBu0REB/Fv3dm36IQj
    04Bv76F5cpJ89tzkE0MZrE+pH4v2/qYDvpKEa05KIF44S42ih2Cb1EUA1HxQ
X-ME-Proxy: <xmx:X4vvamUrlNOtC7-AgwvowyqDNVqUNp4zYJ1d6t0yV9I_RdTF1igDAA>
    <xmx:X4vvapezkDaq2_HBpprN7ZEzxwDyX5szeSNYvb_sd2HFt66rH6_jkw>
    <xmx:X4vvanWiu8jQzgbDdcHL4AK8meNX6aj1KOiHQy8DKkq1NoQ9E90kbw>
    <xmx:X4vvaqdTiLOfYaUwR_PVOBCVW8y03wsF2hLmhdZfWsMnWvZjYoiOjw>
    <xmx:X4vvas3jqUogdaRIR7jstkutWKf6jxH9BKAu9r2qPlZk-ShX1eF5Nbkx>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 15:34:38 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com
Subject: [PATCH v2] ovl: follow lower to lowerdata redirects from any lower layer
Date: Sat,  7 Nov 2026 21:34:13 +0100
Message-ID: <20261107203427.1739067-1-giuseppe@scrivano.org>
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

Without metacopy=on, a metacopy file with an absolute redirect into a
data-only layer is followed only from the lowest lower layer.  From any
other lower layer, the lookup fails with EPERM.  This is always the
case with userxattr, which cannot be used with metacopy=on, and with
redirect_dir=nofollow.

Add redirect_dir=followdata, which follows only redirects from lower to
lowerdata, and select it when there are data-only layers, unless
redirect_dir=follow or redirect_dir=on is in effect.  Without
metacopy=on, the absolute redirect of a lower metacopy file stops the
lookup in the lower layers and the data is looked up in the data-only
layers.  Data-only layers cannot be used without following redirects,
so reject redirect_dir=nofollow with data-only layers.

Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower -> data redirect")
Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
---
v1: https://lore.kernel.org/linux-unionfs/CAOQ4uxhVD=OjY7ro4rpbYu7aRC_eLybG+crLAQBFgMyHdw2Fgg@mail.gmail.com/T/#t

Documentation/filesystems/overlayfs.rst | 16 ++++++++------
 fs/overlayfs/namei.c                    | 28 ++++++++++++++++++++++---
 fs/overlayfs/overlayfs.h                |  6 ++++++
 fs/overlayfs/params.c                   | 25 ++++++++++++++++++++--
 fs/overlayfs/super.c                    | 16 +++++++++-----
 5 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 16c35b491dad..5d947eda09e5 100644
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
+Note: redirect_dir={off|nofollow|follow[*]|followdata} and nfs_export=on
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
index ca899fdfaafd..b354d8f4b1fd 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1069,7 +1069,12 @@ static bool ovl_check_follow_redirect(struct ovl_lookup_data *d)
 		pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n", d->dentry);
 		return false;
 	}
-	if ((d->redirect || d->upperredirect) && !ovl_redirect_follow(ofs)) {
+	/*
+	 * redirect_dir=followdata follows only the lower to lowerdata
+	 * redirects, which are not checked here.
+	 */
+	if ((d->redirect || d->upperredirect) &&
+	    (!ovl_redirect_follow(ofs) || ovl_redirect_followdata(ofs))) {
 		pr_warn_ratelimited("refusing to follow redirect for (%pd2)\n", d->dentry);
 		return false;
 	}
@@ -1087,13 +1092,26 @@ struct ovl_lookup_ctx {
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
@@ -1224,6 +1242,10 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 			ctx->ctr++;
 		}
 
+		/* Lookup of lowerdata in the data-only layers only */
+		if (ovl_is_lowerdata_redirect(ctx, d))
+			d->stop = true;
+
 		if (d->stop)
 			break;
 
@@ -1384,7 +1406,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 {
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct ovl_entry *poe = OVL_E(dentry->d_parent);
-	bool check_redirect = (ovl_redirect_follow(ofs) || ofs->numdatalayer);
+	bool check_redirect = ovl_redirect_follow(ofs);
 	int err;
 	struct ovl_lookup_ctx ctx = {
 		.dentry = dentry,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 92da556598da..411690ea3ae3 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -78,6 +78,7 @@ enum ovl_entry_flag {
 enum {
 	OVL_REDIRECT_OFF,	/* "off" mode is never used. In effect	*/
 	OVL_REDIRECT_FOLLOW,	/* ...it translates to either "follow"	*/
+	OVL_REDIRECT_FOLLOWDATA,
 	OVL_REDIRECT_NOFOLLOW,	/* ...or "nofollow".			*/
 	OVL_REDIRECT_ON,
 };
@@ -632,6 +633,11 @@ static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
 	return ofs->config.redirect_mode != OVL_REDIRECT_NOFOLLOW;
 }
 
+static inline bool ovl_redirect_followdata(struct ovl_fs *ofs)
+{
+	return ofs->config.redirect_mode == OVL_REDIRECT_FOLLOWDATA;
+}
+
 static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
 {
 	return ofs->config.redirect_mode == OVL_REDIRECT_ON;
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 5a15e5478a6b..2dd965121a68 100644
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
@@ -991,7 +992,8 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	/* Resolve userxattr -> !redirect && !metacopy dependency */
 	if (config->userxattr) {
 		if (set.redirect &&
-		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
+		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW &&
+		    config->redirect_mode != OVL_REDIRECT_FOLLOWDATA) {
 			pr_err("conflicting options: userxattr,redirect_dir=%s\n",
 			       ovl_redirect_mode(config));
 			return -EINVAL;
@@ -1006,10 +1008,29 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		 * options must be explicitly enabled if used together with
 		 * userxattr.
 		 */
-		config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
+		if (!set.redirect)
+			config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
 		config->metacopy = false;
 	}
 
+	/*
+	 * Data-only layers are reached through redirects, so they cannot be
+	 * used with redirect_dir=nofollow: use followdata instead, or fail
+	 * if nofollow was requested explicitly.
+	 */
+	if (ctx->nr_data && config->redirect_mode == OVL_REDIRECT_NOFOLLOW) {
+		if (set.redirect) {
+			pr_err("conflicting options: data-only layers,redirect_dir=%s\n",
+			       ovl_redirect_mode(config));
+			return -EINVAL;
+		}
+		config->redirect_mode = OVL_REDIRECT_FOLLOWDATA;
+	}
+	if (!ctx->nr_data && config->redirect_mode == OVL_REDIRECT_FOLLOWDATA) {
+		pr_err("redirect_dir=followdata requires data-only layers\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * Fail if we don't have trusted xattr capability and a feature was
 	 * explicitly requested that requires them.
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 19b6d54c4500..d5352a95f7f6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -680,7 +680,7 @@ static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
 }
 
 static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
-			    const struct path *workpath)
+			    const struct path *workpath, size_t nr_data)
 {
 	struct vfsmount *mnt = ovl_upper_mnt(ofs);
 	struct dentry *workdir;
@@ -744,7 +744,12 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err) {
 		pr_warn("failed to set xattr on upper\n");
 		ofs->noxattr = true;
-		if (ovl_redirect_follow(ofs)) {
+		/* Data-only layers require at least redirect_dir=followdata */
+		if (nr_data && ovl_redirect_follow(ofs) &&
+		    !ovl_redirect_followdata(ofs)) {
+			ofs->config.redirect_mode = OVL_REDIRECT_FOLLOWDATA;
+			pr_warn("...falling back to redirect_dir=followdata.\n");
+		} else if (!nr_data && ovl_redirect_follow(ofs)) {
 			ofs->config.redirect_mode = OVL_REDIRECT_NOFOLLOW;
 			pr_warn("...falling back to redirect_dir=nofollow.\n");
 		}
@@ -823,7 +828,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
 static int ovl_get_workdir(struct super_block *sb, struct ovl_fs *ofs,
 			   const struct path *upperpath,
-			   const struct path *workpath)
+			   const struct path *workpath, size_t nr_data)
 {
 	int err;
 
@@ -852,7 +857,7 @@ static int ovl_get_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err)
 		return err;
 
-	return ovl_make_workdir(sb, ofs, workpath);
+	return ovl_make_workdir(sb, ofs, workpath, nr_data);
 }
 
 static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
@@ -1465,7 +1470,8 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 			}
 		}
 
-		err = ovl_get_workdir(sb, ofs, &ctx->upper, &ctx->work);
+		err = ovl_get_workdir(sb, ofs, &ctx->upper, &ctx->work,
+				      ctx->nr_data);
 		if (err)
 			return err;
 
-- 
2.56.0

