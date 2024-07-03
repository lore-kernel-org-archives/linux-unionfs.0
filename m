Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AC2177981
	for <linux-unionfs@vger.kernel.org>; Wed,  3 Jul 2024 13:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720014512; cv=none; b=MZbDQ6NGLH/DupTaeazb7OhXclrz0LiFOao3OKSNdqma07CmAacsuCDWOrvr9ujSLYpUrDdwMtG8A8pKnbSl5+XQZaibqaa0WQLIneOtBRY6d995iLL2a1Y8NkEf4tBIxEjcvwfDAEz/NwOvprxEyksY/iP+ad5cicUz7ioXip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720014512; c=relaxed/simple;
	bh=2m6x6p0eyncV6eFUY20UG4xVl+O0pc9NGH+iOk3mmHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDJ+j/thHRKLYpE2DSCliSqopvHMGPywF5vpcsh3Me9qOjWmxaOF7Nz9uekjUdqgeTHj3ZeoU8p20TBcRUQcXnBanMTp55FoWJQ1otPWxI7A+JbMSlyFoYvs7/lrc/WfFsHXbeF9nXmZRHsbRg5oAsX8zICMwcrDfXdmSuQe3tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ue/oW8qr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ue/oW8qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A14C2BD10;
	Wed,  3 Jul 2024 13:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720014511;
	bh=2m6x6p0eyncV6eFUY20UG4xVl+O0pc9NGH+iOk3mmHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ue/oW8qrVdZBorKZVULlOAhx8Z8uUl/ptSNHxX2P2DInigwaQGeW38D/WcQoAw/pp
	 i5H+3EJalI9HJRR4a4tfF4JV0xdveUN9GLdljVnllooxDqZQM9u8EANM9DVyahyQy2
	 CUB63aPwgQD7oT4Y0ui2kT3JRts6uItrl1Dfmdxahs2Cg/3pDWGUIzLBx6ExuzKq8u
	 vv4+gDfdt1+kXatJvqF5rHp2JMZdq4W+kgOB78f9CNmFvKsAHS+Mrahi8f5o9pyDa6
	 4asRnEg/qZu341Eurgzaf35rEX9luJrZpSycoJAjz89+A+f1GRQ4V8wUPi/SXazhhs
	 8kb6eMgOSpldg==
Date: Wed, 3 Jul 2024 15:48:26 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, miklos@szeredi.hu, 
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix wrong lowerdir number check for parameter
 Opt_lowerdir
Message-ID: <20240703-maulwurf-beinverletzungen-dfb0ff663d78@brauner>
References: <20240703044631.4089465-1-chengzhihao1@huawei.com>
 <CAOQ4uxg8YvWYobbx5ztjkw6ZnUVgv1JDWFYq71HQ5O22=jYTKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sy4jzimmnhycampu"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxg8YvWYobbx5ztjkw6ZnUVgv1JDWFYq71HQ5O22=jYTKw@mail.gmail.com>


