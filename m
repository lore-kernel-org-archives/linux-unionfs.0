From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/3] ovl: fix IS_APPEND() checks
Date: Fri,  7 Apr 2017 12:01:38 +0300
Message-ID: <1491555701-16608-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33803 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754675AbdDGJBi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 05:01:38 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

This series fixes the append-only violations found by the new
xfstest overlay/030.

I got rid of the wrong patch to convert sb_start_write() to
file_start_write() and moved the open flag checks into
ovl_d_real().

Amir.

v2:
- move open check to ovl_d_real()
- discard wrong patch to file_start_write() in ftruncate()

v1:
- fix checks in [f]truncate and vfs_open()

Amir Goldstein (3):
  vfs: ftruncate check IS_APPEND() on real inode
  vfs: truncate check IS_APPEND() on real inode
  ovl: check IS_APPEND() on real upper inode

 fs/open.c            | 20 ++++++++++----------
 fs/overlayfs/super.c | 30 +++++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 13 deletions(-)

-- 
2.7.4
