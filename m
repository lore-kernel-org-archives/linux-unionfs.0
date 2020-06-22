Return-Path: <SRS0=6Mas=AD=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13C8C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Jun 2020 17:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BC12073E
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Jun 2020 17:22:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o4jjIBK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgFVRWE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 13:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729605AbgFVRWE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jun 2020 13:22:04 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C62DC061573
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jun 2020 10:22:04 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id v11so8444872pgb.6
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jun 2020 10:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=brHT3l5Z6KWqc2X/y9zQwixQY2i2+88w19X3eryl6Dw=;
        b=o4jjIBK9OjyL1NhY9Xiea4AE3q1E9v9j47FJes6OQW3AS+2dDoilULZMISFmUmnZzT
         wMlhirJDButatQbW7pFDOW4S4DYWbK9d2BWzI+YkgmPs37i/0mpbNm8EJwBKOVLD4HLY
         uQCLJZ3hxSzV7NyK8pBflRZqXLSuB05UJrTd50E/Dc5qNsEwOMOWa7qSEYRvEJPyyqLy
         HbmyZncW+DhEbc4tuQSB2knbP7ahGjdl7/tpBlp/D+X2+/RPC7wcOyb/qaXKt0/UBCTv
         uXOxqb2LC0sthXTMazI1lWgTCmYqv5li6C4AGkwOQijFuHwtX6sfd58sTzfnl3r8o7mN
         KCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=brHT3l5Z6KWqc2X/y9zQwixQY2i2+88w19X3eryl6Dw=;
        b=EMVGvl9m7rXJg8ZhuDnfpDm3/hQSh6rFO5kQSApR+GiOsoSVnfbA7SS2xwxIoVN8z5
         wJQtm6w2ifVOd6WEp2lGCT5bTklwTZsZLpAFgNgR8sccO5MLYi9iaShL1uT0MznSrHQ4
         VU2CIYzO2Wzw4uFHuDG5utW/eWPKtTg7t8DmmhKlDla/ntujLTNUty0cJx6FtTFO0iHT
         rVJaByhcp/eBOUqpUzbDlUuVrLIoJUgts9ZeygEnN/5MqG6bdaiY+s6rhzlKj03Q9LqU
         Q3RV5svANPwiN9TN92F1WgbA45vOahh4LwGt19aPEXKMurfgOf9OtH+cCCge23Xqa286
         X9jQ==
X-Gm-Message-State: AOAM531aSkSmVWoFapldYtjz9eItME4LsoBVc7hc8hXMY7wcLy4rQVxC
        M7hOKbODunMe7rw+HjpiC9Y=
X-Google-Smtp-Source: ABdhPJxEpKAZ1VnZ0ZeCWcUi15F00tx9p11wdIHx36KQg8RDS9QbGGozrh3gNW5i7/B1r9kAyNBKtw==
X-Received: by 2002:a63:451c:: with SMTP id s28mr14109715pga.340.1592846523767;
        Mon, 22 Jun 2020 10:22:03 -0700 (PDT)
Received: from ubuntu.localdomain ([220.116.27.194])
        by smtp.gmail.com with ESMTPSA id i19sm138730pjz.4.2020.06.22.10.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 10:22:03 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, youngjun <her0gyugyu@gmail.com>
Subject: [PATCH] ovl: credential not reverted in ovl_copy_up_flags on error case
Date:   Mon, 22 Jun 2020 10:21:55 -0700
Message-Id: <20200622172155.73579-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In "ovl_copy_up_flags" on disconnected dir case(error case),
credential not reverted.

Fixes: aa3ff3c152ff9("ovl: copy up of disconnected dentries")
Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/copy_up.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 79dd052c7dbf..53daa54ac859 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -906,8 +906,10 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 	 * In this case, we will copy up lower inode to index dir without
 	 * linking it to upper dir.
 	 */
-	if (WARN_ON(disconnected && d_is_dir(dentry)))
+	if (WARN_ON(disconnected && d_is_dir(dentry))) {
+		revert_creds(old_cred);
 		return -EIO;
+	}
 
 	while (!err) {
 		struct dentry *next;
-- 
2.17.1

