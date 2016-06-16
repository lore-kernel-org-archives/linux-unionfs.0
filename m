From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: NFS/ro: mv: cannot move 'foo' to a subdirectory of itself, 'bar'
Date: Thu, 16 Jun 2016 14:30:50 +0200
Message-ID: <CAJfpegsxnqOpDUDHwKd4p+ZJMkBTAVKgjpNBhNqP0e2uZvrkVQ@mail.gmail.com>
References: <20160613130710.57321936@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34234 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbcFPMav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 16 Jun 2016 08:30:51 -0400
Received: by mail-oi0-f42.google.com with SMTP id d132so66255860oig.1
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Jun 2016 05:30:51 -0700 (PDT)
In-Reply-To: <20160613130710.57321936@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: =?UTF-8?Q?Andr=C3=A9_Roth?= <neolynx@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jun 13, 2016 at 1:07 PM, Andr=C3=A9 Roth <neolynx@gmail.com> wr=
ote:
>
> Hello,
>
> I try to use overlay for network boot clients using an NFS read-only
> filesystem. This works pretty well, except renaming files with the mv
> command fails:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> # ls -l
> -rw-r--r-- 1 root root 785 Mar 27  2016 foo
>
> # mv foo bar
> mv: cannot move 'foo' to a subdirectory of itself, 'bar'
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>
> I mount the overlay filesystem as follows in the initrd, where /root =
is
> already mounted read-only from NFS:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> mkdir /writable
> mkfs.ext2 /dev/ram0 >/dev/null
> mount -n /dev/ram0 /writable >/dev/null
>
> mkdir /writable/upper
> mkdir /writable/work
>
> modprobe overlay
> mount -t overlay overlay -olowerdir=3D/root,upperdir=3D/writable/uppe=
r,workdir=3D/writable/work,default_permissions /root
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>
> kernel version is 4.7.0-rc2, git cloned from
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git,
> using the overlayfs-next branch.
>
> is this a bug ?
> can I help anything debugging fixing this ?

 # echo 'module overlay +mp' > /sys/kernel/debug/dynamic_debug/control
 # strace -o /tmp/strace mv foo bar
 # dmesg | grep overlay > /tmp/debug

And post the /tmp/strace and /tmp/debug files.

Thanks,
Miklos
