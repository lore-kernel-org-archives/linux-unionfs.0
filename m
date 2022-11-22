Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93668C433FE
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Nov 2022 02:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiKVCRS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 21:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiKVCQi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2022 21:16:38 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C257E6372
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:11 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id l193-20020a2525ca000000b006ee927786d6so378553ybl.14
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vP4dk37Xutp/zfeNLDJTOudpRYQEN0iw5Uyo2Mo/Ols=;
        b=DY/+xVmpzHQ3WvEhCX7ieUerHnSB5Lpd6FMaZi6jH6pOfb5qnq5SVm2kzYA7oUL/nw
         WO9LLKurB78pQ87qElgkNJZ7ImFLGJB6Yh+edXbaQDZNC2NdhxOLAIXfA1Vcf2LkB58P
         Qn1iFXabi4oOuviuNqWNZGySxV5cfswF7VqpPyA+R3g+3OCV4lvTpIgjkXFytSdsz+LW
         MHnhROSy/7ZBDK9u9g04Gvn/e5l8NapW2aA0nEHFDnH3IO7QGeHiN/jCcm6kCn72+7Dj
         JjGtw49yT4bnRddNuuZ4Zgv7DSxrlKLXNb/0Ajf19HiN91NjSd8wXrF0iKLI8LWWc/iQ
         1Nzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vP4dk37Xutp/zfeNLDJTOudpRYQEN0iw5Uyo2Mo/Ols=;
        b=Xus2tptYEEU3H+rm/0gIWXK39kCmCb2XUoJbYMheAez+B+MdWu+CmJNdXf4ISB+ojb
         hDXiBQXvVXkjI3Iywxce01w7kCOFPDP3IZ4Ql04uf8Vn9OHro3ZUFodA3WvNq7VCdyR3
         V9ow+RdNpGtLr8ihkPtCyJqSBCODSbro6E3QJmTdnI68R+L32P25VTJOzTfJMeNXkWm6
         BxjDdYK5YYBd3Btft8ZLh/H3rRaOAvISrliiBQrs028IfmAXSP8tvavmDuIIKSQwtgZD
         cDo8LxZ1eaBectqQCcrVR+y+/2YTRCk61KGRdE7y23UDPPt6Er+vqxY+P7tEkfrCgny2
         7W2Q==
X-Gm-Message-State: ANoB5pmmg51d+ajx49R1JXHiRKH0sGwLagL23deJPP6r0QB7vtbOryMA
        yF5aCcywoiNE5uCDI3SIKXh/wHWRO1c=
X-Google-Smtp-Source: AA0mqf476G/R0CUwNiLHlfAwn4G2ioKB+vHzTZxkW/54/ZyJ3M6Rw1N3J+sdZB5SEx/PmuNCUZHD3uiftQc=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:200:8539:aadd:13be:6e82])
 (user=drosen job=sendgmr) by 2002:a25:eb04:0:b0:6cf:e761:41ed with SMTP id
 d4-20020a25eb04000000b006cfe76141edmr3734311ybs.82.1669083370436; Mon, 21 Nov
 2022 18:16:10 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:15:22 -0800
In-Reply-To: <20221122021536.1629178-1-drosen@google.com>
Mime-Version: 1.0
References: <20221122021536.1629178-1-drosen@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122021536.1629178-8-drosen@google.com>
Subject: [RFC PATCH v2 07/21] fuse-bpf: Add support for FUSE_ACCESS
From:   Daniel Rosenberg <drosen@google.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@android.com,
        Daniel Rosenberg <drosen@google.com>,
        Paul Lawrence <paullawrence@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/backing.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dir.c     |  6 ++++++
 fs/fuse/fuse_i.h  |  6 ++++++
 3 files changed, 57 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 5a59a8963d52..670e82d68e36 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -390,3 +390,48 @@ int fuse_revalidate_backing(struct dentry *entry, unsigned int flags)
 		return backing_entry->d_op->d_revalidate(backing_entry, flags);
 	return 1;
 }
+
+static int fuse_access_initialize_in(struct fuse_args *fa, struct fuse_access_in *fai,
+				     struct inode *inode, int mask)
+{
+	*fai = (struct fuse_access_in) {
+		.mask = mask,
+	};
+
+	*fa = (struct fuse_args) {
+		.opcode = FUSE_ACCESS,
+		.nodeid = get_node_id(inode),
+		.in_numargs = 1,
+		.in_args[0].size = sizeof(*fai),
+		.in_args[0].value = fai,
+	};
+
+	return 0;
+}
+
+static int fuse_access_initialize_out(struct fuse_args *fa, struct fuse_access_in *fai,
+				      struct inode *inode, int mask)
+{
+	return 0;
+}
+
+static int fuse_access_backing(struct fuse_args *fa, int *out, struct inode *inode, int mask)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	const struct fuse_access_in *fai = fa->in_args[0].value;
+
+	*out = inode_permission(&init_user_ns, fi->backing_inode, fai->mask);
+	return 0;
+}
+
+static int fuse_access_finalize(struct fuse_args *fa, int *out, struct inode *inode, int mask)
+{
+	return 0;
+}
+
+int fuse_bpf_access(int *out, struct inode *inode, int mask)
+{
+	return fuse_bpf_backing(inode, struct fuse_access_in, out,
+				fuse_access_initialize_in, fuse_access_initialize_out,
+				fuse_access_backing, fuse_access_finalize, inode, mask);
+}
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index fb7c6988f0d9..4e19320889ed 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1364,6 +1364,9 @@ static int fuse_access(struct inode *inode, int mask)
 	struct fuse_access_in inarg;
 	int err;
 
+	if (fuse_bpf_access(&err, inode, mask))
+		return err;
+
 	BUG_ON(mask & MAY_NOT_BLOCK);
 
 	if (fm->fc->no_access)
@@ -1420,6 +1423,9 @@ static int fuse_permission(struct user_namespace *mnt_userns,
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
+	if (fuse_bpf_access(&err, inode, mask))
+		return err;
+
 	/*
 	 * If attributes are needed, refresh them before proceeding
 	 */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 3452530aba94..db3f703c700f 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1401,6 +1401,7 @@ int parse_fuse_bpf_entry(struct fuse_bpf_entry *fbe, int num_entries);
 #ifdef CONFIG_FUSE_BPF
 
 int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct dentry *entry, unsigned int flags);
+int fuse_bpf_access(int *out, struct inode *inode, int mask);
 
 #else
 
@@ -1409,6 +1410,11 @@ static inline int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct
 	return 0;
 }
 
+static inline int fuse_bpf_access(int *out, struct inode *inode, int mask)
+{
+	return 0;
+}
+
 #endif // CONFIG_FUSE_BPF
 
 int fuse_handle_backing(struct fuse_bpf_entry *feb, struct path *backing_path);
-- 
2.38.1.584.g0f3c55d4c2-goog

