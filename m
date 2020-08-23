Return-Path: <SRS0=etKX=CB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2C6C433E1
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 02:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BA252078D
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 02:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHWCXA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 22:23:00 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:33664 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgHWCXA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 22 Aug 2020 22:23:00 -0400
Received: from kevinlocke.name (2600-6c67-5080-46fc-f2e4-73e2-fe35-4565.res6.spectrum.com [IPv6:2600:6c67:5080:46fc:f2e4:73e2:fe35:4565])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 3F9961B9E37C;
        Sun, 23 Aug 2020 02:22:59 +0000 (UTC)
Received: by kevinlocke.name (Postfix, from userid 1000)
        id 43B43130056E; Sat, 22 Aug 2020 20:22:57 -0600 (MDT)
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2] ovl: document lower modification caveats
Date:   Sat, 22 Aug 2020 20:22:57 -0600
Message-Id: <fe78446e6565cda29cc2c87f3e3c1b2a16f5d5cc.1598149357.git.kevin@kevinlocke.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <82b537e0ca5fa38b492413bd665c0198e6761015.1597944769.git.kevin@kevinlocke.name>
References: <82b537e0ca5fa38b492413bd665c0198e6761015.1597944769.git.kevin@kevinlocke.name>
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

Changes since v1:
- Actually send to the maintainer this time.
  (Sorry Miklos Szeredi, not sure what I was thinking on v1!)
- Rebase onto overlayfs-next of
  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git

As mentioned with v1, I'm still open to collaborating on a combined
patch if there is still interest in including Vivek's changes to the
"Sharing and copying layers" section.

This patch does not mention nfs_export being incompatible with offline
changes to lower, since the following 3 paragraphs specify the behavior
(IIUC).  If the behavior of offline modification with nfs_export is
undefined, should these paragraphs be removed?

Thanks for considering (again),
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

