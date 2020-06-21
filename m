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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F13C433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 14:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00C12080C
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 14:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qpBXEPZO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgFUObH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 10:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgFUObG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 Jun 2020 10:31:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA87C061794
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 07:31:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id d6so7131576pjs.3
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 07:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:reply-to;
        bh=xQISDFi7OtSQENMvfNsJZYStJ++HTm3ZfKITsq8Ytpg=;
        b=qpBXEPZOsaCEMI6gix14Iq18mD/41WhnUbDbayVx8P6iDCsxpTSoCso/EnlyJysr1A
         e+V/71NAkFEsTyMxQBn/S9NjXNNru2kKPHEHtmbPAcmS2M3MZB/1NJLvwH9yZ6tLL8rX
         exgFxoKg0+ttuhEHT2IUqKEWMY9u0AO5mKB4Juf1FzfwWHZ0xCO7J1pJ0QV+7Xg2qDgd
         OBcxK47s5fmko6XWVZxX3Dr0kW0fRIYhLv31KsrgV4bc3FUn1ibKMCzqccr4n9pvgCL1
         o/t4srcXcBGuJsWFziiutkR9RgreuvypbkXTNixr1h2Q3GmFFUD1QWx/MeHoPqBTaeoG
         Y5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xQISDFi7OtSQENMvfNsJZYStJ++HTm3ZfKITsq8Ytpg=;
        b=KpKtx8SoIHH/GFB8iklrN+5FeA4rUjwSnd5cLR3KnOVK2sPZ1RbwyMknrDsIjKidaT
         3ObZD9GOJMNU0wiQ+l3KFm/NwVNGqr6yqxNguxRdDq/Eg0/Xqve52SNPCuaB+UNtSYQM
         erTxxQoYQDQEBSgxSIhKU/Ymf/tHZhobg1T+Ks0i6WgibXbVU4Nfbaov6fNRBylNvGgL
         xiXjr9EqSQC6CX5OoUF0Mc6xHNrbY4+S8LAG3pZn3Zb1LQcI+43TYDQnou8FMQw97XM0
         DKLxBZs4W+kxmBVUKNTXPW88uWEoCAyWi01pZLmRYtXkalsNm6LxV6yyn2OXhg+uzEUi
         Q5gw==
X-Gm-Message-State: AOAM532ffaYgliRxfJ3pKxY6V1+ffc2RCknXHnUlrMwDGSExSqH/W5Pa
        4CVDXK2zOQ1IYtu+5F/Udz09gi/Fucg=
X-Google-Smtp-Source: ABdhPJxzGp530CKqMgB44KnpNfkiaZ7m/O0roN/rFz6PQapXW456ElrZDtYgSGtD3fdDaCc1djLBTg==
X-Received: by 2002:a17:90a:e60d:: with SMTP id j13mr13948626pjy.127.1592749866513;
        Sun, 21 Jun 2020 07:31:06 -0700 (PDT)
Received: from ubuntu.localdomain ([220.116.27.194])
        by smtp.gmail.com with ESMTPSA id d23sm10803092pjv.45.2020.06.21.07.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 07:31:06 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, youngjun <her0gyugyu@gmail.com>
Subject: [PATCH v2] ovl: change ovl_copy_up_flags static
Date:   Sun, 21 Jun 2020 07:30:59 -0700
Message-Id: <20200621143059.66313-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
Reply-To: CAOQ4uxgXiL1AZroRAe=mqJhuxXfv57moCdNxL7yAHuV_ONLPiw@mail.gmail.com
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

"ovl_copy_up_flags" is used in copy_up.c.
so, change it static.

Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/copy_up.c   | 2 +-
 fs/overlayfs/overlayfs.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

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
Thanks Amir.
I remove the content which is not part of this patch. 
(the message-id which I sent is wrong. so I resend it.)
