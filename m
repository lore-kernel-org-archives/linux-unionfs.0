Return-Path: <SRS0=etKX=CB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D52DC433E1
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 14:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522A620706
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 14:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHWOi0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 10:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgHWOiZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 23 Aug 2020 10:38:25 -0400
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B40C061573
        for <linux-unionfs@vger.kernel.org>; Sun, 23 Aug 2020 07:38:25 -0700 (PDT)
Received: from kevinlocke.name (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 0105E1BA3BE6;
        Sun, 23 Aug 2020 14:38:18 +0000 (UTC)
Received: by kevinlocke.name (Postfix, from userid 1000)
        id 487721300671; Sun, 23 Aug 2020 08:38:17 -0600 (MDT)
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: warn about orphan metacopy
Date:   Sun, 23 Aug 2020 08:38:17 -0600
Message-Id: <e5f0eb2ec133c68aa0add8f792396db0239fb17b.1598193369.git.kevin@kevinlocke.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200823143043.GA14919@kevinlocke.name>
References: <20200823143043.GA14919@kevinlocke.name>
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

Add a rate-limited warning for orphan metacopy to give users a hint
when investigating such errors, as discussed on linux-unionfs[0].

[0]: https://lore.kernel.org/linux-unionfs/CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com/

Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
---

Changes since v1:
- Use message text similar to suggestion by Amir Goldstein, except that
  "upper" is removed to avoid confusion if the metacopy is on a middle
  (i.e. lower-but-not-lowest) layer.

 fs/overlayfs/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f7d4358db637..57cd048ce0af 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1000,6 +1000,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	 * Just make sure a corresponding data dentry has been found.
 	 */
 	if (d.metacopy || (uppermetacopy && !ctr)) {
+		pr_warn_ratelimited("metacopy with no lower data found - abort lookup (%pd2)\n",
+				    dentry);
 		err = -EIO;
 		goto out_put;
 	} else if (!d.is_dir && upperdentry && !ctr && origin_path) {
-- 
2.28.0

