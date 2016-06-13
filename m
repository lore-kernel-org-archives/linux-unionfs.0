From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Subject: NFS/ro: mv: cannot move 'foo' to a subdirectory of itself, 'bar'
Date: Mon, 13 Jun 2016 13:07:10 +0200
Message-ID: <20160613130710.57321936@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35031 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422670AbcFMLHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 13 Jun 2016 07:07:15 -0400
Received: by mail-wm0-f45.google.com with SMTP id v199so73036175wmv.0
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jun 2016 04:07:14 -0700 (PDT)
Received: from localhost (215.180.105.92.dynamic.wline.res.cust.swisscom.ch. [92.105.180.215])
        by smtp.gmail.com with ESMTPSA id wb10sm27040643wjc.8.2016.06.13.04.07.12
        for <linux-unionfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 13 Jun 2016 04:07:12 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org


Hello,

I try to use overlay for network boot clients using an NFS read-only
filesystem. This works pretty well, except renaming files with the mv
command fails:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
# ls -l
-rw-r--r-- 1 root root 785 Mar 27  2016 foo

# mv foo bar
mv: cannot move 'foo' to a subdirectory of itself, 'bar'
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

I mount the overlay filesystem as follows in the initrd, where /root is
already mounted read-only from NFS:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
mkdir /writable
mkfs.ext2 /dev/ram0 >/dev/null
mount -n /dev/ram0 /writable >/dev/null

mkdir /writable/upper
mkdir /writable/work

modprobe overlay
mount -t overlay overlay -olowerdir=3D/root,upperdir=3D/writable/upper,=
workdir=3D/writable/work,default_permissions /root
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

kernel version is 4.7.0-rc2, git cloned from
git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git,
using the overlayfs-next branch.

is this a bug ?
can I help anything debugging fixing this ?


Regards,

 Andr=C3=A9
