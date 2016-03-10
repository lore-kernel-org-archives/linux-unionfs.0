From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: Unmounting lower filesystem while overlayfs uses it
Date: Thu, 10 Mar 2016 16:22:47 -0600
Message-ID: <56E1F3B7.2090306@suse.de>
References: <56E1CF7C.1010505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204AbcCJWWv (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 10 Mar 2016 17:22:51 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 44306AC32
	for <linux-unionfs@vger.kernel.org>; Thu, 10 Mar 2016 22:22:49 +0000 (UTC)
In-Reply-To: <56E1CF7C.1010505@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org



On 03/10/2016 01:48 PM, Goldwyn Rodrigues wrote:
> Hi,
>
> I noticed that you can continue using overlayfs while the underlying
> filesystem is unmounted. While overlayfs continues to use and show the
> entries from the underlying filesystem. Howerver, /proc/mounts is
> missing the lowerdir mount entry. This could be pretty confusing for
> users (say for example for users looking to hot swap devices)
>
> I traced it down to the vfs mount point being copied/cloned as opposed
> to using the original one. Is there a reason why a new vfsmount is used
> as opposed to using the lowerdir's vfsmount? Perhaps I did not look hard
> enough, but I did not find any changes being made to the cloned lowerdir
> vfsmount.

I found the changes to cloned vfsmount: MS_RDONLY flag.
So, we would have to preserve the stack[].mnt [from ovl_fill_super()] 
variables in ovl_fs and perform the mntput() in ovl_put_super()/ Is that 
okay?


-- 
Goldwyn
