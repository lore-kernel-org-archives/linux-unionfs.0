From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Exporting overlay via NFS?
Date: Thu, 28 Sep 2017 10:14:52 +0300
Message-ID: <CAOQ4uxiv7zL2ppmCDEr7sM+YP3st3DG1Xoq-xZ=n69=PzZTzRw@mail.gmail.com>
References: <20161012142904.GB10902@otheros> <CAOQ4uxjR8q2X=q8=-JnU8QiE6a8F4SXUyzjq9_EZeDTy0=qR4g@mail.gmail.com>
 <20170928060425.GC6726@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:46948 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbdI1HOx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Sep 2017 03:14:53 -0400
Received: by mail-yw0-f181.google.com with SMTP id v72so389654ywa.3
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Sep 2017 00:14:53 -0700 (PDT)
In-Reply-To: <20170928060425.GC6726@otheros>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Sep 28, 2017 at 9:04 AM, Linus L=C3=BCssing <linus.luessing@c0d3.bl=
ue> wrote:
> Hi Amir,
>

Hi Linus,

I hope I am not out of line adding back list to CC.
I believe my answer to your question has public value as
other people are confused about index feature.
Keeping the old discussion below for those joining in now.

> Just saw this new feature you added, available since 4.13:
>
>     OVERLAY_FS_INDEX:
>     - 02bcd15 ovl: introduce the inodes index dir feature
>
> Would it make sense for me to rebuild a recent kernel with this
> option (and maybe this [0] one too?) and retry my NFS exported
> overlayfs case?
>
> Or did I misinterpret this new option?

The way to interpret this statement from commit 02bcd15:

"The index dir is going to be used to prevent breaking lower hardlinks
    on copy up and to implement overlayfs NFS export."

- index is already used to prevent breaking lower hardlinks in v4.13
- index is going to be used to implement overlayfs NFS export in near futur=
e

Note that description of OVERLAY_FS_INDEX that was merged to v4.13
says: "The inodes index feature prevents breaking of lower hardlinks on cop=
yup."

See also commit message of
9412812ef548 ovl: document copying layers restrictions with inodes index
 "The inodes index feature is required to support:
    - Prevent breaking hardlinks on copy up
    - NFS export support (upcoming)
    - Overlayfs snapshots (POC)"

I am currently working on NFS export support.
Last WIP branch is here (based on v4.13-rc1):
https://github.com/amir73il/linux/commits/ovl-nfs-export-wip

The work is not complete and not actually tested with NFS server
(only with unit tests), but AFAICT there is nothing that should
prevent it from working while overlay inodes remain in cache.

At this time I am working on rebaing the work on v4.14-rc1,
completing the missing pieces and the missing tests.
If all goes well I should be able to submit the patches for v4.15.
If you have the time and will to test WIP branches on
your setup that could be very helpful and may help speed up
my development of the NFS export feature.

Let me know if you need help with configuring the WIP build.

Thanks!
Amir.

>
> Regards, Linus
>
> PS: Thanks for all your work on the overlayfs! :)
>
> [0]: OVERLAY_FS_REDIRECT_DIR:
> - 688ea0e ovl: allow redirect_dir to default to "on"

That feature is independent of index/nfs export
it provides the ability to rename non empty directories
so it is quire recommended.
The only culprit of this feature is that makes the overlay
layers non backward compatible with kernel < v4.10.
The feature *is* compatible with kernel >=3D v4.10 even
when compiled without OVERLAY_FS_REDIRECT_DIR.

