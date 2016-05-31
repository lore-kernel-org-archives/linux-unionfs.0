From: Andrea <ass3mbler@gmail.com>
Subject: ext4 with encryption, error "overlayfs: filesystem on [...] not
 supported as upperdir"
Date: Tue, 31 May 2016 15:20:38 +0200
Message-ID: <CAE6L1VppFednd52B5cfiDW6d-KeC6QedGOD6EMZS6ub0F4VKKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34539 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbcEaNUo (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 31 May 2016 09:20:44 -0400
Received: by mail-yw0-f171.google.com with SMTP id c127so187725518ywb.1
        for <linux-unionfs@vger.kernel.org>; Tue, 31 May 2016 06:20:43 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hello,

I'm trying to store a Docker graph directory in a ext4 encypted dir
(/mnt/drbd0/docker):

- /dev/drbd0 <- ext4 partition
- /dev/drbd0 -> mounted on /mnt/drbd0
- /mnt/drbd0/docker <- dir encrypted with ext4 std encryption

The Docker daemon runs ok, pulls the images layers as needed but it's
unable to mount the ovl. The kernel used is a mainline pure v4.6
manually compiled and running on a standard Gentoo installation.

the relevant error line in dmseg are (i.e.)

/mnt/drbd0/docker/overlay/446f76c928f35f1e30228c79e89faae2c5c57a814109b602a318e02f264a5e50-init/upper'
not supported as upperdir

The same error is given even if I use another unencrypted directory on
the same partition as my graph directory. Moreover, manually testing
with this procedure:

- cd /mnt/drbd0/test <- unencryped dir
- mkdir lower upper work merged
- mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merged

gives exactly the same error. If I run the same procedures (docker
and/or the manual test) after formatting the same partition (but
keeping the encryption disabled) everything works perfectly.

Looking at the code, as far as I'm able to understand, it seems that
the check for the dentry flags (DCACHE_OP_REVALIDATE |
DCACHE_OP_WEAK_REVALIDATE) in the ovl_dentry_remote() call (file:
super.c, line 871) fails and the mount procedure is then aborted.
Maybe I have to change some flags on the ext4 fs and I'm missing
something?

Could someone please give me some hint?

Thank you in advance and best regards,

Andrew
