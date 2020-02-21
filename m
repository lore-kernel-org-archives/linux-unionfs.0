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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E48EC35656
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FA852073A
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GsMNmCT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgBUOMy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:12:54 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51459 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbgBUOMy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:12:54 -0500
Received: by mail-wm1-f67.google.com with SMTP id t23so1953207wmi.1
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Feb 2020 06:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0O8ea0X6L2HDWaW01X90r8VKZfmfWCchJ9jAUgWEgAg=;
        b=GsMNmCT9QWuqNurVhIhW80r8L9Z9+2+FwOqqenIbFeNHYJ3OojdpPEbCx6E1PSSUrM
         BjIb7X6bM/djL6XUvefmjNeVlyec6KQT7OJf062l7jseVJn3tkX2vBr/t8JDQt5z3DP9
         fwIV94JoCDJqEikx+MP8dyf2mSQwDwSGw+Z6dvdDBaAP0kdqqMR+rYkckFbOxNHJAEFN
         tSYGmp/lutu5j4C34uGiFoyQSAm33cQUTmx29cMYqmm0TdHNRxhjuestiHJphDLGt3/r
         eXBPbMKpb9Ja9sbHclFiSpJGI4HzxC8FS2Ypthgxg1rOFh9FJys5E/lHqDMq8OFsd5Mt
         xHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0O8ea0X6L2HDWaW01X90r8VKZfmfWCchJ9jAUgWEgAg=;
        b=o0Wd7QsJoVFlCm9sHFvC5ahY1AR14NLhReFMCZ/okxiCsIvk4XUmWWysvZnAXqfh1l
         1pgPbJfjMcdWm2tYXCHVdXE7mcU7EnsBFIFlefp/ye8meKxkT9G6D/9Fo3R8rTolRnHZ
         cqx34988F8tGhJbn+VfWHWnkubHHJUFDSKLCKcSs6AxP/XXcAg9m99jQ492yrsDD5w/j
         tThcCRFzN2l8WI0Eh9rofk+8GJ8tKpjfMp6MbBnJZ+q1sqRKZ7Bnwp6ysGXqCyyZXTp1
         dsGBycd9FxRjlOBLYhlr1Th1J3kzv6eRJRjxNx+Y7t4r4cK0qeCigWQP8b4Pq4zS7kgg
         WijQ==
X-Gm-Message-State: APjAAAVS4z4MO3sBXXubQcIt7JOuxUgbfrINxrtNPoOLer8dlCUoIeIb
        6BmXIeFeksMwU1xn6CO3O5w=
X-Google-Smtp-Source: APXvYqyWVJEOERMJwIsL4PbJMt7836dwjpiFbNgCs0jINplS11DMWp2eSTHU2zpGbEhrzetHXo5tlA==
X-Received: by 2002:a1c:1d09:: with SMTP id d9mr4295512wmd.91.1582294372319;
        Fri, 21 Feb 2020 06:12:52 -0800 (PST)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id y12sm4104916wrw.88.2020.02.21.06.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:12:51 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 1/3] ovl: resurrect ovl_dentry_remote()
Date:   Fri, 21 Feb 2020 16:12:43 +0200
Message-Id: <20200221141245.6773-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

These patches are against overlayfs-next.
You'd probably want to squash this one.

Thanks,
Amir.

 fs/overlayfs/overlayfs.h | 1 +
 fs/overlayfs/util.c      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8db6cf3ffc46..8d67dc7c1c04 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -229,6 +229,7 @@ struct dentry *ovl_indexdir(struct super_block *sb);
 bool ovl_index_all(struct super_block *sb);
 bool ovl_verify_lower(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
+bool ovl_dentry_remote(struct dentry *dentry);
 void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
 			     unsigned int mask);
 bool ovl_dentry_weird(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index ad5770c145ec..0ec3766386b7 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -90,6 +90,12 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 	return oe;
 }
 
+bool ovl_dentry_remote(struct dentry *dentry)
+{
+	return dentry->d_flags &
+		(DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+}
+
 void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
 			     unsigned int mask)
 {
-- 
2.17.1

