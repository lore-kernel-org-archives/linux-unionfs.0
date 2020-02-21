Return-Path: <SRS0=Fd6Y=4J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB36C35657
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5238824650
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fZ/xePkc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgBUOfD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:35:03 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42964 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgBUOfD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:35:03 -0500
Received: by mail-wr1-f65.google.com with SMTP id k11so2310684wrd.9
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Feb 2020 06:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ix94ljPSP1gKMM/0Amlxq25P59WPQDQRLFYqw5AELe8=;
        b=fZ/xePkcRTG+qnXpc4W9fxQqjAml/6Ph+NLQBKSCWDK9siv6xzUrEEi5lenMZCVnws
         TwjdLJzj44AVQaE0nFg8mLZvZqEXb2tLv3ddKGctevDB4v0GpzVJI2K9EBvq//h94RCC
         q0xjGl8VY4DReeSrrcZDgiQ/IqF9e2a7or0EX4/fR4DNNakMaV3UvcTdlS2bj4XBl0N9
         mHPpaOps4Uogmy9enCMjvV7qC0ikNiC/LBz3iP/HFODv44B8n2uyR20/hFnJVdWGdtQQ
         11zFohOKsX+HwFnchxiF541ZlefA+Zcu/JKRrbuHyQXNMSTZy0NDA5u64UCysH9zJ7c2
         orNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ix94ljPSP1gKMM/0Amlxq25P59WPQDQRLFYqw5AELe8=;
        b=T7vlNUvfZnksC0bB0sF4U0ykw5xBMdAoLXyxuGM9QmLQkQ7fwXuPjlj9keozB7nJpa
         occCXXGs4CF7b1UabLyIiz86YMXbjRb+UItNECXCunTTRRg4fdqXDw6dtmpigyMWtdWW
         xiNLT9vdVEdhYvAOyzZpvbWBArMO8u/Ow0D7YmGCrTKSUnNKAgNjJK1GwiyERoujlYWx
         lL/ujo2EA3pp71LrfK//cqldZiIF8jZpQxDiBOlkYjKZvxvhIg2SOAg6ctqD2YhcYHS8
         htnQ5pXg3dCCv76n+D6JeOuwO28FFeTaoSjYcReZlU5hiiUmtRyXhyqwcDMBWmoWDiUD
         V4HQ==
X-Gm-Message-State: APjAAAXHJsg/uNpiotC4+N1AzlosWlRJHGqA8Ll8CRqbAj5jhTmH2AHn
        mAynbrSloz08mrqXHSF3MIw9mLJY
X-Google-Smtp-Source: APXvYqzXPDk4G7cXt245FXjFHmhOX5xh7Sgrb3iDq4rEYIk4khzy4VTwImYxxZ7Awj1pvm4UDBhf6w==
X-Received: by 2002:adf:e5c4:: with SMTP id a4mr51985164wrn.292.1582295700613;
        Fri, 21 Feb 2020 06:35:00 -0800 (PST)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id a184sm4109014wmf.29.2020.02.21.06.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:35:00 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v2 5/5] ovl: document xino expected behavior
Date:   Fri, 21 Feb 2020 16:34:46 +0200
Message-Id: <20200221143446.9099-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221143446.9099-1-amir73il@gmail.com>
References: <20200221143446.9099-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Summarize the inode properties of different configurations in a table.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 38 +++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index e398fdf7353e..c9d2bf96b02d 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -40,13 +40,46 @@ On 64bit systems, even if all overlay layers are not on the same
 underlying filesystem, the same compliant behavior could be achieved
 with the "xino" feature.  The "xino" feature composes a unique object
 identifier from the real object st_ino and an underlying fsid index.
+
 If all underlying filesystems support NFS file handles and export file
 handles with 32bit inode number encoding (e.g. ext4), overlay filesystem
 will use the high inode number bits for fsid.  Even when the underlying
 filesystem uses 64bit inode numbers, users can still enable the "xino"
 feature with the "-o xino=on" overlay mount option.  That is useful for the
 case of underlying filesystems like xfs and tmpfs, which use 64bit inode
-numbers, but are very unlikely to use the high inode number bit.
+numbers, but are very unlikely to use the high inode number bits.  In case
+the underlying inode number does overflow into the high xino bits, overlay
+filesystem will fall back to the non xino behavior for that inode.
+
+The following table summarizes what can be expected in different overlay
+configurations.
+
+Inode properties
+````````````````
+
++--------------+------------+------------+-----------------+----------------+
+|Configuration | Persistent | Uniform    | st_ino == d_ino | d_ino == i_ino |
+|              | st_ino     | st_dev     |                 | [*]            |
++==============+=====+======+=====+======+========+========+========+=======+
+|              | dir | !dir | dir | !dir |  dir   +  !dir  |  dir   | !dir  |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+| All layers   |  Y  |  Y   |  Y  |  Y   |  Y     |   Y    |  Y     |  Y    |
+| on same fs   |     |      |     |      |        |        |        |       |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+| Layers not   |  N  |  Y   |  Y  |  N   |  N     |   Y    |  N     |  Y    |
+| on same fs,  |     |      |     |      |        |        |        |       |
+| xino=off     |     |      |     |      |        |        |        |       |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+| xino=on/auto |  Y  |  Y   |  Y  |  Y   |  Y     |   Y    |  Y     |  Y    |
+|              |     |      |     |      |        |        |        |       |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+| xino=on/auto,|  N  |  Y   |  Y  |  N   |  N     |   Y    |  N     |  Y    |
+| ino overflow |     |      |     |      |        |        |        |       |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+
+[*] nfsd v3 readdirplus verifies d_ino == i_ino. i_ino is exposed via several
+/proc files, such as /proc/locks and /proc/self/fdinfo/<fd> of an inotify
+file descriptor.
 
 
 Upper and Lower
@@ -427,7 +460,8 @@ guarantee that the values of st_ino and st_dev returned by stat(2) and the
 value of d_ino returned by readdir(3) will act like on a normal filesystem.
 E.g. the value of st_dev may be different for two objects in the same
 overlay filesystem and the value of st_ino for directory objects may not be
-persistent and could change even while the overlay filesystem is mounted.
+persistent and could change even while the overlay filesystem is mounted, as
+summarized in the `Inode properties`_ table above.
 
 
 Changes to underlying filesystems
-- 
2.17.1

