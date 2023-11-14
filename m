Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372AAC072A2
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbjKNPdM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbjKNPdL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:11 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6672693
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:08 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4079ed65471so47699835e9.1
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975987; x=1700580787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Y/W0FbMcXpJV0p21IBOzpdokgFQvpWnRV6Ba5vkiZs=;
        b=Bcd6hJcw2IXhUY6Nl4cx1Z9OSLdpALPf5n8AV02cJd7Uw+PWhcyRP4uvis9tGeGx5p
         pufhP62X3Tr9wqgoDWhD20dNEPyW15dUoviPRWIuaDxc84JItwW5CPmsFDHncHnBXp2u
         xrwaGFzDNtmZY3UljW1EmbeApuBnHV14GGtY5CwH0WTGez+EfDdLALBw+9gdCB1Lky2n
         y9Xmg8zG//jd7JQQKwdnkU+K/I2P5oxtul0CInTiRY09xF8UcNkkx7gfmSRkjQtVzSKC
         abGCMYXffqdTEx74SVWuv4CXAqnOT/sBD4VnUhJx0Isz9efoYAk9NzbG7xpYiKoTyvXx
         HHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975987; x=1700580787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Y/W0FbMcXpJV0p21IBOzpdokgFQvpWnRV6Ba5vkiZs=;
        b=OlM42MLVyKxHyniHlxXuIdVYfA/vf009FZl+apY3BXl5lO/hXcTVwBD+CCT/Val/zx
         jViNJBZuHTn8kaee+RT+kAioHS2nUn7dPrhz1DElGRZkn2shul90rezLJqiza5kvbefg
         73DRFbRupzuC3BdS7EfNl534PlEa9uIgwljVhNkU2U89HT9mP8VnNENoUnY+Qtg6PuoN
         PZG2WdatRrgXoB2ER3Wj36Sdx3TbvFU1H7b/39PbkQXplxe6BkuI933GMZyyIxfzepss
         +KNILd5/HM+ctPY2OPIOXvMdO3PJ7HuaGHJlNjodMR0e7pvDALzLqcN4Z0hyTbrfXt7F
         Kqyg==
X-Gm-Message-State: AOJu0Yzsb18+S3ZEyblYGsznEOmvEUGT2Fc8BWnlJkOjYmNclVHCoZ72
        TBUe/wuBNw9LNTXXUXNpl60=
X-Google-Smtp-Source: AGHT+IHHoiHFbG2IlpK2yIAUE4O1dYFLZkYaT04IFIOLEF0cAH8f5/a1pjfZZC9ARwxL+M3p173GDg==
X-Received: by 2002:a05:600c:3111:b0:405:36d7:4582 with SMTP id g17-20020a05600c311100b0040536d74582mr6632416wmo.15.1699975986626;
        Tue, 14 Nov 2023 07:33:06 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:05 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 05/15] splice: remove permission hook from iter_file_splice_write()
Date:   Tue, 14 Nov 2023 17:32:44 +0200
Message-Id: <20231114153254.1715969-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

All the callers of ->splice_write(), (e.g. do_splice_direct() and
do_splice()) already check rw_verify_area() for the entire range
and perform all the other checks that are in vfs_write_iter().

Create a helper do_iter_writev(), that performs the write without the
checks and use it in iter_file_splice_write() to avoid the redundant
rw_verify_area() checks.

This is needed for fanotify "pre content" events.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/internal.h   | 8 +++++++-
 fs/read_write.c | 7 +++++++
 fs/splice.c     | 9 ++++++---
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 58e43341aebf..c114b85e27a7 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -298,7 +298,13 @@ static inline ssize_t do_get_acl(struct mnt_idmap *idmap,
 }
 #endif
 
-ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *pos);
+/*
+ * fs/read_write.c
+ */
+ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from,
+			    loff_t *pos);
+ssize_t do_iter_writev(struct file *file, struct iov_iter *iter, loff_t *ppos,
+		       rwf_t flags);
 
 /*
  * fs/attr.c
diff --git a/fs/read_write.c b/fs/read_write.c
index 4771701c896b..590ab228fa98 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -739,6 +739,13 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 	return ret;
 }
 
+ssize_t do_iter_writev(struct file *filp, struct iov_iter *iter, loff_t *ppos,
+		       rwf_t flags)
+{
+	return do_iter_readv_writev(filp, iter, ppos, WRITE, flags);
+}
+
+
 /* Do it by hand, with file-ops */
 static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
 		loff_t *ppos, int type, rwf_t flags)
diff --git a/fs/splice.c b/fs/splice.c
index d4fdd44c0b32..decbace5d812 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -673,10 +673,13 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		.u.file = out,
 	};
 	int nbufs = pipe->max_usage;
-	struct bio_vec *array = kcalloc(nbufs, sizeof(struct bio_vec),
-					GFP_KERNEL);
+	struct bio_vec *array;
 	ssize_t ret;
 
+	if (!out->f_op->write_iter)
+		return -EINVAL;
+
+	array = kcalloc(nbufs, sizeof(struct bio_vec), GFP_KERNEL);
 	if (unlikely(!array))
 		return -ENOMEM;
 
@@ -733,7 +736,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		}
 
 		iov_iter_bvec(&from, ITER_SOURCE, array, n, sd.total_len - left);
-		ret = vfs_iter_write(out, &from, &sd.pos, 0);
+		ret = do_iter_writev(out, &from, &sd.pos, 0);
 		if (ret <= 0)
 			break;
 
-- 
2.34.1

