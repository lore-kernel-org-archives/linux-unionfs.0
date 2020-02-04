Return-Path: <SRS0=9nie=3Y=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1E8C35247
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 18:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CEE82084E
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 18:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgBDSuE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 13:50:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32788 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgBDSuD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Feb 2020 13:50:03 -0500
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <ioanna-maria.alifieraki@canonical.com>)
        id 1iz3Gr-00051W-Qt
        for linux-unionfs@vger.kernel.org; Tue, 04 Feb 2020 18:50:01 +0000
Received: by mail-wm1-f72.google.com with SMTP id s25so1859617wmj.3
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Feb 2020 10:50:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=wqNJjW0961V0F/Hsv7qunFjB3mjgTIfFca5lKHl9ZDc=;
        b=YXPRZP2QEVL7uE4lnwoP7LyU0UWf0Dw9MoZGEceI9eFlqNJqXBNVslpvXnt78MmRr0
         0rVl1AFGafD1tVMtZ4tb4kYamqrSY3rK9fOvX5R20eMVdhmRsRxLuu4GImYMUdSw6l9A
         1gzjDokfhVgNo23E/BOKptXWfJGBtOlNBWKm3mekg/ZvPjlm8ujhkSFrU4vSWaHkaY9T
         3qfTRBGOwG+ahKuVO9emc362clnH0vPHaDT+YaclPXm2k1ngP3aLqAKlYln1pX0SGQQi
         3uTm/CoiPNwM0g8CUNA6fuOV0C6gJx7ngfRBUU+Q1daQa2Wnvx6yBHfL5JA8cPQMMZsX
         q3LA==
X-Gm-Message-State: APjAAAXwsww6bfMfTrow196day7gln2H/9ze8yufBTNSgDh0VeAiZ7KC
        DiCh/Q1VtRzckL+RS65fj2IYcEdi1/P0LPXAS7NoqyukCrKU2K102TSB+nkKOZzSOfMrSffJ2tj
        kurpgyQf4I3PEKKoSaZfKQNZCd6DT00hltVT5XfXHO5k=
X-Received: by 2002:a1c:4144:: with SMTP id o65mr366351wma.81.1580842201477;
        Tue, 04 Feb 2020 10:50:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqzRFe+hJeL5rST0hSaPR4ib64GGHXk5+nrGpO0tQaud4j5+He+r93rqdEj/r9gqdbdAPTBb0A==
X-Received: by 2002:a1c:4144:: with SMTP id o65mr366332wma.81.1580842201208;
        Tue, 04 Feb 2020 10:50:01 -0800 (PST)
Received: from localhost ([2a02:587:2808:4200:3c88:b258:f61b:eab3])
        by smtp.gmail.com with ESMTPSA id z11sm30520937wrv.96.2020.02.04.10.50.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Feb 2020 10:50:00 -0800 (PST)
From:   Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
To:     ioanna.alifieraki@gmail.com, jay.vosburgh@canonical.com,
        miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, srivatsa@csail.mit.edu
Subject: [4.4.y PATCH] Revert "ovl: modify ovl_permission() to do checks on two inodes"
Date:   Tue,  4 Feb 2020 18:49:58 +0000
Message-Id: <20200204184958.6586-1-ioanna-maria.alifieraki@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This reverts commit b24be4acd17a8963a29b2a92e1d80b9ddf759c95.

Commit b24be4acd17a ("ovl: modify ovl_permission() to do checks on two
inodes") (stable kernel  id) breaks r/w access in overlayfs when setting
ACL to files, in 4.4 stable kernel. There is an available reproducer in
[1].

To reproduce the issue :
$./make-overlay.sh
$./test.sh
st_mode is 100644
open failed: -1
cat: /tmp/overlay/animal: Permission denied <---- Breaks access
-rw-r--r-- 1 jo jo 0 Oct 11 09:57 /tmp/overlay/animal

There are two options to fix this; (a) backport commit ce31513a9114
("ovl: copyattr after setting POSIX ACL") to 4.4 or (b) revert offending
commit b24be4acd17a ("ovl: modify ovl_permission() to do checks on two
inodes"). Following option (a) entails high risk of regression since
commit ce31513a9114 ("ovl: copyattr after setting POSIX ACL") has many
dependencies on other commits that need to be backported too (~18
commits).

This patch proceeds with reverting commit b24be4acd17a ("ovl: modify
ovl_permission() to do checks on two inodes").  The reverted commit is
associated with CVE-2018-16597, however the test-script provided in [3]
shows that 4.4 kernel is  NOT affected by this cve and therefore it's
safe to revert it.

The offending commit was introduced upstream in v4.8-rc1. At this point
had nothing to do with any CVE.  It was related with CVE-2018-16597 as
it was the fix for bug [2]. Later on it was backported to stable 4.4.

The test-script [3] tests whether 4.4 kernel is affected by
CVE-2018-16597. It tests the reproducer found in [2] plus a few more
cases. The correct output of the script is failure with "Permission
denied" when a normal user tries to overwrite root owned files.  For
more details please refer to [4].

[1] https://gist.github.com/thomas-holmes/711bcdb28e2b8e6d1c39c1d99d292af7
[2] https://bugzilla.suse.com/show_bug.cgi?id=1106512#c0
[3] https://launchpadlibrarian.net/459694705/test_overlay_permission.sh
[4] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1851243

Signed-off-by: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
---
 fs/overlayfs/inode.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 060482e349ef..013d27dc6f58 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -9,7 +9,6 @@
 
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <linux/cred.h>
 #include <linux/xattr.h>
 #include "overlayfs.h"
 
@@ -92,7 +91,6 @@ int ovl_permission(struct inode *inode, int mask)
 	struct ovl_entry *oe;
 	struct dentry *alias = NULL;
 	struct inode *realinode;
-	const struct cred *old_cred;
 	struct dentry *realdentry;
 	bool is_upper;
 	int err;
@@ -145,18 +143,7 @@ int ovl_permission(struct inode *inode, int mask)
 			goto out_dput;
 	}
 
-	/*
-	 * Check overlay inode with the creds of task and underlying inode
-	 * with creds of mounter
-	 */
-	err = generic_permission(inode, mask);
-	if (err)
-		goto out_dput;
-
-	old_cred = ovl_override_creds(inode->i_sb);
 	err = __inode_permission(realinode, mask);
-	revert_creds(old_cred);
-
 out_dput:
 	dput(alias);
 	return err;
-- 
2.17.1

