Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AE4C77B76
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 01:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjDRBmc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDRBl6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Apr 2023 21:41:58 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A885B90
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 18:41:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54be7584b28so368334067b3.16
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 18:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681782075; x=1684374075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Zzn8o1i1Qipa77dzB0ZPLXp5K2/As2sG8h87DoyjGM=;
        b=2+I98OIJuVmlxxZnL112cFQtwT3jCQDjIow9U7tinQ0J7PnT7CW2nk5rnzuaqyfrh7
         t3DlfVAZR6sD5E+Luhvth8wbofyEZeHmBpkUkBocSpBEVttlXwuggShqUO9kj7Yq0/h/
         aX7QFH/O8g9rnwLpOW9lAXc/V85QKHAhuJlpvE7i1s3Gysd2bhwkmvNvqQ40s9IHS+fW
         iwFwXKp/SUQPTFNVB9+Xbi1KWg/VuO0heZfOSN2cvyCPhvHY7TR+CKbNpElBlFthzn2Y
         NCkq3jwcH9x/45VO8uba3X5M5Kc8fLUu98eMXLHD5qQZ70F2CYgsgu/Pb70DPzEmoCIC
         +4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681782076; x=1684374076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Zzn8o1i1Qipa77dzB0ZPLXp5K2/As2sG8h87DoyjGM=;
        b=E2wVhVUNEtYl7JOj1+S8L5Yjgq2PP91h9Le2YMj37OIwIMtMuSCCTFRApV9DdW6ux0
         f4/zWn5WFHuwJ28ZhCgdFkIXtyVYy7jZflUUU/SlLQHrgz5AgEynFuSgmK4F87GLk5Dv
         T/vF99zGoVKnEnF5XV/TcPhn78/+bqQ/ydSOlpBzrBh2C5LF4z/DnGQrw+A8p9vZY6MN
         YB6Aw3J71zbzZGMZqHn7Ys/+5pQWOYda7uSgYueI+F7eKnS8VpMNnahDDBxrbeoUyERP
         qiw788tLAlIj5uD5n0Vddhn86+8qpflRhyA40jfcpfV5vapJwOtLlYZVXUmuuF8ZGABa
         iazg==
X-Gm-Message-State: AAQBX9d2IOglSBjDP369fjUBXnnHUubKnMZaThFA37vWqOqpBhArnTio
        78WW1N0Op8F0KhTB0jYVPt3S0afoOBs=
X-Google-Smtp-Source: AKy350a3U2lTLEFmBlzns8CqFoaKv7hHvFxu3WPdR2gkRwnkhckHyeUhIddcfAh3AVrbzcBi92gpNo88opU=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:e67a:98b0:942d:86aa])
 (user=drosen job=sendgmr) by 2002:a25:74d0:0:b0:b92:25a0:90d with SMTP id
 p199-20020a2574d0000000b00b9225a0090dmr5872731ybc.0.1681782075783; Mon, 17
 Apr 2023 18:41:15 -0700 (PDT)
Date:   Mon, 17 Apr 2023 18:40:11 -0700
In-Reply-To: <20230418014037.2412394-1-drosen@google.com>
Mime-Version: 1.0
References: <20230418014037.2412394-1-drosen@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418014037.2412394-12-drosen@google.com>
Subject: [RFC PATCH v3 11/37] fuse-bpf: Add support for access
From:   Daniel Rosenberg <drosen@google.com>
To:     Miklos Szeredi <miklos@szeredi.hu>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Joanne Koong <joannelkoong@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>, kernel-team@android.com,
        Daniel Rosenberg <drosen@google.com>,
        Paul Lawrence <paullawrence@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This adds backing support for FUSE_ACCESS

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/backing.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dir.c     |  6 ++++++
 fs/fuse/fuse_i.h  |  6 ++++++
 3 files changed, 59 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 3d895957b5ce..e42622584037 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -417,3 +417,50 @@ int fuse_revalidate_backing(struct dentry *entry, unsigned int flags)
 		return backing_entry->d_op->d_revalidate(backing_entry, flags);
 	return 1;
 }
+
+static int fuse_access_initialize_in(struct bpf_fuse_args *fa, struct fuse_access_in *in,
+				     struct inode *inode, int mask)
+{
+	*in = (struct fuse_access_in) {
+		.mask = mask,
+	};
+
+	*fa = (struct bpf_fuse_args) {
+		.info = (struct bpf_fuse_meta_info) {
+			.opcode = FUSE_ACCESS,
+			.nodeid = get_node_id(inode),
+		},
+		.in_numargs = 1,
+		.in_args[0].size = sizeof(*in),
+		.in_args[0].value = in,
+	};
+
+	return 0;
+}
+
+static int fuse_access_initialize_out(struct bpf_fuse_args *fa, struct fuse_access_in *in,
+				      struct inode *inode, int mask)
+{
+	return 0;
+}
+
+static int fuse_access_backing(struct bpf_fuse_args *fa, int *out, struct inode *inode, int mask)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	const struct fuse_access_in *fai = fa->in_args[0].value;
+
+	*out = inode_permission(&nop_mnt_idmap, fi->backing_inode, fai->mask);
+	return 0;
+}
+
+static int fuse_access_finalize(struct bpf_fuse_args *fa, int *out, struct inode *inode, int mask)
+{
+	return 0;
+}
+
+int fuse_bpf_access(int *out, struct inode *inode, int mask)
+{
+	return bpf_fuse_backing(inode, struct fuse_access_in, out,
+				fuse_access_initialize_in, fuse_access_initialize_out,
+				fuse_access_backing, fuse_access_finalize, inode, mask);
+}
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 73ebe3498fb9..535e6cf9e970 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1439,6 +1439,9 @@ static int fuse_access(struct inode *inode, int mask)
 	struct fuse_access_in inarg;
 	int err;
 
+	if (fuse_bpf_access(&err, inode, mask))
+		return err;
+
 	BUG_ON(mask & MAY_NOT_BLOCK);
 
 	if (fm->fc->no_access)
@@ -1495,6 +1498,9 @@ static int fuse_permission(struct mnt_idmap *idmap,
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
+	if (fuse_bpf_access(&err, inode, mask))
+		return err;
+
 	/*
 	 * If attributes are needed, refresh them before proceeding
 	 */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 39a9fdf2a752..cb166168f9c2 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1406,6 +1406,7 @@ int parse_fuse_bpf_entry(struct fuse_bpf_entry *fbe, int num_entries);
 #ifdef CONFIG_FUSE_BPF
 
 int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct dentry *entry, unsigned int flags);
+int fuse_bpf_access(int *out, struct inode *inode, int mask);
 
 #else
 
@@ -1414,6 +1415,11 @@ static inline int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct
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
2.40.0.634.g4ca3ef3211-goog

