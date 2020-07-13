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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D04C433E3
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 14:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3E8A2072D
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 14:19:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2FU1jz4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgGMOT5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 10:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMOT5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 10:19:57 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0076AC061755
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 07:19:56 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so13346778wmh.2
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 07:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s/tJ2tVhwkzCFnUVD1krC2IRsi+8XkybACDah8AUlOg=;
        b=l2FU1jz4CaB3ru8mxi/A/55n5Ckb3NsbHI+R/Z/NIj3GM6xOESMVqHcx+4A8H7mDge
         CUnhsYwjM/AKEOPnoTTaT90Uhq4jEerqUTTJ25pJhecOMcFhibzGvfTymfAS0x7qT5jp
         5d7vjs+3T5o+4YDUG1kz0VP60Iv7BtY7qTS2PmfhZ/00Xlzlx8E+wYPweix8aE42Y/nv
         64jMdYv0wlNkfDxQff+ciCmYJy+prI9KN9J3paTWAm5lzcww0N+wojvb8h+piVFsaHrX
         nLyf0IYEyNznB3qv0WvsurY43HjugqnGFWNCWNPBhpUXhCbve1TyW3RFZrCgiEKwvSAX
         6RVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s/tJ2tVhwkzCFnUVD1krC2IRsi+8XkybACDah8AUlOg=;
        b=YiVZZqvR4LOpfSZx4bFaExgG8DnYZDrTrkVd4JHhwAm7l3I5sJ7GJ3k1+JJ4XcHo8n
         aw9EOdosxoHQJFOaFa4Ddt1MEikgJkXj/kQ4iD1RzsVFTBhRv71iLViHAg79IylkVZ5H
         dzk5g5Of+3YZxRtpSAyZeECbUoXWwLUhDGpDwl5Cw0hm98Jts5Wpno0yaJrDJ+lIByCW
         XIL8kCciOD9dkbDFpbowEjtXl7lB0PPts/PSw3ELPYRecXvrrXzOZiAeY9yPlh3MmoZ7
         suZouidBHpjkOywvcGPmD86AmTdeeH60H5pq4iwJbe9ghNuWZkQjLC7Dr2ySAeuoyPue
         rmpw==
X-Gm-Message-State: AOAM532fpN+0kGWKVkeGDEGTkd0A4s3+mCxxHkikwwgXT69If6ESCnCc
        UbXmv8mSUD9jLIcRxT4+su3UWiCj
X-Google-Smtp-Source: ABdhPJyUd0PMThUgXhQBseb2MGqVnnUfrO847WNShaLt7rmemVeaTnktAVOqDr0ON9VHEbLQUQCasg==
X-Received: by 2002:a7b:c394:: with SMTP id s20mr200266wmj.31.1594649995749;
        Mon, 13 Jul 2020 07:19:55 -0700 (PDT)
Received: from localhost.localdomain ([141.226.183.23])
        by smtp.gmail.com with ESMTPSA id 1sm21681024wmf.21.2020.07.13.07.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:19:55 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 1/3] ovl: force read-only sb on failure to create index dir
Date:   Mon, 13 Jul 2020 17:19:43 +0300
Message-Id: <20200713141945.11719-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713141945.11719-1-amir73il@gmail.com>
References: <20200713141945.11719-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

With index feature enabled, on failure to create index dir, overlay
is being mounted read-only.  However, we do not forbid user to remount
overlay read-write.  Fix that by setting ofs->workdir to NULL, which
prevents remount read-write.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4b7cb2d98203..41d7fe2b8129 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1374,12 +1374,13 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 		goto out;
 	}
 
+	/* index dir will act also as workdir */
+	iput(ofs->workdir_trap);
+	ofs->workdir_trap = NULL;
+	dput(ofs->workdir);
+	ofs->workdir = NULL;
 	ofs->indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
 	if (ofs->indexdir) {
-		/* index dir will act also as workdir */
-		iput(ofs->workdir_trap);
-		ofs->workdir_trap = NULL;
-		dput(ofs->workdir);
 		ofs->workdir = dget(ofs->indexdir);
 
 		err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
@@ -1884,7 +1885,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ovl_upper_mnt(ofs))
 		sb->s_flags |= SB_RDONLY;
 
-	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
+	if (!ovl_force_readonly(ofs) && ofs->config.index) {
 		err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
 		if (err)
 			goto out_free_oe;
-- 
2.17.1

