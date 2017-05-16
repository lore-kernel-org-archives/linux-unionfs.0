From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/3] ovl: corner cases of upper with no xattr support
Date: Wed, 17 May 2017 00:12:38 +0300
Message-ID: <1494969161-30267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36164 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753002AbdEPVMa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 17:12:30 -0400
Received: by mail-wr0-f193.google.com with SMTP id v42so15377879wrc.3
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2017 14:12:30 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

Found one more bug in ovl_set_impure() patch besides the noxattr case.

Added the mount time check and piggy backed the noxattr checks for
setting opaque and redirect.

Checked that all cases work as expected with and without CONFIG_TMPFS_XATTR.

Amir.

Amir Goldstein (3):
  ovl: fix wrong error handling of ovl_set_impure()
  ovl: check on mount time if upper fs supports setting xattr
  ovl: handle rename when upper doesn't supports xattr

 fs/overlayfs/copy_up.c   | 34 ++++++++++++++++++++++++----------
 fs/overlayfs/dir.c       | 33 +++++++++++++++++++++++++--------
 fs/overlayfs/overlayfs.h |  5 +++++
 fs/overlayfs/ovl_entry.h |  2 +-
 fs/overlayfs/super.c     |  6 ++++++
 fs/overlayfs/util.c      |  9 ++++++++-
 6 files changed, 69 insertions(+), 20 deletions(-)

-- 
2.7.4
