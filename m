Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980278;
	b=DbIzQ0zZ872GnUcajbSx1QjFIHEQvFjp5Z/XRnpwd1+v9MJiWmqU5pmKqXrXHR3MZuFH
	 r/3CdFgNyF5OL0LBTKQRqwz1Kz+L+qXOB8yNWF4XEv5NS1iJACOlMhdvj5AnYGtsEbG33
	 zfevxpC2CeEgdPNfUQvW14dBr8UEAhrj6ZwzgWGt8Kr+LFTGAuysJ25kG0JnHp83PZ7Hh
	 Xw/pD010J/mc2AbBWslD0kdg2RAcd0ePMejuM/+zGyVIubJs+JrCKPT2751GPpjQwV+1K
	 yzJlGOra7vw59WfFk2wb2CdmJYFeRSBakBCsxm37fUAzVInuuhvoUE+cdIttPC8CYjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980278;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p4axIjgNQYRulsj1VnBuA4fqS2548q7uk/1jGvgjqfw=;
	b=jZ0zn/osBExhh+0IzUnOoTwJQcFLS8YZYVdYKEPv6YBqxYGB8c9jIrXwrLL6OztGcaB+
	 /aQ2EwsiQVkDAyZIEkRADUFy2wFN9EcGNBkc/cun8WWg2raX1h9Euw9C1SDbApfZKomoV
	 VMqi+eNJH53AG95seyVqJzjor9sePH1rtlVITOCprj5NDEoOGTZ7AlBEkC7FlyNIwOxJJ
	 g3qNn8RDMENfX58Cjue7V8y790svpXjePT45xRzRgkrJhXOBZ5Az9xcqZZU1qRx/D7rYm
	 9JxgsEkBkU9+d3zY9jMvIyHHcwyLMII3r/3HLcine4qXp5S/GxjpkPz8tMsqIO5pBoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=AA5lQQxD;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=waPpSRj0;
	arc=none smtp.remote-ip=202.12.124.144
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25239606A326
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 15:51:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25239606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=AA5lQQxD;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=waPpSRj0
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 78D491D00154
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 10:51:16 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Fri, 06 Nov 2026 10:51:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1793980276; x=1794066676; bh=p4axIjgNQYRulsj1VnBuA
	4fqS2548q7uk/1jGvgjqfw=; b=AA5lQQxDbBk73VOLK3HPuPGGvt+b409UH9yiy
	Eh9Qf4IvGpqIBtmm3gwnIWwAf74R6XinJ33gwzMD6XCeh1S9yH9Klipsgzbk3hgW
	6+VPRkKj6mxXc3COu0H5jQDFrz0pUb0C4qstyWBgzNF8PddwAxCce/WFPCWmwVMO
	UFzsnMJ6N+MUh+H1LbE9VECn26IkRk7667fRHE3yjNlFepvPpclbN4/FSrnQrPdi
	kVVUBhKz+REvsApXlnJN28o+fYX87iD6z4WXslMCpy5n15Vg181c2iutR7ZnBco1
	68ut3wDlXHj95ELhXlFbyl8NjbFXgG1TCR2KOv1fsQ7NJ1I1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793980276; x=1794066676; bh=p4axIjgNQYRulsj1VnBuA4fqS2548q7uk/1
	jGvgjqfw=; b=waPpSRj0IXyYofCWt1RXqBOS7fhSZ8/hzJY2+25phTrTPXm+RsJ
	EzBbHn0jAmNfwrmvYQVJmA2bK+FCAAwVrknMl3FbpN4QCCGzrnU+ATiITcV4sfmk
	11RSwJ5+Mx7TkekcSZldIpgW9+FmuZ5XwmQHAPCCDrZuoQTiYqmvDptlYW8uv8bs
	hEzQPV+YWl/9MXStInbkPwa1UiUiKrTCMQmbXHIK4GkOIry38Ybxd0GVv3U4+RxE
	zwakRcCvy6HeuSRLwMX9FH/ESQrFSik2C58HTVXF8cMucCOsuocHUKK1j9ETeg3y
	2j8wwq+dH0MGWo1D9wV5D7y9RvNi6jI5hmQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793980276; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:yxvobQyu9PkmNzO0X6wDdIGNQYc9lwZgnA+Av2/7MKEShXK
	h1bpNxDwGoBS2En1g2SZAkdHBqz3eQiwNGzxbN7l0vX3coDcJuLPRtQYytLt+YFl
	MU6ib/RNTTevanKpHNg/0a0oF00IWMjZOwJY5OBz2jd+K4ceYzv8xmmCcqO8VPob
	LiQskx6QmtW50Eq0UXGGrgJABQ04orevzerwT1KTeamaYAaTZhPcFtAikG8xmxyG
	2K6Keqhev+XET5NWjBpNDOs5vG6ZC7UogxnvqqGgfDQcYYlXqFob1K8yAywzIA0G
	Fo8Ur9GHHJhanIu9iXWKOMHz1JvWu/ljKvcdSlw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:H4DZqOl+tunevmdq1ZRdg2cc9yTUslNO80Kdr9EXBcI=:IIsdngRtM9BptO39BE7QcK3IwO+bul97H3uAysfl7Rk=;
