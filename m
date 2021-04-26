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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B2FC433B4
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Apr 2021 15:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B7961359
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Apr 2021 15:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhDZPVI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhDZPVI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Apr 2021 11:21:08 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B8DC061574
        for <linux-unionfs@vger.kernel.org>; Mon, 26 Apr 2021 08:20:25 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k14so6393244wrv.5
        for <linux-unionfs@vger.kernel.org>; Mon, 26 Apr 2021 08:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yQcC8svMAO35Sjr0bxPSk+CXoHVMHHZ94tWT9Cy+/7s=;
        b=bZwb9Q1AY95qCLK/uDrqAqGC9HQXbYIZUWmND3VF3u8eIpKWQ1guylQgK6laQgvixD
         aL15j0hJQmx8amWEYjPKKt3HgLuCy+R+aDLSY9NQr9joMvcB6wLOUtLNchrLM03PtpzQ
         sAY+VYpnk0UzjE3f6axE1WATOZ5B16C8inB6nCWChwUkzx9gSoBvAdDeSwCyAAMkjV3v
         F4T0hXKeVGEjpoDj1nNxYHgCFtC1XMRNphWtl4p7DFkYa41jW4Zmr6QkbbaaiAcEYZH5
         lrH5MbpVCgDmwoN/s/OmTDymBw5iLvT0y/GsDkW6sqROp8cJho8dUlezejtEyq+Nh0nH
         9FYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yQcC8svMAO35Sjr0bxPSk+CXoHVMHHZ94tWT9Cy+/7s=;
        b=c1LUb7YGswFH+RDq6x6tsN6ju/9VgXtNnHuas4NCE/ib8Ig/3Zi8IGnY2kdv0KZvvw
         uYlpXD/3UYrAmOzChZJklTK2sksWObMbKNUcgg/OeTHMHCejG1dPy+8Z6hmcfYq9cw66
         nidAEZWIJFHxw1j0Y0+/U6/7k4V1jYK+1IccIyKdf5N/bTBmTXnXnxPF/6/8d52hBMB3
         iFGyNQwjbw7tunLa5Pj7WflBf3djMk5VpEclEafirODc6JPi4AKbF/NJfdd9qSjxfzsZ
         gCFqNI6AR+iWehEtLXXkWt2oV/BF8PBA7Eafc4wIGKtT5i5uK5UIYCgJMVd4sw1rliAO
         ivWA==
X-Gm-Message-State: AOAM533BsU6W66zfYFSAFcvqFQ6WKPCX8U3nqXL2Lr8rLGPsgLwHyNFs
        SfaW2uE22Y5mfy8ShqL4lEI=
X-Google-Smtp-Source: ABdhPJydLcalmNazzOqGyneJ+Az0vNU+c/yzWycxIzF2Zqfs4XS63m4Kki6p5rcsQSS0ap2dPStgRw==
X-Received: by 2002:a05:6000:110d:: with SMTP id z13mr8204202wrw.92.1619450423977;
        Mon, 26 Apr 2021 08:20:23 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id c77sm17769400wme.37.2021.04.26.08.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 08:20:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: skip stale entries in merge dir cache iteration
Date:   Mon, 26 Apr 2021 18:20:21 +0300
Message-Id: <20210426152021.1145298-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On the first getdents call, ovl_iterate() populates the readdir cache
with a list of entries, but for upper entries with origin lower inode,
p->ino remains zero.

Following getdents calls traverse the readdir cache list and call
ovl_cache_update_ino() for entries with zero p->ino to lookup the entry
in the overlay and return d_ino that is consistent with st_ino.

If the upper file was unlinked between the first getdents call and the
getdents call that lists the file entry, ovl_cache_update_ino() will not
find the entry and fall back to setting d_ino to the upper real st_ino,
which is inconsistent with how this object was presented to users.

Instead of listing a stale entry with inconsistent d_ino, simply skip
the stale entry, which is better for users.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index cc1e80257064..10b7780e4bdc 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -481,6 +481,8 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	}
 	this = lookup_one_len(p->name, dir, p->len);
 	if (IS_ERR_OR_NULL(this) || !this->d_inode) {
+		/* Mark a stale entry */
+		p->is_whiteout = true;
 		if (IS_ERR(this)) {
 			err = PTR_ERR(this);
 			this = NULL;
@@ -776,6 +778,9 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 				if (err)
 					goto out;
 			}
+		}
+		/* ovl_cache_update_ino() sets is_whiteout on stale entry */
+		if (!p->is_whiteout) {
 			if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
 				break;
 		}
-- 
2.25.1

