Return-Path: <SRS0=3hX1=7U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77507C433E0
	for <linux-unionfs@archiver.kernel.org>; Sun,  7 Jun 2020 09:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D80C2073B
	for <linux-unionfs@archiver.kernel.org>; Sun,  7 Jun 2020 09:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IPgD1798"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgFGJEP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 7 Jun 2020 05:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgFGJEP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 7 Jun 2020 05:04:15 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09925C08C5C2;
        Sun,  7 Jun 2020 02:04:13 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w20so7314428pga.6;
        Sun, 07 Jun 2020 02:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D/y4hFvvwLwiTdep1fp13E4p8rqYN4Onjhusy+MPIlk=;
        b=IPgD1798WEOvPTQJv93A2sSB0k2hIXax2eT0h1qLpRkeaO+NNhcAU/DCOyU51du8i0
         O6KC6vv/cjNkQKibf+GuNS05i7prDi9B0CHldlexo3BXidalYHDub7fMnW/aJlK80DL4
         Eod8PU4Sa/q0T8F4C7KUvM5tLA9P9MJA8GOGscDi1uJUzX7C9kjFhgzaKti28kYpW9dR
         zuvwjF899STWFG2c/9zPf4f8AJMnUKTvM7ZbxbWMxam2aXhCpkQGcWfhMlqp8Q29CLJz
         WfUqSHBY2P7xqr9VCCZI5A7oV4T27GbuGqOQe/3pxYYLnd9YZzAY2UiFVUEKeibfBp4x
         p6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D/y4hFvvwLwiTdep1fp13E4p8rqYN4Onjhusy+MPIlk=;
        b=UK3dbo6hcL5ZFgNnys6pfhUSADbdexHy3iWmy3qtM7/uLydyHkOYx8s5dHW60Rp98e
         Vw5BeE3c+UVQNDi8T4PmXbFP0ZG+9IYYgPkXWfd0Bn5c3ZTscPKs/NKgVbjjz17rZZsC
         7lLgpvUEjfqXZ0SV2nKImKrr/ortlGVBYbcSTXTxyGCEjxZqSAeEszpKp8ShAPy+o9Jt
         /8ELQtnA25iZv8QimR5BH6GXToZpJbywqj29FJT8L0ffkPKswb/oUhp5Iht09GpXbBNM
         7hioHwsfFVrDY8fovEIaRIXYkzvuzaIlKs4VO5FYDqlOw1OdbuqROiSXIeoFTzmhAWRd
         w2ew==
X-Gm-Message-State: AOAM531lBA5anHzmyHaG7vnWLngQulC9qtOO0rVQCMvOEoqZjoEgi5re
        jsK5Gm6pvKpZF2BzgznVYOI=
X-Google-Smtp-Source: ABdhPJzWPwHWWH0oqsFWe2lIIBV1npm9Sno+uSIRNbNNDtL7gTVaNTS27Zwv+9AMOBnfn3s8Cq5yXA==
X-Received: by 2002:a63:fe0e:: with SMTP id p14mr15727719pgh.126.1591520652408;
        Sun, 07 Jun 2020 02:04:12 -0700 (PDT)
Received: from ubuntu.localdomain ([220.116.27.194])
        by smtp.gmail.com with ESMTPSA id w5sm3871158pfn.22.2020.06.07.02.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 02:04:11 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        youngjun <her0gyugyu@gmail.com>
Subject: [PATCH] overlay: remove not necessary lock check.
Date:   Sun,  7 Jun 2020 02:04:06 -0700
Message-Id: <20200607090406.129012-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

dir is always locked until "out_unlock" label.
So lock check is not needed.

Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/super.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 732ad5495c92..43257c18fe26 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -615,10 +615,8 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 	struct dentry *work;
 	int err;
 	bool retried = false;
-	bool locked = false;
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
-	locked = true;
 
 retry:
 	work = lookup_one_len(name, ofs->workbasedir, strlen(name));
@@ -680,9 +678,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 		goto out_err;
 	}
 out_unlock:
-	if (locked)
-		inode_unlock(dir);
-
+	inode_unlock(dir);
 	return work;
 
 out_dput:
-- 
2.17.1

