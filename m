Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37957 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfDLLZn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Apr 2019 07:25:43 -0400
Received: by mail-yw1-f66.google.com with SMTP id m207so3231865ywd.5
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Apr 2019 04:25:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190410100150.13939-1-michael.weiss@aisec.fraunhofer.de>
 <20190411201131.GA23000@redhat.com> <58e6d0d1-207b-d877-e91a-3336aa512c72@aisec.fraunhofer.de>
In-Reply-To: <58e6d0d1-207b-d877-e91a-3336aa512c72@aisec.fraunhofer.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 12 Apr 2019 14:25:31 +0300
Message-ID: <CAOQ4uxit=0_iTxetdhGEJcimpoAs_tTpZM2ACTnC6QoiOPUc-A@mail.gmail.com>
Subject: Re: [PATCH] ovl: Introduce mount option hide_paths
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
To: =?UTF-8?Q?Michael_Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Apr 12, 2019 at 10:55 AM Michael Wei=C3=9F
<michael.weiss@aisec.fraunhofer.de> wrote:
>
> Hi Vivek,
>
> yes it is, because the path names are in the options and not
> in the mount source. I only know overlayfs as kernel filesystem
> which uses the options for source pathes, due to obvious reasons.
>
> On a bind mount the source block device on which the directory
> is located will be shown as source, thus there is no information leak
> in the mount namespace / chroot there.
>
> Short example:
>
> bind mount:
>
> host:
> mount --bind /mnt/test-rootns/ /var/lib/schroot/mount/stable-a73e0370-da3=
c-4325-aa4c-2585febb65d5/root/test/
>
> /dev/mapper/system-root on /var/lib/schroot/mount/stable-a73e0370-da3c-43=
25-aa4c-2585febb65d5/root/test type ext4 (rw,noatime,errors=3Dremount-ro,us=
er_xattr,barrier=3D1,data=3Dordered)
>
> chroot:
>
> /dev/mapper/system-root on /root/test type ext4 (rw,noatime,errors=3Dremo=
unt-ro,user_xattr,barrier=3D1,data=3Dordered)
>
> overlayfs:
>
> host:
>
> overlay on /var/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bddad7c317=
3f1811651c1b37d93f02e5dbb39/merged type overlay (rw,relatime,lowerdir=3D/va=
r/lib/docker/overlay2/l/MXNJRWHBTT3FY7ZLXSZOXZHEDX:/var/lib/docker/overlay2=
/l/Q5R45CZKDNRTTYJ4RSP6OWYRT2,upperdir=3D/var/lib/docker/overlay2/9c428ab52=
04f10fad81dbd6ea21bddad7c3173f1811651c1b37d93f02e5dbb39/diff,workdir=3D/var=
/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bddad7c3173f1811651c1b37d93=
f02e5dbb39/work)
>
> chroot:
>
> overlay on / type overlay (rw,relatime,lowerdir=3D/var/lib/docker/overlay=
2/l/MXNJRWHBTT3FY7ZLXSZOXZHEDX:/var/lib/docker/overlay2/l/Q5R45CZKDNRTTYJ4R=
SP6OWYRT2,upperdir=3D/var/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bd=
dad7c3173f1811651c1b37d93f02e5dbb39/diff,workdir=3D/var/lib/docker/overlay2=
/9c428ab5204f10fad81dbd6ea21bddad7c3173f1811651c1b37d93f02e5dbb39/work)
>
>

You know, these options are just strings.
It's not a problem to use any strings you like using symlink to avoid
leaking paths.
Its exactly the same method that docker uses to shorten the mount
option args length,
for example:

cd var/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bddad7c3173f1811651c1=
b37d93f02e5dbb39/
ln -s ../l/MXNJRWHBTT3FY7ZLXSZOXZHEDX l0
ln -s ../l/Q5R45CZKDNRTTYJ4RSP6OWYRT2 l1
mount -t overlay overlay merged/ -olowerdir=3Dl0:l1,upperdir=3Ddiff,workdir=
=3Dwork

And that's it.
I wonder why docker is not that to shorten the argument list instead
of the l/XXX symlinks

Thanks,
Amir.
