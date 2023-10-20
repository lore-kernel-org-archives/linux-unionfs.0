Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7248CDB474
	for <linux-unionfs@archiver.kernel.org>; Fri, 20 Oct 2023 16:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjJTQTK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 12:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJTQTK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Oct 2023 12:19:10 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBC71A4;
        Fri, 20 Oct 2023 09:19:08 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 3f1490d57ef6-d9c66e70ebdso1028128276.2;
        Fri, 20 Oct 2023 09:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697818747; x=1698423547; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oP5PNeYe8f91HgGFKlBunHtlkKcLAk2EAYhGmoq99U8=;
        b=ZJBSfaiBRgOfP8Yn5LLqiUMGzgWAwxWeVM8739UYoQDIVqOh8BOa7KJYzZ6IM1ixES
         cHthuu/oggHd5EgQcF7YSKzBTlE5z2VCowPQaRkuWpwkPxRKzEpNcxrJvtZ/oGUPmK0p
         qyD4chfEwXbRrWYiXsiwAl8/cUvx+/pFv9e5SO+h5n8uq3SI1QxM2x0IqhasLGjFIq7G
         MRs0ZiJDFZQnfMjU20T5tYpLi8o28apEvpJVrCLqpA3XEmb9fKW6KJSM6OSFUmhHyy1G
         MbgkTOuOkZxHXE57L/1SnTK4eGE+HseZ1exqa8L+ixBGBLLlaS+y1Tsq8ZgaFoLC162k
         EjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697818747; x=1698423547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oP5PNeYe8f91HgGFKlBunHtlkKcLAk2EAYhGmoq99U8=;
        b=dlw/iR5SYZLKvRxToKaThDADaOBPjiBnwszyBKWwXXc9iYp6wMafMwg4htlgRnmsML
         YY9h39Me9gY7vUWF+zCYxX9Bs9CpzAjvd+dpdPUKW2/AP5OGkzmP+DHZo47aXf8v1Qe2
         gDzNjIVjyWflScIKy3eiUeSOUmaM3VdGRJMUm51FSXPEEc0jpS5KnyTh2vslv7dEVKZV
         Jw08vMURbxP8hsjxDIZWu5adFRFCYJlEKchBoCBH+loejPy+/xKsb8bRixeLqP80kVmz
         iT1HkrlrEpXNbcxKAD+oPA+96m6Cm7DJL0klDU86G9uCZuu41nn5IpxCyoJ51L4OTS/o
         LzZg==
X-Gm-Message-State: AOJu0YxM4XXoyo6k9UJWSPvi9LPUv/N9A1i6ZTSycGdCNTOtzuI4g4Fw
        BxCIFvB+nOyzq8bgrX3EltvO4I9FGkDA5byoLNM0AzUUXBc=
X-Google-Smtp-Source: AGHT+IG1EdUiPtZ4+4Hyuh8oSeE+MbPebUeiPJ9ywQ8IUaPuC3lEMx2NekLNivX5Zr4okRVhZkh+/iIJsMwVdL5BTIw=
X-Received: by 2002:a5b:749:0:b0:d9a:b86a:637c with SMTP id
 s9-20020a5b0749000000b00d9ab86a637cmr2331393ybq.57.1697818747247; Fri, 20 Oct
 2023 09:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <20231017101145.2348571-1-amir73il@gmail.com> <20231019175000.afv2b5fma3ttkt4v@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231019175000.afv2b5fma3ttkt4v@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 20 Oct 2023 19:18:55 +0300
