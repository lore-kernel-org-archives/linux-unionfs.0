Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA055C47434
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2E02238E5
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgLGQek (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:34:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727777AbgLGQej (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607358793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q1fH8U2k617dM0XyiEykpCNbr+LOxy6e2jOJ7NB6sW0=;
        b=fJwj9zALUeYOMoWCz2impGGB+TcQqxkHwqisfTC4TSyKIzDFdAiY8c2WThli0w1heJDZ1A
        JDQ2UakpjlirDmDZ8jHxPsM+2NuKA8dF5oo40vQBCNQThqbthEAIz7RwRpgWOxY03Ch5pz
        y17uuwGNn4h1hvblVHkoHboRkbeH+vk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-Sf6LotPTNheiMpFlBioNeA-1; Mon, 07 Dec 2020 11:33:12 -0500
X-MC-Unique: Sf6LotPTNheiMpFlBioNeA-1
Received: by mail-ej1-f72.google.com with SMTP id 2so4027710ejv.4
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Dec 2020 08:33:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q1fH8U2k617dM0XyiEykpCNbr+LOxy6e2jOJ7NB6sW0=;
        b=XKil8t7a426Z2gfR8Ms6YQxR9HMhK1XrJkVzL+/UslDWOWly6LTPIKlGMekWBTCdAP
         lbnX62gP9q7S27v/bWTufqDcISv7Ng9tGrmV95OPiKqxFfKaaoBRKNDNKi6jFkNV7AXd
         c5Ig7TjtwzmJlbjQzM4+jQ/65kH59Lxt+EGHwfQabJ5X7Z6kEZkX17XA6ce7QTdaMO4t
         X98FHDLGWDlIvFVVwoSZB47QtIvzM/E+qpQR3o78SzYey8C3nCeMnUQ5TIzmCeXGJeWk
         zshAwbakBPbyoBP2TGGwk3cGR6y2nzkKoUkF3SYlv6KvmBYIzrdQMMlP5Sbb9h8jBDLd
         /4rw==
X-Gm-Message-State: AOAM532fjknGFbAooYwx+MDPPOA/3t64y0BYLI8brEf7ti9l2OK2sdfM
        QbKFQhf1AIfyPHPscryN2Izbta7icDFB1Xo2kmZJLHo8Rb4bsuooPN9Z306r8Vtfr3TYsIgQjab
        CB+nUY2A34DjzulOUKWpwZJCqhg==
X-Received: by 2002:a17:906:a2d0:: with SMTP id by16mr19156478ejb.207.1607358790895;
        Mon, 07 Dec 2020 08:33:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweaIFgMC09TO4pnW1Q9E6ePGnwgJZA2DaWMFT2e+UPWDLsluzpW5Ef28/5k5tUJJKQ0PR7fA==
X-Received: by 2002:a17:906:a2d0:: with SMTP id by16mr19156470ejb.207.1607358790718;
        Mon, 07 Dec 2020 08:33:10 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id op5sm12801964ejb.43.2020.12.07.08.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:33:10 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     "Eric W . Biederman" <ebiederm@xmission.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/10] ovl: do not fail because of O_NOATIME
Date:   Mon,  7 Dec 2020 17:32:53 +0100
Message-Id: <20201207163255.564116-9-mszeredi@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207163255.564116-1-mszeredi@redhat.com>
References: <20201207163255.564116-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In case the file cannot be opened with O_NOATIME because of lack of
capabilities, then clear O_NOATIME instead of failing.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index dc767034d37b..d6ac7ac66410 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -53,9 +53,10 @@ static struct file *ovl_open_realfile(const struct file *file,
 	err = inode_permission(realinode, MAY_OPEN | acc_mode);
 	if (err) {
 		realfile = ERR_PTR(err);
-	} else if (!inode_owner_or_capable(realinode)) {
-		realfile = ERR_PTR(-EPERM);
 	} else {
+		if (!inode_owner_or_capable(realinode))
+			flags &= ~O_NOATIME;
+
 		realfile = open_with_fake_path(&file->f_path, flags, realinode,
 					       current_cred());
 	}
-- 
2.26.2

