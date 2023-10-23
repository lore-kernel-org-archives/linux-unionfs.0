Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FE2CDB474
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Oct 2023 14:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjJWOXd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 10:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjJWOXd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Oct 2023 10:23:33 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A5F100;
        Mon, 23 Oct 2023 07:23:30 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-3b3f6f330d4so1814959b6e.2;
        Mon, 23 Oct 2023 07:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698071010; x=1698675810; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yETbC1VXhdBUNyg8/wLvtXWyTcXn6v4HAao7RFdhPA=;
        b=DSPCYoDkUQoXQdU8TW5CvncRAo3fXEvdC+R+ElQ0NqlYxK6ElKFNL8mtLvk7hRrQsd
         lelKbh+4pbhzCVzS//uRLR/bFvP/4NmdyszEftpzfwS7sEDMjrurH3mpBDdqdguPddos
         LG1cohZ9ULONnS2+5LAUZkyMATD+ek4IC8lYfkR4Q3shcyR6BbpTA/tKQi7FNrkbkxGG
         hqIp8cGOE8uN9njkI3NGs8Q1DFUypuz6Nvsph9M5k/A/SlQ8xU+zQv5/4eQEn8YDJ3Y1
         rUgNChAEzJ1Udt3FpZLKStp3D1RvHvRi/iMGJq/noQt/IuuT+xyUVNqrOiJgFzFLFjzJ
         w3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698071010; x=1698675810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2yETbC1VXhdBUNyg8/wLvtXWyTcXn6v4HAao7RFdhPA=;
        b=tSR+bvwlA/1831QDtJl7kmZ0RctxNCiyxjhUYNsOG9rTCXDns8uJbt0Dq/sVPQoGBl
         hzxGjvWOduli6N5DsaKun/BSrR2iCK3BGRmFj+OJM3mcL36Vq5rVbsFfyWUyWmuFJp1U
         VECqbxvv+BiLAqDPL5ddecQqPFSLKO/0Yma+ak7tACIl4+8ZxzrYl0M6IVhwSjwIuxJH
         sYvX9Ns9dAyeChiTGjJpTGWlJCU0z2Zbl61JSAtP96HeISCnFGrpbjeVQRz5NJRhhxGZ
         fPdvEKAOWIJ6qt7WdbVzHtBNKX4XiPRGYXNo/asDWjFQBbdytIQMq37pGv9ORskD2E9q
         Zbfg==
X-Gm-Message-State: AOJu0YwlyXEDjngOp5G6oVbWuCuf/Xw+thlIVH7EpQi11l1APldMGAkk
        PqE0mL64YFalEpm5S2g3rSkFYGkaaug4Sm8qtxDQjUNnCxc=
X-Google-Smtp-Source: AGHT+IEQ030x9iJxme1tg+y0V69GHR9fhsvatPVGGdO1qBCvNgBNE8Wg3tWv0Y3jHvb4040DSos9bCn4tZB3UYkWBSY=
X-Received: by 2002:a05:6808:1a91:b0:3ae:2b43:dd21 with SMTP id
 bm17-20020a0568081a9100b003ae2b43dd21mr8714606oib.25.1698071010032; Mon, 23
 Oct 2023 07:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <20231023104916.2932366-1-amir73il@gmail.com> <20231023140237.d5e3qewsm4sdi4d2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231023140237.d5e3qewsm4sdi4d2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 23 Oct 2023 17:23:18 +0300
