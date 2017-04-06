From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] ovl: fix IS_APPEND() checks
Date: Thu,  6 Apr 2017 11:13:45 +0300
Message-ID: <1491466429-30333-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36757 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbdDFINp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 04:13:45 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

This series fixes the append-only violations found by the new
xfstest overlay/030.

I did it to see how bad it would be compared to propagating
the S_APPEND/S_IMMUTABLE flags to overlay inode.

IMO, the [f]truncate patches look ok, but the last vfs_open()
patch less so (?).

Do you think we can get away without propagating the flags?
If getflags()/setflags() were standard vfs ops, we could have
handled this nicer...
Those "fs specific flags" have long been a standard, so perhaps
its time to make the setflags/getflags a vfs api?

Amir.

Amir Goldstein (4):
  vfs: ftruncate freeze protect backing inode
  vfs: ftruncate check IS_APPEND() on backing inode
  vfs: truncate check IS_APPEND() on backing inode
  vfs: open check IS_APPEND() on backing inode

 fs/open.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

-- 
2.7.4
