Return-Path: <SRS0=+IUt=76=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A78C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 17 Jun 2020 06:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58291208D5
	for <linux-unionfs@archiver.kernel.org>; Wed, 17 Jun 2020 06:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sc2+pfgX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgFQG5X (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 02:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgFQG5U (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 Jun 2020 02:57:20 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D598FC061573
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Jun 2020 23:57:18 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x13so1077274wrv.4
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Jun 2020 23:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nhV5DPnGBT0UXlVanrTn3Pr8CjGMBQckzJeOpEG0rAU=;
        b=sc2+pfgXFYzHI77lT8WMHMJt2c3+rjNkKEbRG+776Rs+B0ilgLsmE5haIs/ys5tghA
         eHtNLzNJawLXI5VNDd2hVXeVtp0+XQ+KV2Ecb+WVW++m1f5Ut+W1lgfnI3MHC9FWQUg+
         gLsVQ3D19R/BybJOvt/ZZwZcYBZ5oxt6k5ydBG54sXFB0ZGu/qas0XVfAWBPsutfc3yv
         OuRbQqtoxUhP7/4Pwmng9E7AnjaDIHq+u5ix8NbyhswirDoS0aqVyxfnJwnov1+ejTUB
         oDP1+W6nqzkTdTL7iXYRK8hmJN1b+Bp787WJhDNWa/dX1lY+xrFxKNwq6IVKHwEjCzeS
         blWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nhV5DPnGBT0UXlVanrTn3Pr8CjGMBQckzJeOpEG0rAU=;
        b=bk5iukwivXrVvvCERygMSS/oiGMUkH2h+mwWJhLlHHcZcKZyERoIq9UswDSCEYrdTW
         5SvrHmdSM7ZyKJEJq57zi1nqZNSgIku26ekva/BZs0FH4vijVIIxUYupnx1WfIstXBxj
         n/pm2zkM2VNj/bGjBRXp8ZIfd9eWFUd2RyuvkatazyQ3/e3vcvoFB0qvbDVYvS+6C/j1
         YcNhxMx2Ze0zcT1yZ3pMVT4lugxQ20D2eDFg4Eza1gtAPTRUGP6w7TpWUso5QlE0jtj6
         tD+r35AJqPc+QGcdL2MwWBGpjSeaYc8nSwoL8owhmyEPd2lcq0Jusrh7Yo/+AAWRjJEK
         mDGg==
X-Gm-Message-State: AOAM533ndUWpIc+jbGSM4DGJWWJFfAkl6lz5Fli/f857BeFVYcVxRab9
        NzvIAykTKjiIIb3EsxPR+ck=
X-Google-Smtp-Source: ABdhPJytJJCECiTFTNYZZz17S1xjXhF3I21arO48qzf3bFe7ppD2Rq/H3ONd+VirxE9gGA+zsJRrFQ==
X-Received: by 2002:adf:ecc8:: with SMTP id s8mr3597498wro.317.1592377037571;
        Tue, 16 Jun 2020 23:57:17 -0700 (PDT)
Received: from localhost.localdomain ([94.230.83.8])
        by smtp.gmail.com with ESMTPSA id 5sm42424305wrr.5.2020.06.16.23.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 23:57:16 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: relax WARN_ON() when decoding lower directory file handle
Date:   Wed, 17 Jun 2020 09:57:11 +0300
Message-Id: <20200617065711.3784-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Decoding a lower directory file handle to overlay path with cold
inode/dentry cache may go as follows:

1. Decode real lower file handle to lower dir path
2. Check if lower dir is indexed (was copied up)
3. If indexed, get the upper dir path from index
4. Lookup upper dir path in overlay
5. If overlay path found, verify that overlay lower is the lower dir
   from step 1

On failure to verify step 5 above, user will get an ESTALE error and
a WARN_ON will be printed.

A mismatch in step 5 could be a result of lower directory that was renamed
while overlay was offline, after that lower directory has been copied
up and indexed.

This is a scripted reproducer based on xfstest overlay/052:

  # Create lower subdir
  create_dirs
  create_test_files $lower/lowertestdir/subdir
  mount_dirs
  # Copy up lower dir and encode lower subdir file handle
  touch $SCRATCH_MNT/lowertestdir
  test_file_handles $SCRATCH_MNT/lowertestdir/subdir -p -o $tmp.fhandle
  # Rename lower dir offline
  unmount_dirs
  mv $lower/lowertestdir $lower/lowertestdir.new/
  mount_dirs
  # Attempt to decode lower subdir file handle
  test_file_handles $SCRATCH_MNT -p -i $tmp.fhandle

Since this WARN_ON() can be triggered by user we need to relax it.

Fixes: 4b91c30a5a19 ("ovl: lookup connected ancestor of dir in inode...")
Cc: <stable@vger.kernel.org> # v4.16+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 8f4286450f92..0e696f72cf65 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -476,7 +476,7 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 	if (IS_ERR_OR_NULL(this))
 		return this;
 
-	if (WARN_ON(ovl_dentry_real_at(this, layer->idx) != real)) {
+	if (ovl_dentry_real_at(this, layer->idx) != real) {
 		dput(this);
 		this = ERR_PTR(-EIO);
 	}
-- 
2.17.1

