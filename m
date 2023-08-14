Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E1AC04A6A
	for <linux-unionfs@archiver.kernel.org>; Mon, 14 Aug 2023 14:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjHNOFx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 14 Aug 2023 10:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjHNOFY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 Aug 2023 10:05:24 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099C310D0
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 07:05:24 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3fe4b95c371so25324945e9.1
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 07:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692021922; x=1692626722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IOOr5QYnNLog8tvUu7SLUAFImKdABufBXJK7L+ZIumQ=;
        b=lhqnSUM4uIwMxXSk1zSrFNZtFGJOarLfg8TzqCzPjj63qUk339vYftnXfmxQ9fiW9Z
         XUWhxqgT8BCgg1IqlCP/Lcn6RggQCnPaY0RH+43N0nuYhT29q7G0pbkTPPtqeff+HdKl
         JGKcQu78TOnB6rmufbcG2Tj3gm4jeXCY51qQcIkmW7b5cCTsQfrJ0B4MLkvtxRk3lUDe
         R5qXXbMrt7LrQE5lfb/nRHLLKcKdkOYxvd7g+K3Q1VZCovGr+NA8Edjaj32v1x5t3RLO
         XKe7MpAYIlYhZNrP4zRajOEPIHuH2/llEnpdgrHjnpn7zPzFQE7SWlAeVvp+n3UTAvhb
         fYOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692021922; x=1692626722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IOOr5QYnNLog8tvUu7SLUAFImKdABufBXJK7L+ZIumQ=;
        b=QjDMstgkKLXTofdtF9c2x5bgTYbKZxMmNfpHkQw4AqsSDwPt/w2Uz6f+vq1IrEHN6x
         Mc3gbU4GmLAu2J2xfPRsM18nQmV9hbj3ou0cNVokKn75xFnlBzHcmXt0Cu8PlF+3N4A+
         FHNy7cc5nFX3U2mz2xpg1xAEdddGgClXnOxfqaqS/cH99g5K302MlbOx1oS7yTaYmILX
         Gc22PDjX0La/A21hzk+FeiSmV5E8fZeyvtrDZnSRHJtjvhZoLFd5wWA9iSu/Xe2tC9QS
         oIjn01SGLesXvdlng7roSyWjRmP9IsWg4v04EXz/eSo1rRmIN6vimGia1UzqEN61ikDs
         2Dyg==
X-Gm-Message-State: AOJu0Yw8tWaSYSI0yqHwU+qq7Lb7848U8lYHR/BKB7nC4V6Rfk1vHPSd
        J8zhvo0gBtkUukX3Tu9v9SSXSfZxNxM=
X-Google-Smtp-Source: AGHT+IEyLMt8V7pBX7j3nsnZ/adfLOJFxW2+3VefGpdZXu+ZWqvZhtx4uIeq3KjxyLc1n/amwud4Fw==
X-Received: by 2002:a05:600c:285:b0:3fe:1c57:3be with SMTP id 5-20020a05600c028500b003fe1c5703bemr10443658wmk.8.1692021922264;
        Mon, 14 Aug 2023 07:05:22 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b003142ea7a661sm14609901wrr.21.2023.08.14.07.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 07:05:21 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 0/3] overlayfs lock ordering changes
Date:   Mon, 14 Aug 2023 17:05:15 +0300
Message-Id: <20230814140518.763674-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Miklos,

These patches are needed for my start-write-safe series [1].
I think that at least patch 3 fixes a real bug.

Thanks,
Amir.

Changes since v1:
- Breakup the large ovl_want_write() transaction in copy up
- Add fix to possible deadlock with encode lower ovl fh

[1] https://github.com/amir73il/linux/commits/start-write-safe

Amir Goldstein (3):
  ovl: reorder ovl_want_write() after ovl_inode_lock()
  ovl: do not open/llseek lower file with upper sb_writers held
  ovl: do not encode lower fh with upper sb_writers held

 fs/overlayfs/copy_up.c   | 195 ++++++++++++++++++++++++++-------------
 fs/overlayfs/dir.c       |  71 +++++++-------
 fs/overlayfs/export.c    |   7 +-
 fs/overlayfs/inode.c     |  56 ++++++-----
 fs/overlayfs/namei.c     |  37 ++++++--
 fs/overlayfs/overlayfs.h |  26 ++++--
 fs/overlayfs/super.c     |  20 ++--
 fs/overlayfs/util.c      |  16 ++++
 8 files changed, 268 insertions(+), 160 deletions(-)

-- 
2.34.1

