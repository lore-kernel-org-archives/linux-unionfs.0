Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B63C4167B
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 12:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjJ3MEb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJ3MEb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 08:04:31 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D072EC6
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:28 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2c6cb4a79deso4278161fa.1
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698667467; x=1699272267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7GyRjWgAxfLBz49YoxIaJewQyTYAtCFm3+x+/qv5xOM=;
        b=hhGGIDkpl+1RdoaN8qEOZqtzvN0FLDQvWfTSH8VYFtvjRzCVhsifYtgR2fjv0b0LN5
         DBCgpnKXvR9N1c4Ze7d9i0oIb+wUNjjPRAVxBTnZqgfEFhipRHUWqbRLjdZMSKPtpY2S
         CDPFq/zJ+QwsrgeasWFDSIFnl6xwB594+3xj3gK8vE69XjPlhWPKvnB5uDUZ29/FUf7I
         gj2MWFH1i/IMdeWEoS7kFQTdISKSqOy5/gchd7wlmOQVUn/GezaHKIx1SD7GnTE8QRp6
         MUYU1FW64jNn/gPHyu/Mn/PtvSmSsaUDO547Mx89MgAc4Q5Q26lMtH+m5s7CP2Kx9nOW
         Xa9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698667467; x=1699272267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GyRjWgAxfLBz49YoxIaJewQyTYAtCFm3+x+/qv5xOM=;
        b=Rvzc/7g3eGnLkYGlByEb1KZwfT5DwzGN23JpONsWr/Ouu5AmTTTtcQMRZDy7+8Mcf6
         DKCP5p/Porprq4LIyl+hqefdWxmE2ZxhExQka/KurjzA1vM+CVhdm4P9CjNywMnhFzrU
         xAzSdWHXPoMvjXGJXbay7PFRDrgjvXp6VtyEqB/HNVEPbpgrpzCni9awVakcvP9nuU+4
         uXAbqsaOpVlMsOKQKn/1FgUmG1w6HgWAHyj7JfOHFWCiwz8F++X+KISxy2uBkJWQJkoS
         xYqf1d3B+yAF3ahBY3nDIAszDu5jhwSPFQpwbwMTo0nN2knpy6SGnwMQSANEcWwT+U1c
         E/Lw==
X-Gm-Message-State: AOJu0YwIzt5hi+/FlfPsrY3ZQrJ/Nj730aMZEsmhFx5h7/fAAAn0Bviw
        kbdha1in6IFu461RF1z5lf1UkIuWrjE=
X-Google-Smtp-Source: AGHT+IH5Mgp9+s9ytLSSrghJoWLaNQBS8l26Nb4Tfam3ImfPFnjqbwPyJMPBwQH2tCXi6krhMWzXZg==
X-Received: by 2002:a05:651c:2044:b0:2c5:7c22:c071 with SMTP id t4-20020a05651c204400b002c57c22c071mr2654946ljo.25.1698667466913;
        Mon, 30 Oct 2023 05:04:26 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l21-20020a2e7015000000b002b9e346a152sm1210753ljc.96.2023.10.30.05.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 05:04:26 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 1/4] ovl: remove unused code in lowerdir param parsing
Date:   Mon, 30 Oct 2023 14:04:16 +0200
Message-Id: <20231030120419.478228-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030120419.478228-1-amir73il@gmail.com>
References: <20231030120419.478228-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Commit beae836e9c61 ("ovl: temporarily disable appending lowedirs")
removed the ability to append lowerdirs with syntax lowerdir=":<path>".
Remove leftover code and comments that are irrelevant with lowerdir
append mode disabled.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/params.c | 95 ++++++++-----------------------------------
 1 file changed, 16 insertions(+), 79 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index f6ff23fd101c..0059cc405159 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -346,7 +346,7 @@ static void ovl_parse_param_drop_lowerdir(struct ovl_fs_context *ctx)
 /*
  * Parse lowerdir= mount option:
  *
- * (1) lowerdir=/lower1:/lower2:/lower3::/data1::/data2
+ * e.g.: lowerdir=/lower1:/lower2:/lower3::/data1::/data2
  *     Set "/lower1", "/lower2", and "/lower3" as lower layers and
  *     "/data1" and "/data2" as data lower layers. Any existing lower
  *     layers are replaced.
@@ -356,9 +356,9 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	int err;
 	struct ovl_fs_context *ctx = fc->fs_private;
 	struct ovl_fs_context_layer *l;
-	char *dup = NULL, *dup_iter;
+	char *dup = NULL, *iter;
 	ssize_t nr_lower = 0, nr = 0, nr_data = 0;
-	bool append = false, data_layer = false;
+	bool data_layer = false;
 
 	/*
 	 * Ensure we're backwards compatible with mount(2)
@@ -366,10 +366,10 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	 */
 
 	/* drop all existing lower layers */
