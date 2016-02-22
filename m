From: Andin Bren <andin.bren@gmail.com>
Subject: overlayfs: support ecryptfs upperdir
Date: Sun, 21 Feb 2016 19:11:56 -0500
Message-ID: <CAM7c_2ox4zZGuh_adr27FkRDtF3aZRbg_uAt=aHaNTqp2omczA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34123 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbcBVAMg (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 21 Feb 2016 19:12:36 -0500
Received: by mail-ig0-f174.google.com with SMTP id g6so75359811igt.1
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Feb 2016 16:12:35 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hello,

Would it be possible for overlayfs to support being mounted with an
upperdir on an ecryptfs filesystem?

andin@box:~$ mkdir lower upper work merged

andin@box:~$ sudo mount -t overlay overlay -o
lowerdir=$HOME/lower,upperdir=$HOME/upper,workdir=$HOME/workdir merged
mount: wrong fs type, bad option, bad superblock on overlay,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so

andin@box:~$ tail -n 1 /var/log/syslog
Feb 21 18:57:01 box kernel: [ 5323.931064] overlayfs: filesystem on
'/home/andin/upper' not supported as upperdir

andin@box:~$ mount|grep " / "
/dev/sda2 on / type ext4 (rw,relatime,errors=remount-ro,data=ordered)

andin@box:~$ mount|grep home
/home/.ecryptfs/andin/.Private on /home/andin type ecryptfs
(rw,nosuid,nodev,relatime,ecryptfs_fnek_sig=11c07678abb13aac,ecryptfs_sig=b1d3451eeea22381,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_unlink_sigs)

Thanks,
- Andin
