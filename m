Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E37C43219
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Nov 2022 02:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiKVCUp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 21:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbiKVCTn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2022 21:19:43 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A14E9154
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:44 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y82-20020a253255000000b006e7a04f3824so11780247yby.19
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tJXvhRhAgfuVfe2WyHPR4tz1JKdoKAJyNeGFfWGwJfA=;
        b=qGkvx8TFpzkUW6hJpxPR4PKq3xLOu9Os7QX2lTMWCilalOFz9Xa1h5bFbtSpucKkWm
         TltFT8llXWJ7GhU2/JCvGPxUKKyf+M5vl3oAklLsvD1oxP8MTw156iiPERz5BlwYWBaw
         /Aotf3Al2u6liOXujyYy4ynyF1St9jqgbgFkLtP2NvI1Bj6udJvaG0Xmp52Kx7gzMg1Z
         adtT/ZnVZK6ZkF1A3IJqIRE5Nn89VCvBJgCK2auE41NBM56Tw2QLxlXT3TEm6s4rCvbA
         y+aBIj+GuWxJUkSGWY++ynL0CiCHeRY6X5vmgLh4cigCoA8tF6uoSbhGFr6AmKQfLhY7
         hKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tJXvhRhAgfuVfe2WyHPR4tz1JKdoKAJyNeGFfWGwJfA=;
        b=8Cs0wxh2uelWIO0Whg1ShJhhH4MdwAEYgrphMvC49DlQZjCz1QPE66MaDNBpSNW2V3
         MUob0NmzVxwUtQmwYBLloZIcs6nqLS2WsY9ti0yk4gZN0CHFDX0e3OG0QDyF78YST8Yz
         SCKO9tgRj4yU0Wypx9k0PVj1mkoGNllcqn9oLjPl6E5+kk3xc/MqUCm4meIj+usDXvof
         iOJlOpHbdBexRYLmv+JvmRLqOBdbiLORK+9tKoBQ7RyDxW6BmG68HYgXkrMNwmkKUd4p
         YPx65CxY5jrWHOWGlKaa8Fk1fbdrJaykMtPBtUzTCzDbHPsZvA46gRgZXGHRBusWRJw4
         C2Aw==
X-Gm-Message-State: ANoB5pk69QfkbIr0Hz2/nSKhIZtugYN6ZXyWlGbxCJq2tXoALIhlfySs
        H9/I/AMTcE0vq+GSnIlMgflciKDUyvE=
X-Google-Smtp-Source: AA0mqf4ig5LKUxIEPBtpsrsS6x8pF+5RIGhWCLARqw1OqEfhOKW0oTQ5XDVHBGd5PrVtKUOP4DD+H6Fg8PM=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:200:8539:aadd:13be:6e82])
 (user=drosen job=sendgmr) by 2002:a25:bd03:0:b0:6e6:9336:f565 with SMTP id
 f3-20020a25bd03000000b006e69336f565mr0ybk.598.1669083402808; Mon, 21 Nov 2022
 18:16:42 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:15:36 -0800
In-Reply-To: <20221122021536.1629178-1-drosen@google.com>
Mime-Version: 1.0
References: <20221122021536.1629178-1-drosen@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122021536.1629178-22-drosen@google.com>
Subject: [RFC PATCH v2 21/21] fuse-bpf: allow mounting with no userspace daemon
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

When using fuse-bpf in pure passthrough mode, we don't explicitly need a
userspace daemon. This allows simple testing of the backing operations.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/fuse_i.h |  4 ++++
 fs/fuse/inode.c  | 25 +++++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 99c9231ec98b..402d80d35958 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -564,6 +564,7 @@ struct fuse_fs_context {
 	bool no_control:1;
 	bool no_force_umount:1;
 	bool legacy_opts_show:1;
+	bool no_daemon:1;
 	enum fuse_dax_mode dax_mode;
 	unsigned int max_read;
 	unsigned int blksize;
@@ -842,6 +843,9 @@ struct fuse_conn {
 	/* Is tmpfile not implemented by fs? */
 	unsigned int no_tmpfile:1;
 
+	/** BPF Only, no Daemon running */
+	unsigned int no_daemon:1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1e7d45977144..4820edcc242a 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -749,6 +749,7 @@ enum {
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
 	OPT_ROOT_DIR,
+	OPT_NO_DAEMON,
 	OPT_ERR
 };
 
@@ -764,6 +765,7 @@ static const struct fs_parameter_spec fuse_fs_parameters[] = {
 	fsparam_u32	("blksize",		OPT_BLKSIZE),
 	fsparam_string	("subtype",		OPT_SUBTYPE),
 	fsparam_u32	("root_dir",		OPT_ROOT_DIR),
+	fsparam_flag	("no_daemon",		OPT_NO_DAEMON),
 	{}
 };
 
@@ -853,6 +855,11 @@ static int fuse_parse_param(struct fs_context *fsc, struct fs_parameter *param)
 			return invalfc(fsc, "Unable to open root directory");
 		break;
 
+	case OPT_NO_DAEMON:
+		ctx->no_daemon = true;
+		ctx->fd_present = true;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -1411,7 +1418,7 @@ void fuse_send_init(struct fuse_mount *fm)
 	ia->args.nocreds = true;
 	ia->args.end = process_init_reply;
 
-	if (fuse_simple_background(fm, &ia->args, GFP_KERNEL) != 0)
+	if (unlikely(fm->fc->no_daemon) || fuse_simple_background(fm, &ia->args, GFP_KERNEL) != 0)
 		process_init_reply(fm, &ia->args, -ENOTCONN);
 }
 EXPORT_SYMBOL_GPL(fuse_send_init);
@@ -1693,6 +1700,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	fc->destroy = ctx->destroy;
 	fc->no_control = ctx->no_control;
 	fc->no_force_umount = ctx->no_force_umount;
+	fc->no_daemon = ctx->no_daemon;
 
 	err = -ENOMEM;
 	root = fuse_get_root_inode(sb, ctx->rootmode, ctx->root_dir);
@@ -1739,7 +1747,7 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	struct fuse_fs_context *ctx = fsc->fs_private;
 	int err;
 
-	if (!ctx->file || !ctx->rootmode_present ||
+	if (!!ctx->file == ctx->no_daemon || !ctx->rootmode_present ||
 	    !ctx->user_id_present || !ctx->group_id_present)
 		return -EINVAL;
 
@@ -1747,10 +1755,12 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	 * Require mount to happen from the same user namespace which
 	 * opened /dev/fuse to prevent potential attacks.
 	 */
-	if ((ctx->file->f_op != &fuse_dev_operations) ||
-	    (ctx->file->f_cred->user_ns != sb->s_user_ns))
-		return -EINVAL;
-	ctx->fudptr = &ctx->file->private_data;
+	if (ctx->file) {
+		if ((ctx->file->f_op != &fuse_dev_operations) ||
+		    (ctx->file->f_cred->user_ns != sb->s_user_ns))
+			return -EINVAL;
+		ctx->fudptr = &ctx->file->private_data;
+	}
 
 	err = fuse_fill_super_common(sb, ctx);
 	if (err)
@@ -1800,6 +1810,9 @@ static int fuse_get_tree(struct fs_context *fsc)
 
 	fsc->s_fs_info = fm;
 
+	if (ctx->no_daemon)
+		return get_tree_nodev(fsc, fuse_fill_super);
+
 	if (ctx->fd_present)
 		ctx->file = fget(ctx->fd);
 
-- 
2.38.1.584.g0f3c55d4c2-goog