Message-ID: <CAOQ4uxgYyEfyFrQbyzdzXko6ZUmdRS6g2gH8znOrz-7M3KCUXg@mail.gmail.com>
Subject: Re: [PATCH] overlay: add test for lowerdir mount option parsing
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 19, 2023 at 8:50=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Tue, Oct 17, 2023 at 01:11:45PM +0300, Amir Goldstein wrote:
> > Check parsing and display of spaces and escaped colons and commans in
> > lowerdir mount option.
> >
> > This is a regression test for two bugs introduced in v6.5 with the
> > conversion to new mount api.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Zorro,
> >
> > This is a test for two regressions in kernel v6.5.
> > The two fixes were merged in 6.6-rc6 and have been picked for
> > the upcoming LTS 6.5.y release.
>
>
> >
> > Thanks,
> > Amir.
> >
> >  tests/overlay/083     | 54 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/083.out |  2 ++
> >  2 files changed, 56 insertions(+)
> >  create mode 100755 tests/overlay/083
> >  create mode 100644 tests/overlay/083.out
> >
> > diff --git a/tests/overlay/083 b/tests/overlay/083
> > new file mode 100755
> > index 00000000..071b4b84
> > --- /dev/null
> > +++ b/tests/overlay/083
> > @@ -0,0 +1,54 @@
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
>
> Hi Amir,
>
> I tried this case on the latest linux kernel which contains the
> two commits, but still hit below failure:
>
> FSTYP         -- overlay
> PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP P=
REEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> MKFS_OPTIONS  -- /mnt/scratch
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /mnt/scratch /m=
nt/scratch/ovl-mnt
>
> overlay/083       - output mismatch (see /root/git/xfstests/results//over=
lay/083.out.bad)
>     --- tests/overlay/083.out   2023-10-19 14:07:18.099496414 +0800
>     +++ /root/git/xfstests/results//overlay/083.out.bad 2023-10-20 00:25:=
47.682874383 +0800
>     @@ -1,2 +1,4 @@
>      QA output created by 083
>     +mount: /mnt/scratch/ovl-mnt: special device ovl_esc_test does not ex=
ist.
>     +       dmesg(1) may have more information after failed mount system =
call.
>      Silence is golden
>

Strange.
I was under the impression that the 'dev' argument to mount command
of overlayfs is a completely opaque string.

Maybe you are using a different libmount version that I do.
I have libmount 2.36.1.

Anyway, can you please try if this variation works for you:

--- a/tests/overlay/083
+++ b/tests/overlay/083
@@ -42,12 +42,12 @@ mkdir -p "$lowerdir1" "$lowerdir2" "$lowerdir3"

 # _overlay_mount_* helpers do not handle special chars well, so
execute mount directly.
 # if escaped colons and commas are not parsed correctly, mount will fail.
-$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
+$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
        -o"upperdir=3D$upperdir,workdir=3D$workdir,lowerdir=3D$lowerdir3_es=
c:$lowerdir2_esc:$lowerdir1"

 # if spaces are not escaped when showing mount options,
 # mount command will not show the word 'spaces' after the spaces
-$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full |
grep -v spaces
+$MOUNT_PROG -t overlay | grep lower3 | tee -a $seqres.full | grep -v space=
s

Thanks,
Amir.

>
> > +
> > +# _overlay_check_* helpers do not handle special chars well
> > +_require_scratch_nocheck
> > +
> > +# Remove all files from previous tests
> > +_scratch_mkfs
> > +
> > +# Create lowerdirs with special characters
> > +lowerdir1=3D"$OVL_BASE_SCRATCH_MNT/lower1 with  spaces"
> > +lowerdir2=3D"$OVL_BASE_SCRATCH_MNT/lower2:with::colons"
> > +lowerdir3=3D"$OVL_BASE_SCRATCH_MNT/lower3,with,,commas"
> > +lowerdir2_esc=3D"$OVL_BASE_SCRATCH_MNT/lower2\:with\:\:colons"
> > +lowerdir3_esc=3D"$OVL_BASE_SCRATCH_MNT/lower3\,with\,\,commas"
> > +upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> > +workdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> > +mkdir -p "$lowerdir1" "$lowerdir2" "$lowerdir3"
> > +
> > +# _overlay_mount_* helpers do not handle special chars well, so execut=
e mount directly.
> > +# if escaped colons and commas are not parsed correctly, mount will fa=
il.
> > +$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
> > +     -o"upperdir=3D$upperdir,workdir=3D$workdir,lowerdir=3D$lowerdir3_=
esc:$lowerdir2_esc:$lowerdir1"
> > +
> > +# if spaces are not escaped when showing mount options,
> > +# mount command will not show the word 'spaces' after the spaces
> > +$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full | gr=
ep -v spaces
> > +
> > +echo "Silence is golden"
> > +status=3D0
> > +exit
> > diff --git a/tests/overlay/083.out b/tests/overlay/083.out
> > new file mode 100644
> > index 00000000..0beba309
> > --- /dev/null
> > +++ b/tests/overlay/083.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 083
> > +Silence is golden
> > --
> > 2.34.1
> >
>
