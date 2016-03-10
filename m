From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Unmounting lower filesystem while overlayfs uses it
Date: Thu, 10 Mar 2016 13:48:12 -0600
Message-ID: <56E1CF7C.1010505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbcCJTsP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 10 Mar 2016 14:48:15 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 12625ABD3
	for <linux-unionfs@vger.kernel.org>; Thu, 10 Mar 2016 19:48:14 +0000 (UTC)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi,

I noticed that you can continue using overlayfs while the underlying 
filesystem is unmounted. While overlayfs continues to use and show the 
entries from the underlying filesystem. Howerver, /proc/mounts is 
missing the lowerdir mount entry. This could be pretty confusing for 
users (say for example for users looking to hot swap devices)

I traced it down to the vfs mount point being copied/cloned as opposed 
to using the original one. Is there a reason why a new vfsmount is used 
as opposed to using the lowerdir's vfsmount? Perhaps I did not look hard 
enough, but I did not find any changes being made to the cloned lowerdir 
vfsmount.

-- 
Goldwyn
