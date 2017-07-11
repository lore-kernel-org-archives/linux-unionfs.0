From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 00/10] overlayfs assorted fixes for v4.13
Date: Tue, 11 Jul 2017 15:58:33 +0300
Message-ID: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34426 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754695AbdGKM6g (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 08:58:36 -0400
Received: by mail-lf0-f68.google.com with SMTP id g21so14382877lfk.1
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 05:58:35 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

This is a collection of fixes on top of current overlayfs-next.
None of the fixes are urgent for -rc1, so up to you.
Also wanted to remind you that the top commit of overlayfs-next
is missing your s-o-b.

Patch 1 is a fix for an oversight from v4.12.
Patch 2 is a fix for error handing from v4.7.
Patches 3-7 are various fixes to index=on,ro mount.
Patches 8-10 are forward compat fixes for when index dir
will be used for NFS export.

Specifically, patches 9-10 introduce a behavior change in the
case of changes to lower layer (rename or delete of lower dir).
The new behavior is to verify origin fh and try to decode it
if verification fails (overlayfs.txt updated).

This change in needed for snapshots and I argue in the commit
message of patch 10 why it is needed for indexing of directories.
I admit that the argument is not rigorous, but since the behavior of
changes to lower layer is documented as "undefined", I recon you
don't really mind if we change it for index=on.

The rational of making this change in v4.13 as opposed to when
directory indexing is implemented, is that index=on already introduces
a behavior change related to copying layers, so IMO it is better to
introduce all those behavior changes together on index=on.

Thanks,
Amir.

Amir Goldstein (10):
  ovl: mark parent impure on ovl_link()
  ovl: fix random return value on mount
  ovl: fix origin verification of index dir
  ovl: remove unneeded check for IS_ERR()
  ovl: suppress file handle support warnings on read-only mount
  ovl: force read-only mount with no index dir
  ovl: mount overlay read-only on failure to verify index dir
  ovl: do not cleanup directory and whiteout index entries
  ovl: verify origin of merge dir lower
  ovl: follow decoded origin file handle of merge dir

 Documentation/filesystems/overlayfs.txt | 20 +++++++++++
 fs/dcache.c                             |  1 +
 fs/overlayfs/copy_up.c                  |  4 +--
 fs/overlayfs/dir.c                      | 20 ++++++++---
 fs/overlayfs/namei.c                    | 63 +++++++++++++++++++++++++++++----
 fs/overlayfs/overlayfs.h                |  5 +--
 fs/overlayfs/super.c                    | 35 +++++++++---------
 fs/overlayfs/util.c                     |  6 ++--
 8 files changed, 118 insertions(+), 36 deletions(-)

-- 
2.7.4
