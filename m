Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03A8C433E6
	for <linux-unionfs@archiver.kernel.org>; Sat, 13 Mar 2021 03:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD51564F2B
	for <linux-unionfs@archiver.kernel.org>; Sat, 13 Mar 2021 03:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhCMDcz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 22:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhCMDcp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Mar 2021 22:32:45 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407A3C061574;
        Fri, 12 Mar 2021 19:32:45 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id t5so5286896qvs.5;
        Fri, 12 Mar 2021 19:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uYcgGXRL3DFzHYcd5pyVfkjaOUVSDlvIj5tHuFRY6Cw=;
        b=e1bHxIhS9TY0sIDCbT4d9UOkI+HB8IM0R0ra7D1m/4Ive1Lw5E/wB17WHvnVXSl9mY
         oz6RLEnlYCccJOQaPRP715PNqv2fl7bKC6fvxuBwMz/d6mPEHL12Kq8UshtxZ1gXIJYO
         v1tF2guoBtY5v7SbRJgGVl7rmAxoy/rBQqz8DxGjuwrotD5+29/xjl9ygZvxuKVY9Vgc
         4STReO92DtVX770JihLNi3O7xl+vZXTyvhbEqVJeRj6Hxpkl/W+Lo7SI+p3TnzLGVKXS
         8S1+JdDSqK5huhVkijl6knxj9PPduq6rSt0H6AJ3HHvSv6q7uhfvhKMwiPqK6Bq9PvGr
         0zWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uYcgGXRL3DFzHYcd5pyVfkjaOUVSDlvIj5tHuFRY6Cw=;
        b=SCJL0X49UtNHx7Tfvpm8TNipLd1/6M2BnN2lP6F45bY5iUrnYmazFE11sohk+suC4P
         9GJy4qBeFqvEx5gLNqoF4/Xbc60li02piovwkq/viXr179wKPiMFzp8C6VJebSUICDW5
         vgYE37LA3Ye0+DMINiG/HBkivzPt+gFC8MZjyQqfutKNynv6/AL4mfBlw7bCObGxlH3k
         /61Gl6DqyWDNf2DhZEdpj9xN1MpJop5EUbH7spFKzUkbyWDjbU3Cbako0Z5OOybXTiUb
         8mAmtOl4H0v3NlRNlA2UlgbzUWh/rNeE9sQqityNIaJECcqXDkztuyM9t6pyAzb6qmV3
         LH1A==
X-Gm-Message-State: AOAM532gPm7EzBSL8BssA4Z7PqGXr3B5EnEOEBQOr/yVKQWNTtQ3dfd1
        8+kiWPocWpqrU0tVApG3z4K8iXssexP0Oo/f
X-Google-Smtp-Source: ABdhPJz+Bysj1+7bP2KL8nOJaSiN2S4llcMl1rbwXAyJFTIR9u5zO/j0s2N1lzd1m0JIpJpUxwx8SQ==
X-Received: by 2002:a05:6214:15d1:: with SMTP id p17mr1261475qvz.28.1615606364376;
        Fri, 12 Mar 2021 19:32:44 -0800 (PST)
Received: from localhost.localdomain ([37.19.198.104])
        by smtp.gmail.com with ESMTPSA id v7sm5877668qkv.86.2021.03.12.19.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 19:32:43 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] fs: overlayfs: Trivial typo fixes in the file inode.c
Date:   Sat, 13 Mar 2021 09:00:23 +0530
Message-Id: <20210313033023.28411-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org


s/peresistent/persistent/
s/xatts/xattrs/  ---> this is a filesystem attribute, so, it spell like this.
s/annotaion/annotation/


Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Note: The second change has nothing to do with dictionary words.

 fs/overlayfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d739e14c6814..e5588fc90a7d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -114,7 +114,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 		 * high xinobits, so we use high xinobits to partition the
 		 * overlay st_ino address space. The high bits holds the fsid
 		 * (upper fsid is 0). The lowest xinobit is reserved for mapping
-		 * the non-peresistent inode numbers range in case of overflow.
+		 * the non-persistent inode numbers range in case of overflow.
 		 * This way all overlay inode numbers are unique and use the
 		 * overlay st_dev.
 		 */
@@ -403,7 +403,7 @@ static bool ovl_can_list(struct super_block *sb, const char *s)
 	if (ovl_is_private_xattr(sb, s))
 		return false;

-	/* List all non-trusted xatts */
+	/* List all non-trusted xattrs */
 	if (strncmp(s, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) != 0)
 		return true;

@@ -533,7 +533,7 @@ static const struct address_space_operations ovl_aops = {
  * stackable i_mutex locks according to stack level of the super
  * block instance. An overlayfs instance can never be in stack
  * depth 0 (there is always a real fs below it).  An overlayfs
- * inode lock will use the lockdep annotaion ovl_i_mutex_key[depth].
+ * inode lock will use the lockdep annotation ovl_i_mutex_key[depth].
  *
  * For example, here is a snip from /proc/lockdep_chains after
  * dir_iterate of nested overlayfs:
--
2.26.2

