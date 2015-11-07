From: Arseny Sher <sher-ars@yandex.ru>
Subject: Changes to underlying filesystems in overlayfs
Date: Sat, 07 Nov 2015 20:04:30 +0300
Message-ID: <1002461446915870@web28j.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from forward11j.cmail.yandex.net ([5.255.227.175]:56498 "EHLO
	forward11j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082AbbKGRNZ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 7 Nov 2015 12:13:25 -0500
Received: from web28j.yandex.ru (web28j.yandex.ru [5.45.198.69])
	by forward11j.cmail.yandex.net (Yandex) with ESMTP id 6F50E20D69
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2015 20:04:32 +0300 (MSK)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi all,

I have some questions regarding making changes to underlying filesystems in
overlayfs. From the documentation:
 "Changes to the underlying filesystems while part of a mounted overlay filesystem are
 not allowed.  If the underlying filesystem is changed, the behavior of the overlay is
 undefined, though it will not result in a crash or deadlock."

Could you tell me, is it safe to
  - freeze the merged mountpoint, remounting it as ro to prevent any external changes
  - directly make changes to lowerdir or upperdir
  - immediate reboot

I hope the rebooting will clean the cache and thus manipulating underlying filesystems
in this way can be considered safe. Am I right? 

There is a project overlayroot developed for mounting / as an overlay filesystem:
http://blog.dustinkirkland.com/2012/08/introducing-overlayroot-overlayfs.html
It provides utility overlayroot-chroot which lets to modify lowerdir partition while
overlayfs on / is mounted.  It does this by adding proc, run, sys mounts inside
lowerdir, than remounting it as rw and finally chrootting into it. It is mainly used for
modyfing overlayroot config, so the next action after exiting chroot is usually reboot.
The utility even doesn't freezes / while doing this, as far as I know. Is this allowed?

P.S. I know that this mail list is for unionfs'es development, not for users.
Unfortunately, I couldn't find more appropriate place for such questions. I'd be happy
if someone would tell me the right place.


-- 
Arseny Sher