--sy4jzimmnhycampu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 03, 2024 at 02:35:49PM GMT, Amir Goldstein wrote:
> On Wed, Jul 3, 2024 at 7:48 AM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> >
> > The max count of lowerdir is OVL_MAX_STACK[500], which is broken by
> > commit 37f32f526438("ovl: fix memory leak in ovl_parse_param()") for
> > parameter Opt_lowerdir. Since commit 819829f0319a("ovl: refactor layer
> > parsing helpers") and commit 24e16e385f22("ovl: add support for
> > appending lowerdirs one by one") added check ovl_mount_dir_check() in
> > function ovl_parse_param_lowerdir(), the 'ctx->nr' should be smaller
> > than OVL_MAX_STACK, after commit 37f32f526438("ovl: fix memory leak in
> > ovl_parse_param()") is applied, the 'ctx->nr' is updated before the
> > check ovl_mount_dir_check(), which leads the max count of lowerdir
> > to become 499 for parameter Opt_lowerdir.
> > Fix it by updating 'ctx->nr' after the check ovl_mount_dir_check().
> >
> > Fixes: 37f32f526438 ("ovl: fix memory leak in ovl_parse_param()")
> > Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> > ---
> >  fs/overlayfs/params.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> > index 4860fcc4611b..0d8c456aa8fa 100644
> > --- a/fs/overlayfs/params.c
> > +++ b/fs/overlayfs/params.c
> > @@ -486,7 +486,6 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
> >         iter = dup;
> >         l = ctx->lower;
> >         for (nr = 0; nr < nr_lower; nr++, l++) {
> > -               ctx->nr++;
> >                 memset(l, 0, sizeof(*l));
> >
> >                 err = ovl_mount_dir(iter, &l->path);
> > @@ -494,9 +493,12 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
> >                         goto out_put;
> >
> >                 err = ovl_mount_dir_check(fc, &l->path, Opt_lowerdir, iter, false);
> > -               if (err)
> > +               if (err) {
> > +                       path_put(&l->path);
> >                         goto out_put;
> > +               }
> >
> > +               ctx->nr++;
> >                 err = -ENOMEM;
> >                 l->name = kstrdup(iter, GFP_KERNEL_ACCOUNT);
> >                 if (!l->name)
> > --
> > 2.39.2
> >
> 
> This fix looks correct, but it is not pretty IMO.
> The cleanup on error is much cleaner in ovl_parse_layer() -> ovl_add_layer()
> I wonder if we can reuse some of those helpers instead of the current code.
> 
> Christian, what do you think?

Yeah, sounds good. Something like the completely untested below.
Feel free to reuse in whatever form.

--sy4jzimmnhycampu
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-ovl-pass-string-to-ovl_parse_layer.patch"

From f5809f6c8ba65da54388c6bca28b0e67c4642d1e Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 3 Jul 2024 15:39:34 +0200
Subject: [PATCH 1/2] ovl: pass string to ovl_parse_layer()

So it can be used for parsing the Opt_lowerdir.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/overlayfs/params.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 4860fcc4611b..52e3860973b7 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -365,10 +365,9 @@ static void ovl_add_layer(struct fs_context *fc, enum ovl_opt layer,
 	}
 }
 
-static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
-			   enum ovl_opt layer)
+static int ovl_parse_layer(struct fs_context *fc, const char *layer_name, enum ovl_opt layer)
 {
-	char *name = kstrdup(param->string, GFP_KERNEL);
+	char *name = kstrdup(layer_name, GFP_KERNEL);
 	bool upper = (layer == Opt_upperdir || layer == Opt_workdir);
 	struct path path;
 	int err;
@@ -582,7 +581,7 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_datadir_add:
 	case Opt_upperdir:
 	case Opt_workdir:
-		err = ovl_parse_layer(fc, param, opt);
+		err = ovl_parse_layer(fc, param->string, opt);
 		break;
 	case Opt_default_permissions:
 		config->default_permissions = true;
-- 
2.43.0


--sy4jzimmnhycampu
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0002-ovl-simplify-ovl_parse_param_lowerdir.patch"

From d78c20ac44f75344e3d2babae7e3243fae6ddb1e Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 3 Jul 2024 15:46:19 +0200
Subject: [PATCH 2/2] ovl: simplify ovl_parse_param_lowerdir()

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/overlayfs/params.c | 36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 52e3860973b7..a4f14d8c8884 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -353,6 +353,8 @@ static void ovl_add_layer(struct fs_context *fc, enum ovl_opt layer,
 	case Opt_datadir_add:
 		ctx->nr_data++;
 		fallthrough;
+	case Opt_lowerdir:
+		fallthrough;
 	case Opt_lowerdir_add:
 		WARN_ON(ctx->nr >= ctx->capacity);
 		l = &ctx->lower[ctx->nr++];
@@ -431,9 +433,8 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 {
 	int err;
 	struct ovl_fs_context *ctx = fc->fs_private;
-	struct ovl_fs_context_layer *l;
 	char *dup = NULL, *iter;
-	ssize_t nr_lower, nr;
+	ssize_t nr_lower;
 	bool data_layer = false;
 
 	/*
@@ -471,39 +472,12 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 		goto out_err;
 	}
 
-	if (nr_lower > ctx->capacity) {
-		err = -ENOMEM;
-		l = krealloc_array(ctx->lower, nr_lower, sizeof(*ctx->lower),
-				   GFP_KERNEL_ACCOUNT);
-		if (!l)
-			goto out_err;
-
-		ctx->lower = l;
-		ctx->capacity = nr_lower;
-	}
-
 	iter = dup;
-	l = ctx->lower;
-	for (nr = 0; nr < nr_lower; nr++, l++) {
-		ctx->nr++;
-		memset(l, 0, sizeof(*l));
-
-		err = ovl_mount_dir(iter, &l->path);
-		if (err)
-			goto out_put;
-
-		err = ovl_mount_dir_check(fc, &l->path, Opt_lowerdir, iter, false);
+	for (ssize_t nr = 0; nr < nr_lower; nr++) {
+		err = ovl_parse_layer(fc, iter, Opt_lowerdir);
 		if (err)
 			goto out_put;
 
-		err = -ENOMEM;
-		l->name = kstrdup(iter, GFP_KERNEL_ACCOUNT);
-		if (!l->name)
-			goto out_put;
-
-		if (data_layer)
-			ctx->nr_data++;
-
 		/* Calling strchr() again would overrun. */
 		if (ctx->nr == nr_lower)
 			break;
-- 
2.43.0


--sy4jzimmnhycampu--