Message-ID: <CAOQ4uxjppUR4Zdume1PkV367FskpiFGrQQdBpBGoPGTyVgbPSQ@mail.gmail.com>
Subject: Re: [PATCH v2] overlay: add test for lowerdir mount option parsing
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        Karel Zak <kzak@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 23, 2023 at 5:03=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Mon, Oct 23, 2023 at 01:49:16PM +0300, Amir Goldstein wrote:
> > Check parsing and display of spaces and escaped colons and commans in
> > lowerdir mount option.
> >
> > This is a regression test for two bugs introduced in v6.5 with the
> > conversion to new mount api.
> >
> > There is another regression of new mount api related to libmount parsin=
g
> > of escaped commas, but this needs a fix in libmount - this test only
> > verifies the fixes in the kernel, so it uses LIBMOUNT_FORCE_MOUNT2=3Dal=
ways
> > to force mount(2) and kernel pasring of the comma separated options lis=
t.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Zorro,
> >
> > I've fixed the libmount issue by splitting the combined test cases
> > to two test cases that corresspond to the two kernel fix commits.
> >
> > The first test case (lowerdir_spaces) is agnostic to libmount version.
> >
> > The second test case (lowerdir_commas) explicitly opts-in to mount(2)
> > syscall.
> >
> > ATM, using LIBMOUNT_FORCE_MOUNT2=3Dalways, as the second test cases doe=
s,
> > would be our recommended workaround for the escaped commas regression
> > in v6.5, until libmount gets a fix to detect overlayfs escaped commas.
> >
> > Thanks,
> > Amir.
> >
> >  tests/overlay/083     | 71 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/083.out |  2 ++
> >  2 files changed, 73 insertions(+)
> >  create mode 100755 tests/overlay/083
> >  create mode 100644 tests/overlay/083.out
> >
> > diff --git a/tests/overlay/083 b/tests/overlay/083
> > new file mode 100755
> > index 00000000..0f434951
> > --- /dev/null
> > +++ b/tests/overlay/083
> > @@ -0,0 +1,71 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> > +#
> > +# FS QA Test 083
> > +#
> > +# Test regressions in parsing and display of special chars in mount op=
tions.
> > +#
> > +# The following kernel commits from v6.5 introduced regressions:
> > +#  b36a5780cb44 ("ovl: modify layer parameter parsing")
> > +#  1784fbc2ed9c ("ovl: port to new mount api")
> > +#
> > +
> > +. ./common/preamble
> > +_begin_fstest auto quick mount
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs overlay
> > +_fixed_by_kernel_commit 32db51070850 \
> > +     "ovl: fix regression in showing lowerdir mount option"
> > +_fixed_by_kernel_commit c34706acf40b \
> > +     "ovl: fix regression in parsing of mount options with escaped com=
ma"
> > +
> > +# _overlay_check_* helpers do not handle special chars well
> > +_require_scratch_nocheck
> > +
> > +# Remove all files from previous tests
> > +_scratch_mkfs
> > +
> > +# Create lowerdirs with special characters
> > +lowerdir_spaces=3D"$OVL_BASE_SCRATCH_MNT/lower1 with  spaces"
> > +lowerdir_colons=3D"$OVL_BASE_SCRATCH_MNT/lower2:with::colons"
> > +lowerdir_commas=3D"$OVL_BASE_SCRATCH_MNT/lower3,with,,commas"
> > +lowerdir_colons_esc=3D"$OVL_BASE_SCRATCH_MNT/lower2\:with\:\:colons"
> > +lowerdir_commas_esc=3D"$OVL_BASE_SCRATCH_MNT/lower3\,with\,\,commas"
> > +upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> > +workdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> > +mkdir -p "$lowerdir_spaces" "$lowerdir_colons" "$lowerdir_commas"
> > +
> > +# _overlay_mount_* helpers do not handle special chars well, so execut=
e mount directly.
> > +# if escaped colons are not parsed correctly, mount will fail.
> > +$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
> > +     -o"upperdir=3D$upperdir,workdir=3D$workdir" \
> > +     -o"lowerdir=3D$lowerdir_colons_esc:$lowerdir_spaces" \
> > +     2>&1 | tee -a $seqres.full
> > +
> > +# if spaces are not escaped when showing mount options,
> > +# mount command will not show the word 'spaces' after the spaces
> > +$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full | gr=
ep -v spaces && \
> > +     echo "ERROR: escaped spaces truncated from lowerdir mount option"
> > +$UMOUNT_PROG $SCRATCH_MNT
> > +
> > +# Kernel commit c34706acf40b fixes parsing of mount options with escap=
ed comma
> > +# when the mount options string is provided via data argument to mount=
(2) syscall.
> > +# With libmount >=3D 2.39, libmount itself will try to split the comma=
 separated
> > +# options list provided to mount(8) commnad line and call fsconfig(2) =
for each
> > +# mount option seperately.  Since libmount does not obay to overlayfs =
escaped
> > +# commas format, it will call fsconfig(2) with the wrong path (i.e. ".=
../lower3")
> > +# and this test will fail, but the failure would indicate a libmount i=
ssue, not
> > +# a kernel issue.  Therefore, force libmount to use mount(2) syscall, =
so we only
> > +# test the kernel fix.
> > +LIBMOUNT_FORCE_MOUNT2=3Dalways $MOUNT_PROG -t overlay $OVL_BASE_SCRATC=
H_DEV $SCRATCH_MNT \
> > +     -o"upperdir=3D$upperdir,workdir=3D$workdir,lowerdir=3D$lowerdir_c=
ommas_esc" 2>> $seqres.full || \
> > +     echo "ERROR: incorrect parsing of escaped comma in lowerdir mount=
 option"
>
> Hi Amir, Please check, this part still fails as:
>
> # ./check -overlay overlay/083
> FSTYP         -- overlay
> PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP P=
REEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> MKFS_OPTIONS  -- /mnt/scratch
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /mnt/scratch /m=
nt/scratch/ovl-mnt
>
> overlay/083 0s ... - output mismatch (see /root/git/xfstests/results//ove=
rlay/083.out.bad)
>     --- tests/overlay/083.out   2023-10-23 21:18:46.765059777 +0800
>     +++ /root/git/xfstests/results//overlay/083.out.bad 2023-10-23 21:51:=
39.030561512 +0800
>     @@ -1,2 +1,3 @@
>      QA output created by 083
>     +ERROR: incorrect parsing of escaped comma in lowerdir mount option
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
> # cat results/overlay/083.full
> ovl_esc_test on /mnt/scratch/ovl-mnt type overlay (rw,relatime,seclabel,l=
owerdir=3D/mnt/scratch/lower2\:with\:\:colons:/mnt/scratch/lower1 with  spa=
ces,upperdir=3D/mnt/scratch/ovl-upper,workdir=3D/mnt/scratch/ovl-work,uuid=
=3Don)
> mount: /mnt/scratch/ovl-mnt: mount(2) system call failed: Stale file hand=
le.
>        dmesg(1) may have more information after failed mount system call.
>
> # dmesg
> [341033.046302] run fstests overlay/083 at 2023-10-23 22:00:11
> [341033.458188] XFS (loop0): Mounting V5 Filesystem 23e1781e-f5ce-4c2b-88=
01-3b586f459ee8
> [341033.464410] XFS (loop0): Ending clean mount
> [341033.506666] overlayfs: failed to verify origin (/lower3,with,,commas,=
 ino=3D16908385, err=3D-116)
> [341033.507626] overlayfs: failed to verify upper root origin
> [341033.540865] XFS (loop1): Unmounting Filesystem 58e81b68-81dd-48cd-ab2=
3-ce30ec77e689
> [341033.554488] XFS (loop0): Unmounting Filesystem 23e1781e-f5ce-4c2b-880=
1-3b586f459ee8
>


Oh, you must have CONFIG_OVERLAY_FS_INDEX=3Dy.
I did not check this config.

I will send a fix soon.

Thanks,
Amir.
