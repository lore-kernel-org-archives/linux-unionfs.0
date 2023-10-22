Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69450C00A8F
	for <linux-unionfs@archiver.kernel.org>; Sun, 22 Oct 2023 07:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjJVHKM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 22 Oct 2023 03:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjJVHKL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 22 Oct 2023 03:10:11 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DE2F7;
        Sun, 22 Oct 2023 00:10:08 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 71dfb90a1353d-49d0ae5eb7bso777797e0c.0;
        Sun, 22 Oct 2023 00:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697958608; x=1698563408; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4k/9FY6fMFqvpg448nKs2FBoQM4OJPOc2Fs8YH2hpHk=;
        b=djEYev2Bcn7NfIMVo+K855a1eDwj5JcrKfBKkWt4yRXODTu4fg4Pm5xW+UWSwEAlHY
         GojbCexb/j+ZPUj6dsAJLbQW1GefkPxmywVHy+bPmjkJexFqpgfmPtd28+d8Qy64Gvkt
         zwdkhXQ6v2r7r3DVJ7rJ+pWNoH9UketUAlM5Hy4gJ5wnlmXHtmhfitv9QNleDJKlIRgo
         0e0Bu3hNU4DktxLTDdKo5vQF53ylb6j5SCLORkKkwj6i5jbEGv+DDwqjoVxFo6pM1UQV
         C+GM00cuxLAJ1lZTUgCUtUZN/vVQzv2a0FxQxfUlcxlkuQKrE72ti+JSEIb1p3zZFFjM
         arew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697958608; x=1698563408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4k/9FY6fMFqvpg448nKs2FBoQM4OJPOc2Fs8YH2hpHk=;
        b=nTX89Jr9dicFdpcXoTmueOV/qqYvXQWRsW7gTG2TK0nDenmQByaRGiW+FkMZU/fg61
         +WlZjwuiIG/gZaIM4pvtb4dhU705IZUTZw9o45GJRqBdtJO2uyQlqPltbQYnohNldxyD
         9rYKn860JYTfMwT40YWc0QsQFssxhWrHdM1IwgZmq3K7PNA25SfQP6rIDG0FJ4G77ZZ2
         /OeHToMe+Xz2FnqjuCFNej+m7mtLyYZu8A5DJtCN76pdf9J7QgoUyJU/ln6joRlZi55/
         2Qlm4d3CYUzBMMfNZ84qJJAjRtTTuDn50VwaZK19CC8UuICnvH4UnMjgcwrqFRif7Vmu
         je5A==
X-Gm-Message-State: AOJu0YzCTi0e8uc8uxWhDIwegTlsibRgY7zsVr9Rz3qMKFMHVKHTNI26
        +VJ71k+d4HTV1sUzFDpmcchY7jaSfGFqshXLwl+M5wuNLqE=
X-Google-Smtp-Source: AGHT+IGxJ9hwDBZv5Cst51A5zbN3ED2Hh4I39vZnLY/dKMhGgLfy2J2L0QGoymSMOgz0SuyVs8k23ORHUExGI8GzOng=
X-Received: by 2002:a05:6102:10c3:b0:457:cc13:29f6 with SMTP id
 t3-20020a05610210c300b00457cc1329f6mr5897378vsr.31.1697958607686; Sun, 22 Oct
 2023 00:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <20231017101145.2348571-1-amir73il@gmail.com> <20231019175000.afv2b5fma3ttkt4v@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgYyEfyFrQbyzdzXko6ZUmdRS6g2gH8znOrz-7M3KCUXg@mail.gmail.com>
 <20231021123000.4rp7iykcomfdk6ev@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgHZxcf-OdJHwKn0PUonK4sQz90av+=rurjURW=gw1g3Q@mail.gmail.com> <20231022062634.cdqoy77oe7ibt5vo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231022062634.cdqoy77oe7ibt5vo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 22 Oct 2023 10:09:55 +0300
