From: radioconfusion@gmail.com
Subject: Overlayfs regression: NFS as lowerdir fails to read any file
Date: Tue, 16 Feb 2016 12:15:41 -0800 (PST)
Message-ID: <56c3836d.09a7700a.f340f.ffffa6cb@mx.google.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32942 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbcBPUPn (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 16 Feb 2016 15:15:43 -0500
Received: by mail-lb0-f174.google.com with SMTP id x4so105106745lbm.0
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Feb 2016 12:15:42 -0800 (PST)
Received: from localhost (a91-155-132-134.elisa-laajakaista.fi. [91.155.132.134])
        by smtp.gmail.com with ESMTPSA id zk9sm4506607lbb.3.2016.02.16.12.15.41
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 16 Feb 2016 12:15:41 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hello,

I think that I have found a regression/bug on overlayfs.
I can't get NFS lowerdir working with Linux 4.4 even though it's supported without custom patching. It worked with Linux 4.1 with little custom patching (see link below).

How to reproduce:
* Compile Linux 4.4 or any revision which is newer than "Commit 4bacc9 overlayfs: Make f_path always point to the overlay and f_inode to the underlay"
* Mount nfs with default options (my share is exported with (rw,sync,no_subtree_check))
* Mount overlay with nfs as lowerdir
* Try to read any existing file on overlayfs

Example:

# uname -r
4.3.0-1-amd64
# mkdir /tmp/nfs /tmp/upper /tmp/work /tmp/merge
# mount -o defaults 192.168.1.9:/home/shared /tmp/nfs
# mount -t overlay overlay -olowerdir=/tmp/nfs,upperdir=/tmp/upper,workdir=/tmp/work /tmp/merge
# mount | grep "/tmp"
192.168.1.9:/home/shared on /tmp/nfs type nfs4 (rw,relatime,vers=4.0,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=sys,clientaddr=192.168.1.15,local_lock=none,addr=192.168.1.9)
overlay on /tmp/merge type overlay (rw,relatime,lowerdir=/tmp/nfs,upperdir=/tmp/upper,workdir=/tmp/work)
# echo hello >/tmp/nfs/hello
# cat /tmp/merge/hello
cat: /tmp/merge/hello: No such device or address

I think my issue is same than:
http://www.spinics.net/lists/linux-unionfs/msg00386.html

NFS works as lowerdir without 4bacc9 (linux 4.1 for example) when nfs lowerdir is allowed by patching fs/overlayfs/super.c@692
See http://www.spinics.net/lists/linux-unionfs/msg00188.html for details.

Best Regards
Jussi
