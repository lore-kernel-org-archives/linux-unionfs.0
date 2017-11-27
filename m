From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: sync filesystem of overlayfs
Date: Mon, 27 Nov 2017 10:59:41 +0200
Message-ID: <CAOQ4uxjnVajcd=0tqVYbGiTSmMhN_Pemjn3N2fhTZs4KYasV_w@mail.gmail.com>
References: <5862C310-F8B9-40AF-826D-BE867CCDA519@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f169.google.com ([209.85.213.169]:40049 "EHLO
        mail-yb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdK0I7m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 03:59:42 -0500
Received: by mail-yb0-f169.google.com with SMTP id g2so6735376ybb.7
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Nov 2017 00:59:41 -0800 (PST)
In-Reply-To: <5862C310-F8B9-40AF-826D-BE867CCDA519@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: cgxu <cgxu@mykernel.net>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, suyue@meili-inc.com

On Mon, Nov 27, 2017 at 10:08 AM, cgxu <cgxu@mykernel.net> wrote:
>
> Hi,
>
> Recently I found syncfs and umount could not make data consistency in ove=
rlayfs.
> I did some investigations and now I know synchronization didn=E2=80=99t d=
irectly happen
> in upperdir filesystem during these operations executed in overlayfs.
>

Can you share the method of your investigation?
Maybe make it into an xfstest?
You can probably use dmflakey target.

> I'm also confused by below comment in function ovl_sync_fs() in super.c
>
> /* real inodes have already been synced by sync_filesystem(ovl_sb) */
>
> In my understanding sync_filesystem(ovl_sb) can not make real inodes sync=
ed
> unless delivers real superblock of upperdir filesystem to sync_filesystem=
().
>
> I can=E2=80=99t make sure current implementation is by design or for some=
 other reasons because
> sync upperdir filesystem may be a little bit heavy especially in a large =
filesystem.
> Could anyone give me a hint for this=EF=BC=9F
>

Looks like you are right.
That comment I wrote is an oversight, not by design, although the concern
that you raise is valid.

> If this problem needs to be fix, I=E2=80=99ll try to make a patch for rev=
iew.
>

So the simple way would be to call __sync_filesystem() from ovl_sync_fs()
instead of calling upper_sb->s_op->sync_fs(), but that would be heavy
as you said.
A better fix would be to iterate overlay sb inodes and flush only the dirty
ovl_inode_upper() pages, before calling upper_sb->s_op->sync_fs().

I didn't look closely to see how complex that would be, so let me know what
you think is best.

Thanks,
Amir.
