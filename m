From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Using overlay on top of overlay
Date: Wed, 13 Dec 2017 11:10:17 +0100
Message-ID: <1c1c2e7d-8121-65bc-60f9-b93bbe2ff411@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:47035 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdLMKKW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 Dec 2017 05:10:22 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hi,

For few kernel releases overlay supported using it on top of another
overlay.

FWIW there was a regression related to this "feature" in 4.2:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01
but it was fixed:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1c8a47df36d72ace8cf78eb6c228aa0f8027d3c2


Starting with kernel 4.4 this "feature" seems to be disabled explicitly:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=76bc8e2843b66f8205026365966b49ec6da39ae7

Disabling commit says that it "does not make sense" but actually there
seem to be few projects that are looking for such a solution, see:
1) https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1629509
2) https://bugs.centos.org/view.php?id=12986
3) https://github.com/rkt/rkt/issues/1537

I can't really elaborate on above cases but I have a similar need for
my OpenWrt system running LXC (Linux Containers).

First of all OpenWrt uses overlay to "merge" squashfs and some writable
filesystem partition. It needs squashfs due to dealing with devices with
really small flashes (down to 4 - 8 MiB). Then it stores all its LXC
containers in the /srv/lxc/.

Secondly LXC itself uses overlay feature in few places, e.g.
1) lxc.rootfs with the overlayfs:lower:upper syntax
2) lxc.mount.entry with the fstab syntax

As you can guess LXC simply assumes overlay can be used and doesn't
check if the host system uses it for directory holding container data.
This breaks LXC because kernel refuses mounting dir with some message
like:
overlayfs: filesystem on '/foo' not supported as upperdir


I managed to find a workaround for this. As OpenWrt uses:
overlayfs:/overlay on / type overlay (rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work)
I can simply replace
upperdir=/srv/lxc/foo/upper
with
upperdir=/overlay/upper/srv/lxc/foo/upper
(same for workdir) but this isn't really a user friendly solution.


I would like to ask if use cases I described above make any sense to
you?
Is there any chance someone could work on a proper support for overlay
on top of overlay and enabling it again?
