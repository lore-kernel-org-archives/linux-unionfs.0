Return-Path: <SRS0=T6lg=3U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D6CC33CB2
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2F9C206F0
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aO3ih65t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgAaLuS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 06:50:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44279 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728453AbgAaLuS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jan 2020 06:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580471417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2WGviQLsH6AvMNQjdMyzX3t1BULCm9mhpUqub5Zuv+E=;
        b=aO3ih65tk/YL32JoriU5//jpicEZMmXzgqSiDcLcm4aNMYM5MqFtZ6ABqqJsR3E+DALjf4
        h2QoMffF6RNcQc1gCa3UysgS6s15Fk4kgbnuep4S84Q9MI635Igx/veP6IEuiEbSmniqTd
        hlhLmRcPDJLfXgARPfNV3wLJql10JuQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-8J7iuDOxO02wDv-4w4vd1g-1; Fri, 31 Jan 2020 06:50:16 -0500
X-MC-Unique: 8J7iuDOxO02wDv-4w4vd1g-1
Received: by mail-wr1-f70.google.com with SMTP id d8so3225695wrq.12
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jan 2020 03:50:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2WGviQLsH6AvMNQjdMyzX3t1BULCm9mhpUqub5Zuv+E=;
        b=LWl5tYmFWV//xDkyG8C3KO7ZpWjaUX6W3FjLpZFGwF6nmxlWtSxCwzpWE5DZ7YSnaL
         mMlhjep+xrLjKtlMrolRcuZBmCmDlj3lnlYVGJ/x1047RdCP4k9LrL3SYyICtKe9Gsdo
         zmRRbyjdKh9CZHbYsBFljFV52BGIZlClhmDbMBSEeUQFpbdHgYb+eWEMltoPUtrYWPoZ
         kcBii+jQRust54Y1LSfyT92t8SbwSCNEadr9Y0oknWZDDjFMVRhoPe2fkyHP5uLlPTI0
         +xE5yDAMX1Phzf1V1jhrsqKtlTx95mU2PckDFdfwfoKMWv2RnkZG3hKC08nw6cmd4b3Y
         HMeA==
X-Gm-Message-State: APjAAAVJRQHLLSD8pgHYbdaVEhAtnG+8WVfzIXQCMAGHzaGUJcbCDDS2
        1rkKEO7kOU6SNM+U1+wMVWxV87zXIxTdhk/lQmFv3Z2UHz7fUHJYlaRvpKYCY4qtbElkwe9PdPU
        O76eNCi9kVNAdG4xYBGj5Plte1g==
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr12489956wrt.229.1580471414662;
        Fri, 31 Jan 2020 03:50:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqxpyFnDsYUD/UFMSZ5RGBKK5QG7dbAHqvgHv8woAFzPIbBp14lwxTvhrqmj9sRgsB5dMvp6nw==
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr12489935wrt.229.1580471414456;
        Fri, 31 Jan 2020 03:50:14 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (84-236-74-45.pool.digikabel.hu. [84.236.74.45])
        by smtp.gmail.com with ESMTPSA id s1sm2746622wro.66.2020.01.31.03.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 03:50:13 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     linux-unionfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/4] ovl: restructure dentry revalidation
Date:   Fri, 31 Jan 2020 12:50:01 +0100
Message-Id: <20200131115004.17410-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200131115004.17410-1-mszeredi@redhat.com>
References: <20200131115004.17410-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Use a common loop for plain and weak revalidation.  This will aid doing
revalidation on upper layer.

This patch doesn't change behavior.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/super.c | 51 ++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 319fe0d355b0..852a1816fea1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -113,47 +113,48 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	return dentry;
 }
 
-static int ovl_dentry_revalidate(struct dentry *dentry, unsigned int flags)
+static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
-	unsigned int i;
 	int ret = 1;
 
-	for (i = 0; i < oe->numlower; i++) {
-		struct dentry *d = oe->lowerstack[i].dentry;
-
-		if (d->d_flags & DCACHE_OP_REVALIDATE) {
-			ret = d->d_op->d_revalidate(d, flags);
-			if (ret < 0)
-				return ret;
-			if (!ret) {
-				if (!(flags & LOOKUP_RCU))
-					d_invalidate(d);
-				return -ESTALE;
-			}
+	if (weak) {
+		if (d->d_flags & DCACHE_OP_WEAK_REVALIDATE)
+			ret =  d->d_op->d_weak_revalidate(d, flags);
+	} else if (d->d_flags & DCACHE_OP_REVALIDATE) {
+		ret = d->d_op->d_revalidate(d, flags);
+		if (!ret) {
+			if (!(flags & LOOKUP_RCU))
+				d_invalidate(d);
+			ret = -ESTALE;
 		}
 	}
-	return 1;
+	return ret;
 }
 
-static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
+static int ovl_dentry_revalidate_common(struct dentry *dentry,
+					unsigned int flags, bool weak)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 	unsigned int i;
 	int ret = 1;
 
-	for (i = 0; i < oe->numlower; i++) {
-		struct dentry *d = oe->lowerstack[i].dentry;
-
-		if (d->d_flags & DCACHE_OP_WEAK_REVALIDATE) {
-			ret = d->d_op->d_weak_revalidate(d, flags);
-			if (ret <= 0)
-				break;
-		}
+	for (i = 0; ret > 0 && i < oe->numlower; i++) {
+		ret = ovl_revalidate_real(oe->lowerstack[i].dentry, flags,
+					  weak);
 	}
 	return ret;
 }
 
+static int ovl_dentry_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	return ovl_dentry_revalidate_common(dentry, flags, false);
+}
+
+static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	return ovl_dentry_revalidate_common(dentry, flags, true);
+}
+
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_release = ovl_dentry_release,
 	.d_real = ovl_d_real,
-- 
2.21.1

