Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928DD19B59D;
	Thu, 19 Sep 2024 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726757287; cv=none; b=dYhTTEuNCrr01U/fzxxnsia5mOGGJNbvBYdxHCc0AcBd/uYl7lQOJw8tEsSjpxmJ0LMELWH3oA/ThbzVuwg640HPxPc52L6akgwIaX/2OfYmFeEGoii9oJ7orVVk0SCGfdDz0CW2/hSymUZUdneIvk3GM7nuPh+4KIn24lMCSjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726757287; c=relaxed/simple;
	bh=6HmN5TvJEss7EqaBS8oqa/dyqBwxAZAhuU6cOlfGlto=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eyIAEqDB/pKRdYNHfACE8p670s//ACkdEV2o/9VBuSHcocuaqa9D//6bs5ocM6Octbvl+9qQbhVETjc3Tsc46EWEmYmituBZLUks1uliQz1Dwv8Z4KceVRxTVmrJjCgXD9sOd4oLCTFTIfV6e617dbrBxBDFcd0J4ImWJLgZNEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0d2K7C5; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0d2K7C5"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7a99fdf2e1aso98968185a.2;
        Thu, 19 Sep 2024 07:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726757284; x=1727362084; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOjco/E16CHEaO1YAuTf4mFCCjXRlB2Xs78RO681f9A=;
        b=T0d2K7C5EZqsPW6zsygfXU8RmxWIsloPcK7IbrT7TAFbnV+GFrPwCnUN78NS8W2vPU
         d0sag6j/QBF5EwDm4qBOaP/ZPRsNzskX3W7vNWFs0vtLE8Q5ruECzjOkIKg8LEsQ+54I
         Od+IkC8gFa6BX9rHI6Pj/jzVbP2V+ZWFDPieExwsXjT6XRcSVRSMcbNS+aTZsylTqLiF
         fALbnVuZOruKqY5sn3pIImoGCcj9N2oZEyIS+kBrsNtIkAalcf+4Wv15DwG+UMGGVxMz
         9zCTw0P39scQulXp2vGJVwkZwY8R4mgFcT5y+sMJyHNFfFXWhyC//n0G2n9P+gspyQux
         YBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726757284; x=1727362084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BOjco/E16CHEaO1YAuTf4mFCCjXRlB2Xs78RO681f9A=;
        b=DLcHKrGmoBJqisefpJOa+V92j8DFgSECcYekWi3f2bdv1X5Pd8IriiA2SjA/fcktZ5
         YpQ9BYqMTjzsz3ggp2mScOUh5EL4hzF62CA+TRSccpwwfU961zA1P2MBA987lwiue52g
         1kBwtciJalYG5CSVmB3Xx3TDXpnPek/Pe5eO0NWnult6ZaeoUuP3ADJbfRZIDGCCS211
         JuckTyXxWzxxEr+gWWhvvAjgsJFdqK48qcXRKXUaoSMADQqZH18YaGtQRzBB3DjOkTdB
         eKrM2IV+1lf1Iq7g4pKJ2Dx8Q9bGNCKO+/Vz1G0040Y0tISppJL1wFpm89zWHaC9RHVF
         HaAg==
X-Forwarded-Encrypted: i=1; AJvYcCUqTVbzuKv3IRfJC7g2sxKZsG7iztVULTjHmRw5QgiTdUCnjl9OjVjsijoDbOhr1plF1Pck6+6y@vger.kernel.org, AJvYcCVNpZFTA1kFr3h4xlb7iWYRDyqberxuJp55TzBzk1qmt0diuxYhdVISezj6v8M7qJ9+fUNJ1skoBygu100okQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTv1iCnjM3ltkETUht0w9ypAqS4VUKrJlDYyx1XvMJHg5LRa0r
	Rm+mIZ4g/mohCf1sF2aVm27aNtqaRgldVBCl8x/JD4fUdCgcpMSckCKUAKF8UYZBk78lftw+Nl8
	9NLEb5CjzF0mumP8nK2z30hfoXfc=
X-Google-Smtp-Source: AGHT+IH9+bpBZi+W16pu6j9mMuprOCE14+PfDORJj9/QAW3ZaKgg2YZwoRQd9vEDlzU72D5qzS3L3ORs4FUB/hJP5CE=
X-Received: by 2002:a05:6214:5c09:b0:6c5:ab33:5244 with SMTP id
 6a1803df08f44-6c5ab33526bmr133851946d6.31.1726757284312; Thu, 19 Sep 2024
 07:48:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240830180844.857283-1-amir73il@gmail.com> <20240903042128.ksqua6ha47iayolq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxifYDgCmKEUQrbZWwL8JxmRnmPK3dGtVpMhq2cgGQ_etg@mail.gmail.com>
 <20240904025840.obxcbe22bud6ga2i@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxjDcgm9preuBY_5b+bbHpiLzVw+yKNj7KaeWs_1ye1Tqw@mail.gmail.com>
 <20240904112533.vbzp3nclece2sukg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxiTKJjgL16tL2iUzxBFAK+bLCsgfGaj3HGKq+nYWFMAnQ@mail.gmail.com> <20240919135810.givimomj6vgvotzk@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20240919135810.givimomj6vgvotzk@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Sep 2024 16:47:52 +0200
