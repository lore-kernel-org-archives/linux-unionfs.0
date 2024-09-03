Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4696B1CB527;
	Tue,  3 Sep 2024 06:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725345702; cv=none; b=fz48T//OnLpZNSDMFES5v4yVPpTl2iNR+drGI2hISWy9jGj4ZZqz+2sV0Zfp7Py+WVZ1ikjqFHmfq01YDwkUbjvoIEaWWRqHGkKlZF3OvMrcL4a0b4xt9aUvLd7EuckuL09FzEUOYgZyl1oBpn2Dtt/hFqLug3qdwkYBX5kO01k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725345702; c=relaxed/simple;
	bh=ewjk9A7KEMGjrdYsBEaMJBrlGopYWN8WEd6OWtX+/oo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SvwCmfN5oi2dQRidIqPQbdW7htNywIviQYNuwreZ8TaPqZHcmC70WxByZa4/zYN1ydIB+KMnxum9I8SynjJz3xD5XTMr/eo7QzxkH8oEfxHLTax3UJKLz/wd8NF8nsRcl/SDkD4jICrU38qz9DjtghyHAAiGD24EM8mRsEl3hE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCvIQ5JA; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCvIQ5JA"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7a8197d82a9so208520485a.0;
        Mon, 02 Sep 2024 23:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725345700; x=1725950500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrE1TRHyEqe0Y5+yeSUrcJk3BYLMQghS3ufUodHvvx4=;
        b=eCvIQ5JAfXJEloCkkTs3dS06/KhyyUU8cX1GjJr8XW0ok61bvatMZ6Uy8NB1pwolav
         +molo4HdZjDJVNWkN4LV0t7AHKUzWJ/9vxe7ENR27LHx0OXVHLtIGN+T8Rj9pq9IUXAP
         9gvs7GFpOa4QFJVYb2Kj9e5V9/9fkIk8asrpt5g/U1qqPqTCJANIrPSO4hRiEDndDG8k
         zJJHIf2evgPURA1+pGZ3Mue/e615VzDgIe3FzdswgjFzxjLHp2hvhqnUPLi4gAxZxxnr
         GZbfCRMbAna3hS/RN06ZcXuVtWosYixKRDspmvOYsFElDy8Un9/HGQCS+EloMHDzmk6E
         WuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725345700; x=1725950500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OrE1TRHyEqe0Y5+yeSUrcJk3BYLMQghS3ufUodHvvx4=;
        b=lkfLBSgkdsziom/b7vXqv0PKm7XbeFJe9L6q9TUzy2cpIxVGFDbr77gqfrNKM5+a7/
         Fbca4bnIQ4YhbblV1gAv6fAXvGWS+ykmytHJX6FJ2KVDZEXyRRwZRdTwnRjjRhGOaUWx
         ZIMkYpIPpk618x9BjdayX+dMXMWQDeIBgnPQff+HDY4mQh2lyV7OnmaHhK5n/SwJTg9Q
         PzyE7DnYyLuRm/IibFu7gyWZXsLL8Y/db4xfCeljMckbObDxV23S7mygnRYHVzRo+l7D
         RbNAFMhnup2ZTCEeZqSZQsZWQ5PCF8ReNuAXKtOCossozyrAvSmx/3T8E6eEpOlUFAgW
         hG8w==
X-Forwarded-Encrypted: i=1; AJvYcCW39JFZy9C7SDq7jeQQpxvIIaerptRJVkyAljzw2Hddz1q4U7+adDpG0rz4wD1SLp9Ekaig2dfj@vger.kernel.org, AJvYcCXyVWwP6wI5lFzYLmftcqsXQPXwnMvJ74a5lPir95FCQfdzJaD4nebd8CcEOpQzqX/VIdrQxqC4U9+HZocs/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVgxBag7vh/LJs5MrJSIY1T8lCH3/RYInvF3/rQ93xKu2a8TsU
	44eaHmo+ftqKAmdtI1droPQRGUNI0f4jPpRLr2+2Zbx9Q47SFqGtM7MLzpQZeMqTnHeL1lWg7Ig
	NB/uEu65gL3A1Y/0TRxR5f5ZW/U8Vxs8S9M4=
X-Google-Smtp-Source: AGHT+IFvD7Zrk/xWw9n6VCo21m99N399Gvlb1dYyK4lTAHefrXHIZhByy5bySaWjjsDs2lGerkdEsiFTCggyI8qbNRU=
X-Received: by 2002:a05:620a:4481:b0:7a7:dd0f:649d with SMTP id
 af79cd13be357-7a97bd2a6e6mr125757085a.57.1725345699923; Mon, 02 Sep 2024
 23:41:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240830180844.857283-1-amir73il@gmail.com> <20240903042128.ksqua6ha47iayolq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20240903042128.ksqua6ha47iayolq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Sep 2024 08:41:28 +0200
