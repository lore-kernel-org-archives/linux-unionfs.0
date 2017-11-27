From: cgxu <cgxu@mykernel.net>
Subject: sync filesystem of overlayfs
Date: Mon, 27 Nov 2017 16:08:59 +0800
Message-ID: <5862C310-F8B9-40AF-826D-BE867CCDA519@mykernel.net>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain;
        charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtpbg62.qq.com ([103.7.29.139]:24277 "EHLO smtpbg64.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751390AbdK0IQJ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 03:16:09 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: suyue@meili-inc.com


Hi,

Recently I found syncfs and umount could not make data consistency in overlayfs. 
I did some investigations and now I know synchronization didn¡¯t directly happen 
in upperdir filesystem during these operations executed in overlayfs.

I'm also confused by below comment in function ovl_sync_fs() in super.c

/* real inodes have already been synced by sync_filesystem(ovl_sb) */

In my understanding sync_filesystem(ovl_sb) can not make real inodes synced
unless delivers real superblock of upperdir filesystem to sync_filesystem(). 

I can¡¯t make sure current implementation is by design or for some other reasons because
sync upperdir filesystem may be a little bit heavy especially in a large filesystem. 
Could anyone give me a hint for this£¿

If this problem needs to be fix, I¡¯ll try to make a patch for review. 



Best Regards,
Chengguang
