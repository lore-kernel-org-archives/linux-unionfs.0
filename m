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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE83FC433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 12:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B1D3248EB
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 12:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hPbiKlCb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbgFUMuI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 08:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbgFUMuI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 Jun 2020 08:50:08 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EE7C061794
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 05:50:07 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so2195722plq.6
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 05:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RlJ8ftXRO7FgO7gmzZy1QLpHLSNTr6nrralYNH4Uixo=;
        b=hPbiKlCbCljMGTJTlWBxSxlpXgMrwkIrV/e72AmW6oCDpMGm74O1YbeLO3wKl08CmH
         IJp6hS2NMC/VOFyvh8Yw2t41fcSPB5V+N0xIspaJQBgIwfmcB5Oja3nQ2s1cuwUaD0nH
         zKhnwtoqvQYgYYPnO5HriOePJdBxHDd2jh335Qsac3YvYj/DYcO1/C7Bx3aKJ0aImKEM
         LeCxbl/q8zQoNhE+vO/pf2v73wc3iefT1WVxLZI5tRDdcnO1xoGH0JmwZyXP3s6CFnY9
         kc62BkmjS5UMmUpOFp8zwQ4YHMSjl+r/omWv8S9EAZb94y6PZYuqDKV8OeloZsqPWPkO
         s8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RlJ8ftXRO7FgO7gmzZy1QLpHLSNTr6nrralYNH4Uixo=;
        b=Qer4vVsP7R+OGDJYFfSrVFuwLf6wV/JDA8y8eXxg1TAlHUN3fYgGopZwfLTTAh24DY
         T4ewQccZDGjGp3CaY0vkIIecv1WaLOpPySlOs+c3J03S28Npo1IIsHR38kd0Ms5uqiaj
         DNvhXy/Jl0fZOH0nfkGNqPZzFKZZgRYMH12gcME7wprhixUtgHide570UaKbKDMm6rhP
         hATcsPUxmnKAN4WDajd2H3LIl35q/BEKZiuD/kaqg8EMuUFLB6pwQ+qdy9tA4e99Fx13
         B9LH5nZv7Asye1FV5RfdzJOWMPFXzl4md1yjTTy5Lcl+TS1+N36Kn2EXOuuwl1Mht/80
         BRxA==
X-Gm-Message-State: AOAM531xO5oXi7a2bjG1xkaqllXtwv2xyLVOWQjMm11vyUI1tq+1DCLQ
        OT2eRZnfrttmnyABjv0ez2A=
X-Google-Smtp-Source: ABdhPJwOCRki4auf4EuvN7JATJgyOTT5yTV/wlHQAp32c1bmoZ1ESmOyio3VxHv2X/1JP8K2TfTr2w==
X-Received: by 2002:a17:90a:b25:: with SMTP id 34mr12338341pjq.220.1592743807349;
        Sun, 21 Jun 2020 05:50:07 -0700 (PDT)
Received: from ubuntu.localdomain ([220.116.27.194])
        by smtp.gmail.com with ESMTPSA id z85sm11396420pfc.66.2020.06.21.05.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 05:50:06 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, youngjun <her0gyugyu@gmail.com>
Subject: [PATCH] ovl: remove not used argument in ovl_check_origin
Date:   Sun, 21 Jun 2020 05:50:01 -0700
Message-Id: <20200621125001.65428-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl_check_origin outparam 'ctrp' argument
not used by caller. So, remove this argument
from ovl_check_origin.

Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/namei.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

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
 
-- 
2.17.1