>
>
> On Wed, Oct 12, 2016 at 09:40:53PM +0300, Amir Goldstein wrote:
>> On Wed, Oct 12, 2016 at 5:29 PM, Linus L=C3=BCssing <linus.luessing@c0d3=
.blue> wrote:
>> > Hi,
>> >
>> > I'm currently trying to spice up an NFS share by adding an overlay
>> > fs layer.
>> >
>> > As I only found a note regarding issues with using an overlay on
>> > the NFS client side in Documentation/filesystems/overlayfs.txt,
>> > I thought I'd ask about the NFS server side here.
>> >
>> >
>> > Instead of booting from a /srv/nfs/debian-sid/.amd64,
>> > I want to boot from an overlay like:
>> >
>> > /srv/nfs/debian-sid/.amd64 + /srv/nfs/debian-sid/overlay
>> > =3D /srv/nfs/debian-sid/amd64
>> >
>> > This overlay is constructed on the NFS server side.
>> >
>> >
>> > Without this overlay, things work for me:
>> >
>> > /etc/exports:
>> >         /srv/nfs *(ro,async,no_root_squash)
>> >
>> > And mounting that with a kernel parameter like:
>> >         ... ro root=3D/dev/nfs net.ifnames=3D0 ip=3D:::::eth0:dhcp \
>> >         nfsroot=3D172.23.208.16:/srv/nfs/debian-sid/.amd64 ...
>> >
>> > As well as some more overlay magic in the initrd on the client
>> > side to add a tmpfs over the read-only NFS share. This part works
>> > so far.
>> >
>> >
>> > Now I'm trying to add an overlayfs on the NFS server side too,
>> > as described above. Unfortunately, this fails on the
>> > nfs-root-booting client side:
>> >
>> > ~~~
>> > [...]
>> > mount call failed - server replied: Permission denied.
>> > Begin: Retrying nfs mount ... mount call failed - server replied: Perm=
ission denied.
>> > done.
>> > Begin: Retrying nfs mount ... mount call failed - server replied: Perm=
ission denied.
>> > done.
>> > [...]
>> > ~~~
>> >
>> >
>> > I also tried changing the export from /srv/nfs to
>> > /srv/nfs/debian-sid/amd64, but I still get the permission denied.
>> > The overlay /srv/nfs/debian-sid/amd64 looks fine and with an empty
>> > /srv/nfs/debian-sid/overlay directory identical to the .amd64 one.
>> >
>> >
>> > NFS server side runs a Debian Jessie with a 4.7.0-0.bpo.1-amd64
>> > kernel. The NFS client side runs a 4.7 kernel, too, and is
>> > supposed to boot a Debian Sid.
>> >
>> >
>> > Any idea why this permission denied might happen?
>> >
>>
>> You should be examining kmsg of the server machine.
>> Not sure why the client gets a Permission denied error, but the fact is =
that
>> exporting overlayfs is not supported.
>>
>> I suppose that is all you wanted to know, but while I'm at it, I'll cont=
inue
>> the "what if" line of though.
>>
>> check_export() in fs/nfsd/export.c says:
>>
>>         /* There are two requirements on a filesystem to be exportable.
>>          * 1:  We must be able to identify the filesystem from a number.
>>          *       either a device number (so FS_REQUIRES_DEV needed)
>>          *       or an FSID number (so NFSEXP_FSID or ->uuid is needed).
>>          * 2:  We must be able to find an inode from a filehandle.
>>          *       This means that s_export_op must be set.
>>          */
>>
>> overlayfs does not qualify for the first requirement, which is hard to
>> fix, but can be circumvented from userspace.
>>
>> overlayfs does not qualify for the second requirement either, which is w=
here
>> things get interesting.. although the general case of any overlay combin=
ation
>> is hard to fix, there is a simpler case of lower and upper on the same s=
b
>> and that sb has s_export_op (which is the case in your setup).
>>
>> In that case, I think it shouldn't be too hard to implement the export o=
ps.
>> The question is what happens after copy-up.
>> My first instinct is to always identify the inode by lower inode handle,
>> unless it is a pure upper, same approach that Miklos took in recent patc=
h
>>   ovl: make directory ino/dev numbers stable
>>
>> If there is interest I could probably look into this.
>>
>> Amir.
