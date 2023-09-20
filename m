Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461C4C04A97
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Sep 2023 15:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjITPeo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 11:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235454AbjITPel (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Sep 2023 11:34:41 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7D9A3;
        Wed, 20 Sep 2023 08:34:34 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id 71dfb90a1353d-49351972cbeso2647499e0c.2;
        Wed, 20 Sep 2023 08:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695224072; x=1695828872; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6xgfycrDfXDSoYS8UUa4kOAVuKTt2sQwgXfyUldWLI=;
        b=TdtxAhqB03CGVAp/2+1IWBk+EptHKP6G5L+BeHcs9d6rh+gsDKmT1E/1MivqnaB920
         C28bMWkzellz9X3aisaVwPmrE8HW1gZRRrA2EbxXOeuCfoF1TuKTkxwS6m2Yrs0VrhNq
         bIJJ2J9ZH7gxz8QkNjhwyso+aeKp7d22mEkkz2LyKuGJJMYlB+mI9a4S+SS84nuQJwhx
         ddmFodBy6Fx0jRrnyXjJ6xz8ly6/w+C5Zl9+SlJtMrB9enAKBHLpzFBvY9EgatAZdCgC
         09jR2XpVxkO+lqj+SsLlUuBKgXsO+pNejskkKbxVtjFHmCHr8lbPf32ayMSpoz6lCN/5
         UuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695224072; x=1695828872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6xgfycrDfXDSoYS8UUa4kOAVuKTt2sQwgXfyUldWLI=;
        b=iu6wmTo7RYk1ktgDpwtavznJzHVwVkeySFdEGVuB4CW3p6LpQVS4MOn6I48BtVCg4V
         fnzgyY/7pmJWUlfGeSzMBSBlXkrSAeDB8Rrfe7m1az5SR411FHjHFzHNCYPm1LJns1KN
         3+L7V7SahIhwLXBCyX6u2natJF65eQ9cBPmv5tjRJ54deu3puR0G3qkERtCNQIn6Ii5p
         ryYCL3m4v0Y5mmltgmLV05Ad4EAobSX9h+WNi9Ixk22XsZKi1GPzLCuCsyhgmzQjhiv1
         gHfIXjNbrTaVprZu5Jn7xlDPBS33kiuBLBG0JhXE4ldM3+7rn1Lqv+0MWDlW7M1ExIfM
         9ftA==
X-Gm-Message-State: AOJu0YwXoOrc3NG30Catb1R8Fnl9cyIiJwbU/BOpTiOZ5zgzc4sCasat
        jhlCHmN8J7ozsyJKknkQ0KC+uyo9VvcumvtOcbkDbLkZTjI=
X-Google-Smtp-Source: AGHT+IEkezAjkivmbsBp9Oz7J79B98alW89gbSwyGFc+qMvL5fwuhIpI/einIFD748Biswm8OS7GMi8qjvysxN96OaM=
X-Received: by 2002:a1f:ca46:0:b0:495:bf04:8a05 with SMTP id
 a67-20020a1fca46000000b00495bf048a05mr2562919vkg.9.1695224072124; Wed, 20 Sep
 2023 08:34:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230920130355.62763-1-amir73il@gmail.com> <20230920151403.gsh5gphvlilhp6sv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20230920151403.gsh5gphvlilhp6sv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 20 Sep 2023 18:34:21 +0300
Message-ID: <CAOQ4uxhxsg2AwttYPfhSLQQNbFxo2pmyNUMTC8QpxNw6L_afpw@mail.gmail.com>
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

On Wed, Sep 20, 2023 at 6:14=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Wed, Sep 20, 2023 at 04:03:55PM +0300, Amir Goldstein wrote:
> > A test for a regression from v5.15 reported by Ruiwen Zhao:
> > https://lore.kernel.org/linux-unionfs/CAKd=3Dy5Hpg7J2gxrFT02F94o=3DFM9Q=
vGp=3DkcH1Grctx8HzFYvpiA@mail.gmail.com/
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Zorro,
> >
> > This is a test for a regression in kernel v5.15.
> > The fix was merged for 6.6-rc2 and has been picked for
> > the upcoming LTS releases 5.15, 6.1, 6.5.
> >
> > The reproducer only manifests the bug in fs that inherit noatime flag,
> > namely ext4, btrfs, ... but not xfs.
> >
> > The test does _notrun on xfs for that reason.
> >
> > Thanks,
> > Amir.
> >
> >  tests/overlay/082     | 68 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/082.out |  2 ++
> >  2 files changed, 70 insertions(+)
> >  create mode 100755 tests/overlay/082
> >  create mode 100644 tests/overlay/082.out
> >
> > diff --git a/tests/overlay/082 b/tests/overlay/082
> > new file mode 100755
> > index 00000000..abea3c2b
> > --- /dev/null
> > +++ b/tests/overlay/082
> > @@ -0,0 +1,68 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> > +#
> > +# FS QA Test 082
> > +#
> > +# kernel commit 72db82115d2b ("ovl: copy up sync/noatime fileattr flag=
s")
> > +# from v5.15 introduced a regression.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs overlay
> > +_fixed_by_kernel_commit ab048302026d \
> > +     "ovl: fix failed copyup of fileattr on a symlink"
> > +
> > +_require_scratch
> > +_require_chattr A
> > +
> > +# remove all files from previous runs
> > +_scratch_mkfs
> > +
> > +# prepare lower test dir with NOATIME flag
> > +lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> > +mkdir -p $lowerdir/testdir
> > +$CHATTR_PROG +A $lowerdir/testdir >> $seqres.full 2>&1 ||
> > +     _notrun "base fs $OVL_BASE_FSTYP does not support No_Atime flag"
> > +
> > +# The NOATIME is inheritted to children symlink in ext4/fs2fs
> > +# (and on tmpfs on recent kernels).
> > +# The overlayfs test will not fail unless base fs is
> > +# one of those filesystems.
> > +#
> > +# The problem with this inheritence is that the NOATIME flag is inheri=
tted
> > +# to a symlink and the flag does take effect, but there is no way to q=
uery
> > +# the flag (lsattr) or change it (chattr) on a symlink, so overlayfs w=
ill
> > +# fail when trying to copy up NOATIME flag from lower to upper symlink=
.
> > +#
> > +touch $lowerdir/testdir/foo
> > +ln -sf foo $lowerdir/testdir/lnk
> > +
> > +$LSATTR_PROG -l $lowerdir/testdir/foo >> $seqres.full 2>&1
> > +$LSATTR_PROG -l $lowerdir/testdir/foo | grep -q No_Atime || \
> > +     _notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag"
> > +
> > +before=3D$(stat -c %x $lowerdir/testdir/lnk)
> > +echo "symlink atime before readlink: $before" >> $seqres.full 2>&1
> > +cat $lowerdir/testdir/lnk
> > +after=3D$(stat -c %x $lowerdir/testdir/lnk)
> > +echo "symlink atime after readlink: $after" >> $seqres.full 2>&1
> > +
> > +[ "$before" =3D=3D "$after" ] || \
> > +     _notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag o=
n symlink"
> > +
> > +# mounting overlay
> > +_scratch_mount
> > +
> > +# moving symlink will try to copy up lower symlink flags
> > +mv $SCRATCH_MNT/testdir/lnk $SCRATCH_MNT/
>
> Lots of above codes are checking if the underlying fs supports No_Atime (=
and inherit),
> and _notrun if not support. How about do these checking steps in a requir=
e_*
> function locally or in common/, likes _require_noatime_inheritance(). And=
 we also
> can let _require_chattr accept one more argument to specify a test direct=
ory.
>

ok.

> The "mv ..." command looks like the final testing step. If there's not th=
at bug,
> nothing happen, but I'm wondering what should happen if there's a bug?

mv fails with error ENXIO, see linked bug report in commit message.

Thanks,
Amir.
