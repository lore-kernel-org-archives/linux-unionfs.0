From: Eric Jones <ejones@cray.com>
Subject: BUG? Missing dput() in ovl_permissions().
Date: Tue, 16 Feb 2016 12:00:59 -0800
Message-ID: <20160216200059.GH30731@cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [68.232.143.164] ([68.232.143.164]:14510 "EHLO
	esa2.cray.iphmx.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbcBPUCQ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 16 Feb 2016 15:02:16 -0500
Received: from nostradamus (nostradamus.us.cray.com [172.28.65.159])
	by sealmr01.us.cray.com (8.14.3/8.13.8/hubv3-LastChangedRevision: 16250) with ESMTP id u1GK0xNm023748
	for <linux-unionfs@vger.kernel.org>; Tue, 16 Feb 2016 12:00:59 -0800
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

I apologize for not having tested this on the latest kernel. I hit this bug in SUSE SLES12 and by inspection it still appears to be in Linus's kernel.

Failure to free dentry. Missing dput() using default_permissions in ovl_permission().

# mount overlayfs with default_permissions
mkdir l u m
mount -t tmpfs tmpfs u
mount -t overlayfs -o upperdir=u,lowerdir=l,default_permissions overlayfs m
dd if=/dev/zero of=m/test_dput bs=4096b count=1000
df u l m
rm m/test_dput
df u l m
# tmpfs space is not freed!

umount m u
# BUG. Dentry still in use!

It appears that there may be a missing dput() in the ovl_is_default_permissions(inode) path of ovl_permission().

I hit this in SUSE because default_permissions was getting set by accident due to uninitialized data in ovl_config (kalloc vs. kzalloc). This bug is fixed upstream.


-Eric Jones
