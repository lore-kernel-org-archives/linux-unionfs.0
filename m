Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5141C00A8F
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Oct 2023 06:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjJXGs6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 02:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbjJXGs5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2023 02:48:57 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339B510C;
        Mon, 23 Oct 2023 23:48:55 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-7781bc3783fso289694685a.1;
        Mon, 23 Oct 2023 23:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698130134; x=1698734934; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inJosdq8jb5PuPq2UDk7SY9dZ1wk9+FXXSMQ8N3WKD0=;
        b=Ddcl+J6LbrM0zO6X8KTJnKO2m2K1POD20TTWR8k8Ez2VmeTY0KqLLA0iHyYaCj1QuR
         cIlgUD3Hb/sokldwQF3KTtao4nRk29admtadUppJ5pR+VP/I+NlbMYJXk2mqogZ2Zxpy
         +ZtRPvEievmienSQLC9JcadFEfSf1zcAkGeI/hM5fmttgIkFDkET0e5Io0556Huov5CW
         x5M87sDj1riAZeTvUYgXoI7L8vjZg4SODjOqtuTvl7KnuJGe2PRjYOVIZ8zDd4IzI5dD
         +YQjeX56eKWQiCN4Mxo/BUBxDrxezhD6OjtwmptsxkgF0EF5Ca4QSr3Ca5os6acqYF1N
         i43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698130134; x=1698734934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=inJosdq8jb5PuPq2UDk7SY9dZ1wk9+FXXSMQ8N3WKD0=;
        b=hiCgT/GmXE8BzIxJK52qROFESFudctoLHlTa3+lOOI76ppEeCuBiBshfAKuxzvCpCP
         3KI1nVlOOdUGXQjzwNpaS+cWs+a2gBHX/qLo7F45Rq9t08izrzQR76FtNmCPhgoUU80r
         n4ze68z/l/uMUopIBQ9dR6UghTTkF+U+7OZN72RHMPt3XMeKIOUTC4utgukhXsxH8ucp
         l5mw2af4uBmu+SBZtAcLtKvuHATh3Xqk5lvZPC6InswaNZ6TphbFc8c6sMMMTy2eLtPW
         rhCGm8YCUOm5XXcK9xWgwOkGwsc2nQg7cmgJSlUXQmWTHqIjfmnVLznLgwn6Rp4w8cg9
         u+Uw==
X-Gm-Message-State: AOJu0Yx/umoE4z89eonlK/kuV4whU+W9PG5kqJRMslBSzBBRZdye1ruT
        1KL705nH5x++I+wBDq2OM/EzWngzyICx165tX6U=
X-Google-Smtp-Source: AGHT+IHG+3q7slEZoJjuWDyHrOIL4GRvL6lv2/j7h5pSyJ+HibW97oIvN0x0iMjjzMFLWgArVM55SnA1M6sWVY+Yzdo=
X-Received: by 2002:a05:6214:5089:b0:656:3fbd:d1f3 with SMTP id
 kk9-20020a056214508900b006563fbdd1f3mr14274160qvb.11.1698130134172; Mon, 23
 Oct 2023 23:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20231023163259.2949803-1-amir73il@gmail.com> <20231024052433.gpalxwtb37kqd6kn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231024052433.gpalxwtb37kqd6kn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 24 Oct 2023 09:48:42 +0300
Message-ID: <CAOQ4uxgD5KoDc5=VjvpguAO07SixYFZafJr+7fhs9J13LL2s4w@mail.gmail.com>
Subject: Re: [PATCH v3] overlay: add test for lowerdir mount option parsing
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

On Tue, Oct 24, 2023 at 8:24=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Mon, Oct 23, 2023 at 07:32:59PM +0300, Amir Goldstein wrote:
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
> > Changes since v2:
> > - Fix test for when index feature is enabled
> >
> > Changes since v1:
> > - Fix test for libmount >=3D 2.39
> >
> >  tests/overlay/083     | 76 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/083.out |  2 ++
> >  2 files changed, 78 insertions(+)
> >  create mode 100755 tests/overlay/083
> >  create mode 100644 tests/overlay/083.out
> >
> > diff --git a/tests/overlay/083 b/tests/overlay/083
> > new file mode 100755
> > index 00000000..df82d1fd
> > --- /dev/null
> > +++ b/tests/overlay/083
> > @@ -0,0 +1,76 @@
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
> > +
> > +# Re-create the upper/work dirs to mount them with a different lower
> > +# This is required in case index feature is enabled
> > +$UMOUNT_PROG $SCRATCH_MNT
> > +rm -rf "$upperdir" "$workdir"
> > +mkdir -p "$upperdir" "$workdir"
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
> This version looks good to me. I just hope we can remove the "LIBMOUNT_FO=
RCE_MOUNT2=3Dalways"
> after that issue get fixed, to let this case cover new mount API test too=
.
>

TBH, I am not really sure the best approach here would be.
Let's say that the issue gets fixed in libmount 2.40.
Would we then remove "LIBMOUNT_FORCE_MOUNT2=3Dalways"
and add a hint:

_fixed_in_version libmount 2.40

Do you think that would be the appropriate thing to do for fstests?

I am asking because so far fstests was used to track regressions
in kernel and in various fs progs, e.g.:
_fixed_by_git_commit btrfs-progs ...
_fixed_by_git_commit xfsprogs ...
_fixed_by_git_commit xfsdump ...

Where developers of said fs progs often build their own binaries.

An alternative would be to extend _require_command to take
an optional min_ver argument and try to figure out the version
from running $command -V (best effort).
I am not going to cheer for this approach...

Anyway, we plan to add new overlayfs mount options that
are only supported with FSCONFIG_SET_PATH and libmount 2.39
does not support this yet, so are probably going to need to use
a helper program in src to test the new mount API on overlayfs anyway.

Thanks,
Amir.
