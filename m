Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406B4C63697
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 04:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6873E222C4
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 04:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="SbXZ7A4p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgKPE6J (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 15 Nov 2020 23:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKPE6I (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Nov 2020 23:58:08 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73ACC0613D1
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2020 20:58:07 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q10so13025328pfn.0
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2020 20:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ztFiUedUTg5J0aZhxtXkB0phLulrQA7s3Fbdqug+y0=;
        b=SbXZ7A4pi/U4Y/V4yRmC+emnIOamVUyOGqmbpdqs+2We9Sli/YF7LoNhnAw6bJ7niO
         gAJZTULXAAWBt/dxaJj4NYmilGniGWAilGvmNyaCEtqSOWYArkJMSHpnbQsEN4J1gM28
         D8RV0z0EvXSR6tcbV6qxczx7wZU3bN8DNpbsg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ztFiUedUTg5J0aZhxtXkB0phLulrQA7s3Fbdqug+y0=;
        b=ih4IVjIpjmxAY17/czNz9hyDfrPxLkihXWfiB0KY3Z2Eaxr5PzjUdtL6NXp/nmP4m2
         5fAHnQc1ndabierU1C1ARlNmoawSN4NBIIsniaCpq0ojaN1nSm9HiMOUPc9MBi7KtKb+
         8qOEAI4I3HOh2s5I+0pnBA1lalyMoeDz7o9hmOhuRK8XismLUMi39Aq1nsJDGmmJPK/i
         nVQHpmltINCPCvRWroyn/aZpAd/EaxKuzFarbquLk1E1ANPuyRGtVQk4iKPtlHvV5002
         qEHYXbdDGimwXlPHG11EiBow9M5cHOoIRk8XsK/vkO80HzMXgGFAyYNPN/BiTqo8dsfS
         CKeQ==
X-Gm-Message-State: AOAM531n1gQYbi1dFbxgI+IVRIAm02yVLzPazJVnPWH/ISBz2phYOFE5
        PTK6ROoRVj82lOf77Sgexv/kfE15RAADT+F2
X-Google-Smtp-Source: ABdhPJwqEND9qF0a2sitG/FvfTRXWBCTnv0Tsh4REDBK9tig6k8Z3xgcVxl2WYGd8k5m1d8iSbcrIA==
X-Received: by 2002:a63:2945:: with SMTP id p66mr11921494pgp.419.1605502686837;
        Sun, 15 Nov 2020 20:58:06 -0800 (PST)
Received: from ubuntu.netflix.com (203.20.25.136.in-addr.arpa. [136.25.20.203])
        by smtp.gmail.com with ESMTPSA id v23sm16465284pjh.46.2020.11.15.20.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 20:58:06 -0800 (PST)
From:   Sargun Dhillon <sargun@sargun.me>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 1/3] fs: Add s_instance_id field to superblock for unique identification
Date:   Sun, 15 Nov 2020 20:57:56 -0800
Message-Id: <20201116045758.21774-2-sargun@sargun.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201116045758.21774-1-sargun@sargun.me>
References: <20201116045758.21774-1-sargun@sargun.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This assigns a per-boot unique number to each superblock. This allows
other components to know whether a filesystem has been remounted
since they last interacted with it.

At every boot it is reset to 0. There is no specific reason it is set to 0,
other than repeatability versus using some random starting number. Because
of this, you must store it along some other piece of data which is
initialized at boot time.

This doesn't have any of the overhead of idr, and a u64 wont wrap any time
soon. There is no forward lookup requirement, so an idr is not needed.

In the future, we may want to expose this to userspace. Userspace programs
can benefit from this if they have large chunks of dirty or mmaped memory
that they're interacting with, and they want to see if that volume has been
unmounted, and remounted. Along with this, and a mechanism to inspect the
superblock's errseq a user can determine whether they need to throw away
their cache or similar. This is another benefit in comparison to just
using a pointer to the superblock to uniquely identify it.

Although this doesn't expose an ioctl or similar yet, in the future we
could add an ioctl that allows for fetching the s_instance_id for a given
cache, and inspection of the errseq associated with that.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
---
 fs/super.c              | 3 +++
 include/linux/fs.h      | 7 +++++++
 include/uapi/linux/fs.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 904459b35119..e47ace7f8c3d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -42,6 +42,7 @@
 
 static int thaw_super_locked(struct super_block *sb);
 
+static u64 s_instance_id_counter;
 static LIST_HEAD(super_blocks);
 static DEFINE_SPINLOCK(sb_lock);
 
@@ -546,6 +547,7 @@ struct super_block *sget_fc(struct fs_context *fc,
 	s->s_iflags |= fc->s_iflags;
 	strlcpy(s->s_id, s->s_type->name, sizeof(s->s_id));
 	list_add_tail(&s->s_list, &super_blocks);
+	s->s_instance_id = s_instance_id_counter++;
 	hlist_add_head(&s->s_instances, &s->s_type->fs_supers);
 	spin_unlock(&sb_lock);
 	get_filesystem(s->s_type);
@@ -625,6 +627,7 @@ struct super_block *sget(struct file_system_type *type,
 	s->s_type = type;
 	strlcpy(s->s_id, type->name, sizeof(s->s_id));
 	list_add_tail(&s->s_list, &super_blocks);
+	s->s_instance_id = s_instance_id_counter++;
 	hlist_add_head(&s->s_instances, &type->fs_supers);
 	spin_unlock(&sb_lock);
 	get_filesystem(type);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dbbeb52ce5f3..642847c3673f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1472,6 +1472,13 @@ struct super_block {
 	char			s_id[32];	/* Informational name */
 	uuid_t			s_uuid;		/* UUID */
 
+	/*
+	 * ID identifying this particular instance of the superblock. It can
+	 * be used to determine if a particular filesystem has been remounted.
+	 * It may be exposed to userspace.
+	 */
+	u64			s_instance_id;
+
 	unsigned int		s_max_links;
 	fmode_t			s_mode;
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index f44eb0a04afd..f2b126656c22 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -13,6 +13,7 @@
 #include <linux/limits.h>
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#include <linux/uuid.h>
 #ifndef __KERNEL__
 #include <linux/fscrypt.h>
 #endif
@@ -203,6 +204,7 @@ struct fsxattr {
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
+#define FS_IOC_GET_SB_INSTANCE		_IOR('f', 3, uuid_t)
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
 #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
 #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
-- 
2.25.1

