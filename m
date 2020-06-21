Return-Path: <SRS0=6Laf=AC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C714C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 12:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55D3D248E7
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 12:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HXB3+P/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgFUMoX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 08:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730002AbgFUMoW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 Jun 2020 08:44:22 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DBDC061794
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 05:44:22 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id b5so6828408pgm.8
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 05:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cOBY4MUe2lmuHdONEQBchXq7e9NNsB/CPSaxdVDn8KQ=;
        b=HXB3+P/LdxAQzlkQWISBSrLlWxW3QLrmVEV0bo8XdFb5d4PlnulhiIjEnmh0scG0mK
         Dg3MSFebH8wkVoElSCUGdHXHu0Lx2/JWUJiPlytSdo4fNafowai5sfS4XWHydok7yjH6
         YuiPJMmjoR5VE3K4WyU0aZaUaFzNdVag5GGduUzcBHmQEACIipbys0JkL+lAZ4gTF71B
         eKi6GNoHU1MTn+6AomAYiQGXh9kJxIIddT5ymaqSqrwG/MvEsb6iu1yvfhMWsbtJawxZ
         W0tUe2ajjS5hdkXHNaeA5w7b6NQR/GKq7kSboDES4+7P5Dq1qFFIFfi1o6BMjjpHw+I1
         chJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cOBY4MUe2lmuHdONEQBchXq7e9NNsB/CPSaxdVDn8KQ=;
        b=T8VVvnd1VrOOhWmb+rqa9cCEJSPQDTg69sXhP5lvIOKkYsRdj92kTHpBgrQT6qu0iS
         BSMvlffU/bVg11ul/gg6Vy0v1pVwICPugHnaKN8UGocJNtD/X5WvCqM58G6k8bDmnrqd
         KB5y9prKiVefxNfVaMIlolf2sKY5qA9NW83k5htIqmDDrSmlM5oNQXalI9Ex9aOcDsmm
         qAvnkA4M80uYH4qJrZDmSFWiuyH2xUMLKphI8dg6dBBfSupVvIZi3PoOc0RVYg0PMPI/
         GAAL4tc3vTAzAoT0DkZZQE1FIfKaaj4TFt7AAf2Lg2zynBziZmxAZPNQgWtcSMZ5FVoS
         vGrw==
X-Gm-Message-State: AOAM5324QNQlllqm+14TDptYFgkb5ob1BQ4xtfSMMfYQC+1kMvDGXxNU
        fvZnalnpUi9zP4eFqT5epcM=
X-Google-Smtp-Source: ABdhPJyNfoEiFodsqRJNBKZE5ZZw7BRdq73JBRlKnesV7x+p1Oncf9TXiqs628eJXgs1lypckZ35nw==
X-Received: by 2002:a63:e54d:: with SMTP id z13mr9031932pgj.78.1592743462328;
        Sun, 21 Jun 2020 05:44:22 -0700 (PDT)
Received: from ubuntu.localdomain ([220.116.27.194])
        by smtp.gmail.com with ESMTPSA id f131sm7165929pgc.14.2020.06.21.05.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 05:44:21 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, youngjun <her0gyugyu@gmail.com>
Subject: [PATCH] ovl: change "ovl_copy_up_flags" static
Date:   Sun, 21 Jun 2020 05:44:15 -0700
Message-Id: <20200621124415.65064-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

"ovl_copy_up_flags" is used in copy_up.c.
So, change it static.

Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/copy_up.c   |  2 +-
 fs/overlayfs/namei.c     | 11 ++---------
 fs/overlayfs/overlayfs.h |  1 -
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 79dd052c7dbf..5e0cde85bd6b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -895,7 +895,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	return err;
 }
 
-int ovl_copy_up_flags(struct dentry *dentry, int flags)
+static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 {
 	int err = 0;
 	const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 3566282a9199..3cad68c3efb2 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -389,7 +389,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 }
 
 static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
-			    struct ovl_path **stackp, unsigned int *ctrp)
+			    struct ovl_path **stackp)
 {
 	struct ovl_fh *fh = ovl_get_fh(upperdentry, OVL_XATTR_ORIGIN);
 	int err;
@@ -406,10 +406,6 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
 		return err;
 	}
 
-	if (WARN_ON(*ctrp))
-		return -EIO;
-
-	*ctrp = 1;
 	return 0;
 }
 
@@ -861,8 +857,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out;
 		}
 		if (upperdentry && !d.is_dir) {
-			unsigned int origin_ctr = 0;
-
 			/*
 			 * Lookup copy up origin by decoding origin file handle.
 			 * We may get a disconnected dentry, which is fine,
@@ -873,8 +867,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			 * number - it's the same as if we held a reference
 			 * to a dentry in lower layer that was moved under us.
 			 */
-			err = ovl_check_origin(ofs, upperdentry, &origin_path,
-					       &origin_ctr);
+			err = ovl_check_origin(ofs, upperdentry, &origin_path);
 			if (err)
 				goto out_put_upper;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b725c7f15ff4..29bc1ec699e7 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -483,7 +483,6 @@ void ovl_aio_request_cache_destroy(void);
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_with_data(struct dentry *dentry);
-int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_maybe_copy_up(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
-- 
2.17.1

