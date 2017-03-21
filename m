From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 0/2] ovl: make room to store state flags in dentry
Date: Tue, 21 Mar 2017 12:16:43 -0400
Message-ID: <1490113005-28787-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36277 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757096AbdCUQQq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Mar 2017 12:16:46 -0400
Received: by mail-qk0-f181.google.com with SMTP id 1so138651076qkl.3
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Mar 2017 09:16:45 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

This is a prep work I have done some time ago to make room
for some extra state flags on the dentry.

I converted the boolean opaque field to a flag as an example.

An example for more flags could be:
- this is a copy up file which needs to get st_ino from lower
- this is an O_TEMP copy up from open for read that needs to be
  linked to upper dir on open for write

Amir Goldstein (2):
  ovl: store path type in dentry
  ovl: cram opaque boolean into type flags

 fs/overlayfs/namei.c     | 10 ++++++----
 fs/overlayfs/overlayfs.h |  3 +++
 fs/overlayfs/ovl_entry.h |  4 +++-
 fs/overlayfs/super.c     |  1 +
 fs/overlayfs/util.c      | 25 +++++++++++++++----------
 5 files changed, 28 insertions(+), 15 deletions(-)

-- 
2.7.4
