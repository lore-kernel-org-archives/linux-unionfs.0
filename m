Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48746C4361B
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266D522CAD
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbhASQX4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:23:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731473AbhASQXl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Jan 2021 11:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611073332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0d34g0cQgU3pUUMcwk4mh+TGyc8uh3BJ8u4e70DhUc=;
        b=hCjeZ8FtjvbHI8rOMKH/SyRPqv4u9E+F4P8VpZsaLSb+Ial9VkQsyZTVpF6ZppDeDsWz/4
        Kb9o1naBZtCTA+lSZzdy2JD8eDyNS49YXWo+p0A1mhfqP6qfFweYWSJLhlvPT81JR1/LWX
        e+yE2BV2YaAu9Q/FMY8HyUTikFU2kEU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-nBC7beW7PV6_NFdGymZWIg-1; Tue, 19 Jan 2021 11:22:11 -0500
X-MC-Unique: nBC7beW7PV6_NFdGymZWIg-1
Received: by mail-ej1-f72.google.com with SMTP id gt18so2063094ejb.18
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jan 2021 08:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e0d34g0cQgU3pUUMcwk4mh+TGyc8uh3BJ8u4e70DhUc=;
        b=m1t3EgDCm6B3l/KNagyY18LwXbEEtlugSVALZYipy74IfsLIufmdaLdERSGiinzXFc
         /0sR5IMQgPW6fxvVZOBX8HEWfeLkRu+xSlNuJHtPGgXEb8f5mbkDLF9eUFL6MQrMbS9p
         PkCRUxAOq+57+ykezJj4BD+XOiskZUv3OeJ0zB7rgmcm8XuVfFexs/CHK4R9eYIBtp/w
         7/V90MzD22aadg8UrcycAhXfhEcJLWTuMMRV41RbvekRgm2d5TcoHEhSY3G8V4iaHyDo
         9NJ6I/OMmrL4NC+195MXG5T3nXeUKJ3Z0iT8xyWpsUnNVibiUbdv3Cms6F5Gl1RNOZKG
         Lmfw==
X-Gm-Message-State: AOAM533sXRr8MRietmfmYqWhsEQR975DqioI07rDEIz/W54DKfjbz5Wc
        Hj6rNNa/cxpufA80iPhsVtSCFE8jRVl5sexe8qcJAbF5RIFrjo44PWcvSuXhQTQ6iZQhROV/itf
        xhJU5bMgWnbAykT6w2dNEDM6fsA==
X-Received: by 2002:a17:906:f18c:: with SMTP id gs12mr3548356ejb.422.1611073329718;
        Tue, 19 Jan 2021 08:22:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywCQ8WKQ39LO/s3JpVfU0aRZ0r35Z4MSS7hLGLYpfP7iPEPDe7nnjVqIqyXKcESLiLAw5Qaw==
X-Received: by 2002:a17:906:f18c:: with SMTP id gs12mr3548339ejb.422.1611073329537;
        Tue, 19 Jan 2021 08:22:09 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id f22sm2168066eje.34.2021.01.19.08.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:22:09 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     "Eric W . Biederman" <ebiederm@xmission.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 1/2] ecryptfs: fix uid translation for setxattr on security.capability
Date:   Tue, 19 Jan 2021 17:22:03 +0100
Message-Id: <20210119162204.2081137-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119162204.2081137-1-mszeredi@redhat.com>
References: <20210119162204.2081137-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Prior to commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap() call into
vfs_setxattr()") the translation of nscap->rootid did not take stacked
filesystems (overlayfs and ecryptfs) into account.

That patch fixed the overlay case, but made the ecryptfs case worse.

Restore old the behavior for ecryptfs that existed before the overlayfs
fix.  This does not fix ecryptfs's handling of complex user namespace
setups, but it does make sure existing setups don't regress.

Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Tyler Hicks <code@tyhicks.com>
Fixes: 7c03e2cda4a5 ("vfs: move cap_convert_nscap() call into vfs_setxattr()")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/ecryptfs/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index e23752d9a79f..58d0f7187997 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1016,15 +1016,19 @@ ecryptfs_setxattr(struct dentry *dentry, struct inode *inode,
 {
 	int rc;
 	struct dentry *lower_dentry;
+	struct inode *lower_inode;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	if (!(d_inode(lower_dentry)->i_opflags & IOP_XATTR)) {
+	lower_inode = d_inode(lower_dentry);
+	if (!(lower_inode->i_opflags & IOP_XATTR)) {
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
-	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
+	inode_lock(lower_inode);
+	rc = __vfs_setxattr_locked(lower_dentry, name, value, size, flags, NULL);
+	inode_unlock(lower_inode);
 	if (!rc && inode)
-		fsstack_copy_attr_all(inode, d_inode(lower_dentry));
+		fsstack_copy_attr_all(inode, lower_inode);
 out:
 	return rc;
 }
-- 
2.26.2