X-ME-Sender: <xms:dPftagx5RHkl4E68yrjX_duPALub-9-Yq3WVnZ3AP5Tn9NDQ5CDm_Q>
    <xme:dPftartJyteSo8EvXCnZTDRDYMQkivM1Sk1IpuB9MNctNc8ux_tvOZTT1cRfAvKnO
    fxwTDSB7GciejReyF5WjI1-qBOn8Id4HfwIBHEeZFX-y5qWSHlwT4tq>
X-ME-Received: <xmr:dPftavtuQfbifAD9exSOhpnyd55v4VGPbs-okpoB6hr0pb3wtE00mc9sX1OIeNa7LIf5EQVTDbFAdTKeE_FAqaixefNx>
X-ME-Proxy-Cause: dmFkZTFb09BozYRqyOxMG8dFjZ8fYT2vHcOmHpv16ruW0j50gduT+tZZ84RpOgQIZ++ivm
    gNxMLvJpFQiYV1bMEByJkY0reMvIC7tzVvXKNpxZ5l70A0/ggC98pspX+28AxGhLF/Ysy7
    91tFCrXa+s6TMxiWLo0MsS024ut05WoQSkuFMo0HfMiA3SsX6Sjj+SCDnnnVLWJv5fGsRd
    vYAjE8Gi/83QnR6W2DtqdYYp5u/nOckZTK7jRK4gVndtG+cnGO2AGwNb5T1SfKC36606Jc
    nAejbP3sF4GH9O2RykwSmM9wElgR7Pe2/hxvVp+7V89St2niHYZjXLiMfLdn9S0UyHsjml
    6JnWO/XRK6pFWgr5BxZ/gUyjZvzPURZ7BgDCtVxZP7Xt2Vfx+1VWPQHSxioYobtj/jD262
    bVabZP8xIM9kVrwUqJREHbmWx6jLyURjSRajY100uXl8D5ku/4meAkALR2mPPp5VKRl/xd
    SOmotYYQ0pni6EJkYm9hn+Zw28enSo+WHnWvUaONGJhPx9Pq9nCzk/a/ME4z9BtgQ14Sru
    HkuVJPFJN57g9FqORapcmKkg66eoigG4Vv4s/X3LohwxJIsYwejEazoywP2YlrIzDxvPP9
    R0jmj8+hQzgIb4n0AzaJKJYH0rk4K0l8Ozb3c8Zf9dUS0BV6BmAXiexaALbg
X-ME-Proxy: <xmx:dPftaoNGwIUnYEdoisYA4fiD0Tnr8fI2fgDCCH2gn1tC8QbP9Kc-zw>
    <xmx:dPftal0zXbeJcLP8mXYwq6INe-h7v7g5WZZ8--soL-Mq0zhXcp2i1g>
    <xmx:dPftasPtIdl0hzqJE8xl53xFlEwUrJcsy-SD0sh8XYGyHIvOSg1Q5w>
    <xmx:dPftat13pqaq34hPcCLSfBEfbmMfCELI3tk_xEIZ6wRA7TNREPz9ww>
    <xmx:dPftartLdH3EMJqZa-lU1dHTAvjkD9ijGWcuhV8rMqWIozYDHNRD5Dkk>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 10:51:15 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com
