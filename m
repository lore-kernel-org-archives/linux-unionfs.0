Return-Path: <SRS0=T6lg=3U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA1F9C35240
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B05AE206F0
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qaa8gUyO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgAaLuU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 06:50:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728485AbgAaLuT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jan 2020 06:50:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580471419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Gs10o8erqjXnGfNlK1akrFju0qr46cuwrqKnpu2IuE=;
        b=Qaa8gUyOJpusNv84FXV1wHTTlgnXb8bHlFZ1P6WS5sCix35AHuwvItrazHlXQf3rmu6I9a
        L1gS7ly3f3uBfNexPCsamyoyv5tzO7vuPhpumRM7In423cdch7RiPHq9EaSGsUkLrxdXqd
        SYI2f6ZsWuc1KeDKkkwgScWPWVjJ8/w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-KvAIlGBaPZCrVLlAkPWROw-1; Fri, 31 Jan 2020 06:50:17 -0500
X-MC-Unique: KvAIlGBaPZCrVLlAkPWROw-1
Received: by mail-wr1-f69.google.com with SMTP id v17so3213120wrm.17
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jan 2020 03:50:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Gs10o8erqjXnGfNlK1akrFju0qr46cuwrqKnpu2IuE=;
        b=V/Y+05i5E16SQIL0lNaSVNK6Ku4NxasYJbLVz9rcFpdPHR30Rn1nmbYiSzwO4BF3x2
         BQ58LReyMRKjOCGs2cAImN9JNdI0Jfd3e1XNdAFmH3Hm8yfUiWKH1pX0S8+QPq2cOsST
         rzJpAMpyATNLM3NtpC9mwcwsftCWRGbal1W01ECJzCwpr9/dYtTfCd2l/3TvZbu0t7gB
         bPrb6TxUjKH7IRsl1EfjYQh3ftRsXBsl9+La6wc3EZ+KFBFBk6Fv+2NL4AbEKN9W1qML
         DkK0+qn3+tU/XuLfr6+tN+JG4BHGCuvOD5KMQBgsKRSxw3oYH54jU3tyucHWSvpLbkPY
         cq8w==
X-Gm-Message-State: APjAAAX2DRtuMXCCNEaIBZ0IZtMv3giVGaz7mNYjGcQYCyFRI0TACwZS
        PDbz/WrhskhTw/3WRpY9RXd5FW/amnAdROKWHIc5ADI7oJrCvRRkFp0oTdh0qAYsQ2bF7qrdLmj
        xc7UeDWo75oXYDT+0Sqmuzrfd5Q==
X-Received: by 2002:a1c:1fd0:: with SMTP id f199mr11335626wmf.113.1580471415543;
        Fri, 31 Jan 2020 03:50:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqy5XnMHv+48gW8liIrBqG0aVQmKuS27GqhXks1xZLqKou+Dbno3hgisv0P7LNmG0pxMXvfAQA==
X-Received: by 2002:a1c:1fd0:: with SMTP id f199mr11335605wmf.113.1580471415325;
        Fri, 31 Jan 2020 03:50:15 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (84-236-74-45.pool.digikabel.hu. [84.236.74.45])
        by smtp.gmail.com with ESMTPSA id s1sm2746622wro.66.2020.01.31.03.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 03:50:14 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     linux-unionfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/4] ovl: separate detection of remote upper layer from stacked overlay
Date:   Fri, 31 Jan 2020 12:50:02 +0100
Message-Id: <20200131115004.17410-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200131115004.17410-1-mszeredi@redhat.com>
References: <20200131115004.17410-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Following patch will allow remote as upper layer, but not overlay stacked
on upper layer.  Separate the two concepts.

This patch is doesn't change behavior.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/namei.c |  3 ++-
 fs/overlayfs/super.c | 14 +++++++-------
 fs/overlayfs/util.c  |  3 +--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ed9e129fae04..a5b998a93a24 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -845,7 +845,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (err)
 			goto out;
 
-		if (upperdentry && unlikely(ovl_dentry_remote(upperdentry))) {
+		if (upperdentry && (upperdentry->d_flags & DCACHE_OP_REAL ||
+				    unlikely(ovl_dentry_remote(upperdentry)))) {
 			dput(upperdentry);
 			err = -EREMOTE;
 			goto out;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 852a1816fea1..7e294bf719ff 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -752,13 +752,13 @@ static int ovl_mount_dir(const char *name, struct path *path)
 		ovl_unescape(tmp);
 		err = ovl_mount_dir_noesc(tmp, path);
 
-		if (!err)
-			if (ovl_dentry_remote(path->dentry)) {
-				pr_err("filesystem on '%s' not supported as upperdir\n",
-				       tmp);
-				path_put_init(path);
-				err = -EINVAL;
-			}
+		if (!err && (ovl_dentry_remote(path->dentry) ||
+			     path->dentry->d_flags & DCACHE_OP_REAL)) {
+			pr_err("filesystem on '%s' not supported as upperdir\n",
+			       tmp);
+			path_put_init(path);
+			err = -EINVAL;
+		}
 		kfree(tmp);
 	}
 	return err;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index ea005085803f..67cd2866aaa2 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -93,8 +93,7 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 bool ovl_dentry_remote(struct dentry *dentry)
 {
 	return dentry->d_flags &
-		(DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE |
-		 DCACHE_OP_REAL);
+		(DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
 }
 
 bool ovl_dentry_weird(struct dentry *dentry)
-- 
2.21.1

