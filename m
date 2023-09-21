Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73302E7D0A7
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 20:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjIUUWY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjIUUV4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 16:21:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EB6102D45;
        Thu, 21 Sep 2023 12:20:02 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68bed2c786eso1227192b3a.0;
        Thu, 21 Sep 2023 12:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695324002; x=1695928802; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXtpySYKxc+OsZOWd/8zN1g98t7MAxnf4oPopi6yJvc=;
        b=XvttUsJkdYsyDQOkN/v8Glczs6c5fRWiUyEWrjgg7KgqLb3YzIUORFBNm0f0I0SP3Q
         F6Hq8J6odLWM2Bi2M9HLLIU9NTu/X2PTjiE/6SRCE1uJViyBXK/rxJU0/urbiNXD594l
         dm59kCf8g3ZZp9/eKiF/E2z2Qnrxd9gdX4j3p2MWGNVONIcJXvL6nlrF6p/pkX96rTZa
         XPDesQ5sz4OXG7zOyiivNqWwGA3OpvVe46K/2Qnn3ZO3UEauXC7AaXeG5tWUwcRJ9Cj+
         X8Y8COZwNLzn3dGL5hN2jSLmIEaDYrQxnxCvvygosGOr23051/KQy3UhWOKFcPEfRVAJ
         kIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695324002; x=1695928802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SXtpySYKxc+OsZOWd/8zN1g98t7MAxnf4oPopi6yJvc=;
        b=dVwZpaj5qkwqbaj4KNLNKmG2YoUuP3Putuj9HNqOf9wsK/I0wpJ4wMFhkanV99dcSq
         ka4zk4Y+0sIQrYC7eD4vO6z0rC4QNgRaf14Jv8fH+DZMCebcH4qAbSmGTGuA5vTWOQpX
         noTagMeeeU5dd5F/guUYSi+iMN8EgMdoTFUO1AJW0dGYyKEzYSuiEY+zcHNcoNXOxTbi
         GnisvITf4A0L3f9+KcOfrqLuw3PsRU21NeGKw3VLH1hPAEv/enu/lvzqMGD+cYCgKAY6
         LzW1sP9osV+M22G2biCH08r/mvs9GXDy3xiC7ZRVGG5mOdaN5H1dGQTMBUlnVTrKYzVy
         5nzw==
X-Gm-Message-State: AOJu0YwiW7SbabgHj0BoJpZvT5GYyp3ZEGG/Wl3BVqGwKv2Gp11oqMyL
        AtQrhQ9eotplfT2qRuAiMnNwA/2BjsHFfm/rsQXYUrm1VzM=
X-Google-Smtp-Source: AGHT+IE92sXuSBvvVkGVkRrIlqorfVMqFTTxU6QGaKQKeIyip+smzMq0DNcHAne5pwSD5SE6HMzBRnQ1VHnXUuehVfk=
X-Received: by 2002:a67:ebc1:0:b0:452:560e:31a9 with SMTP id
 y1-20020a67ebc1000000b00452560e31a9mr5009814vso.1.1695283248717; Thu, 21 Sep
 2023 01:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230920130355.62763-1-amir73il@gmail.com> <20230920151403.gsh5gphvlilhp6sv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhxsg2AwttYPfhSLQQNbFxo2pmyNUMTC8QpxNw6L_afpw@mail.gmail.com> <20230921062645.lhryfrod7ggdxfuh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20230921062645.lhryfrod7ggdxfuh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 21 Sep 2023 11:00:37 +0300
Message-ID: <CAOQ4uxjNy6tD87dsGKAOwu6VpkoH3+kgzOEw=KQOzDF1WhhN=A@mail.gmail.com>
Subject: Re: [PATCH] overlay: add test for rename of lower symlink with
 NOATIME attr
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 21, 2023 at 9:26=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Wed, Sep 20, 2023 at 06:34:21PM +0300, Amir Goldstein wrote:
> > On Wed, Sep 20, 2023 at 6:14=E2=80=AFPM Zorro Lang <zlang@redhat.com> w=
rote:
> > >
> > > On Wed, Sep 20, 2023 at 04:03:55PM +0300, Amir Goldstein wrote:
> > > > A test for a regression from v5.15 reported by Ruiwen Zhao:
> > > > https://lore.kernel.org/linux-unionfs/CAKd=3Dy5Hpg7J2gxrFT02F94o=3D=
FM9QvGp=3DkcH1Grctx8HzFYvpiA@mail.gmail.com/
>
> Could you give one more sentence to tell what kind of regression
> does this case test for? Not only a link address.
>
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Zorro,
> > > >
> > > > This is a test for a regression in kernel v5.15.
> > > > The fix was merged for 6.6-rc2 and has been picked for
> > > > the upcoming LTS releases 5.15, 6.1, 6.5.
> > > >
> > > > The reproducer only manifests the bug in fs that inherit noatime fl=
ag,
> > > > namely ext4, btrfs, ... but not xfs.

FYI, I made a mistake in the statement above.
xfs does support inherit of noatime flag, but
it does not inherit noatime for *symlinks*.

I added the _require_chattr_inherit helper that you suggested
in v2, but it only checks for inherit of noatime flag (the 2nd _notrun).
I did not add a helper for _require_chattr_inherit_symlink
because it was too specific and so I left the 3rd _notrun
open coded in the test in v2.

