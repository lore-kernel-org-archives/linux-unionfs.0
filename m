From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/3] ovl: consistent st_ino/d_ino
Date: Fri, 19 May 2017 18:27:18 +0300
Message-ID: <1495207641-11213-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34032 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdESP1V (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 19 May 2017 11:27:21 -0400
Received: by mail-wm0-f66.google.com with SMTP id d127so18926198wmf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 19 May 2017 08:27:21 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

I choose to fork a helper lookup_one_len_noperm().

Hope you find this a good choice.

Amir.

Amir Goldstein (3):
  vfs: factor out lookup_one_len_init()
  vfs: add helper lookup_one_len_noperm()
  ovl: constant d_ino across copy up

 fs/namei.c               | 117 +++++++++++++++++++++++++++--------------------
 fs/overlayfs/namei.c     |   7 ++-
 fs/overlayfs/overlayfs.h |   2 +-
 fs/overlayfs/readdir.c   | 115 +++++++++++++++++++++++++++++++++++++++++++---
 include/linux/namei.h    |   1 +
 5 files changed, 182 insertions(+), 60 deletions(-)

-- 
2.7.4
