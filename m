From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/2] Reduce direct access of nfsd to inode->i_mtime
Date: Wed,  3 Jan 2018 17:14:33 +0200
Message-ID: <1514992475-8142-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:43204 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752662AbeACPNq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 10:13:46 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Bruce, Jeff,

These patches fix issues I found when running nfstest_posix
over NFS exported overlayfs. The issues stem from the fact that
the overlay inode i_mtime is often out of date w.r.t stat->mtime.

I am posting these separately from (soon to be posted) overlayfs NFS
export support patches to get your ACK, or, since those changes are
independent from overlayfs, you could carry them through your tree.

Please note that this does not eliminate all direct access of nfsd
to inode->i_mtime, but only the low hanging access sites, which also
happen to be the cases that matter to overlayfs.

Changes since v1 (RFC):
- Use stat->mtime times instead of inode->i_mtime where relevant,
  so overlayfs doesn't need to be special cased

Thanks,
Amir.

Amir Goldstein (2):
  nfsd: encode stat->mtime for getattr instead of inode->i_mtime
  nfsd: store stat times in fill_pre_wcc() instead of inode times

 fs/locks.c        |  6 ++----
 fs/nfsd/nfs3xdr.c | 31 ++++++++++++++++++++++++++++++-
 fs/nfsd/nfs4xdr.c |  2 +-
 fs/nfsd/nfsfh.h   | 28 ++++++----------------------
 fs/nfsd/nfsxdr.c  |  1 +
 5 files changed, 40 insertions(+), 28 deletions(-)

-- 
2.7.4
