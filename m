Return-Path: <SRS0=xMZa=52=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0919C2BB85
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 08:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6A021973
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 08:25:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J8sBMwb2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgDJIZv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 04:25:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40434 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJIZv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Apr 2020 04:25:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so1926331wmf.5
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Apr 2020 01:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=daNuipW4JwljCyUs2IhrInSZMJrljeJ1xMOIkICrajo=;
        b=J8sBMwb2vuJEyQTMgEPYNJKogZk12Ekeh1G+yCf9Hrv5j8ULk6zMVEJdMwCQhHz/RE
         sqRuaaUIGtCqxqUBUA97t0yWoW7+LyxX7a3LY1ZjsgZju/yYfs+5Qv7lshmB3WgLtEg2
         mLum8LNTGT+kbFlva9q65BibqBDjo4I06SEcv5j6oWM5lKvQ3gGFPUpRO0G2N4OnvFzC
         S27BgzBDj/kqOPEPiQdywXnJJprB3H1Al6+1Ci9wH/CFww8qcav7e42gqS5prqne2H4D
         y9VSW6swJzhS0tHF16+1wxtXf3t7q82eaVRqiu7tazhV4a4Y8DXJn5B5ivhbkaEyHXSV
         SLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=daNuipW4JwljCyUs2IhrInSZMJrljeJ1xMOIkICrajo=;
        b=PEX80cZttTYkRvVCS/w5vYGcVmYFLKLHN+ivtVSaBna1LQ7SeBJNv+zRFqYvJXKoBn
         ZFtn9szcJkx1SLZi4026IVj8JauoezY2FTY+Keekwgx0jxBHHvEy8qGgczreq5tFb3IO
         KMCHnBcBNbR0jPLO4zs8NwF4cK8syI+ZZLeCxlpfGrJTirtBqXeBcz+n/sTIG1n5Zzzk
         trQXdhOxgzDQU7SzWT7yh0P6yZpDx2KoNrB6jdOh54tkDIt6iHnAxOm/EwXE4G35BUqL
         kniQC7LgcxnqE2nr/cQKnwoBAyimE8NbLGR/GlRLKcqcTV4sk5F0lfF83nsFpdYPwuVa
         vARQ==
X-Gm-Message-State: AGi0PubHaNROI0lBjNSmpOXuoMHStvYcgc5oPk93p7W3j+J01rOFm6Mf
        BwaI0UQatz+vN/CsSVN6hXM=
X-Google-Smtp-Source: APiQypJhkLtsCj7tpwRwjSI+gOq02Q3nHeV6KL1PnSnszC/HmN1j3NNvqwuABAgSDCAMciQLFzSdgA==
X-Received: by 2002:a7b:c404:: with SMTP id k4mr3777985wmi.37.1586507149884;
        Fri, 10 Apr 2020 01:25:49 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id b7sm1710327wrn.67.2020.04.10.01.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 01:25:49 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH 3/3] ovl: index dir act as work dir
Date:   Fri, 10 Apr 2020 11:25:39 +0300
Message-Id: <20200410082539.23627-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200410082539.23627-1-amir73il@gmail.com>
References: <20200410082539.23627-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

With index=on, let index dir act as the work dir for copy up and
cleanups.  This will help implementing whiteout inode sharing.

We still create the "work" dir on mount regardless of index=on
and it is used to test the features supported by upper fs.
One reason is that before the feature tests, we do not know if
index could be enabled or not.

The reason we do not use "index" directory also as workdir with
index=off is because the existence of the "index" directory acts
as a simple persistent signal that index was enabled on this
filesystem and tools may want to use that signal.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

It is worth mentioning that I contemplated about the right point to
overload workdir with indexdir.

I decided to go for ofs->workdir and not ovl_workdir(), because
it makes the patch touch less code and avoids future uninterntional
uses of ofs->workdir after 'work' dir has been retired.

That said, I do not feel strongly about it, so I could go for
ovl_workdir() if you prefer.

I do feel strongly about the decision to keep 'work' dir for
index=off case.

Thanks,
Amir.

 fs/overlayfs/super.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 732ad5495c92..b91b23a0366c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1777,17 +1777,21 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_flags |= SB_RDONLY;
 
 	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
+		/* index dir will act also as workdir */
+		dput(ofs->workdir);
+		ofs->workdir = NULL;
+		iput(ofs->workdir_trap);
+		ofs->workdir_trap = NULL;
+
 		err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
 		if (err)
 			goto out_free_oe;
 
 		/* Force r/o mount with no index dir */
-		if (!ofs->indexdir) {
-			dput(ofs->workdir);
-			ofs->workdir = NULL;
+		if (ofs->indexdir)
+			ofs->workdir = dget(ofs->indexdir);
+		else
 			sb->s_flags |= SB_RDONLY;
-		}
-
 	}
 
 	err = ovl_check_overlapping_layers(sb, ofs);
-- 
2.17.1

