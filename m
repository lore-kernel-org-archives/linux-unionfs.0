Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1258182;
	Tue, 17 Sep 2024 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726583840; cv=none; b=Pza3CdqpkQL1QNA9AjP2a0gblZfbu9ZOM/HNNfaDyR8VnvUzy8xxy/MKzpns+G8JWDPhOiiJLswNWn85w+R0AP+rL92xoctn2it/HEaGOwUb+/+Dm/8pwA4FiGgs3q4Wcxz+u7F7eklSaubXiRVsrODRarbUVWRdwxkudkmzi4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726583840; c=relaxed/simple;
	bh=AViRqSngDqbqf/hlRpk+aZDsrSUeeg23lSMKByZwXCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XPe6KGmIhUTFECJMUNfTQg9q4b6/QkIsaJkj4QUGnT7SRcA2wfZEtCX2vuqF6FMQ/8ZbDH9y2gSLiXVk63Z4ro1Sh8AYRQq/PUc3e7ga45hRWdTcc/+xoMCI4ITwljTAhQlXIHfVJ/mcw8bjTtGOUhxqjcTtj3VQ4ulephjE4fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4rWJkef; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4rWJkef"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6c354415c19so48093176d6.2;
        Tue, 17 Sep 2024 07:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726583838; x=1727188638; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EiZWWJXiC+3uJXFbrPPfPqobLygs7NcApQUgV4iydYc=;
        b=m4rWJkef8gtqiAyz+MKDZ/N+MhVc6f8JDB1LzbEJLp296tVCom2zsmSwB5hg7YWsAj
         Z93LT7/QoamrkckEBQRF7qiAkJ1Ht6NZu94PjRQwCPpTcOzyGL4zxXudL6jWD4CIvRlV
         T3GMFhKhCRNyeOEYdu7fAz7kBIiivVwIfab9ak1ffu8TL9kZpehNVnmYYqlL256D1A+Z
         bTw2a+cc5NtGjvCy06nzBl48xfZ2eGUqZ/2qhZV6BMNrfXJPuNscpJ5QpJDE5SqQxqGW
         FgarmCoUYn6fHutSf/VvuTytYSmS6AIuOXV1nbTO6ehGgf7rUgFdFLw6SxlCpa5Sp7ca
         oK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726583838; x=1727188638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EiZWWJXiC+3uJXFbrPPfPqobLygs7NcApQUgV4iydYc=;
        b=XWQULoyV+AI1yOC7RoggH61TKsukojQohw7vkjVnHM7MxGV5W40ryZH3HzydtTnhw7
         HbtaOK9lkieH+stD7+0h/tCg5Y8V4nZuNYWhi2TRXfudGjjaDpYYVWXaOriiSUtap++2
         d7vvW0FO7X9o2FWVsvVVSAzLOycVl8nyfUX/yTCwO6wazpprpBCvdXqF4vczIOUvxIWc
         G3lPuDFH++quoi5mrj5E2j1O3msbYr7NeohzqAlBox89PMdSUdqZKLC33Q0WLCtxKzjw
         0L3/4FU5Qoj4a6Syf+cKsxujtvVIxyI/m4trxJLwiLnDJ96C5FND2gVu0KcitMrHqcNt
         zkkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAp9XuHie/6wSvNSGTHxfFWNrGKMpCRmQIuFfqSTMfQRa88zFsULqIVoVsxReticynoMTDnNTP@vger.kernel.org, AJvYcCVakXO6YPrgnPyMHxHQFeCerMNXC6xaB0cqGoSMP/UOIz+odKDwRllEcaV7swQBb1CujTzVgLTZ/maJRXuC4A==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywca2HUnLcfcsXps5YXqfgkZYfVdfNBs1Mq4XFQ7EQjkEewN8N4
	t8CXVz7UKAsVRzoakHmZyiRyrUsCGVMWpMuC/xQREgRUOJT1vwi7hpef/LeOF3slTvad8622sjD
	0NmYoZlmu4I8Q6kRxoZMlOvIG550=
X-Google-Smtp-Source: AGHT+IE31BVvXNEwfn9Jgp6JJTJvMJacLfk/J4hllCbmt6QPLTx+Pm5sn2OkvdW6sIsmnujprESte3xWBiEeLFRRN7k=
X-Received: by 2002:a05:6214:468a:b0:6c3:5db2:d999 with SMTP id
 6a1803df08f44-6c573556d57mr264877306d6.9.1726583837497; Tue, 17 Sep 2024
 07:37:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240830180844.857283-1-amir73il@gmail.com> <20240903042128.ksqua6ha47iayolq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxifYDgCmKEUQrbZWwL8JxmRnmPK3dGtVpMhq2cgGQ_etg@mail.gmail.com>
 <20240904025840.obxcbe22bud6ga2i@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxjDcgm9preuBY_5b+bbHpiLzVw+yKNj7KaeWs_1ye1Tqw@mail.gmail.com> <20240904112533.vbzp3nclece2sukg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20240904112533.vbzp3nclece2sukg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 17 Sep 2024 16:37:04 +0200
