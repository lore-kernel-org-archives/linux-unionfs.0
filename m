Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A42517279E;
	Wed,  4 Sep 2024 08:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725438210; cv=none; b=dcRSRZ7fSUW7WQOZCpncpFptN0FDf2jaPZHNQ+k098vhwbAJ9nPMadOXtWLoYEw2QXqR2NabQmFSIbo6yA7q79EebblawHbsP9HkjoIO3GdbjxXN4had3KGPKaS80izRB2sthqSsq5k9hRQu24wVmRbrzT31ebgS4+ACNRwD/z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725438210; c=relaxed/simple;
	bh=HQyLiSiA6t3wv32GhiAovg9+bJWCwAHUzrsRrIgLdq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MhKfhawr/qYKyYLjTlgF9OK77ZqIPKtk+RvsSiml7Y/VvZtYCrLBtVvVZxLq6/mlwj1amYFoiOBQOD8q0f+QMV2Qj+BSAVGx6qnfE1ahmflR0ovfUR2DdqdweOMZv+5jekLWaN4MJTQsZhkYzgFid2jiGQIDCRZM4yirLKFEwtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kB7qaeqD; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kB7qaeqD"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4567edb7dceso32459531cf.1;
        Wed, 04 Sep 2024 01:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725438208; x=1726043008; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkZAVlLuRosh8R7lr7Js2poL662rjuGtt2mio5FLH28=;
        b=kB7qaeqDJN8GPZ4MLnsFflrqFC8sMMOCAbCf4HN2mJD73MrL4FYNR6XmKeWd5Fz96o
         WdZ/bxnZkFUAMxQvvpISbzPnvxwwWSL+A9nRiVw5ttLsMBZqBsKszYnNJvINDmSob7k6
         JVHR9hH7EnHT3lY+Sj0GNUxAb9oQP5S7R2DxcibEpOwdEG1YyblUuwdaX1q2z8GcF2Oq
         eKYM5o1xxOjbuoGqr4VG98DE70KznoJiav78UZhO8QhqNG7RvNxIxeuczrXQlGeRuZuq
         LruS+VDB0bwBEdjrFCAMGx9Kc/WlA6xuavgGrPrd2nonRPK9CUbnCr/sE717Dr2KqcVu
         GteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725438208; x=1726043008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkZAVlLuRosh8R7lr7Js2poL662rjuGtt2mio5FLH28=;
        b=M3IR0aKxbx6X/wD+iyfkriWhpQskdA5pADKX77KtJsEO2VfyJZ4DIAVDRqRK5EzjD4
         1mNM9FlS0lq3hfH4+Je8K/oSN/HoU++231zQF3coEXfO2vcvRGCMU3nCOWhstX5W0rQv
         F2y2AGrXcFcxYWQL4tAHsye01Vb1gMAZGNtg2KUP4niFJ8BrsA46jwAiyiPch5Faj3io
         3slxzxZEy3HrxeUA47fK3nPMSCdxPcSzR9Vt91JbrYzVoDXAsBuyvt3Pnv+VoSmy4LpK
         wW+KDPvRyldLxa4VZcLTsWnULpBWDOWFSeQ8AckLJJChAt2hsWmbwW73SedpADxdmFTu
         /Dcw==
X-Forwarded-Encrypted: i=1; AJvYcCUqxrSSonnb8DragfBMo7FEHWHS9PW2hKIJL6fXRMtrvQsbDKF0bAcKbA/2EKjOjih8dBnJ1rmAFeq79WxwuQ==@vger.kernel.org, AJvYcCVXnmY/qKZLpg6DD0FB3sME8uDjenFTgSIZjlaxoA70uXsmHOszbhBjUleChCESm8VFF5yA3Fk0@vger.kernel.org
X-Gm-Message-State: AOJu0YwkATETag8D7PSfLgRy084c1i5x9m3WdzximnZHFXLQepIOcK7Y
	2MrY1VFVJXP7NSzgp/yE/ebjtMJfITWXP4R4twxMKAuz5bEBmcti9Q8T3IOB8ts5xAWpGoS/CLe
	AhQw7Fv8V7hHUKJnS/adjB/m+WSQ=
