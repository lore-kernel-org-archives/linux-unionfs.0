Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3441BC197BF
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F577238E9
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgLGQee (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:34:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727699AbgLGQed (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607358787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=otYj369xse9R2kbOApLqBDn6NdlRsKHBl6lYbw3xZEw=;
        b=ilx0XmJ983dYodBhAs4Q4VYTh27yeCPwf400wL+Pl889/kCMZ3H/JgFwXDvphJofHKNn5z
        mmyVgH0ZX2O/c40zagkLrRiDZrQD92Vr8z45V1iNlB19sXxSuxnS9EyaKArbcmDKD4KQEU
        EY7LVA4XUQ/pnd9AuBc8Xgik11OMDgw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-yHBCAuRaPAu2Wf9jvbIEoQ-1; Mon, 07 Dec 2020 11:33:03 -0500
X-MC-Unique: yHBCAuRaPAu2Wf9jvbIEoQ-1
Received: by mail-ej1-f70.google.com with SMTP id t17so4060788ejd.12
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Dec 2020 08:33:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=otYj369xse9R2kbOApLqBDn6NdlRsKHBl6lYbw3xZEw=;
        b=ZddgxKObKhIcwTEF/616LUYdZ8Jnfbk6ItpvrP622lD14Z9Cnieb4g2IKo0QtsahxH
         UrJh2y5f+6rOGX9XpYMBvVeEXYrnHKnTE4SUJ4o1lETMMKv93CENoXWJgMpc2jULpbHt
         CgMXleTkAyscI4zd26JIqpv47EgB7SRdBPim4UMz6S8m5r2THEKYzNedyB5D4IyhFrtS
         VA5O2hPtl9RMPTeO8QLD3PVjQ7OQZtXw9Hk7bzUpxe7mUOPJbOkH9bs7/Uyw36c5bVkD
         v7SnNYJsY6YIlm4pQQwOGsmjD20+GeqmsREucJw5dBgdCK0/W1i6lLb7/MbivQjKMe+w
         7UNg==
X-Gm-Message-State: AOAM530GZAc/ms6sdGoNPAihMpxt8RReeb/H2ipX3EmT7TU6kUXRnvZY
        X/rhVJkZwEDY7ZX4yjB9ZQ5NjfpUnooozwcPw2DCxG6CaiuvZdO0ELEtwyf4nrBbyb3C09rVi0F
        V/8MZuyvNfeNOJFdeRLc9tH0eeQ==
X-Received: by 2002:a17:906:c83b:: with SMTP id dd27mr19881675ejb.356.1607358782442;
        Mon, 07 Dec 2020 08:33:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygw9J/iNohcy2imBMmRfiewi1ytt2qnsha6UorIQb1JISBnH+1nxrUZXhES5TAxxlwjwkJkQ==
X-Received: by 2002:a17:906:c83b:: with SMTP id dd27mr19881657ejb.356.1607358782244;
        Mon, 07 Dec 2020 08:33:02 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id op5sm12801964ejb.43.2020.12.07.08.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:33:01 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     "Eric W . Biederman" <ebiederm@xmission.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/10] vfs: verify source area in vfs_dedupe_file_range_one()
Date:   Mon,  7 Dec 2020 17:32:47 +0100
Message-Id: <20201207163255.564116-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207163255.564116-1-mszeredi@redhat.com>
References: <20201207163255.564116-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Call remap_verify_area() on the source file as well as the destination.

When called from vfs_dedupe_file_range() the check as already been
performed, but not so if called from layered fs (overlayfs, etc...)

Could ommit the redundant check in vfs_dedupe_file_range(), but leave for
now to get error early (for fear of breaking backward compatibility).

This call shouldn't be performance sensitive.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/remap_range.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/remap_range.c b/fs/remap_range.c
index e6099beefa97..77dba3a49e65 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -456,8 +456,16 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	if (ret)
 		return ret;
 
+	/*
+	 * This is redundant if called from vfs_dedupe_file_range(), but other
+	 * callers need it and it's not performance sesitive...
+	 */
+	ret = remap_verify_area(src_file, src_pos, len, false);
+	if (ret)
+		goto out_drop_write;
+
 	ret = remap_verify_area(dst_file, dst_pos, len, true);
-	if (ret < 0)
+	if (ret)
 		goto out_drop_write;
 
 	ret = -EPERM;
-- 
2.26.2

