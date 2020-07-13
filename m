Return-Path: <SRS0=r5kD=AY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2F7C433E2
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 10:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E7C120758
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 10:57:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KIFPG08t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgGMK5p (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 06:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgGMK5p (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 06:57:45 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C80C061755
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 03:57:44 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f139so12726392wmf.5
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 03:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yUbE2NwYzMVyxRj09aByC/Q4aiut3QiVx/EgD6Po9t4=;
        b=KIFPG08tCD3DD17x8mxPtu4jEoY9QeIayOJL4kKZSUJ6al8TqeFqJM4UGkLPhp3u5h
         WyYg1aL87zfod+vKMwi2g+9tMvLLoS0eiepCC2jg4hvqRqtGBYsKpm9hgSJ80zxnTL+I
         AZSCVkQmCPO2csBXaxTfQ0U6C+zVmxckh3FgdKGD0ntV+VUFunJYesxrXy/aK9OWG6WS
         qNOJ6cJ9zw50pRHQ9Ar5Qw0i9prCwj18Y7j1+qz5gt+4M2VDRH5MjKsR+Cs5JIFAKREI
         gKgkJsX5nmafSQKKUzFedfESon13dYSkCy33oEBvUI7DBeR0cwdBIs2BjGa6KH5GMLZg
         Lr4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yUbE2NwYzMVyxRj09aByC/Q4aiut3QiVx/EgD6Po9t4=;
        b=flxZHBr0W749Wemhcq04Ul6doYGDslZBBAW5N/2EsEZh2Dh9rMlEdcb71HolmZE/G8
         rMD4BV4KFFPd/wicpuhpMVrfv34zfgjAuyQIK3Z3djxbjFAbYJn/iX5K49t7pTbFdQr0
         MNj2eVFZ6D0necqghm2bqJZoHw/qWWvXGP9p3Bv5BYWUdo8TqyjqS+KftAMqmrcYx2dk
         FH8IESZ/Upjtt1acYeEx2IqHPzGoEspZZ1PSrwTslXxh+wu31iifeEnh3YS2RrvV/UhF
         tsWq+lXCdXwsadha3UsQsQe75JkP6zP3M5RAzi7lv2wdP4mhZlYvmD7j2843690aY6hK
         kycw==
X-Gm-Message-State: AOAM532Qm/Jfs16XPRFSCZwxhQke+7RVHbQ6g1CQRknFhTKm7eAoMXCV
        2N0YvWdqQX0kBE7ioHFLEz8=
X-Google-Smtp-Source: ABdhPJxg9REmBLcz1OMTOOJzD6PQD+0lU2xvjtL5iswEAHHrJ56chjRKRbNnz7xsVgnwcF6YhyZqDg==
X-Received: by 2002:a1c:f407:: with SMTP id z7mr18292905wma.8.1594637863437;
        Mon, 13 Jul 2020 03:57:43 -0700 (PDT)
Received: from localhost.localdomain ([141.226.183.23])
        by smtp.gmail.com with ESMTPSA id r1sm23099330wrw.24.2020.07.13.03.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 03:57:42 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Josh England <jjengla@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH RFC 1/2] ovl: invalidate dentry with deleted real dir
Date:   Mon, 13 Jul 2020 13:57:31 +0300
Message-Id: <20200713105732.2886-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713105732.2886-1-amir73il@gmail.com>
References: <20200713105732.2886-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Changes to underlying layers while overlay in mounted result in
undefined behavior.  Therefore, we can change the behavior to
invalidate the overlay dentry on dcache lookup if one of the
underlying dentries was deleted since the dentry was composed.

Negative underlying dentries are not expected in overlay upper and
lower dentries.  If they are found it is probably dcache lookup racing
with an overlay unlink, before d_drop() was called on the overlay dentry.
IS_DEADDIR directories may be caused by underlying rmdir, so invalidate
overlay dentry on dcache lookup if we find those.

We preserve the legacy behaior of returning -ESTALE on invalid cache
for lower dentries, but we relax this behavior for upper dentries
that may be invalidated by a race with overlay unlink/rmdir.

This doesn't make live changes to underlying layers valid, because
invalid dentry stacks may still be referenced by open files, but it
reduces the window for possible bugs caused by underlying delete,
because lookup cannot return those invalid dentry stacks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 06ec3cb977e6..f2c74387e05b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -113,21 +113,42 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	return dentry;
 }
 
-static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak)
+static bool ovl_dentry_is_dead(struct dentry *d)
 {
+	return unlikely(!d->d_inode || IS_DEADDIR(d->d_inode));
+}
+
+static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak,
+			       bool is_upper)
+{
+	bool strict = !weak;
 	int ret = 1;
 
-	if (weak) {
+	/* Invalidate dentry if real was deleted since we found it */
+	if (ovl_dentry_is_dead(d)) {
+		ret = 0;
+		/* Raced with overlay unlink/rmdir? */
+		if (is_upper)
+			strict = false;
+	} else if (weak) {
 		if (d->d_flags & DCACHE_OP_WEAK_REVALIDATE)
-			ret =  d->d_op->d_weak_revalidate(d, flags);
+			ret = d->d_op->d_weak_revalidate(d, flags);
 	} else if (d->d_flags & DCACHE_OP_REVALIDATE) {
 		ret = d->d_op->d_revalidate(d, flags);
-		if (!ret) {
-			if (!(flags & LOOKUP_RCU))
-				d_invalidate(d);
-			ret = -ESTALE;
-		}
 	}
+
+	/*
+	 * Legacy overlayfs strict behavior is to return an error to user on
+	 * non-weak revalidate rather than retry the lookup, because underlying
+	 * layer changes are not expected. We may want to relax this in the
+	 * future either for upper only or also for lower.
+	 */
+	if (strict && !ret) {
+		if (!(flags & LOOKUP_RCU))
+			d_invalidate(d);
+		ret = -ESTALE;
+	}
+
 	return ret;
 }
 
@@ -141,11 +162,11 @@ static int ovl_dentry_revalidate_common(struct dentry *dentry,
 
 	upper = ovl_dentry_upper(dentry);
 	if (upper)
-		ret = ovl_revalidate_real(upper, flags, weak);
+		ret = ovl_revalidate_real(upper, flags, weak, true);
 
 	for (i = 0; ret > 0 && i < oe->numlower; i++) {
 		ret = ovl_revalidate_real(oe->lowerstack[i].dentry, flags,
-					  weak);
+					  weak, false);
 	}
 	return ret;
 }
-- 
2.17.1

