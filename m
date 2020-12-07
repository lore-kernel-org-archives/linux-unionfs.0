Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C69C2BB48
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 415B3238E7
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgLGQek (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:34:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727776AbgLGQej (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607358793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrWD39vQ5236vo/77WTHcclMwYYEe2kMnOzynaA/vIg=;
        b=e6U/BQuqzl1WUWYgl06IfXVfZx9bSvNIOcvAdfuB/Xa5V05M4nfdzXni/zOqRtSnaQTnCy
        fOL8/h1o/VAjJqP8atdRmI+eEjyNWIp1NGR2SX+0GTsuXD6I4W27G6pe0tgF6LDkGiBfUX
        hNB2xIrObhFDmiAoO7soBlssznGpeLI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-Nyuy7wARO0SPTe0fozMPKg-1; Mon, 07 Dec 2020 11:33:10 -0500
X-MC-Unique: Nyuy7wARO0SPTe0fozMPKg-1
Received: by mail-ed1-f69.google.com with SMTP id u18so6005225edy.5
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Dec 2020 08:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WrWD39vQ5236vo/77WTHcclMwYYEe2kMnOzynaA/vIg=;
        b=FTaYnOLgM7dHrYY7Ow6SU/M6h10T2uaNgQgsdw7cVIA3tFVwzgotZ/yM8D7dMzAycb
         k4C4+ynFYHf96SkGJm6n/4s7ycyMHPmbRRkRhVh+YkumoM2HlFndSHkOMFMPSbXbf0Ng
         FC8XHimJt7Z4vhrJTh762bZ9WyD6EdGetFlkqFF22H+fS7Lzp42k0AxQwK/g5sURwW7N
         WUP6ftYIliehmYXPmXb0aR8PlizPmRLqroUkkfwM+BxbomH9P6o0+Udyr6esWWUqD5C5
         YK5zn5sdg7V0Q9D41ARccCk0HEzRZOOyeLuFnGjO4jBBi0uKzTnNmlM38HIqa3qtNIQ4
         fzpw==
X-Gm-Message-State: AOAM533CXc+I3jwChkw4E8RGKYwzUL1mT8RcL7E8q8WGusfwFNrARlro
        GIHqZMPRSsGrxkVn9wGh/QWjUgZ4Uj4QldrXZrHA/y/rrHl4twZgY+vKpabjlpd282NMjn1s3NH
        iPj8tkzSbOWKINLJxHnxi99jHNQ==
X-Received: by 2002:a05:6402:b57:: with SMTP id bx23mr20433026edb.191.1607358789300;
        Mon, 07 Dec 2020 08:33:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDZ8PBOMTmy7Viq25/DAuAax7RMDShGdfStsG7a9V/Uv4Vpsy2gyL1w0kDb+e0n297b859wQ==
X-Received: by 2002:a05:6402:b57:: with SMTP id bx23mr20433017edb.191.1607358789148;
        Mon, 07 Dec 2020 08:33:09 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id op5sm12801964ejb.43.2020.12.07.08.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:33:08 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     "Eric W . Biederman" <ebiederm@xmission.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/10] ovl: do not fail when setting origin xattr
Date:   Mon,  7 Dec 2020 17:32:52 +0100
Message-Id: <20201207163255.564116-8-mszeredi@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207163255.564116-1-mszeredi@redhat.com>
References: <20201207163255.564116-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Comment above call already says this, but only EOPNOTSUPP is ignored, other
failures are not.

For example setting "user.*" will fail with EPERM on symlink/special.

Ignore this error as well.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 955ecd4030f0..8a7ef40d98f8 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -352,7 +352,8 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 				 fh ? fh->fb.len : 0, 0);
 	kfree(fh);
 
-	return err;
+	/* Ignore -EPERM from setting "user.*" on symlink/special */
+	return err == -EPERM ? 0 : err;
 }
 
 /* Store file handle of @upper dir in @index dir entry */
-- 
2.26.2

