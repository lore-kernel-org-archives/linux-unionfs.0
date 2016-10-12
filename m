From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Exporting overlay via NFS?
Date: Wed, 12 Oct 2016 21:40:53 +0300
Message-ID: <CAOQ4uxjR8q2X=q8=-JnU8QiE6a8F4SXUyzjq9_EZeDTy0=qR4g@mail.gmail.com>
References: <20161012142904.GB10902@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34803 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933991AbcJLSk4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Oct 2016 14:40:56 -0400
Received: by mail-qk0-f172.google.com with SMTP id f128so45564936qkb.1
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Oct 2016 11:40:55 -0700 (PDT)
In-Reply-To: <20161012142904.GB10902@otheros>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc: linux-unionfs@vger.kernel.org

On Wed, Oct 12, 2016 at 5:29 PM, Linus L=C3=BCssing <linus.luessing@c0d3.bl=
ue> wrote:
> Hi,
>
> I'm currently trying to spice up an NFS share by adding an overlay
> fs layer.
>
> As I only found a note regarding issues with using an overlay on
> the NFS client side in Documentation/filesystems/overlayfs.txt,
> I thought I'd ask about the NFS server side here.
>
>
> Instead of booting from a /srv/nfs/debian-sid/.amd64,
> I want to boot from an overlay like:
>
> /srv/nfs/debian-sid/.amd64 + /srv/nfs/debian-sid/overlay
> =3D /srv/nfs/debian-sid/amd64
>
> This overlay is constructed on the NFS server side.
>
>
> Without this overlay, things work for me:
>
> /etc/exports:
>         /srv/nfs *(ro,async,no_root_squash)
>
> And mounting that with a kernel parameter like:
>         ... ro root=3D/dev/nfs net.ifnames=3D0 ip=3D:::::eth0:dhcp \
>         nfsroot=3D172.23.208.16:/srv/nfs/debian-sid/.amd64 ...
>
> As well as some more overlay magic in the initrd on the client
> side to add a tmpfs over the read-only NFS share. This part works
> so far.
>
>
> Now I'm trying to add an overlayfs on the NFS server side too,
> as described above. Unfortunately, this fails on the
> nfs-root-booting client side:
>
> ~~~
> [...]
> mount call failed - server replied: Permission denied.
> Begin: Retrying nfs mount ... mount call failed - server replied: Permiss=
ion denied.
> done.
> Begin: Retrying nfs mount ... mount call failed - server replied: Permiss=
ion denied.
> done.
> [...]
> ~~~
>
>
> I also tried changing the export from /srv/nfs to
> /srv/nfs/debian-sid/amd64, but I still get the permission denied.
> The overlay /srv/nfs/debian-sid/amd64 looks fine and with an empty
> /srv/nfs/debian-sid/overlay directory identical to the .amd64 one.
>
>
> NFS server side runs a Debian Jessie with a 4.7.0-0.bpo.1-amd64
> kernel. The NFS client side runs a 4.7 kernel, too, and is
> supposed to boot a Debian Sid.
>
>
> Any idea why this permission denied might happen?
>

You should be examining kmsg of the server machine.
Not sure why the client gets a Permission denied error, but the fact is tha=
t
exporting overlayfs is not supported.

I suppose that is all you wanted to know, but while I'm at it, I'll continu=
e
the "what if" line of though.

check_export() in fs/nfsd/export.c says:

        /* There are two requirements on a filesystem to be exportable.
         * 1:  We must be able to identify the filesystem from a number.
         *       either a device number (so FS_REQUIRES_DEV needed)
         *       or an FSID number (so NFSEXP_FSID or ->uuid is needed).
         * 2:  We must be able to find an inode from a filehandle.
         *       This means that s_export_op must be set.
         */

overlayfs does not qualify for the first requirement, which is hard to
fix, but can be circumvented from userspace.

overlayfs does not qualify for the second requirement either, which is wher=
e
things get interesting.. although the general case of any overlay combinati=
on
is hard to fix, there is a simpler case of lower and upper on the same sb
and that sb has s_export_op (which is the case in your setup).

In that case, I think it shouldn't be too hard to implement the export ops.
The question is what happens after copy-up.
My first instinct is to always identify the inode by lower inode handle,
unless it is a pure upper, same approach that Miklos took in recent patch
  ovl: make directory ino/dev numbers stable

If there is interest I could probably look into this.

Amir.
