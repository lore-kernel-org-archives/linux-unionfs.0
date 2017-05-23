From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] overlayfs multiple mount protection
Date: Tue, 23 May 2017 12:50:31 +0300
Message-ID: <1495533033-22367-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34031 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934072AbdEWJuW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 May 2017 05:50:22 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

I've implemented verification that lower root dir matches the origin file
handle stored at upper root dir with the verify_lower mount option [1].

As you correctly noted, before we move on to verifying that upper dir
'belongs to' lower dir and that index dir 'belongs to' upper dir for the
case of mounting not at the same time, we first need to cover the case of
mount at the same time.

This patch set provides protection against reuse of upperdir and workdir
by two different overlay instances at the same time, e.g.:

root@kvm-xfstests:~/unionmount-testsuite# mount -t overlay
overlay on /mnt type overlay (rw,noatime,lowerdir=/lower,upperdir=/upper/0,workdir=/upper/work)
root@kvm-xfstests:~/unionmount-testsuite# mount -t overlay overlay /backup/ -o rw,noatime,lowerdir=/lower,upperdir=/upper/0,workdir=/upper/work
overlayfs: upperdir in-use by another overlay mount?
mount: overlay is already mounted or /backup busy
       overlay is already mounted on /mnt
root@kvm-xfstests:~/unionmount-testsuite# mkdir /upper/1
root@kvm-xfstests:~/unionmount-testsuite# mount -t overlay overlay /snapshot/ -o rw,noatime,lowerdir=/lower,upperdir=/upper/1,workdir=/upper/work
overlayfs: workdir in-use by another overlay mount?
mount: overlay is already mounted or /snapshot busy
       overlay is already mounted on /mnt

It also provides protection against removal of workdir just after mount,
which would have caused failures to copy up:

root@kvm-xfstests:~/unionmount-testsuite# rmdir /upper/work/work/
rmdir: failed to remove '/upper/work/work/': Device or resource busy

[1] https://github.com/amir73il/linux/commits/ovl-verify-dir

Amir Goldstein (2):
  vfs: introduce inode 'inuse' lock
  ovl: get exclusive ownership on upper/work dirs

 fs/btrfs/ioctl.c     |  3 +++
 fs/inode.c           | 40 ++++++++++++++++++++++++++++++
 fs/namei.c           |  3 +++
 fs/overlayfs/super.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/fs.h   | 16 ++++++++++++
 5 files changed, 129 insertions(+), 3 deletions(-)

-- 
2.7.4
