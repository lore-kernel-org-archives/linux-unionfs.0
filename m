From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: overlayfs + ubifs: power cut results in "failed to create
 directory /overlay/work/work (errno: 17); mounting read-only"
Date: Tue, 6 Sep 2016 14:56:44 +0200
Message-ID: <CACna6rzJi37CYg86YgT+age8ebWX6BtpoEbz7uM18-QiWFvDxQ@mail.gmail.com>
References: <58c7c482-9a51-73d1-7694-e1928f3bedb0@gmail.com>
 <d56ee9a9-5246-a609-b8ca-1c8dee322f46@nod.at> <CAJfpegt_Rw0O7mmP4scNPObAokwiNGs7m9ez1-tmjndOZDMXBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34433 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933143AbcIFM4p (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Sep 2016 08:56:45 -0400
Received: by mail-oi0-f50.google.com with SMTP id m11so161790868oif.1
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Sep 2016 05:56:45 -0700 (PDT)
In-Reply-To: <CAJfpegt_Rw0O7mmP4scNPObAokwiNGs7m9ez1-tmjndOZDMXBg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Richard Weinberger <richard@nod.at>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, LEDE Development List <lede-dev@lists.infradead.org>

On 6 September 2016 at 14:50, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Sep 6, 2016 at 1:59 PM, Richard Weinberger <richard@nod.at> wrote=
:
>> Rafa=C5=82,
>>
>> On 06.09.2016 12:46, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> Hi,
>>>
>>> In LEDE/OpenWrt we use UBI with two volumes: "rootfs" and "rootfs_data"=
. With
>>> rootfs mounted at / we mount rootfs_data volume at /overlay and then us=
e
>>> overlayfs to combine these two.
>>>
>>> 1) Before:
>>> /dev/root on / type squashfs (ro,relatime)
>>> /dev/ubi0_1 on /overlay type ubifs (rw,noatime)
>>>
>>> 2) Mounting overlayfs
>>> mount("overlayfs:/overlay", "/mnt", "overlay", MS_NOATIME, "lowerdir=3D=
/,upperdir=3D/overlay/upper,workdir=3D/overlay/work")
>>>
>>> 3) After:
>>> /dev/root on / type squashfs (ro,relatime)
>>> /dev/ubi0_1 on /overlay type ubifs (rw,noatime)
>>> overlayfs:/overlay on /mnt type overlay (ro,noatime,lowerdir=3D/,upperd=
ir=3D/overlay/upper,workdir=3D/overlay/work)
>>>
>>> It works fine as long as there aren't unexpected power cuts. I can easi=
ly break
>>> it in a well-reproducible way by doing:
>>> date > bar.txt && rm foo.sh
>>> sleep 2s
>>> [power cut]
>>>
>>> On the next boot LEDE/OpenWrt script calls the same mount function but =
it
>>> results in:
>>> [   10.017235] overlayfs: failed to create directory /overlay/work/work=
 (errno: 17); mounting read-only
>>>
>>> I tracked that error and got a following forward trace for it:
>>> ovl_fill_super
>>> ovl_workdir_create
>>> ovl_cleanup
>>> vfs_rmdir
>>> ubifs_rmdir
>>> check_dir_empty
>>>
>>> In other words mounting overlayfs fails because ubifs refuses to remove
>>> work/work as this directory is not empty. On a clean boot /overlay/work=
/work is
>>> empty and everything works fine but after a power cut I can see
>>> /overlay/work/work/#c752f2a8 file.
>>>
>>> I don't really know anything about overlayfs and its workdir, I just ex=
pected
>>> overlayfs to recover from such situation on its own. FWIW after a power=
 cut and
>>> reboot my bar.txt is an empty file and foo.sh still exists.
>>>
>>> Does it sound like an overlayfs issue to you? Can you think of some way=
 of
>>> fixing this?
>>
>> overlayfs does not issue a recursive rm on workdir, AFAICT you are suppo=
sed to cleanup
>> workdir yourself before mounting.
>> Miklos?
>
> Fixed in 4.8-rc5 by
>
> eea2fb4851e9 ("ovl: proper cleanup of workdir")
>
> I think it's better if kernel does the cleanup, but if it's easier to
> upgrade userspace, then that's a valid workaround.

Oh, this should solve my problem! It seems it didn't git stable
kernels yet, but I can backport it on my own for now.

Thanks!

P.S.
Interesting part:
> While this has never been reported, it is possible to get a non-empty
> "work" dir from a previous mount of overlayfs in case of crash in the
> middle of an operation using the work directory.
Funny to hit never-reported problem right after someone (Miklos) fixed it ;=
)

--=20
Rafa=C5=82
