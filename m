From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs + ubifs: power cut results in "failed to create
 directory /overlay/work/work (errno: 17); mounting read-only"
Date: Tue, 6 Sep 2016 14:50:54 +0200
Message-ID: <CAJfpegt_Rw0O7mmP4scNPObAokwiNGs7m9ez1-tmjndOZDMXBg@mail.gmail.com>
References: <58c7c482-9a51-73d1-7694-e1928f3bedb0@gmail.com> <d56ee9a9-5246-a609-b8ca-1c8dee322f46@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34080 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754997AbcIFMu4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Sep 2016 08:50:56 -0400
Received: by mail-oi0-f41.google.com with SMTP id m11so161516477oif.1
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Sep 2016 05:50:55 -0700 (PDT)
In-Reply-To: <d56ee9a9-5246-a609-b8ca-1c8dee322f46@nod.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org, lede-dev@lists.infradead.org

On Tue, Sep 6, 2016 at 1:59 PM, Richard Weinberger <richard@nod.at> wrote:
> Rafa=C5=82,
>
> On 06.09.2016 12:46, Rafa=C5=82 Mi=C5=82ecki wrote:
>> Hi,
>>
>> In LEDE/OpenWrt we use UBI with two volumes: "rootfs" and "rootfs_data".=
 With
>> rootfs mounted at / we mount rootfs_data volume at /overlay and then use
>> overlayfs to combine these two.
>>
>> 1) Before:
>> /dev/root on / type squashfs (ro,relatime)
>> /dev/ubi0_1 on /overlay type ubifs (rw,noatime)
>>
>> 2) Mounting overlayfs
>> mount("overlayfs:/overlay", "/mnt", "overlay", MS_NOATIME, "lowerdir=3D/=
,upperdir=3D/overlay/upper,workdir=3D/overlay/work")
>>
>> 3) After:
>> /dev/root on / type squashfs (ro,relatime)
>> /dev/ubi0_1 on /overlay type ubifs (rw,noatime)
>> overlayfs:/overlay on /mnt type overlay (ro,noatime,lowerdir=3D/,upperdi=
r=3D/overlay/upper,workdir=3D/overlay/work)
>>
>> It works fine as long as there aren't unexpected power cuts. I can easil=
y break
>> it in a well-reproducible way by doing:
>> date > bar.txt && rm foo.sh
>> sleep 2s
>> [power cut]
>>
>> On the next boot LEDE/OpenWrt script calls the same mount function but i=
t
>> results in:
>> [   10.017235] overlayfs: failed to create directory /overlay/work/work =
(errno: 17); mounting read-only
>>
>> I tracked that error and got a following forward trace for it:
>> ovl_fill_super
>> ovl_workdir_create
>> ovl_cleanup
>> vfs_rmdir
>> ubifs_rmdir
>> check_dir_empty
>>
>> In other words mounting overlayfs fails because ubifs refuses to remove
>> work/work as this directory is not empty. On a clean boot /overlay/work/=
work is
>> empty and everything works fine but after a power cut I can see
>> /overlay/work/work/#c752f2a8 file.
>>
>> I don't really know anything about overlayfs and its workdir, I just exp=
ected
>> overlayfs to recover from such situation on its own. FWIW after a power =
cut and
>> reboot my bar.txt is an empty file and foo.sh still exists.
>>
>> Does it sound like an overlayfs issue to you? Can you think of some way =
of
>> fixing this?
>
> overlayfs does not issue a recursive rm on workdir, AFAICT you are suppos=
ed to cleanup
> workdir yourself before mounting.
> Miklos?

Fixed in 4.8-rc5 by

eea2fb4851e9 ("ovl: proper cleanup of workdir")

I think it's better if kernel does the cleanup, but if it's easier to
upgrade userspace, then that's a valid workaround.

Thanks,
Miklos
