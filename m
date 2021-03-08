Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1807FC433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD216526A
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhCHPbY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:31:24 -0500
Received: from vulcan.kevinlocke.name ([107.191.43.88]:45456 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhCHPay (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Mar 2021 10:30:54 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2021 10:30:54 EST
Received: from kevinolos.kevinlocke.name (2600-6c67-5000-3d1b-0401-7aea-fa23-6d7b.res6.spectrum.com [IPv6:2600:6c67:5000:3d1b:401:7aea:fa23:6d7b])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id C42D92102675;
        Mon,  8 Mar 2021 15:23:28 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
        id 86E3C1300159; Mon,  8 Mar 2021 08:23:26 -0700 (MST)
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: add xino to "changes to underlying fs" docs
Date:   Mon,  8 Mar 2021 08:23:16 -0700
Message-Id: <b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <CAOQ4uxj4zNHU49Q6JeUrw4dvgRBumzhtvGXpuG4WDEi5G7uyxw@mail.gmail.com>
References: <CAOQ4uxj4zNHU49Q6JeUrw4dvgRBumzhtvGXpuG4WDEi5G7uyxw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add "xino" to the list of features which cause undefined behavior for
offline changes to the lower tree in the "Changes to underlying
filesystems" section of the documentation to make users aware of
potential issues if the lower tree is modified and xino was enabled.

This omission was noticed by Amir Goldstein, who mentioned that xino is
one of the "forbidden" features for making offline changes to the lower
tree and that it wasn't currently documented.

Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
---
 Documentation/filesystems/overlayfs.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 78240e29b0bb..52d47bed9ef8 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -476,9 +476,9 @@ a crash or deadlock.
 
 Offline changes, when the overlay is not mounted, are allowed to the
 upper tree.  Offline changes to the lower tree are only allowed if the
-"metadata only copy up", "inode index", and "redirect_dir" features
-have not been used.  If the lower tree is modified and any of these
-features has been used, the behavior of the overlay is undefined,
+"metadata only copy up", "inode index", "redirect_dir", and "xino"
+features have not been used.  If the lower tree is modified and any of
+these features has been used, the behavior of the overlay is undefined,
 though it will not result in a crash or deadlock.
 
 When the overlay NFS export feature is enabled, overlay filesystems
-- 
2.30.1