Message-ID: <CAOQ4uxg7TEjF81MT-nre+0VFgsJhXe1hpAz9hNMwp3utgz+gSQ@mail.gmail.com>
Subject: Re: [PATCH] overlay: create a variant to syncfs error test xfs/546
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, Theodore Tso <tytso@mit.edu>, 
	"Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2024 at 3:58=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Tue, Sep 17, 2024 at 04:37:04PM +0200, Amir Goldstein wrote:
> > On Wed, Sep 4, 2024 at 1:25=E2=80=AFPM Zorro Lang <zlang@redhat.com> wr=
ote:
> > >
> > > On Wed, Sep 04, 2024 at 10:23:16AM +0200, Amir Goldstein wrote:
> > > > On Wed, Sep 4, 2024 at 4:58=E2=80=AFAM Zorro Lang <zlang@redhat.com=
> wrote:
> > > > >
> > > > > On Tue, Sep 03, 2024 at 08:41:28AM +0200, Amir Goldstein wrote:
> > > > > > On Tue, Sep 3, 2024 at 6:21=E2=80=AFAM Zorro Lang <zlang@redhat=
.com> wrote:
> > > > > > >
> > > > > > > On Fri, Aug 30, 2024 at 08:08:44PM +0200, Amir Goldstein wrot=
e:
> > > > > > > > Test overlayfs over xfs with and without "volatile" mount o=
ption.
> > > > > > > >
> > > > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > > > ---
> > > > > > > >
> > > > > > > > Zorro,
> > > > > > > >
> > > > > > > > I was going to make a generic test from xfs/546, so that ov=
erlayfs could
> > > > > > > > also run it, but then I realized that ext4 does not behave =
as xfs in
> > > > > > > > that case (it returns success on syncfs post shutdown).
> > > > > > > >
> > > > > > > > Unless and until this behavior is made a standard, I made a=
n overlayfs
> > > > > > > > specialized test instead, which checks for underlying fs xf=
s.
> > > > > > > > While at it, I also added test coverage for the "volatile" =
mount options
> > > > > > > > that is expected to return succuss in that case regardles o=
f the
> > > > > > > > behavior of the underlying fs.
> > > > > > > >
> > > > > > > > Thanks,
> > > > > > > > Amir.
> > > > > > > >
> > > > > > > >  tests/overlay/087     | 62 +++++++++++++++++++++++++++++++=
++++++++++++
> > > > > > > >  tests/overlay/087.out |  4 +++
> > > > > > > >  2 files changed, 66 insertions(+)
> > > > > > > >  create mode 100755 tests/overlay/087
> > > > > > > >  create mode 100644 tests/overlay/087.out
> > > > > > > >
> > > > > > > > diff --git a/tests/overlay/087 b/tests/overlay/087
> > > > > > > > new file mode 100755
> > > > > > > > index 00000000..a5afb0d5
> > > > > > > > --- /dev/null
> > > > > > > > +++ b/tests/overlay/087
> > > > > > > > @@ -0,0 +1,62 @@
> > > > > > > > +#! /bin/bash
> > > > > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > > > > > +# Copyright (c) 2024 CTERA Networks.  All Rights Reserved.
> > > > > > > > +#
> > > > > > > > +# FS QA Test No. 087
> > > > > > > > +#
> > > > > > > > +# This is a variant of test xfs/546 for overlayfs
> > > > > > > > +# with and without the "volatile" mount option.
> > > > > > > > +# It only works over xfs underlying fs.
> > > > > > > > +#
> > > > > > > > +# Regression test for kernel commits:
> > > > > > > > +#
> > > > > > > > +# 5679897eb104 ("vfs: make sync_filesystem return errors f=
rom ->sync_fs")
> > > > > > > > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > > > > > > > +#
> > > > > > > > +# During a code inspection, I noticed that sync_filesystem=
 ignores the return
> > > > > > > > +# value of the ->sync_fs calls that it makes.  sync_filesy=
stem, in turn is used
> > > > > > > > +# by the syncfs(2) syscall to persist filesystem changes t=
o disk.  This means
> > > > > > > > +# that syncfs(2) does not capture internal filesystem erro=
rs that are neither
> > > > > > > > +# visible from the block device (e.g. media error) nor rec=
orded in s_wb_err.
> > > > > > > > +# XFS historically returned 0 from ->sync_fs even if there=
 were log failures,
