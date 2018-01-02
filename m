From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 0/2] Updating overlay inode i_mtime for nfsd
Date: Tue,  2 Jan 2018 14:26:47 +0200
Message-ID: <1514896009-11468-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34821 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752380AbeABM0C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jan 2018 07:26:02 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Jeff, Bruce,

These RFC patches fix an issue I found when running nfstest_posix
over NFS exported overlayfs.

I am posting these separately from (soon to be posted) overlayfs NFS
export support patches to get your inputs about the preferred way for
a fix.

The 1st patch is a proposal to fix overlay inode i_mtime on inode
modification. This fix is incomplete w.r.t nfstest_posix test failures.
The 2nd patch more or less reverts the 1st patch in favor of updating
overlay inode i_mtime only when nfsd would care. At least as far as
nfstest_posix is concerned this fix is complete.

I lean towards the 2nd fix, but wasn't sure, so posting both suggestions.
Another option would be to call vfs_getattr() from lease_get_mtime(),
which will get the correct i_mtime for overlayfs (upper inode i_mtime),
but wasn't sure if this is a viable option for nfsd.

Would appreciate your thoughts about the issue and about the proposed fix.

Thanks,
Amir.

Amir Goldstein (2):
  vfs: update overlay inode times on write
  vfs: update overlay inode times on lease_get_mtime()

 fs/inode.c    | 15 ++++++++++++---
 fs/internal.h |  1 +
 fs/locks.c    | 12 +++++++++++-
 3 files changed, 24 insertions(+), 4 deletions(-)

-- 
2.7.4