Subject: [PATCH] overlay: add redirect_dir=followdata
Date: Fri,  6 Nov 2026 16:51:07 +0100
Message-ID: <20261106155110.1145957-1-giuseppe@scrivano.org>
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

A metacopy file with an absolute redirect to a data-only layer is
followed without metacopy=on and redirect_dir=on only when it is in the
last lower layer.

A mount with userxattr cannot have metacopy=on and redirect_dir=on, so
a user namespace mount that stacks several metadata-only layers over a
data-only layer can use the metacopy files of the last lower layer
only:

  mount -t overlay none -o userxattr,lowerdir+=l3,lowerdir+=l2,\
        lowerdir+=l1,datadir+=data,upperdir=u,workdir=w m
  cat m/low   # metacopy file in l1: works
  cat m/mid   # metacopy file in l2: Operation not permitted

Add the opt-in mount option redirect_dir=followdata.  Like
redirect_dir=follow it creates no redirects, but it follows only the
absolute redirect of a lower metacopy file, and only into the data-only
layers: the first such file found stops the lookup in the lower layers,
so the lower layers below it are never consulted, and the lookup of the
data stays lazy and happens only in the data-only layers.

Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
---
 Documentation/filesystems/overlayfs.rst | 27 +++++++++++++++++++++++--
 fs/overlayfs/namei.c                    | 15 ++++++++++++++
 fs/overlayfs/overlayfs.h                |  9 ++++++++-
 fs/overlayfs/params.c                   | 19 ++++++++++++++---
 4 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 16c35b491dad..dbaf7200b6a6 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -244,6 +244,10 @@ Mount options:
 - "redirect_dir=off":
     If "redirect_always_follow" is enabled in the kernel/module config,
     this "off" translates to "follow", otherwise it translates to "nofollow".
+- "redirect_dir=followdata":
+    Redirects are not created.  Only absolute redirects of metacopy files
+    in lower layers to data-only lower layers are followed (see
+    "Data-only lower layers" below).  Requires a data-only lower layer.
 
 When the NFS export feature is enabled, every copied up directory is
 indexed by the file handle of the lower inode and a file handle of the
@@ -418,8 +422,8 @@ pointed by REDIRECT. This should not be possible on local system as setting
 "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
 for untrusted layers like from a pen drive.
 
-Note: redirect_dir={off|nofollow|follow[*]} and nfs_export=on mount options
-conflict with metacopy=on, and will result in an error.
+Note: redirect_dir={off|nofollow|follow[*]|followdata} and nfs_export=on
+mount options conflict with metacopy=on, and will result in an error.
 
 [*] redirect_dir=follow only conflicts with metacopy=on if upperdir=... is
 given.
@@ -465,6 +469,25 @@ layers may be used together with "userxattr", in which case careful attention
 must be given to privileges needed to change the "user.overlay.redirect" xattr
 to prevent misuse.
 
+Without "metacopy=on", only a metacopy file in the lowest of the lower layers
+that are not data-only may redirect to a data-only layer; lookup of such a
+metacopy file in any lower layer above it fails with EPERM.  Since "userxattr"
+cannot be used together with "metacopy=on" and "redirect_dir=on", stacking
+several lower layers of metacopy files over data-only layers needs the
+"redirect_dir=followdata" mount option.  For example::
+
+  mount -t overlay none -o userxattr,redirect_dir=followdata,\
+        lowerdir+=/l1,lowerdir+=/l2,lowerdir+=/l3,datadir+=/do1 /merged
+
+With "redirect_dir=followdata", a metacopy file in any lower layer that has
+an absolute redirect stops the lookup in the lower layers: the lower layers
+below it are not looked up, and the data is looked up only in the data-only
+layers.  As for a metacopy file in the lowest lower layer, the "verity" mount
+option decides whether a fs-verity digest is verified or required on open.
+Directory redirects, relative redirects, and metacopy files and redirects in
+the upper layer are rejected, as they are without this option.  Mounting with
+"redirect_dir=followdata" fails if there is no data-only layer.
+
 Since kernel version v6.8, "data-only" lower layers can also be added using
 the "datadir+" mount options and the fsconfig syscall from new mount api.
 For example::
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ca899fdfaafd..c7ce26af5edf 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1087,6 +1087,17 @@ struct ovl_lookup_ctx {
 	unsigned int ctr;
 };
 