X-Google-Smtp-Source: AGHT+IFbA+aFEUZi9EYjWq33qvP+AMoGtkYTzzrcgLob/+lr23psZOSJuVF04Fevv/bXMh4ST53tLJWtj6VIk14gSdU=
X-Received: by 2002:a05:6214:4988:b0:6c3:67d5:aa1 with SMTP id
 6a1803df08f44-6c367d50e15mr102384516d6.10.1725438207903; Wed, 04 Sep 2024
 01:23:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240830180844.857283-1-amir73il@gmail.com> <20240903042128.ksqua6ha47iayolq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxifYDgCmKEUQrbZWwL8JxmRnmPK3dGtVpMhq2cgGQ_etg@mail.gmail.com> <20240904025840.obxcbe22bud6ga2i@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20240904025840.obxcbe22bud6ga2i@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 4 Sep 2024 10:23:16 +0200
Message-ID: <CAOQ4uxjDcgm9preuBY_5b+bbHpiLzVw+yKNj7KaeWs_1ye1Tqw@mail.gmail.com>
Subject: Re: [PATCH] overlay: create a variant to syncfs error test xfs/546
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, Theodore Tso <tytso@mit.edu>, 
	"Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:58=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote:
>
> On Tue, Sep 03, 2024 at 08:41:28AM +0200, Amir Goldstein wrote:
> > On Tue, Sep 3, 2024 at 6:21=E2=80=AFAM Zorro Lang <zlang@redhat.com> wr=
ote:
> > >
> > > On Fri, Aug 30, 2024 at 08:08:44PM +0200, Amir Goldstein wrote:
> > > > Test overlayfs over xfs with and without "volatile" mount option.
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Zorro,
> > > >
> > > > I was going to make a generic test from xfs/546, so that overlayfs =
could
> > > > also run it, but then I realized that ext4 does not behave as xfs i=
n
> > > > that case (it returns success on syncfs post shutdown).
> > > >
> > > > Unless and until this behavior is made a standard, I made an overla=
yfs
> > > > specialized test instead, which checks for underlying fs xfs.
> > > > While at it, I also added test coverage for the "volatile" mount op=
tions
> > > > that is expected to return succuss in that case regardles of the
> > > > behavior of the underlying fs.
> > > >
> > > > Thanks,
> > > > Amir.
> > > >
> > > >  tests/overlay/087     | 62 +++++++++++++++++++++++++++++++++++++++=
++++
> > > >  tests/overlay/087.out |  4 +++
> > > >  2 files changed, 66 insertions(+)
> > > >  create mode 100755 tests/overlay/087
> > > >  create mode 100644 tests/overlay/087.out
> > > >
> > > > diff --git a/tests/overlay/087 b/tests/overlay/087
> > > > new file mode 100755
> > > > index 00000000..a5afb0d5
> > > > --- /dev/null
> > > > +++ b/tests/overlay/087
> > > > @@ -0,0 +1,62 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > +# Copyright (c) 2024 CTERA Networks.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 087
> > > > +#
> > > > +# This is a variant of test xfs/546 for overlayfs
> > > > +# with and without the "volatile" mount option.
> > > > +# It only works over xfs underlying fs.
> > > > +#
> > > > +# Regression test for kernel commits:
> > > > +#
> > > > +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sy=
nc_fs")
> > > > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > > > +#
> > > > +# During a code inspection, I noticed that sync_filesystem ignores=
 the return
> > > > +# value of the ->sync_fs calls that it makes.  sync_filesystem, in=
 turn is used
> > > > +# by the syncfs(2) syscall to persist filesystem changes to disk. =
 This means
> > > > +# that syncfs(2) does not capture internal filesystem errors that =
are neither
> > > > +# visible from the block device (e.g. media error) nor recorded in=
 s_wb_err.
