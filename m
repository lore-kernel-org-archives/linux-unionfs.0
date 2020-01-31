Return-Path: <SRS0=T6lg=3U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 281F7C35246
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEAD6206F0
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TIAKataM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgAaLuW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 06:50:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21417 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728531AbgAaLuW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jan 2020 06:50:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580471421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nQ17yO5W5w5qlWY/ou9U5Zs/oUqInXzTRAcl/4EyG5I=;
        b=TIAKataMmj2rQGp7Znd30HjU/9nk/pyJpvWyr0tib2+bsglVTbzC5farQmOEX0KR3jA8B7
        /a5Frkc/r5vsteZMq30UUusUApNGpbeO4txU4sheS1J8IgFyLf2INBHBUKixgR9RElvMLV
        8YERLJgRZlTUlxt2pEx9UuvtvASOcE4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-SOfJg_HyPmyc3Aq1g48yGQ-1; Fri, 31 Jan 2020 06:50:19 -0500
X-MC-Unique: SOfJg_HyPmyc3Aq1g48yGQ-1
Received: by mail-wr1-f72.google.com with SMTP id d8so3225753wrq.12
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jan 2020 03:50:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nQ17yO5W5w5qlWY/ou9U5Zs/oUqInXzTRAcl/4EyG5I=;
        b=GyJ4bkJN+pRjKIV4MZrCIjzqotiXrjBwOGO6Z+1vQ+ZnCmHasZASIWL8B2jkJlVH9n
         TK71pSK7qLHWiSkWAIDKgk8KZ7bZO8V/vU0g6zKbIMlhMLDsZtZkUO9o7s7z8IN9s3j9
         mBCUNOCuO0bvr6GdoqJJLCBeblRKd4vxZls1lz0uE8yTOLIufeXBmVmuR0w1gsYmhLS4
         5v5i0+MXlFDt0LHCbrXKiBq0GXgKwvNNlbkzFk/EKD+MZT3bZ2q3IdbZABGRPlIaUQH+
         bY8kw2VZkKQ0szfdXX8dad9eRRquNCgMwdBlLat1CMm7XjJY7HWKdkGBtfUS0GTG90uR
         6o6Q==
X-Gm-Message-State: APjAAAVtrQklDC9WtwkUqS2r8Rj3fsSs0kpcVNFMUZpTkml7Uj88z4qj
        g0tN5YfKjyZ9xdXgHo9Zulvnug5NiqTslblEhD0tvLrLHXVUOYajZtE4HrFy+9TtPCIBUjXbFxW
        qhPQq+YbD5WB/C5djGpgYIAx3qg==
X-Received: by 2002:a7b:c392:: with SMTP id s18mr11697468wmj.169.1580471417335;
        Fri, 31 Jan 2020 03:50:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqywPWhJTRUZpBkOIsW+lcecG5d1oMkcsu1k0suFAsbAcNAiz2UC4Oc6MWvdVzVLHNED2OGdiQ==
X-Received: by 2002:a7b:c392:: with SMTP id s18mr11697450wmj.169.1580471417132;
        Fri, 31 Jan 2020 03:50:17 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (84-236-74-45.pool.digikabel.hu. [84.236.74.45])
        by smtp.gmail.com with ESMTPSA id s1sm2746622wro.66.2020.01.31.03.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 03:50:16 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     linux-unionfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 4/4] ovl: alllow remote upper
Date:   Fri, 31 Jan 2020 12:50:04 +0100
Message-Id: <20200131115004.17410-5-mszeredi@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200131115004.17410-1-mszeredi@redhat.com>
References: <20200131115004.17410-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

No reason to prevent upper layer being a remote filesystem.  Do the
revalidation in that case, just as we already do for lower layers.

This lets virtiofs be used as upper layer, which appears to be a real use
case.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/namei.c | 3 +--
 fs/overlayfs/super.c | 8 ++++++--
 fs/overlayfs/util.c  | 2 ++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 76e61cc27822..0db23baf98e7 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -845,8 +845,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (err)
 			goto out;
 
-		if (upperdentry && (upperdentry->d_flags & DCACHE_OP_REAL ||
-				    unlikely(ovl_dentry_remote(upperdentry)))) {
+		if (upperdentry && upperdentry->d_flags & DCACHE_OP_REAL) {
 			dput(upperdentry);
 			err = -EREMOTE;
 			goto out;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 26d4153240a8..ed3a11db9039 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -135,9 +135,14 @@ static int ovl_dentry_revalidate_common(struct dentry *dentry,
 					unsigned int flags, bool weak)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
+	struct dentry *upper;
 	unsigned int i;
 	int ret = 1;
 
+	upper = ovl_dentry_upper(dentry);
+	if (upper)
+		ret = ovl_revalidate_real(upper, flags, weak);
+
 	for (i = 0; ret > 0 && i < oe->numlower; i++) {
 		ret = ovl_revalidate_real(oe->lowerstack[i].dentry, flags,
 					  weak);
@@ -747,8 +752,7 @@ static int ovl_mount_dir(const char *name, struct path *path)
 		ovl_unescape(tmp);
 		err = ovl_mount_dir_noesc(tmp, path);
 
-		if (!err && (ovl_dentry_remote(path->dentry) ||
-			     path->dentry->d_flags & DCACHE_OP_REAL)) {
+		if (!err && path->dentry->d_flags & DCACHE_OP_REAL) {
 			pr_err("filesystem on '%s' not supported as upperdir\n",
 			       tmp);
 			path_put_init(path);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3ad8fb291f7d..c793722739e1 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -96,6 +96,8 @@ void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
 	struct ovl_entry *oe = OVL_E(dentry);
 	unsigned int i, flags = 0;
 
+	if (upperdentry)
+		flags |= upperdentry->d_flags;
 	for (i = 0; i < oe->numlower; i++)
 		flags |= oe->lowerstack[i].dentry->d_flags;
 
-- 
2.21.1