+/*
+ * With redirect_dir=followdata, the absolute redirect of a lower metacopy
+ * file is followed only into the data-only layers.
+ */
+static bool ovl_is_followdata_redirect(struct ovl_lookup_ctx *ctx,
+				       struct ovl_lookup_data *d)
+{
+	return ovl_redirect_followdata(OVL_FS(d->sb)) && ctx->ctr &&
+	       d->metacopy && d->absolute_redirect;
+}
+
 static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data *d)
 {
 	struct dentry *dentry = ctx->dentry;
@@ -1224,6 +1235,10 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 			ctx->ctr++;
 		}
 
+		/* Lookup of lowerdata in the data-only layers only */
+		if (ovl_is_followdata_redirect(ctx, d))
+			d->stop = true;
+
 		if (d->stop)
 			break;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 92da556598da..a9c93ba69e10 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -80,6 +80,7 @@ enum {
 	OVL_REDIRECT_FOLLOW,	/* ...it translates to either "follow"	*/
 	OVL_REDIRECT_NOFOLLOW,	/* ...or "nofollow".			*/
 	OVL_REDIRECT_ON,
+	OVL_REDIRECT_FOLLOWDATA,	/* Only follow to data-only layers */
 };
 
 enum {
@@ -629,7 +630,13 @@ static inline char ovl_get_opaquedir_val(struct ovl_fs *ofs,
 
 static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
 {
-	return ofs->config.redirect_mode != OVL_REDIRECT_NOFOLLOW;
+	return ofs->config.redirect_mode != OVL_REDIRECT_NOFOLLOW &&
+	       ofs->config.redirect_mode != OVL_REDIRECT_FOLLOWDATA;
+}
+
+static inline bool ovl_redirect_followdata(struct ovl_fs *ofs)
+{
+	return ofs->config.redirect_mode == OVL_REDIRECT_FOLLOWDATA;
 }
 
 static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 5a15e5478a6b..72a5e38daf20 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -109,6 +109,7 @@ const struct constant_table ovl_parameter_redirect_dir[] = {
 	{ "follow",	OVL_REDIRECT_FOLLOW   },
 	{ "nofollow",	OVL_REDIRECT_NOFOLLOW },
 	{ "on",		OVL_REDIRECT_ON       },
+	{ "followdata",	OVL_REDIRECT_FOLLOWDATA },
 	{}
 };
 
@@ -988,10 +989,16 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	}
 
 
-	/* Resolve userxattr -> !redirect && !metacopy dependency */
+	/*
+	 * Resolve userxattr -> !redirect && !metacopy dependency.
+	 * redirect_dir=followdata creates no redirects and follows only the
+	 * absolute redirects of lower metacopy files into data-only layers,
+	 * like a metacopy file in the last lower layer does without it.
+	 */
 	if (config->userxattr) {
 		if (set.redirect &&
-		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
+		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW &&
+		    config->redirect_mode != OVL_REDIRECT_FOLLOWDATA) {
 			pr_err("conflicting options: userxattr,redirect_dir=%s\n",
 			       ovl_redirect_mode(config));
 			return -EINVAL;
@@ -1006,10 +1013,16 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		 * options must be explicitly enabled if used together with
 		 * userxattr.
 		 */
-		config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
+		if (config->redirect_mode != OVL_REDIRECT_FOLLOWDATA)
+			config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
 		config->metacopy = false;
 	}
 
+	if (config->redirect_mode == OVL_REDIRECT_FOLLOWDATA && !ctx->nr_data) {
+		pr_err("redirect_dir=followdata requires a data-only layer\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * Fail if we don't have trusted xattr capability and a feature was
 	 * explicitly requested that requires them.
-- 
2.56.0

