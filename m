Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E43C7EE26
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 May 2023 08:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjECIww (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 May 2023 04:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjECIwu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2023 04:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979D744A1
        for <linux-unionfs@vger.kernel.org>; Wed,  3 May 2023 01:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683103920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DuOxmhHvrADxVqyLcYeijglLSxGFgA8WAfOb+tgiEXI=;
        b=G3qO5ijKK85mhfDWpFtImA2cu9Kkc/VgDIE3xXtMvmltoDljeIFciK85wmHs0xa1lq3zOQ
        tQJNmIDwvoyJuAFjaTTQIOes98jWwCKi54q00oukPnYHEOS9dHFLfNugJ4eD23JyRUDDD1
        MWYSIdjVvuuWDTx24nxWav/1QLc/UVE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-n9mWoKKpNYKgccwMC1nnnA-1; Wed, 03 May 2023 04:51:59 -0400
X-MC-Unique: n9mWoKKpNYKgccwMC1nnnA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4edc5d704bbso2760393e87.2
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2023 01:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683103917; x=1685695917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DuOxmhHvrADxVqyLcYeijglLSxGFgA8WAfOb+tgiEXI=;
        b=kr/Ezku/0ye72F8NlNrwZHVnBod8JhTQ5OZDwVfsZSkqYmAZTvuHcboJdN+F4zSNKj
         49aawqABKbBpHw+7xl1LZpfhxslUL8r8za/x+HyH2JT34yTNGkVAD6xuxKk4kPuWuEAc
         hCFV7Q+3RSlxYOi96xLe3tjUKiBbcnZYIJ/j+yiFFuq4g2i0RAJTb+DOXI+EUzdl3fFw
         N35JGEC9PXq1dO3o+ucXQTg00cTwvlj1iGsWAyimsdKl5uP733NKb5jhgjwX53EW8Tlt
         oVvE3dvh+/HJmHFFihc4rhPrxbU3mjhRLLz8j++Tt9deHYKY6Vfkk9tUE+rM82F6QXFV
         DJVA==
X-Gm-Message-State: AC+VfDzYKfQEfjNjSrxDDhzgO9GArWo+FRjVYtUhxgjiQKxb0/19c9Ly
        /YTRvtWgzDnmeYad/xcSMvtsE9BKbMwnSahzb4IQ/eokvSd5l4IMQ/FdK+SebxneZeNG0M2/E2Z
        wrcjaUeW8X3x45iYo8CVKvyv7VA==
X-Received: by 2002:ac2:5a4a:0:b0:4eb:40d4:e0d2 with SMTP id r10-20020ac25a4a000000b004eb40d4e0d2mr685179lfn.38.1683103917773;
        Wed, 03 May 2023 01:51:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5yxUM/3BQQGSn7yGWxkPYM3S0JgZW0405lZebJhguwjx/PTKCM5eqVOOxHUxwVFJOgHb0vvA==
X-Received: by 2002:ac2:5a4a:0:b0:4eb:40d4:e0d2 with SMTP id r10-20020ac25a4a000000b004eb40d4e0d2mr685173lfn.38.1683103917595;
        Wed, 03 May 2023 01:51:57 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id j6-20020ac24546000000b004ed4fa5f20fsm5907089lfm.25.2023.05.03.01.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 01:51:56 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 3/6] ovl: Break out ovl_e_path_lowerdata() from ovl_path_lowerdata()
Date:   Wed,  3 May 2023 10:51:36 +0200
Message-Id: <53ba3af42c7c9cfeaa7d9557ed2daa9363e6f756.1683102959.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1683102959.git.alexl@redhat.com>
References: <cover.1683102959.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This will be needed later when getting the lowerdata path from the
ovl_entry in ovl_lookup() before the dentry is set up.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 1 +
 fs/overlayfs/util.c      | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6ce1c7906bb9..a4867ff97115 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -391,6 +391,7 @@ void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 void ovl_i_path_real(struct inode *inode, struct path *path);
+void ovl_e_path_lowerdata(struct ovl_entry *oe, struct path *path);
 void ovl_e_path_real(struct ovl_fs *ofs, struct ovl_entry *oe,
 		     struct dentry *upperdentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index c32252153e5e..74077ef50bb3 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -222,9 +222,9 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 	}
 }
 
-void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
+void ovl_e_path_lowerdata(struct ovl_entry *oe,
+			  struct path *path)
 {
-	struct ovl_entry *oe = OVL_E(dentry);
 	struct ovl_path *lowerdata = ovl_lowerdata(oe);
 	struct dentry *lowerdata_dentry = ovl_lowerdata_dentry(oe);
 
@@ -242,6 +242,11 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
 	}
 }
 
+void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
+{
+	return ovl_e_path_lowerdata(OVL_E(dentry), path);
+}
+
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 {
 	enum ovl_path_type type = ovl_path_type(dentry);
-- 
2.39.2