Message-ID: <CAOQ4uxipfnuEAmKFZdH=61QN_j+F9svcVGDf=+be6-hx9kq70A@mail.gmail.com>
Subject: Re: [PATCH] overlay: add test for lowerdir mount option parsing
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, Karel Zak <kzak@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Oct 22, 2023 at 9:26=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Sat, Oct 21, 2023 at 03:48:09PM +0300, Amir Goldstein wrote:
> >    On Sat, Oct 21, 2023, 3:30 PM Zorro Lang <[1]zlang@redhat.com> wrote=
:
> >
> >      On Fri, Oct 20, 2023 at 07:18:55PM +0300, Amir Goldstein wrote:
> >      > On Thu, Oct 19, 2023 at 8:50=E2=80=AFPM Zorro Lang <[2]zlang@red=
hat.com>
> >      wrote:
> >      > >
> >      > > On Tue, Oct 17, 2023 at 01:11:45PM +0300, Amir Goldstein wrote=
:
> >      > > > Check parsing and display of spaces and escaped colons and
> >      commans in
> >      > > > lowerdir mount option.
> >      > > >
> >      > > > This is a regression test for two bugs introduced in v6.5 wi=
th
> >      the
> >      > > > conversion to new mount api.
> >      > > >
> >      > > > Signed-off-by: Amir Goldstein <[3]amir73il@gmail.com>
> >      > > > ---
> >      > > >
> >      > > > Zorro,
> >      > > >
> >      > > > This is a test for two regressions in kernel v6.5.
> >      > > > The two fixes were merged in 6.6-rc6 and have been picked fo=
r
> >      > > > the upcoming LTS 6.5.y release.
> >      > >
> >      > >
> >      > > >
> >      > > > Thanks,
> >      > > > Amir.
> >      > > >
> >      > > >  tests/overlay/083     | 54
> >      +++++++++++++++++++++++++++++++++++++++++++
> >      > > >  tests/overlay/083.out |  2 ++
> >      > > >  2 files changed, 56 insertions(+)
> >      > > >  create mode 100755 tests/overlay/083
> >      > > >  create mode 100644 tests/overlay/083.out
> >      > > >
> >      > > > diff --git a/tests/overlay/083 b/tests/overlay/083
> >      > > > new file mode 100755
> >      > > > index 00000000..071b4b84
> >      > > > --- /dev/null
> >      > > > +++ b/tests/overlay/083
> >      > > > @@ -0,0 +1,54 @@
> >      > > > +#! /bin/bash
> >      > > > +# SPDX-License-Identifier: GPL-2.0
> >      > > > +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> >      > > > +#
> >      > > > +# FS QA Test 083
> >      > > > +#
> >      > > > +# Test regressions in parsing and display of special chars =
in
> >      mount options.
> >      > > > +#
> >      > > > +# The following kernel commits from v6.5 introduced
> >      regressions:
> >      > > > +#  b36a5780cb44 ("ovl: modify layer parameter parsing")
> >      > > > +#  1784fbc2ed9c ("ovl: port to new mount api")
> >      > > > +#
> >      > > > +
> >      > > > +. ./common/preamble
> >      > > > +_begin_fstest auto quick mount
> >      > > > +
> >      > > > +# Import common functions.
> >      > > > +. ./common/filter
> >      > > > +
> >      > > > +# real QA test starts here
> >      > > > +_supported_fs overlay
> >      > > > +_fixed_by_kernel_commit 32db51070850 \
> >      > > > +     "ovl: fix regression in showing lowerdir mount option"
> >      > > > +_fixed_by_kernel_commit c34706acf40b \
> >      > > > +     "ovl: fix regression in parsing of mount options with
> >      escaped comma"
> >      > >
> >      > > Hi Amir,
> >      > >
> >      > > I tried this case on the latest linux kernel which contains th=
e
> >      > > two commits, but still hit below failure:
> >      > >
> >      > > FSTYP         -- overlay
> >      > > PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainlin=
e+
> >      #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> >      > > MKFS_OPTIONS  -- /mnt/scratch
> >      > > MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0
> >      /mnt/scratch /mnt/scratch/ovl-mnt
> >      > >
> >      > > overlay/083       - output mismatch (see
> >      /root/git/xfstests/results//overlay/083.out.bad)
> >      > >     --- tests/overlay/083.out   2023-10-19 14:07:18.099496414
> >      +0800
> >      > >     +++ /root/git/xfstests/results//overlay/083.out.bad
> >      2023-10-20 00:25:47.682874383 +0800
> >      > >     @@ -1,2 +1,4 @@
> >      > >      QA output created by 083
> >      > >     +mount: /mnt/scratch/ovl-mnt: special device ovl_esc_test
> >      does not exist.
> >      > >     +       dmesg(1) may have more information after failed
> >      mount system call.
> >      > >      Silence is golden
> >      > >
> >      >
> >      > Strange.
> >      > I was under the impression that the 'dev' argument to mount
> >      command
> >      > of overlayfs is a completely opaque string.
> >      >
> >      > Maybe you are using a different libmount version that I do.
> >      > I have libmount 2.36.1.
> >      I'm using Fedora rawhide, the libmount version is
> >      libmount-2.39.2-1.fc40.
> >      >
> >      > Anyway, can you please try if this variation works for you:
> >      >
> >      > --- a/tests/overlay/083
> >      > +++ b/tests/overlay/083
> >      > @@ -42,12 +42,12 @@ mkdir -p "$lowerdir1" "$lowerdir2"
> >      "$lowerdir3"
> >      >
> >      >  # _overlay_mount_* helpers do not handle special chars well, so
> >      > execute mount directly.
> >      >  # if escaped colons and commas are not parsed correctly, mount
> >      will fail.
> >      > -$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
> >      > +$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> >      I doubt it works. This looks like to try to mount /mnt/scratch on
> >      /mnt/scratch/ovl-mnt.
> >
> >    Please try.
> >    You are making assumption that the dev argument is meaningful to
> >    overlayfs - it is not.
> >    Every one of the overlayfs tests in fstests uses the exact same dev
> >    argument as above inside the ovl mount helpers.
>
> Sure Amir, but it's still failed as below [1]. I think I've changed it as
> you wish [2]. The dmesg shows [3].
>
> Thanks,
> Zorro
>
> [1]
> # ./check -overlay overlay/083
> FSTYP         -- overlay
> PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP P=
REEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> MKFS_OPTIONS  -- /mnt/scratch
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /mnt/scratch /m=
nt/scratch/ovl-mnt
>
> overlay/083       - output mismatch (see /root/git/xfstests/results//over=
lay/083.out.bad)
>     --- tests/overlay/083.out   2023-10-22 14:21:11.446520444 +0800
>     +++ /root/git/xfstests/results//overlay/083.out.bad 2023-10-22 14:23:=
06.642681119 +0800
>     @@ -1,2 +1,4 @@
>      QA output created by 083
>     +mount: /mnt/scratch/ovl-mnt: mount(2) system call failed: No such fi=
le or directory.
>     +       dmesg(1) may have more information after failed mount system =
call.
>      Silence is golden
>     ...
>     (Run 'diff -u /root/git/xfstests/tests/overlay/083.out /root/git/xfst=
ests/results//overlay/083.out.bad'  to see the entire diff)
>
> HINT: You _MAY_ be missing kernel fix:
>       32db51070850 ovl: fix regression in showing lowerdir mount option
>
> HINT: You _MAY_ be missing kernel fix:
>       c34706acf40b ovl: fix regression in parsing of mount options with e=
scaped comma
>
> Ran: overlay/083
> Failures: overlay/083
> Failed 1 of 1 tests
>
> [2]
> # git diff
> diff --git a/tests/overlay/083 b/tests/overlay/083
> index 071b4b84..3a6d6809 100755
> --- a/tests/overlay/083
> +++ b/tests/overlay/083
> @@ -42,12 +42,12 @@ mkdir -p "$lowerdir1" "$lowerdir2" "$lowerdir3"
>
>  # _overlay_mount_* helpers do not handle special chars well, so execute =
mount directly.
>  # if escaped colons and commas are not parsed correctly, mount will fail=
.
> -$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
> +$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
>         -o"upperdir=3D$upperdir,workdir=3D$workdir,lowerdir=3D$lowerdir3_=
esc:$lowerdir2_esc:$lowerdir1"
>
>  # if spaces are not escaped when showing mount options,
>  # mount command will not show the word 'spaces' after the spaces
> -$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full | grep=
 -v spaces
> +$MOUNT_PROG -t overlay | grep lower3 | tee -a $seqres.full | grep -v spa=
ces
>
>  echo "Silence is golden"
>  status=3D0
>
> [3]
> [227208.314968] run fstests overlay/083 at 2023-10-22 14:23:06
> [227208.725135] XFS (loop0): Mounting V5 Filesystem 433b1a77-697c-4a83-ab=
be-85471466b6ca
> [227208.730987] XFS (loop0): Ending clean mount
> [227208.755377] overlayfs: failed to resolve '/mnt/scratch/lower3': -2
> [227208.792994] XFS (loop1): Unmounting Filesystem 0d4e26b6-3202-437c-962=
c-62c15c4763d7
> [227208.809166] XFS (loop0): Unmounting Filesystem 433b1a77-697c-4a83-abb=
e-85471466b6ca
>

This is exactly the "libmount regression" I was warning about:

https://lore.kernel.org/linux-unionfs/20231017101118.5h7pj26vos32h63u@ws.ne=
t.home/

With libmount upgraded to 2.39, the kernel doesn't get a chance
to parse the arguments correctly:

fsconfig(3, FSCONFIG_SET_STRING, "source", "ovl_esc_test", 0) =3D 0
fsconfig(3, FSCONFIG_SET_STRING, "upperdir", "/home/amir/upper", 0) =3D 0
fsconfig(3, FSCONFIG_SET_STRING, "workdir", "/home/amir/work", 0) =3D 0
fsconfig(3, FSCONFIG_SET_STRING, "lowerdir", "/home/amir/lower3\\", 0) =3D =
0
fsconfig(3, FSCONFIG_SET_FLAG, "with\\", NULL, 0) =3D 0
fsconfig(3, FSCONFIG_SET_FLAG, "\\", NULL, 0) =3D 0
fsconfig(3, FSCONFIG_SET_FLAG,
"commas:/home/amir/lower2\\:with\\:"..., NULL, 0) =3D 0
fsconfig(3, FSCONFIG_CMD_CREATE, NULL, NULL, 0) =3D 0

Have no mistake, I am not trying to play the blaming game between
kernel and libmount - we simply have regressions that involve them both.

Kernel c34706acf40b "ovl: fix regression in parsing of mount options with"
solves a regression with comma separated list parsing when using the
old mount API.

Even if kernel could workaround the problem above by re-assembling
the options into a monolithic lowerdir list and splitting them up again, it
would be terribly wrong to do that.

The saner solution, as Karel already suggested it for libmount to
parse \, as a non-separator as overlayfs does with old mount api.
Either that, or, default to old mount api for overlayfs with
LIBMOUNT_FORCE_MOUNT2=3Dauto

As for the test in question.
The purpose of this test is to validate that the kernel comma splitting
regression for old mount api has been fixed.
The fix patches are already in the stable kernel and we need to merge
the test, so that distros will also pick the kernel fix.

To meet this goal we could add to this test:
export LIBMOUNT_FORCE_MOUNT2=3Dnever
so that it can test what it was meant to test.

Can you please try that?

Regarding the fix to libmount, even if a fix to libmount comma separated
list would land in future libmount version, is it the goal of fstests to
test fixes to libmount?

Thanks,
Amir.