> > > > > > > > +# so that had to be corrected as well.
> > > > > > > > +#
> > > > > > > > +# The kernel commits above fix this problem, so this test =
tries to trigger the
> > > > > > > > +# bug by using the shutdown ioctl on a clean, freshly moun=
ted filesystem in the
> > > > > > > > +# hope that the EIO generated as a result of the filesyste=
m being shut down is
> > > > > > > > +# only visible via ->sync_fs.
> > > > > > > > +#
> > > > > > > > +. ./common/preamble
> > > > > > > > +_begin_fstest auto quick mount shutdown
> > > > > > > > +
> > > > > > > > +
> > > > > > > > +# Modify as appropriate.
> > > > > > > > +_require_xfs_io_command syncfs
> > > > > > > > +_require_scratch_nocheck
> > > > > > > > +_require_scratch_shutdown
> > > > > > > > +
> > > > > > > > +[ "$OVL_BASE_FSTYP" =3D=3D "xfs" ] || \
> > > > > > > > +     _notrun "base fs $OVL_BASE_FSTYP has unknown behavior=
 with syncfs after shutdown"
> > > > > > > > +
> > > > > > > > +# Reuse the fs formatted when we checked for the shutdown =
ioctl, and don't
> > > > > > > > +# bother checking the filesystem afterwards since we never=
 wrote anything.
> > > > > > > > +echo "=3D=3D=3D syncfs after shutdown"
> > > > > > > > +_scratch_mount
> > > > > > > > +# This command is complicated a bit because in the case of=
 overlayfs the
> > > > > > > > +# syncfs fd needs to be opened before shutdown and it is d=
ifferent from the
> > > > > > > > +# shutdown fd, so we cannot use the _scratch_shutdown() he=
lper.
> > > > > > > > +# Filter out xfs_io output of active fds.
> > > > > > > > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c '=
shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> > > > > > > > +     grep -vF '[00'
> > > > > > > > +
> > > > > > > > +# Now repeat the same test with a volatile overlayfs mount=
 and expect no error
> > > > > > > > +_scratch_unmount
> > > > > > > > +echo "=3D=3D=3D syncfs after shutdown (volatile)"
> > > > > > > > +_scratch_mount -o volatile
> > > > > > > > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c '=
shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> > > > > > > > +     grep -vF '[00'
> > > > > > >
> > > > > > > Oh, the test steps are much different from xfs/546. If we mov=
e x/546 to generic/,
> > > > > > > can overlay reproduce this bug by that?
> > > > > >
> > > > > > Yes and no.
> > > > > >
> > > > > > For overlayfs to support this as a generic test, the helper
> > > > > > _scratch_shutdown_handle must be used and the shutdown+syncfs
> > > > > > command must be complicated to something like this:
> > > > > >
> > > > > > $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutd=
own -f
> > > > > > ' -c close -c syncfs $SCRATCH_MNT | \
> > > > > >        grep -vF '[00'
> > > > > >
> > > > > > This is because overlayfs itself does not support the shutdown =
ioctl.
> > > > > > If the test is moved to generic as it is we get an error when r=
unning
> > > > > > overlayfs:
> > > > > >
> > > > > >     XFS_IOC_GOINGDOWN: Inappropriate ioctl for device
> > > > > >
> > > > > > because _require_scratch_shutdown is "supported" by overlayfs
> > > > > > but only when the _scratch_shutdown helpers are used.
> > > > >
> > > > > Yeah, I know this.
> > > > >
> > > > > >
> > > > > > If the test is to be moved as is, it will need to opt-out of ov=
erlayfs
> > > > > > explicitly.
> > > > >
> > > > > I mean you have a "-o volatile" option test, that's an overlayfs =
specific
> > > > > mount option. If you need that test, that's an overlay specific t=
est, that
> > > > > part can be an overlay specific test case. If not, we can use a g=
eneric
> > > > > case (from xfs/546) to cover overlay and other fs.
> > > >
> > > > I need the -o volatile test regardless of moving xfs/546 to generic=
.
> > > > That's why I posted this patch.
> > >
> > > OK, let's have two patches, one moves xfs/546 to generic/, the other
> > > is this overlay specific test case.
> > >
> >
> > Hi Zorro,
> >
> > I thought that you agreed to include the overlay specific test overlay/=
087,
> > but I still do not see it in for-next.
> >
> > Did I misunderstand you, or was it accidently left out of for-next?
> >
> > Regarding moving xfs/546 to generic/, I had sent a patch to ext4 [1],
> > but no comment from Ted yet.
> >
> > [1] https://lore.kernel.org/linux-ext4/20240904084657.1062243-1-amir73i=
l@gmail.com/
>
> If this's accepted by ext4, do you still this notrun?
>
>   [ "$OVL_BASE_FSTYP" =3D=3D "xfs" ] || \
>         _notrun "base fs $OVL_BASE_FSTYP has unknown behavior with syncfs=
 after shutdown"
>

If/when the patch is accepted by ext4 we could remove this.

> And what about other fs (besides xfs and ext4).

The truth is that I don't know how all filesystems behave -
If ext4 accepts the patch and we then move xfs/546 to generic/,
we will surely find out...
and then we can remove the xfs restriction from the overlayfs test.

But for now, I need the overlayfs test to provide test coverage to
* 34b4540e6646 - ovl: don't set the superblock's errseq_t manually
that just got merged upstream.

Thanks,
Amir.
