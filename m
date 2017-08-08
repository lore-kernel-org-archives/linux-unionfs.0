From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: two questiones about overlayfs
Date: Tue, 8 Aug 2017 16:21:07 -0400
Message-ID: <20170808202107.GB10664@redhat.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51218 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbdHHUVJ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Aug 2017 16:21:09 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com, Daniel J Walsh <dwalsh@redhat.com>

On Tue, Aug 08, 2017 at 07:01:30AM +0200, Amir Goldstein wrote:

[CC Dan Walsh]

[..]
> > 2. Chattr will modify lower file's attributes directly.
> > Reproduce:
> > # mkdir lower upper worker merger
> > # touch lower/aa
> > # lsattr -p lower/aa
> >     0 --------------e---- lower/aa
> > # mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
> > # chattr -p 123 merger/aa             #set project id
> > # lsattr -p lower/aa
> >   123 --------------e---- lower/aa
> >
> > If we try to set "immutable" or any other attributes, the result are consistent.
> > Because chattr open file in RDONLY mode, so it will not trigger copyup, and then,
> > FS_IOC_SETFLAGS ioctl will get the lower inode and modify it.
> 
> Ouch! I guess it's a "known to some" issue.
> Fixing this would be a pain (intercept ioctl and whitelisting readonly
> fs specific ioctls).
> Hopefully, at least sepolicy would prevent these unauthorized changes
> to lower if
> selinux is used??

I tried it in a docker container on Fedora 26 host and selinux seemed to
block it.

[root@947c53c7d69a bin]# lsattr -p zcat
    0 ------------------- zcat

[root@947c53c7d69a bin]# chattr -p 123 zcat
chattr: Permission denied while setting flags on zcat

Aug 08 16:15:37  audit[24865]: AVC avc:  denied  { setattr } for
pid=24865 comm="chattr" path="/usr/bin/zcat" dev="dm-0" ino=17358919
scontext=system_u:system_r:container_t:s0:c403,c847
tcontext=system_u:object_r:container_share_t:s0 tclass=file permissive=0

But this should probably be properly fixed.

Vivek
