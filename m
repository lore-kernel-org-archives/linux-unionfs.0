Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFD6C2D0E4
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F01238E7
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgLGQfO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:35:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727700AbgLGQeg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607358789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YovU3sr3PaW3+O202/CGPLg5GcG7AOB5YNKN3Gg/9CM=;
        b=SELKqZWPL8dt0qmh7W9WAxh9+kvz3QVKabxzou6+nceanUenhQieJdvIV5BsbBJQ1PBGR2
        EdEnayfAk0X4NcUq5Gx+VKSchRJD3AeeOeZEIYAPs8/6WK159ivWdHCiKhOhbuVIVJSGqj
        MaycnwkR6WzgjUytxSl5HrT+iBBpnog=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-QDc9Nrq6PK-CP8L11r5kKw-1; Mon, 07 Dec 2020 11:33:04 -0500
X-MC-Unique: QDc9Nrq6PK-CP8L11r5kKw-1
Received: by mail-ed1-f72.google.com with SMTP id g25so3715949edu.4
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Dec 2020 08:33:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YovU3sr3PaW3+O202/CGPLg5GcG7AOB5YNKN3Gg/9CM=;
        b=nJctsvfK1dYd9+gfwEWVx82vSd8dk7z4gIN7s667z+BatGkrvEVR1JiiKBlMoDfxfE
         9PiWLByqWyJx503GM6DLs+UfCfExeTMs01wgKq9nNdLKmsEZ23FsoqHho/DCprEAgos/
         lJK9ci2r93ceKbjEDhfRWMzXlTKbTEqXH59SQBF0qh6fxrh0DmLBW3XXII5UK7CEMcW+
         6tVYBsaquXa5QTU0Armwb3ztLh6X76PbVB3+GLwy6GXGoO22+cXC4V0GY/9nGjozVuUY
         jFYMyDlg8bTIKxsp8RN+WRkeoRbsx0LOn7NWWN1KMSqUFwdf8wIZU7FQfWpWh8Id8k54
         ZJ6w==
X-Gm-Message-State: AOAM531MeOT5EMPP0kbnzyJJKppNpEbyIcUsTQAlRgHe/RsPpivir20n
        BfveTQMKqIzkBTi/+wUrMsDDFbgmQLG/4XrNENY5ek5nf5VERVElEqjKweNv4+A7K8ID7c2YWH5
        9q562lPwociAzJ9IIDjDeg46byA==
X-Received: by 2002:a17:906:fa12:: with SMTP id lo18mr20047773ejb.354.1607358783581;
        Mon, 07 Dec 2020 08:33:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRh6Xa+5iZaFkMzkShNmnm8HMI1mEJZ43C03cBXKlr6CObJxEgF3paS8CuYV44ij1yPUSsGQ==
X-Received: by 2002:a17:906:fa12:: with SMTP id lo18mr20047758ejb.354.1607358783452;
        Mon, 07 Dec 2020 08:33:03 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id op5sm12801964ejb.43.2020.12.07.08.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:33:02 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     "Eric W . Biederman" <ebiederm@xmission.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/10] ovl: check privs before decoding file handle
Date:   Mon,  7 Dec 2020 17:32:48 +0100
Message-Id: <20201207163255.564116-4-mszeredi@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207163255.564116-1-mszeredi@redhat.com>
References: <20201207163255.564116-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

CAP_DAC_READ_SEARCH is required by open_by_handle_at(2) so check it in
ovl_decode_real_fh() as well to prevent privilege escalation for
unprivileged overlay mounts.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/namei.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a6162c4076db..82a55fdb1e7a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -156,6 +156,9 @@ struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
 	struct dentry *real;
 	int bytes;
 
+	if (!capable(CAP_DAC_READ_SEARCH))
+		return NULL;
+
 	/*
 	 * Make sure that the stored uuid matches the uuid of the lower
 	 * layer where file handle will be decoded.
-- 
2.26.2