> > > > +# XFS historically returned 0 from ->sync_fs even if there were lo=
g failures,
> > > > +# so that had to be corrected as well.
> > > > +#
> > > > +# The kernel commits above fix this problem, so this test tries to=
 trigger the
> > > > +# bug by using the shutdown ioctl on a clean, freshly mounted file=
system in the
> > > > +# hope that the EIO generated as a result of the filesystem being =
shut down is
> > > > +# only visible via ->sync_fs.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick mount shutdown
> > > > +
> > > > +
> > > > +# Modify as appropriate.
> > > > +_require_xfs_io_command syncfs
> > > > +_require_scratch_nocheck
> > > > +_require_scratch_shutdown
> > > > +
> > > > +[ "$OVL_BASE_FSTYP" =3D=3D "xfs" ] || \
> > > > +     _notrun "base fs $OVL_BASE_FSTYP has unknown behavior with sy=
ncfs after shutdown"
> > > > +
> > > > +# Reuse the fs formatted when we checked for the shutdown ioctl, a=
nd don't
> > > > +# bother checking the filesystem afterwards since we never wrote a=
nything.
> > > > +echo "=3D=3D=3D syncfs after shutdown"
> > > > +_scratch_mount
> > > > +# This command is complicated a bit because in the case of overlay=
fs the
> > > > +# syncfs fd needs to be opened before shutdown and it is different=
 from the
> > > > +# shutdown fd, so we cannot use the _scratch_shutdown() helper.
> > > > +# Filter out xfs_io output of active fds.
> > > > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown=
 -f ' -c close -c syncfs $SCRATCH_MNT | \
> > > > +     grep -vF '[00'
> > > > +
> > > > +# Now repeat the same test with a volatile overlayfs mount and exp=
ect no error
> > > > +_scratch_unmount
> > > > +echo "=3D=3D=3D syncfs after shutdown (volatile)"
> > > > +_scratch_mount -o volatile
> > > > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown=
 -f ' -c close -c syncfs $SCRATCH_MNT | \
> > > > +     grep -vF '[00'
> > >
> > > Oh, the test steps are much different from xfs/546. If we move x/546 =
to generic/,
> > > can overlay reproduce this bug by that?
> >
> > Yes and no.
> >
> > For overlayfs to support this as a generic test, the helper
> > _scratch_shutdown_handle must be used and the shutdown+syncfs
> > command must be complicated to something like this:
> >
> > $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f
> > ' -c close -c syncfs $SCRATCH_MNT | \
> >        grep -vF '[00'
> >
> > This is because overlayfs itself does not support the shutdown ioctl.
> > If the test is moved to generic as it is we get an error when running
> > overlayfs:
> >
> >     XFS_IOC_GOINGDOWN: Inappropriate ioctl for device
> >
> > because _require_scratch_shutdown is "supported" by overlayfs
> > but only when the _scratch_shutdown helpers are used.
>
> Yeah, I know this.
>
> >
> > If the test is to be moved as is, it will need to opt-out of overlayfs
> > explicitly.
>
> I mean you have a "-o volatile" option test, that's an overlayfs specific
> mount option. If you need that test, that's an overlay specific test, tha=
t
> part can be an overlay specific test case. If not, we can use a generic
> case (from xfs/546) to cover overlay and other fs.

I need the -o volatile test regardless of moving xfs/546 to generic.
That's why I posted this patch.

>
> BTW, we actually we have a common _scratch_shutdown helper, I'm wondering
> if it works for this test? Likes:
>
>   _scratch_shutdown -f
>   $XFS_IO_PROG -c syncfs $SCRATCH_MNT
>
> Can this work?

Nope, because $XFS_IO_PROG -c syncfs $SCRATCH_MNT
will fail (EIO) to open the directory after shutdown.
That's why the dance with -c open -c close is needed.

Thanks,
Amir.