-	if (!*name) {
-		ovl_parse_param_drop_lowerdir(ctx);
+	ovl_parse_param_drop_lowerdir(ctx);
+
+	if (!*name)
 		return 0;
-	}
 
 	if (*name == ':') {
 		pr_err("cannot append lower layer");
@@ -385,36 +385,11 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	if (nr_lower < 0)
 		goto out_err;
 
-	if ((nr_lower > OVL_MAX_STACK) ||
-	    (append && (size_add(ctx->nr, nr_lower) > OVL_MAX_STACK))) {
+	if (nr_lower > OVL_MAX_STACK) {
 		pr_err("too many lower directories, limit is %d\n", OVL_MAX_STACK);
 		goto out_err;
 	}
 
-	if (!append)
-		ovl_parse_param_drop_lowerdir(ctx);
-
-	/*
-	 * (1) append
-	 *
-	 * We want nr <= nr_lower <= capacity We know nr > 0 and nr <=
-	 * capacity. If nr == 0 this wouldn't be append. If nr +
-	 * nr_lower is <= capacity then nr <= nr_lower <= capacity
-	 * already holds. If nr + nr_lower exceeds capacity, we realloc.
-	 *
-	 * (2) replace
-	 *
-	 * Ensure we're backwards compatible with mount(2) which allows
-	 * "lowerdir=/a:/b:/c,lowerdir=/d:/e:/f" causing the last
-	 * specified lowerdir mount option to win.
-	 *
-	 * We want nr <= nr_lower <= capacity We know either (i) nr == 0
-	 * or (ii) nr > 0. We also know nr_lower > 0. The capacity
-	 * could've been changed multiple times already so we only know
-	 * nr <= capacity. If nr + nr_lower > capacity we realloc,
-	 * otherwise nr <= nr_lower <= capacity holds already.
-	 */
-	nr_lower += ctx->nr;
 	if (nr_lower > ctx->capacity) {
 		err = -ENOMEM;
 		l = krealloc_array(ctx->lower, nr_lower, sizeof(*ctx->lower),
@@ -426,41 +401,17 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 		ctx->capacity = nr_lower;
 	}
 
-	/*
-	 *   (3) By (1) and (2) we know nr <= nr_lower <= capacity.
-	 *   (4) If ctx->nr == 0 => replace
-	 *       We have verified above that the lowerdir mount option
-	 *       isn't an append, i.e., the lowerdir mount option
-	 *       doesn't start with ":" or "::".
-	 * (4.1) The lowerdir mount options only contains regular lower
-	 *       layers ":".
-	 *       => Nothing to verify.
-	 * (4.2) The lowerdir mount options contains regular ":" and
-	 *       data "::" layers.
-	 *       => We need to verify that data lower layers "::" aren't
-	 *          followed by regular ":" lower layers
-	 *   (5) If ctx->nr > 0 => append
-	 *       We know that there's at least one regular layer
-	 *       otherwise we would've failed when parsing the previous
-	 *       lowerdir mount option.
-	 * (5.1) The lowerdir mount option is a regular layer ":" append
-	 *       => We need to verify that no data layers have been
-	 *          specified before.
-	 * (5.2) The lowerdir mount option is a data layer "::" append
-	 *       We know that there's at least one regular layer or
-	 *       other data layers. => There's nothing to verify.
-	 */
-	dup_iter = dup;
-	for (nr = ctx->nr; nr < nr_lower; nr++) {
-		l = &ctx->lower[nr];
+	iter = dup;
+	l = ctx->lower;
+	for (nr = 0; nr < nr_lower; nr++, l++) {
 		memset(l, 0, sizeof(*l));
 
-		err = ovl_mount_dir(dup_iter, &l->path, false);
+		err = ovl_mount_dir(iter, &l->path, false);
 		if (err)
 			goto out_put;
 
 		err = -ENOMEM;
-		l->name = kstrdup(dup_iter, GFP_KERNEL_ACCOUNT);
+		l->name = kstrdup(iter, GFP_KERNEL_ACCOUNT);
 		if (!l->name)
 			goto out_put;
 
@@ -472,8 +423,8 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 			break;
 
 		err = -EINVAL;
-		dup_iter = strchr(dup_iter, '\0') + 1;
-		if (*dup_iter) {
+		iter = strchr(iter, '\0') + 1;
+		if (*iter) {
 			/*
 			 * This is a regular layer so we require that
 			 * there are no data layers.
@@ -489,7 +440,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 
 		/* This is a data lower layer. */
 		data_layer = true;
-		dup_iter++;
+		iter++;
 	}
 	ctx->nr = nr_lower;
 	ctx->nr_data += nr_data;
@@ -497,21 +448,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	return 0;
 
 out_put:
-	/*
-	 * We know nr >= ctx->nr < nr_lower. If we failed somewhere
-	 * we want to undo until nr == ctx->nr. This is correct for
-	 * both ctx->nr == 0 and ctx->nr > 0.
-	 */
-	for (; nr >= ctx->nr; nr--) {
-		l = &ctx->lower[nr];
-		kfree(l->name);
-		l->name = NULL;
-		path_put(&l->path);
-
-		/* don't overflow */
-		if (nr == 0)
-			break;
-	}
+	ovl_parse_param_drop_lowerdir(ctx);
 
 out_err:
 	kfree(dup);
-- 
2.34.1

