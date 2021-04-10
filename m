Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4558C433B4
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 09:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9124260233
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 09:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhDJJSK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Apr 2021 05:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhDJJSK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Apr 2021 05:18:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D64C061762
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 02:17:54 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id 12so7870305wrz.7
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 02:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PTS6I2Z3YyPwgrSnClFwuuSO4VXcQIPK1TpxT+DCZZQ=;
        b=b1gRYrfdaD8oiWH5kHC6e2WTs+VuHTVwvATo1AWzA8KRwperih/5lP6Ao1IfspiHMv
         nmZAQJalvp6MbrKVYezxq5DAR+m+/xuPS9eg7Xa/z8trFBJCpP97dVJKyWz56uJLuoBn
         dWBGH6Iu+tJUpIkotcw/qttuL9/o/Kbf5CBYCUiIOiGcbzrJwUaJk0uzEPS+Dsb5G5KA
         1F4NmmCDfZ7mqFB22wrDwcgqJJ5Ruk/XSfS/yUX4QV1OLeWtRS6/9TL6eLPhrZuabf9E
         mTLSPIaWek7ZUXdaOAUIz9tQc9WQW7Bhp6bMFPpWXj+YrHwOamMZpKz/2fGkWHqhfgmR
         BJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PTS6I2Z3YyPwgrSnClFwuuSO4VXcQIPK1TpxT+DCZZQ=;
        b=EKTkj3Uq3P02ySlo+MXEr9Sz1iVBNmyFJnr0JJKa0XlYpigX2mP4itZGjX+3v7uKqt
         Y8xp8c2ZuYbbfSQ8JZYWtb9QyG5apGn4Lx7rolAra/x3r800W9jRj292V/FKDLxuFcLx
         Q5ikYQwq9qquh9eSZ2lCTivtq6V/8gHl0faq94Kwb6JbXpG8A93tCu7JOPejZskFqWDj
         YZfDjA53vE5NvnX4OvE1uY1Vg223h6KLheFm5r7fjAvSH7I/h0Y6WhSwabEvoLZIF4fL
         aJlaysHYiW6qI5hTTDgvZnOgmCOJrGXHvpJ4b9/ayVdUcbEWRwSijUu4OlJETt0a9Ehc
         9JTg==
X-Gm-Message-State: AOAM531ugGX/9mNrCG2Eq91C9jLW0tPDdFzUlWnZXimWlCkvfsJroBSk
        DO44JEPViB2D9ophixhh5MI=
X-Google-Smtp-Source: ABdhPJwZdBpL+q1ubZgnKVJp5OxSsq8zQ6SuxN0k9HaO+aNDE27jB65OmjRMWiuI5h+WEcEleKXRog==
X-Received: by 2002:adf:f608:: with SMTP id t8mr21671134wrp.104.1618046273074;
        Sat, 10 Apr 2021 02:17:53 -0700 (PDT)
Received: from localhost.localdomain ([141.226.241.101])
        by smtp.gmail.com with ESMTPSA id s8sm8002729wrn.97.2021.04.10.02.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 02:17:52 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chris Murphy <lists@colorremedies.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: add debug print to ovl_do_getxattr()
Date:   Sat, 10 Apr 2021 12:17:50 +0300
Message-Id: <20210410091750.1858145-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

It was the only ovl_do helper missing it.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2322f854533c..d1e08d804207 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -186,7 +186,12 @@ static inline ssize_t ovl_do_getxattr(struct ovl_fs *ofs, struct dentry *dentry,
 				      size_t size)
 {
 	const char *name = ovl_xattr(ofs, ox);
-	return vfs_getxattr(&init_user_ns, dentry, name, value, size);
+	int err = vfs_getxattr(&init_user_ns, dentry, name, value, size);
+	int len = (value && err > 0) ? err : 0;
+
+	pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu, 0) = %i\n",
+		 dentry, name, min(len, 48), value, size, err);
+	return err;
 }
 
 static inline int ovl_do_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
-- 
2.30.0

