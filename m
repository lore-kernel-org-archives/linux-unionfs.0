Return-Path: <SRS0=zl3V=D5=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CE6C55179
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Oct 2020 13:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABFEA24178
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Oct 2020 13:17:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=android.com header.i=@android.com header.b="JLICfTM8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899450AbgJVNR3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 09:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899445AbgJVNR3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Oct 2020 09:17:29 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F5FC0613D2
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Oct 2020 06:17:29 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id e7so1102345pfn.12
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Oct 2020 06:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=95EtoPtq6IhF7jVfCLm2ubW0zmAlnuViyd/yfLI6I2Q=;
        b=JLICfTM8wkAkoeu/9wJXsAVQVwcIq/0L2dvY2w5FMuiWxtn/7vLcfJGTDShfA/20bI
         HqHj4WAUsBH6VEzGO2V/cXYVgMk8OYYYJw/fsqivUasRB9On2wnATVnNPC4enZQc0vcx
         56l3i0xS7vzwIjdVptJkXjzGRpPJRU2bWXOUbhVUmXx/3rhaEeGFmyGuNdQZwsHU45LI
         yYNh8DHBYn29Iy07IOgOfSb1j9JEGjBM9RlqNRmt/tp8/Fze+shK8j+6Fq5D6VbfVZyX
         JoZaXMFo5GhVxRg6/yC3wEbfB5MkMMYioHv2WfCLSgzd1kHCZdLrZIsoe7uBgj3BLsYG
         5ZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=95EtoPtq6IhF7jVfCLm2ubW0zmAlnuViyd/yfLI6I2Q=;
        b=bKOQ6apRX6Wav6TUEQtJk+DMzu5Y8UHirnIEGT6CGhCYKNzdNC5MVfPuThV5A9Ff8W
         To3ZI9yDxH6k+6OurAkk2qAjp8aKMxe+LZ7GrqmZcJSDS3PCluLBbksYaryVkMdDiGxR
         /DmMiqNnMjMTk7m0VvGtPaOfB12OseQenTXPSxCrAKV9f9M9s2/VgY4nPPjyOeERwxaW
         ELasOoja64lWYNE+CrZuKr1BxD/6shp2bMbVC7V3itIURF3xpxEEDNGp3Gvk0qclpn9d
         1xk5cQo4z6gFxTIIAN933BMLlMIpJY09jHxvAsO6mm2woh5k9t9twaXTLGOVtXBzFUHr
         kDWw==
X-Gm-Message-State: AOAM532114IK16BwJib2My8Y+VzjzfyOJJT50IEjr0fZ5Mq01JMD84Ly
        SvPQ6tWTuwlYlbjugLGjRanFhA==
X-Google-Smtp-Source: ABdhPJyHdppZW0RFvvl0AaAOkc4OPMxfBBSE8nQVLbXo+W5/x+U7rzJWGVU+dyLXQv0nbYMASfK12A==
X-Received: by 2002:a63:4d45:: with SMTP id n5mr2073942pgl.389.1603372648926;
        Thu, 22 Oct 2020 06:17:28 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:4a0f:cfff:fe35:d61b])
        by smtp.gmail.com with ESMTPSA id e2sm1400401pgd.27.2020.10.22.06.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 06:17:27 -0700 (PDT)
From:   Mark Salyzyn <salyzyn@android.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, John Stultz <john.stultz@linaro.org>,
        Mark Salyzyn <salyzyn@android.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [RESEND PATCH v18 4/4] overlayfs: inode_owner_or_capable called during execv
Date:   Thu, 22 Oct 2020 06:16:52 -0700
Message-Id: <20201022131652.2784152-1-salyzyn@android.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

Using old_creds as an indication that we are not overriding the
credentials, bypass call to inode_owner_or_capable.  This solves
a problem with all execv calls being blocked when using the caller's
credentials.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Fixes: 05acefb4872da ("ovl: check permission to open real file")
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-team@android.com
Cc: selinux@vger.kernel.org

v18 - rebase

v17 - rebase

v16 - introduced fix over rebased series
---
 fs/overlayfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index b1357bb067d9..9ab9663b02d8 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -53,7 +53,7 @@ static struct file *ovl_open_realfile(const struct file *file,
 	err = inode_permission(realinode, MAY_OPEN | acc_mode);
 	if (err) {
 		realfile = ERR_PTR(err);
-	} else if (!inode_owner_or_capable(realinode)) {
+	} else if (old_cred && !inode_owner_or_capable(realinode)) {
 		realfile = ERR_PTR(-EPERM);
 	} else {
 		realfile = open_with_fake_path(&file->f_path, flags, realinode,
-- 
2.29.0.rc1.297.gfa9743e501-goog

