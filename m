Return-Path: <SRS0=ksQV=7Q=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0993C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 15:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC4E320679
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 15:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgFCPqB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 11:46:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56894 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgFCPqB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jun 2020 11:46:01 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jgVaZ-00052R-Na; Wed, 03 Jun 2020 15:45:59 +0000
From:   Colin King <colin.king@canonical.com>
To:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ovl: fix null pointer dereference on null stack pointer on error return
Date:   Wed,  3 Jun 2020 16:45:59 +0100
Message-Id: <20200603154559.140418-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two error return paths where the call to path_put is
dereferencing the null pointer 'stack'.  Fix this by avoiding the
error exit path via label 'out_err' that will lead to the path_put
calls and instead just return the error code directly.

Addresses-Coverity: ("Dereference after null check)"
Fixes: 4155c10a0309 ("ovl: clean up getting lower layers")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/overlayfs/super.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1094836f7e31..4be1b041b32c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1594,20 +1594,18 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	unsigned int i;
 	struct ovl_entry *oe;
 
-	err = -EINVAL;
 	if (!ofs->config.upperdir && numlower == 1) {
 		pr_err("at least 2 lowerdir are needed while upperdir nonexistent\n");
-		goto out_err;
+		return ERR_PTR(-EINVAL);
 	} else if (!ofs->config.upperdir && ofs->config.nfs_export &&
 		   ofs->config.redirect_follow) {
 		pr_warn("NFS export requires \"redirect_dir=nofollow\" on non-upper mount, falling back to nfs_export=off.\n");
 		ofs->config.nfs_export = false;
 	}
 
-	err = -ENOMEM;
 	stack = kcalloc(numlower, sizeof(struct path), GFP_KERNEL);
 	if (!stack)
-		goto out_err;
+		return ERR_PTR(-ENOMEM);
 
 	err = -EINVAL;
 	for (i = 0; i < numlower; i++) {
-- 
2.25.1

