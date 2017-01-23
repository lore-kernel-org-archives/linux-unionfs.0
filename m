From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH v2 0/3] overlayfs: support freeze/thaw/syncfs
Date: Mon, 23 Jan 2017 14:32:19 +0200
Message-ID: <1485174742-15866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36083 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751206AbdAWMdM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Jan 2017 07:33:12 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

Take #2 for overlayfs freeze.

Patch #2 I am quite confident is a bug fix and I have written an
xfs specific test for it.

Patch #1 is a POC of what I think overlay freezing should be like,
although we may want to optimize it with some file flag?

Patch #3 just enables overlayfs freezing with NOP freeze_fs()
unfreeze_fs() operations, so I could test it.  It behaves as
expected - overlay and underlying fs can be frozen independently
and writes continue when both fs are thawed.

I believe that mmap freeze protection is not covered, although I am
not sure exactly how it works?

Am I missing anything else?

Amir Goldstein (3):
  vfs: freeze protect overlay inode on file_start_write()
  ovl: properly implement sync_filesystem()
  ovl: support freeze/thaw super

 fs/overlayfs/super.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/fs.h   | 17 ++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletion(-)

-- 
2.7.4
