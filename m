From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 0/3] Overlayfs fixes for exposed whiteouts
Date: Tue, 31 Oct 2017 23:45:47 +0200
Message-ID: <1509486350-21362-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43970 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932584AbdJaVpK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 17:45:10 -0400
Received: by mail-wr0-f195.google.com with SMTP id w105so354156wrc.0
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 14:45:10 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Miklos,

Let's call my previous version v5 (Zhangyi's last post was v4).

Changes since v5:
- Split ovl_check_empty_and_clear() changes from bug fix patch
- Cache "origin" xattr of non-merge dir in inode flag OVL_WHITEOUTS
  (OVL_ORIGIN would have been too confusing)
- Replace layer idx with is_upper boolean

I tested these changes with upstream xfstest overlay/031 by Zhangyi.
Pushed to ovl-whiteouts branch [1] and rebased the non-samefs patches
on top of it [2].

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-whiteouts
[1] https://github.com/amir73il/linux/commits/overlayfs-devel

Amir Goldstein (3):
  ovl: no direct iteration for dir with origin xattr
  ovl: simplify ovl_check_empty_and_clear()
  ovl: fix rmdir problem on non-merge dir with origin xattr

 fs/overlayfs/dir.c       | 18 ++++++++++------
 fs/overlayfs/inode.c     |  5 +++++
 fs/overlayfs/overlayfs.h |  4 ++++
 fs/overlayfs/readdir.c   | 56 ++++++++++++++++++++++++++++++++++++++----------
 fs/overlayfs/util.c      | 13 +++++++++++
 5 files changed, 79 insertions(+), 17 deletions(-)

-- 
2.7.4
