Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCB2EB64DD
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Jul 2023 15:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjGTPij (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 11:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjGTPiX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Jul 2023 11:38:23 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120143A9C
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Jul 2023 08:37:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3fbc77e76abso7802925e9.1
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Jul 2023 08:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689867457; x=1690472257;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YluPpjwNgg+iyA+dz2M/Nfcb7a7bN1snX7l9da4TjVU=;
        b=b6dUCCfzAmvL9F8IegihDt2r6LJvv8sIJiIuEj88XiNt8kLUiPhPSBbk0p1wH7ZKeU
         WCPOXvcQzYxkgywD2aoNdnS2GiANQKOlSEoLGeSw0hGe1RxQl3irDljuO4DU1nEQGJzZ
         CeR5aE4r3XQV+v/QtHiBSWy2SO1oFFgdD7JgYLqMaZ96TmQMEVSOvAK4ZHOs6/APEMhR
         BKxt06rgKGt2WPsot38Dz9SxY1rCrZ/qh0+CjKE357grHDc+UTcbdArFmpX6d9K4eHki
         1c/7lW7GyJRPzkqQHooi0YNuvsxqgwhLUwnsSADMRDto8XxEGzHMGbjJzimYkAHLrV6t
         Esow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689867457; x=1690472257;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YluPpjwNgg+iyA+dz2M/Nfcb7a7bN1snX7l9da4TjVU=;
        b=P3iVx543m4JHux47XjYbs1HICjxISUl7AnMpr8Pu8uSntJ5d6/p4W3TKMP7LjGUC53
         t3LhYnraIFcpuGdyT7aouqXdKwNtTt9NAqNpq3y9LRJG2/yU7YyMox3F1FV14aQo2rQN
         5VcNIlwjrA2ZNUhpD2by1ihn1tr6MdK+g5AVXzSQYvBiMzHMigfZnM0uNbbffuHdK+vn
         YcokBh017MheMUltkLTbUt3BGbw/8pn1AWPzkQ92g383zdI8XnhzQJMzDDfsqKXYrgn4
         WuIK+WEsS053VZ9EHIGWi10nEpKbNinJHdQuniylehtPiVAWVLUjQdEKE/VmjaGU+xrd
         FLiA==
X-Gm-Message-State: ABy/qLb2XVIn2bldCFawHx2dwrFdJOIOrYn9ZpH0IHT6LVLleJY0QTyd
        f1p/vmEdzVTfpPZ/wP7nSd8=
X-Google-Smtp-Source: APBJJlHK35DDi9TMMrnOjWT2OimoZxdjNTs9lfBWkkgQJ20S6hjx4Bu5rooQvHgp+LxU1ihYNrvEKQ==
X-Received: by 2002:a05:600c:b50:b0:3fc:a8:dc3c with SMTP id k16-20020a05600c0b5000b003fc00a8dc3cmr4519934wmr.37.1689867456675;
        Thu, 20 Jul 2023 08:37:36 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id q14-20020a1cf30e000000b003fbe561f6a3sm4235715wmq.37.2023.07.20.08.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 08:37:36 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Subject: [PATCH 0/2] overlayfs lock ordering changes
Date:   Thu, 20 Jul 2023 18:37:29 +0300
Message-Id: <20230720153731.420290-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Miklos,

These prep patches are needed for my start-write-safe series [1].
This is not urgent and the prep patches don't need to be merged
for next cycle, but I think these are good changes regardless,
so wanted to post them for early review - if you like them you can
queue them for 6.6.

It is quite hard to do the review of the locking reorder patch from the
diff itself and I couldn't figure out a better way to split this change.
I've intentionally left some otherwise useless out: goto labels to
make the patch review a bit simper - they could be removed later.

On the good side, lockdep was very tough with me and it easily detected
bugs in the earlier versions of the patches.

Going on vacation. will be back round rc6.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/start-write-safe

Amir Goldstein (2):
  ovl: reorder ovl_want_write() after ovl_inode_lock()
  ovl: avoid lockdep warning with open and llseek of lower file

 fs/overlayfs/copy_up.c | 34 +++++++++++++-------
 fs/overlayfs/dir.c     | 71 ++++++++++++++++++------------------------
 fs/overlayfs/export.c  |  7 +----
 fs/overlayfs/inode.c   | 56 ++++++++++++++++-----------------
 fs/overlayfs/util.c    | 18 +++++++++--
 5 files changed, 97 insertions(+), 89 deletions(-)

-- 
2.34.1

