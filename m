Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1637BE95A86
	for <linux-unionfs@archiver.kernel.org>; Sun,  8 Oct 2023 01:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344353AbjJHBRY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 7 Oct 2023 21:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbjJHBRQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 7 Oct 2023 21:17:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E38324B;
        Sat,  7 Oct 2023 17:52:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C376C433CA;
        Sun,  8 Oct 2023 00:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696726261;
        bh=5S6PWwmnWqAqP87ZXSDEPMhL8crr2ofG0BuY0uFxLvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1gq54MsJ3dYzc+qhMZ27fPODPWBxpIS9gxF6YCiQPh5Tr76OQzfNHUwcjwmPQXcQ
         TmxejxgW8AOS27CMHan9nN7RJSvPgrqZf28DC2r00VVu6YEHGxXcR3RXbBNYyh4cWH
         797cW5SblI0viti2Nb5Go5ofr6LK08YKdYimMNbJnvPhWOaGXSCh3R7ANMKd99JB7V
         IgiTmf3S/lDjcXoe06TCk0kCH+p1TKOdblGVpXqdhhhXejeLu1juuaTtbeYcFB32pi
         k6NaE21YOwwsJz13ubV9RnonNu+6LbnjqKvofPr3RSMTOZTJnNTXYzko0PG03InI+F
         klwTV24mYWDfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Sasha Levin <sashal@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/7] overlayfs: set ctime when setting mtime and atime
Date:   Sat,  7 Oct 2023 20:50:50 -0400
Message-Id: <20231008005053.3768625-4-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231008005053.3768625-1-sashal@kernel.org>
References: <20231008005053.3768625-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 4.14.326
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 03dbab3bba5f009d053635c729d1244f2c8bad38 ]

Nathan reported that he was seeing the new warning in
setattr_copy_mgtime pop when starting podman containers. Overlayfs is
trying to set the atime and mtime via notify_change without also
setting the ctime.

POSIX states that when the atime and mtime are updated via utimes() that
we must also update the ctime to the current time. The situation with
overlayfs copy-up is analogies, so add ATTR_CTIME to the bitmask.
notify_change will fill in the value.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Christian Brauner <brauner@kernel.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>
Message-Id: <20230913-ctime-v1-1-c6bc509cbc27@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f3ed80e2966c3..4a5b0f3c6af34 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -201,7 +201,7 @@ static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
 {
 	struct iattr attr = {
 		.ia_valid =
-		     ATTR_ATIME | ATTR_MTIME | ATTR_ATIME_SET | ATTR_MTIME_SET,
+		     ATTR_ATIME | ATTR_MTIME | ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_CTIME,
 		.ia_atime = stat->atime,
 		.ia_mtime = stat->mtime,
 	};
-- 
2.40.1

