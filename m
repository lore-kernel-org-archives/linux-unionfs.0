Return-Path: <SRS0=etKX=CB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A34C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 02:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E264C206C0
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 02:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgHWCOf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 22:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHWCOb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 22 Aug 2020 22:14:31 -0400
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD98C061573
        for <linux-unionfs@vger.kernel.org>; Sat, 22 Aug 2020 19:14:31 -0700 (PDT)
Received: from kevinlocke.name (2600-6c67-5080-46fc-f2e4-73e2-fe35-4565.res6.spectrum.com [IPv6:2600:6c67:5080:46fc:f2e4:73e2:fe35:4565])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id B3DDC1B9E373;
        Sun, 23 Aug 2020 02:14:25 +0000 (UTC)
Received: by kevinlocke.name (Postfix, from userid 1000)
        id 9D3AB130056E; Sat, 22 Aug 2020 20:14:22 -0600 (MDT)
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: warn about orphan metacopy
Date:   Sat, 22 Aug 2020 20:14:22 -0600
Message-Id: <137e14ca5f75179d23ee2b6408201ae022c88191.1598148862.git.kevin@kevinlocke.name>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When the lower file of a metacopy is inaccessible, -EIO is returned.
For users not familiar with overlayfs internals, such as myself, the
meaning of this error may not be apparent or easy to determine, since
the (metacopy) file is present and open/stat succeed when accessed
outside of the overlay.

Add a rate-limited warning for invalid metacopy to give users a hint
when investigating such errors, as discussed on linux-unionfs[0].  Use
"orphan metacopy" terminology to match "orphan index entry" in
ovl_verify_index.

[0]: https://lore.kernel.org/linux-unionfs/CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com/

Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
---
 fs/overlayfs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f7d4358db637..30e1c10800ab 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1000,6 +1000,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	 * Just make sure a corresponding data dentry has been found.
 	 */
 	if (d.metacopy || (uppermetacopy && !ctr)) {
+		pr_warn_ratelimited("orphan metacopy (%pd2)\n", dentry);
 		err = -EIO;
 		goto out_put;
 	} else if (!d.is_dir && upperdentry && !ctr && origin_path) {
-- 
2.28.0

