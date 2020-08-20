Return-Path: <SRS0=pkCU=B6=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F271C433E3
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Aug 2020 17:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74A71208B3
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Aug 2020 17:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbgHTRef (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 13:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730648AbgHTRe0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Aug 2020 13:34:26 -0400
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990C2C061385
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Aug 2020 10:34:23 -0700 (PDT)
Received: from kevinolos (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id E8CD61B8FD0F;
        Thu, 20 Aug 2020 17:34:13 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id 9F06313037BF; Thu, 20 Aug 2020 11:34:11 -0600 (MDT)
From:   Kevin Locke <kevin@kevinlocke.name>
To:     linux-unionfs@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] ovl: document lower modification caveats
Date:   Thu, 20 Aug 2020 11:34:11 -0600
Message-Id: <82b537e0ca5fa38b492413bd665c0198e6761015.1597944769.git.kevin@kevinlocke.name>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Some overlayfs optional features are incompatible with offline changes
to the lower tree[1][2][3] and may result in -EXDEV[4], -EIO[5], or
other errors.  Such modification is not supported and the error behavior
is intentionally not specified.

Update the "Changes to underlying filesystems" section to note this
restriction.  Move the paragraph describing the offline behavior below
the online behavior so it is adjacent to the following 3 paragraphs
describing the NFS export offline modification behavior.

[1]: https://lore.kernel.org/linux-unionfs/20200708142353.GA103536@redhat.com/
[2]: https://lore.kernel.org/linux-unionfs/CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com/
[3]: https://lore.kernel.org/linux-unionfs/20200817135651.GA637139@redhat.com/
[4]: https://lore.kernel.org/linux-unionfs/20200709153616.GE150543@redhat.com/
[5]: https://lore.kernel.org/linux-unionfs/20200812135529.GA122370@kevinolos/

Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
---

This patch is based on the overlayfs-devel branch of
https://github.com/amir73il/linux.git  If there is a more suitable base,
let me know and I'll rebase the next version.

It appears that Vivek's patch[4] has not been applied and serves a
similar purpose to this patch, although it applies to a different
section of the docs.  I'd be happy to collaborate on a combined patch,
if there's any interest/need.

This patch does not mention nfs_export being incompatible with offline
changes to lower, since the following 3 paragraphs specify the behavior
(IIUC).  If the behavior of offline modification with nfs_export is
undefined, should these paragraphs be removed?

Thanks for considering,
Kevin

 Documentation/filesystems/overlayfs.rst | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index fcda5d6ba9ac..9b39374afdbd 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -467,14 +467,18 @@ summarized in the `Inode properties`_ table above.
 Changes to underlying filesystems
 ---------------------------------
 
-Offline changes, when the overlay is not mounted, are allowed to either
-the upper or the lower trees.
-
 Changes to the underlying filesystems while part of a mounted overlay
 filesystem are not allowed.  If the underlying filesystem is changed,
 the behavior of the overlay is undefined, though it will not result in
 a crash or deadlock.
 
+Offline changes, when the overlay is not mounted, are allowed to the
+upper tree.  Offline changes to the lower tree are only allowed if the
+"metadata only copy up", "inode index", and "redirect_dir" features
+have not been used.  If the lower tree is modified and any of these
+features has been used, the behavior of the overlay is undefined,
+though it will not result in a crash or deadlock.
+
 When the overlay NFS export feature is enabled, overlay filesystems
 behavior on offline changes of the underlying lower layer is different
 than the behavior when NFS export is disabled.
-- 
2.28.0

