Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50138C47089
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 14:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BC23613CA
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 14:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbhE0OHg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 May 2021 10:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbhE0OHg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 May 2021 10:07:36 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E2EC061574
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 07:06:02 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso2679804wmm.3
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 07:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=prgSmi6xlYgUEZwsBm+KqhS/1Sftlb7M46M1dIqrsso=;
        b=h3bMpgi5B+CMxUd2/zzNg3ucRwu81k2LprknyhGc3/HPS1W8ZOd2BXVnb2gKyiUw+j
         kYE0U7dfec7mRFefmc61KFXQmtfe6iuB1aCiUz8HP5gX3Ei+32aHo6uJIDb8suh7s3tv
         6ZbxZmidW0omaLja5UWNY6j8UsEdm0q9Q9qW0uNWdU8C/JASMWor+7aCTLCYrLRhlHIz
         u24cAjVqum61R632TEbF47JzzoY4Fr0numqAorX3Vq040zszNINIvziyImIkjQnk1Ub0
         q5KMpvrVEhBX0rvuMkBCVEP19DjVqdGkg7RHypPKUyu5uHmRnlfKf3RHJCPk3r/mW5Pa
         +rdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=prgSmi6xlYgUEZwsBm+KqhS/1Sftlb7M46M1dIqrsso=;
        b=oPzDIZigftDMoq3XwRov65PFyyIJSKHdLwXicXUwA8DK8cWdZZgRsuWKQ6e4gBn+Og
         BpCXvKZgONHkzG9Qb5Oo/Mzc6wFKNsRWFNoQzMEnr3Xxzvse7vJ5iQbj4PX0N8xy8Jj7
         cOqBcWDXrabthIBUMvv06/Fj3hGgY5HaAdBcuftXd/kI7C++3YolnyLlDZiOh8IaiF7B
         lS/WTRt5C7ozZsVDc1ZxHEGpABrcPlt9iZNvAPmfDvxVo8wlPiO23QQlBf2tGQz+CxDx
         J4ehENXLiODjcquMSKD7Hy2YObYUiFEunGHUudrtr3Ohpk1+4qeOhubvonQPjJ7KnW9C
         Xe7A==
X-Gm-Message-State: AOAM53105X/FFykMIpQ6ku+7sA0ToGyChsfBBIXVTXaV8dQYoLDviRAg
        28pzJ2/7Q8iC24HoOjSxi2M=
X-Google-Smtp-Source: ABdhPJwq1Qke9YLqM1RC4+Fh7bP0EcP0u9zCJl9/K7+nmSraVvwpTTBWbSE7y7isVKxjgVLNFNQ3kw==
X-Received: by 2002:a7b:c5d3:: with SMTP id n19mr3805207wmk.68.1622124361513;
        Thu, 27 May 2021 07:06:01 -0700 (PDT)
Received: from uvv-2004-vm.localdomain (dslb-002-205-242-053.002.205.pools.vodafone-ip.de. [2.205.242.53])
        by smtp.gmail.com with ESMTPSA id x24sm10582754wmi.13.2021.05.27.07.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 07:06:01 -0700 (PDT)
From:   Vyacheslav Yurkov <uvv.mail@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Subject: [PATCH v2 1/3] ovl: disable uuid when redirect_dir is used
Date:   Thu, 27 May 2021 16:05:32 +0200
Message-Id: <20210527140534.107607-1-uvv.mail@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>

Currently decoding origin with lower null uuid is not allowed when user
opted-in to one of the new features that require following the lower inode
of non-dir upper (index, xino, metacopy). Now we add redirect_dir too to
that feature list.

Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b01d4147520d..97ea35fdd933 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1600,7 +1600,7 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	 * lower inode of non-dir upper.
 	 */
 	if (!ofs->config.index && !ofs->config.metacopy &&
-	    ofs->config.xino != OVL_XINO_ON &&
+	    !ofs->config.redirect_dir && ofs->config.xino != OVL_XINO_ON &&
 	    uuid_is_null(uuid))
 		return false;
 
-- 
2.25.1