> > > >
> > > > The test does _notrun on xfs for that reason.
> > > >
> > > > Thanks,
> > > > Amir.
> > > >
> > > >  tests/overlay/082     | 68 +++++++++++++++++++++++++++++++++++++++=
++++
> > > >  tests/overlay/082.out |  2 ++
> > > >  2 files changed, 70 insertions(+)
> > > >  create mode 100755 tests/overlay/082
> > > >  create mode 100644 tests/overlay/082.out
> > > >
> > > > diff --git a/tests/overlay/082 b/tests/overlay/082
> > > > new file mode 100755
> > > > index 00000000..abea3c2b
> > > > --- /dev/null
> > > > +++ b/tests/overlay/082
> > > > @@ -0,0 +1,68 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> > > > +#
> > > > +# FS QA Test 082
> > > > +#
> > > > +# kernel commit 72db82115d2b ("ovl: copy up sync/noatime fileattr =
flags")
> > > > +# from v5.15 introduced a regression.
>
> Hi Amir,
>
> Thanks for this new regression test. More detailed (picky:) review points
> as below ...
>
> So this commit is the one which introduced a regression. But we generally
> say what kind of regression does this case test for, in this comment.
>
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick
>
> According the source code of this case, please think about more detailed =
group
> names, likes: "symlink", "copyup" and "atime".
>
> > > > +
> > > > +# Import common functions.
> > > > +. ./common/filter
>
> I think this case doesn't use any filter helpers, right?
>
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs overlay
> > > > +_fixed_by_kernel_commit ab048302026d \
> > > > +     "ovl: fix failed copyup of fileattr on a symlink"
> > > > +
> > > > +_require_scratch
> > > > +_require_chattr A
> > > > +
> > > > +# remove all files from previous runs
> > > > +_scratch_mkfs
> > > > +
> > > > +# prepare lower test dir with NOATIME flag
> > > > +lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> > > > +mkdir -p $lowerdir/testdir
> > > > +$CHATTR_PROG +A $lowerdir/testdir >> $seqres.full 2>&1 ||
> > > > +     _notrun "base fs $OVL_BASE_FSTYP does not support No_Atime fl=
ag"
> > > > +
> > > > +# The NOATIME is inheritted to children symlink in ext4/fs2fs
> > > > +# (and on tmpfs on recent kernels).
> > > > +# The overlayfs test will not fail unless base fs is
> > > > +# one of those filesystems.
> > > > +#
> > > > +# The problem with this inheritence is that the NOATIME flag is in=
heritted
> > > > +# to a symlink and the flag does take effect, but there is no way =
to query
> > > > +# the flag (lsattr) or change it (chattr) on a symlink, so overlay=
fs will
> > > > +# fail when trying to copy up NOATIME flag from lower to upper sym=
link.
> > > > +#
> > > > +touch $lowerdir/testdir/foo
> > > > +ln -sf foo $lowerdir/testdir/lnk
> > > > +
> > > > +$LSATTR_PROG -l $lowerdir/testdir/foo >> $seqres.full 2>&1
> > > > +$LSATTR_PROG -l $lowerdir/testdir/foo | grep -q No_Atime || \
> > > > +     _notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime fl=
ag"
> > > > +
> > > > +before=3D$(stat -c %x $lowerdir/testdir/lnk)
> > > > +echo "symlink atime before readlink: $before" >> $seqres.full 2>&1
>
> I remember some filesystems' timestamp for atime (e.g. exfat) might have =
more
> seconds granularity. So it would be better to `sleep 2s` at here.
>
> Correct me if someone fs need more or less :)
>

That would be a futile waste of 2 seconds IMO, because
Those niche fs probably do not support chattr and because
This is an overlayfs regression test and overlayfs is highly
unlikely to be running in production on those niche fs and it
probably does not support many of them.


> > > > +cat $lowerdir/testdir/lnk
> > > > +after=3D$(stat -c %x $lowerdir/testdir/lnk)
> > > > +echo "symlink atime after readlink: $after" >> $seqres.full 2>&1
> > > > +
> > > > +[ "$before" =3D=3D "$after" ] || \
> > > > +     _notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime fl=
ag on symlink"
> > > > +
> > > > +# mounting overlay
> > > > +_scratch_mount
> > > > +
> > > > +# moving symlink will try to copy up lower symlink flags
> > > > +mv $SCRATCH_MNT/testdir/lnk $SCRATCH_MNT/
> > >
> > > Lots of above codes are checking if the underlying fs supports No_Ati=
me (and inherit),
> > > and _notrun if not support. How about do these checking steps in a re=
quire_*
> > > function locally or in common/, likes _require_noatime_inheritance().=
 And we also
> > > can let _require_chattr accept one more argument to specify a test di=
rectory.
> > >
> >
> > ok.
> >
> > > The "mv ..." command looks like the final testing step. If there's no=
t that bug,
> > > nothing happen, but I'm wondering what should happen if there's a bug=
?
> >
> > mv fails with error ENXIO, see linked bug report in commit message.
>
> Thanks, I think we can add "fails with error ENXIO at here, if the bug is=
 reproduced" in
> the comment of that "mv ..." command.
>

Sure. no problem.
I will post v2 soon with _require_chattr_inherit and
above comments fixed.

Thanks for the review!
Amir.
