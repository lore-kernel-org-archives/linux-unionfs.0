Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AD8C4708B
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 14:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8344F610A0
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 14:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhE0OHl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 May 2021 10:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbhE0OHl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 May 2021 10:07:41 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AA3C061760
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 07:06:08 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id h3so280159wmq.3
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 07:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OeojCA8oYflsesMUKZSZCLdUW40LZrn+KXsF0tYcHGw=;
        b=utGA4ubMmVJw9z1BRYPZ50gnp1Sph/N14KVcQ5qlnCCnPLeW/Et2e4hZ+bSZUNwwI7
         k1Ki1lhaDoRoeKBifDLl16eUc7a/qiAT5+3RYeix8SL/2RT03Xh6kL4z4kWHw+rRliy5
         r//X9TaUCpUhed4bQPcXEtvPe3FwAiMYCkrefMp5L7zGB8NJN9hPikD9ZliQNHaUp1As
         Iy1I+QmwYAgsa5fssHlM5/nd2fineqGbeAw5no9fOAodV9Pt1DSWSXXdkThuXZhF6Hqz
         vxK0nDMq7KzO8wfqcNdomDI+YTekAyW6mfsbwWVCDEPougPQeSIXs5c5EzZDJ6p+LVUr
         XK7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OeojCA8oYflsesMUKZSZCLdUW40LZrn+KXsF0tYcHGw=;
        b=Ibra8NvN89s63zK0bwsJNtaxe5+9kwI8vgkHJueh5ZOzL16mZJrd+UPzDSCKNTDHap
         k/xTfD9aRjnqnyhudYwWHD7VEZbTDFvxPV7KXdloA8IWDP1PU7tfl6QKUg+GuAMD5mre
         4ysaKiCATU5N7Pqxp3IFFqi7mvTHpYXWA0jnQdtCM3plBn51MeMSJ61d12BnQ+cVIEw/
         HWxJiBt8wt3+VQEfKWbBUtVyZ0rNWiweLuqXtwXBLwzFZAmmWyPcRe0pM6wCWsob84fL
         nTPECwhx+Qjfon0G+Nuxq37U/tlHcpuuAX/VUI7Cak+WzTbZZGyUL6EmFMwgqaQf92Rc
         q+TQ==
X-Gm-Message-State: AOAM531yna4Z1XVhLL2Fjsce7F0SWvmrV56tnG4qbJZk40G8KuOgBcWE
        BjqH2F9W1bNEWgbcb6/A7vw=
X-Google-Smtp-Source: ABdhPJwcLrxrBCK0OPnxdcOPNTg+HJC1kHrIGr30T5CWYhNPObF88i/xLnglVbN9SpawPzwVqPsNtw==
X-Received: by 2002:a7b:c4d0:: with SMTP id g16mr3642600wmk.16.1622124366413;
        Thu, 27 May 2021 07:06:06 -0700 (PDT)
Received: from uvv-2004-vm.localdomain (dslb-002-205-242-053.002.205.pools.vodafone-ip.de. [2.205.242.53])
        by smtp.gmail.com with ESMTPSA id x24sm10582754wmi.13.2021.05.27.07.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 07:06:05 -0700 (PDT)
From:   Vyacheslav Yurkov <uvv.mail@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Subject: [PATCH v2 3/3] ovl: do not set overlay.opaque for new directories
Date:   Thu, 27 May 2021 16:05:34 +0200
Message-Id: <20210527140534.107607-3-uvv.mail@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527140534.107607-1-uvv.mail@gmail.com>
References: <20210527140534.107607-1-uvv.mail@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>

Disable optimizations if user opted-in for any of extended features.
If optimization is enabled, it breaks existing use case when a lower layer
directory appears after directory was created on a merged layer. If
overlay.opaque is applied, new files on lower layer are not visible.

Consider the following scenario:
- /lower and /upper are mounted to /merged
- directory /merged/new-dir is created with a file test1
- overlay is unmounted
- directory /lower/new-dir is created with a file test2
- overlay is mounted again

If opaque is applied by default, file test2 is not going to be visible
without explicitly clearing the overlay.opaque attribute

Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
---
 fs/overlayfs/dir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 93efe7048a77..03a22954fe61 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -320,6 +320,7 @@ static bool ovl_type_origin(struct dentry *dentry)
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 			    struct ovl_cattr *attr)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
 	struct inode *udir = upperdir->d_inode;
 	struct dentry *newdentry;
@@ -338,7 +339,8 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(newdentry))
 		goto out_unlock;
 
-	if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry)) {
+	if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry) &&
+	    !ovl_allow_offline_changes(ofs)) {
 		/* Setting opaque here is just an optimization, allow to fail */
 		ovl_set_opaque(dentry, newdentry);
 	}
-- 
2.25.1