Message-ID: <CAOQ4uxiTKJjgL16tL2iUzxBFAK+bLCsgfGaj3HGKq+nYWFMAnQ@mail.gmail.com>
Subject: Re: [PATCH] overlay: create a variant to syncfs error test xfs/546
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, Theodore Tso <tytso@mit.edu>, 
	"Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 1:25=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote:
>
> On Wed, Sep 04, 2024 at 10:23:16AM +0200, Amir Goldstein wrote:
> > On Wed, Sep 4, 2024 at 4:58=E2=80=AFAM Zorro Lang <zlang@redhat.com> wr=
ote:
> > >
> > > On Tue, Sep 03, 2024 at 08:41:28AM +0200, Amir Goldstein wrote:
> > > > On Tue, Sep 3, 2024 at 6:21=E2=80=AFAM Zorro Lang <zlang@redhat.com=
> wrote:
> > > > >
> > > > > On Fri, Aug 30, 2024 at 08:08:44PM +0200, Amir Goldstein wrote:
> > > > > > Test overlayfs over xfs with and without "volatile" mount optio=
n.
> > > > > >
> > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > ---
> > > > > >
> > > > > > Zorro,
> > > > > >
> > > > > > I was going to make a generic test from xfs/546, so that overla=
yfs could
> > > > > > also run it, but then I realized that ext4 does not behave as x=
fs in
> > > > > > that case (it returns success on syncfs post shutdown).
> > > > > >
> > > > > > Unless and until this behavior is made a standard, I made an ov=
erlayfs
> > > > > > specialized test instead, which checks for underlying fs xfs.
> > > > > > While at it, I also added test coverage for the "volatile" moun=
t options
> > > > > > that is expected to return succuss in that case regardles of th=
e
> > > > > > behavior of the underlying fs.
> > > > > >
> > > > > > Thanks,
> > > > > > Amir.
> > > > > >
> > > > > >  tests/overlay/087     | 62 +++++++++++++++++++++++++++++++++++=
++++++++
> > > > > >  tests/overlay/087.out |  4 +++
> > > > > >  2 files changed, 66 insertions(+)
> > > > > >  create mode 100755 tests/overlay/087
> > > > > >  create mode 100644 tests/overlay/087.out
> > > > > >
> > > > > > diff --git a/tests/overlay/087 b/tests/overlay/087
> > > > > > new file mode 100755
> > > > > > index 00000000..a5afb0d5
> > > > > > --- /dev/null
> > > > > > +++ b/tests/overlay/087
> > > > > > @@ -0,0 +1,62 @@
> > > > > > +#! /bin/bash
> > > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > > > +# Copyright (c) 2024 CTERA Networks.  All Rights Reserved.
> > > > > > +#
> > > > > > +# FS QA Test No. 087
> > > > > > +#
> > > > > > +# This is a variant of test xfs/546 for overlayfs
> > > > > > +# with and without the "volatile" mount option.
> > > > > > +# It only works over xfs underlying fs.
> > > > > > +#
> > > > > > +# Regression test for kernel commits:
> > > > > > +#
> > > > > > +# 5679897eb104 ("vfs: make sync_filesystem return errors from =
->sync_fs")
> > > > > > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > > > > > +#
> > > > > > +# During a code inspection, I noticed that sync_filesystem ign=
ores the return
> > > > > > +# value of the ->sync_fs calls that it makes.  sync_filesystem=
, in turn is used
> > > > > > +# by the syncfs(2) syscall to persist filesystem changes to di=
sk.  This means
> > > > > > +# that syncfs(2) does not capture internal filesystem errors t=
hat are neither
> > > > > > +# visible from the block device (e.g. media error) nor recorde=
d in s_wb_err.
> > > > > > +# XFS historically returned 0 from ->sync_fs even if there wer=
e log failures,
> > > > > > +# so that had to be corrected as well.
> > > > > > +#
> > > > > > +# The kernel commits above fix this problem, so this test trie=
s to trigger the
> > > > > > +# bug by using the shutdown ioctl on a clean, freshly mounted =
filesystem in the
> > > > > > +# hope that the EIO generated as a result of the filesystem be=
ing shut down is
> > > > > > +# only visible via ->sync_fs.
> > > > > > +#
> > > > > > +. ./common/preamble
> > > > > > +_begin_fstest auto quick mount shutdown
> > > > > > +
> > > > > > +
> > > > > > +# Modify as appropriate.
> > > > > > +_require_xfs_io_command syncfs
> > > > > > +_require_scratch_nocheck
> > > > > > +_require_scratch_shutdown
> > > > > > +
> > > > > > +[ "$OVL_BASE_FSTYP" =3D=3D "xfs" ] || \
> > > > > > +     _notrun "base fs $OVL_BASE_FSTYP has unknown behavior wit=
h syncfs after shutdown"
> > > > > > +
> > > > > > +# Reuse the fs formatted when we checked for the shutdown ioct=
l, and don't
> > > > > > +# bother checking the filesystem afterwards since we never wro=
te anything.
> > > > > > +echo "=3D=3D=3D syncfs after shutdown"
> > > > > > +_scratch_mount
> > > > > > +# This command is complicated a bit because in the case of ove=
rlayfs the
> > > > > > +# syncfs fd needs to be opened before shutdown and it is diffe=
rent from the
> > > > > > +# shutdown fd, so we cannot use the _scratch_shutdown() helper=
.
> > > > > > +# Filter out xfs_io output of active fds.
> > > > > > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shut=
down -f ' -c close -c syncfs $SCRATCH_MNT | \
> > > > > > +     grep -vF '[00'
> > > > > > +
> > > > > > +# Now repeat the same test with a volatile overlayfs mount and=
 expect no error
> > > > > > +_scratch_unmount
> > > > > > +echo "=3D=3D=3D syncfs after shutdown (volatile)"
> > > > > > +_scratch_mount -o volatile
> > > > > > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shut=
down -f ' -c close -c syncfs $SCRATCH_MNT | \
> > > > > > +     grep -vF '[00'
> > > > >
> > > > > Oh, the test steps are much different from xfs/546. If we move x/=
546 to generic/,
> > > > > can overlay reproduce this bug by that?
> > > >
> > > > Yes and no.
> > > >
> > > > For overlayfs to support this as a generic test, the helper
> > > > _scratch_shutdown_handle must be used and the shutdown+syncfs
> > > > command must be complicated to something like this:
> > > >
> > > > $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown =
-f
> > > > ' -c close -c syncfs $SCRATCH_MNT | \
> > > >        grep -vF '[00'
> > > >
> > > > This is because overlayfs itself does not support the shutdown ioct=
l.
> > > > If the test is moved to generic as it is we get an error when runni=
ng
> > > > overlayfs:
> > > >
> > > >     XFS_IOC_GOINGDOWN: Inappropriate ioctl for device
> > > >
> > > > because _require_scratch_shutdown is "supported" by overlayfs
> > > > but only when the _scratch_shutdown helpers are used.
> > >
> > > Yeah, I know this.
> > >
> > > >
> > > > If the test is to be moved as is, it will need to opt-out of overla=
yfs
> > > > explicitly.
> > >
> > > I mean you have a "-o volatile" option test, that's an overlayfs spec=
ific
> > > mount option. If you need that test, that's an overlay specific test,=
 that
> > > part can be an overlay specific test case. If not, we can use a gener=
ic
> > > case (from xfs/546) to cover overlay and other fs.
> >
> > I need the -o volatile test regardless of moving xfs/546 to generic.
> > That's why I posted this patch.
>
> OK, let's have two patches, one moves xfs/546 to generic/, the other
> is this overlay specific test case.
>

Hi Zorro,

I thought that you agreed to include the overlay specific test overlay/087,
but I still do not see it in for-next.

Did I misunderstand you, or was it accidently left out of for-next?

Regarding moving xfs/546 to generic/, I had sent a patch to ext4 [1],
but no comment from Ted yet.

[1] https://lore.kernel.org/linux-ext4/20240904084657.1062243-1-amir73il@gm=
ail.com/

> >
> > >
> > > BTW, we actually we have a common _scratch_shutdown helper, I'm wonde=
ring
> > > if it works for this test? Likes:
> > >
> > >   _scratch_shutdown -f
> > >   $XFS_IO_PROG -c syncfs $SCRATCH_MNT
> > >
> > > Can this work?
> >
> > Nope, because $XFS_IO_PROG -c syncfs $SCRATCH_MNT
> > will fail (EIO) to open the directory after shutdown.
> > That's why the dance with -c open -c close is needed.
>
> Oh, although below line:
>   $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f '=
 -c close -c syncfs $SCRATCH_MNT
>
> trys to shudown on $(_scratch_shutdown_handle), then syncfs on $SCRATCH_M=
NT too.
> But the difference is it opens $SCRATCH_MNT before shutdown, so that's wh=
at you
> need.

Correct, this is why the dance with -c open -c close is needed when the tes=
t is
overlayfs specific and/or generic.

Thanks,
Amir.