Message-ID: <CAOQ4uxifYDgCmKEUQrbZWwL8JxmRnmPK3dGtVpMhq2cgGQ_etg@mail.gmail.com>
Subject: Re: [PATCH] overlay: create a variant to syncfs error test xfs/546
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 6:21=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote:
>
> On Fri, Aug 30, 2024 at 08:08:44PM +0200, Amir Goldstein wrote:
> > Test overlayfs over xfs with and without "volatile" mount option.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Zorro,
> >
> > I was going to make a generic test from xfs/546, so that overlayfs coul=
d
> > also run it, but then I realized that ext4 does not behave as xfs in
> > that case (it returns success on syncfs post shutdown).
> >
> > Unless and until this behavior is made a standard, I made an overlayfs
> > specialized test instead, which checks for underlying fs xfs.
> > While at it, I also added test coverage for the "volatile" mount option=
s
> > that is expected to return succuss in that case regardles of the
> > behavior of the underlying fs.
> >
> > Thanks,
> > Amir.
> >
> >  tests/overlay/087     | 62 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/087.out |  4 +++
> >  2 files changed, 66 insertions(+)
> >  create mode 100755 tests/overlay/087
> >  create mode 100644 tests/overlay/087.out
> >
> > diff --git a/tests/overlay/087 b/tests/overlay/087
> > new file mode 100755
> > index 00000000..a5afb0d5
> > --- /dev/null
> > +++ b/tests/overlay/087
> > @@ -0,0 +1,62 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +# Copyright (c) 2024 CTERA Networks.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 087
> > +#
> > +# This is a variant of test xfs/546 for overlayfs
> > +# with and without the "volatile" mount option.
> > +# It only works over xfs underlying fs.
> > +#
> > +# Regression test for kernel commits:
> > +#
> > +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_f=
s")
> > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > +#
> > +# During a code inspection, I noticed that sync_filesystem ignores the=
 return
> > +# value of the ->sync_fs calls that it makes.  sync_filesystem, in tur=
n is used
> > +# by the syncfs(2) syscall to persist filesystem changes to disk.  Thi=
s means
> > +# that syncfs(2) does not capture internal filesystem errors that are =
neither
> > +# visible from the block device (e.g. media error) nor recorded in s_w=
b_err.
> > +# XFS historically returned 0 from ->sync_fs even if there were log fa=
ilures,
> > +# so that had to be corrected as well.
> > +#
> > +# The kernel commits above fix this problem, so this test tries to tri=
gger the
> > +# bug by using the shutdown ioctl on a clean, freshly mounted filesyst=
em in the
> > +# hope that the EIO generated as a result of the filesystem being shut=
 down is
> > +# only visible via ->sync_fs.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick mount shutdown
> > +
> > +
> > +# Modify as appropriate.
> > +_require_xfs_io_command syncfs
> > +_require_scratch_nocheck
> > +_require_scratch_shutdown
> > +
> > +[ "$OVL_BASE_FSTYP" =3D=3D "xfs" ] || \
> > +     _notrun "base fs $OVL_BASE_FSTYP has unknown behavior with syncfs=
 after shutdown"
> > +
> > +# Reuse the fs formatted when we checked for the shutdown ioctl, and d=
on't
> > +# bother checking the filesystem afterwards since we never wrote anyth=
ing.
> > +echo "=3D=3D=3D syncfs after shutdown"
> > +_scratch_mount
> > +# This command is complicated a bit because in the case of overlayfs t=
he
> > +# syncfs fd needs to be opened before shutdown and it is different fro=
m the
> > +# shutdown fd, so we cannot use the _scratch_shutdown() helper.
> > +# Filter out xfs_io output of active fds.
> > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f =
' -c close -c syncfs $SCRATCH_MNT | \
> > +     grep -vF '[00'
> > +
> > +# Now repeat the same test with a volatile overlayfs mount and expect =
no error
> > +_scratch_unmount
> > +echo "=3D=3D=3D syncfs after shutdown (volatile)"
> > +_scratch_mount -o volatile
> > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f =
' -c close -c syncfs $SCRATCH_MNT | \
> > +     grep -vF '[00'
>
> Oh, the test steps are much different from xfs/546. If we move x/546 to g=
eneric/,
> can overlay reproduce this bug by that?

Yes and no.

For overlayfs to support this as a generic test, the helper
_scratch_shutdown_handle must be used and the shutdown+syncfs
command must be complicated to something like this:

$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f
' -c close -c syncfs $SCRATCH_MNT | \
       grep -vF '[00'

This is because overlayfs itself does not support the shutdown ioctl.
If the test is moved to generic as it is we get an error when running
overlayfs:

    XFS_IOC_GOINGDOWN: Inappropriate ioctl for device

because _require_scratch_shutdown is "supported" by overlayfs
but only when the _scratch_shutdown helpers are used.

If the test is to be moved as is, it will need to opt-out of overlayfs
explicitly.

> If not, I think we can have this overlay
> specific test case at first, and "move x/546 to generic" can be another j=
ob.
>

The reason I posted the overlayfs test is because for a while I noticed
that we do not have test coverage for "volatile" mount option
and adding this test coverage to this test was a very low hanging fruit.
So I would like to keep the overlayfs test regardless of the decision
about moving x/546 to generic.

Thanks,
Amir.
