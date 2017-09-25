From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] assorted overlayfs fixes for v4.14-rc3
Date: Mon, 25 Sep 2017 12:36:17 +0300
Message-ID: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33702 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932817AbdIYJfv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2017 05:35:51 -0400
Received: by mail-wr0-f193.google.com with SMTP id b9so1615445wra.0
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2017 02:35:50 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

Following are 1 fix for a commit in v4.14-rc1
and 3 fixes for index error paths in v4.13.

Amir.

Amir Goldstein (4):
  ovl: fix may_write_real() for overlayfs directories
  ovl: fix error value printed in ovl_lookup_index()
  ovl: fix dput() of ERR_PTR in ovl_cleanup_index()
  ovl: fix dentry leak in ovl_indexdir_cleanup()

 fs/namespace.c         | 4 +++-
 fs/overlayfs/namei.c   | 1 +
 fs/overlayfs/readdir.c | 6 ++++--
 fs/overlayfs/util.c    | 9 ++++++---
 4 files changed, 14 insertions(+), 6 deletions(-)

-- 
2.7.4
