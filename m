From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 7 Nov 2016 14:31:19 +0300
Message-ID: <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com> <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34202 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbcKGLbX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Nov 2016 06:31:23 -0500
In-Reply-To: <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Raphael Hertzog <hertzog@debian.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Nov 7, 2016 at 2:03 PM, Raphael Hertzog <hertzog@debian.org> wrote:
> Hello,
>
> On Sun, 06 Nov 2016, Konstantin Khlebnikov wrote:
>> > - If upper is nonempty, then leave redirect feature alone except when
>> > mount option "-oredirect=3Don" is used to force enabling it.
>> > - If upper is empty, then enable redirect feature except when mount
>> > option "-oredirect=3Doff" is used to force disabling it.
>>
>> I don't like this empty-nonempty upper logic.
>
> Why? (I don't have the feeling that your subsequent paragraphs answer thi=
s
> question... unless "overlayfs mounting is hard, let's complicate it even
> more" is your answer)

Mixing flags from mount options, xattrs and emptiness of upper layer
doesn't make it simpler.

We have clear statement that options in /proc/mounts describes overlay
instance, let's keep feeding state in this way.

>
>> I think this feature should be off by default and be enabled
>> explicitly in mount option.
>> Available features could be listed in sysfs /sys/fs/overlay/..., like ex=
t4 does.
>
> TTBOMK in ext4, they are set at mkfs time and the default feature set
> comes from /etc/mke2fs.conf. There's nothing like that for overlayfs.

/etc/mke2fs.conf is used by mkfs.ext4 - state is saved in super-block
inside filesystem.

overlayfs have no persistent super-block.

>
>> Overlayfs mounting anyway is complicated operation.
>> User must know a lot about it and provide persistent state for each moun=
t:
>> list layers in correct order, work and uppder directory on the same disk=
, etc.
>> Enabled features is a part of this state.
>
> A large part of the users are not direct overlayfs users, they use
> application (like schroot and live-build in my case) that rely on
> overlayfs to offer some user-modifiable throw-away chroots or some
> persistency on top of a read-only image. In both cases, the upper
> directory start empty.
>
> I find it highly disturbing to have to modify all those applications just
> to get the correct semantics to rename a directory.

Other application are already aware about overlay layout and use it.
We cannot enable by default new backward incompatible features.

Returning -EXDEV is a completely correct semantics for rename,
most applications employ broken assumptions about this syscall =3D)

>
>> Probably this could be solved in userspace tool "mount.overlay" - it cou=
ld load
>> features and layers from config file or xattr and set required mount
>> options automatically.
>
> I'm all for having a better API to mount overlayfs, but I don't think
> blocking on the "redirect=3Don" by default is a good way to get this.
>
> Cheers,
> --
> Rapha=C3=ABl Hertzog =E2=97=88 Debian Developer
>
> Support Debian LTS: http://www.freexian.com/services/debian-lts.html
> Learn to master Debian: http://debian-handbook.info/get/
