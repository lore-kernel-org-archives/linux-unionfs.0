Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D179D1C62B3
	for <linux-unionfs@vger.kernel.org>; Mon,  2 Sep 2024 19:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725307159; cv=none; b=Yux3hp0STDyLiWNeWYdqf4gD8WZbtJtk+95W0zE5hFp/oXI8Y1PxCYjCRfYo5UChtfxYL07youm/FaIpLXelRuwrVtrssNYPuvoNqYy5s1P1dUdheSrIgyw04buTUHBzElFsSxoqgHf3Qb/EsgOqcunVaZwU5H2ggviI5PSSBfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725307159; c=relaxed/simple;
	bh=ybw04S5XTif79lBaCvh7cWKW9Vk7XL9Q4rQOa0mftvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NaQd/NonTJaa1G9V6GpiOWIs/OxgIQ17GlR7+HiyZ+OpuIzED0fEruUoj6Y9K5tdfqlC20aNcnQ6kTTXictx32pOubjJ/X1LLT17GhYMco6FZVcuwJ2EuLRqHPiCZf8VH/9yIpFIx1I2pl1hr2PsXA0IoGD9k0YpTN4Ny22M2zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D7OiHzgH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D7OiHzgH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725307155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiN98PQJnrgLH/u4aexpePXh6Hb+bGqgidOh2fajBRw=;
	b=D7OiHzgHakLwSpoTAM8adQlExDAVhGqkjmGyQ08jY7KRjXhvsbn8dCXGYCdqqbFNtbGEmx
	3OJEGBPma0gT4NIZn/Wi9s0Oe31mvTv8Jkp3nkwLtxT09cPOWMU+pMAsUM5f4EyuyObUY6
	1i2I3lSfce9wd1EN0eT6AHKFMhe4p/s=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-ijCCQmbjOlWRWpOpgUc8sQ-1; Mon, 02 Sep 2024 15:59:14 -0400
X-MC-Unique: ijCCQmbjOlWRWpOpgUc8sQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-7c6b192a39bso3841105a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Sep 2024 12:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725307153; x=1725911953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iiN98PQJnrgLH/u4aexpePXh6Hb+bGqgidOh2fajBRw=;
        b=kCCBt447XawXM4dmmLlJqnML3N/kvGHAZU2ggtLre/kc/6v9Jkbfp6IN9JdxkslKzH
         6hTcJByE5DZST984o8uXZthxM8A1SlcZshZm3520lVlBMRt1B/z932QcpT4AMOc/3rj9
         SnkETeZ7H6QYbkxoIgfxZ40NUqHtHH/Up9VLW8Z+2PvX3SE9Q6WeJpX/dENTchNDpEGD
         jdy5X/Hy5qCDrBwdnttxH+Ii86ZmGY/YUOX39umeUX8C5wK+cXhmyPf2MKUmxTx03fTA
         erNOULWkmOEstTrHnalzsR8C2TbZliC2WIEFsrvnNu73HoKur3Jm1Z8FB9/G6/g+WbAh
         qlOA==
X-Forwarded-Encrypted: i=1; AJvYcCXL5kl9UkXVxDHUsaunod4NK9Ls7VjBwQuPS7FKnrodY6AHEbC01nlGeNhlogas0D6rEwX/jOI2Wo5Dj10S@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkod8VpPA4em/vKQZd+RUbOkBlxOQ53DZ5zv/jg64Xr6TPKoFs
	Asiw00sNFzBdNn1uH0/9Osv5xZj/VrzJXdfjv/86NFGJHbSWIqgV3uhbjnfehEqvRXyL+Ycknw8
	0SHvux3QUMkS3lWYfeZkEM1S+b5Srd9Ho/yjtzA1ReYjZZGoeRA/ZYi0wBr+tkLg=
X-Received: by 2002:a17:902:ce12:b0:205:3aa8:f22f with SMTP id d9443c01a7336-2053aa8f47emr107142275ad.46.1725307153422;
        Mon, 02 Sep 2024 12:59:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaCPaPAcfZQoJ+mRk3gYLOY3XmuZPSXxQbM4HwPsLr2yO+vW2D9L1M5Ypchg9iD+KHbDRUcA==
X-Received: by 2002:a17:902:ce12:b0:205:3aa8:f22f with SMTP id d9443c01a7336-2053aa8f47emr107142035ad.46.1725307152793;
        Mon, 02 Sep 2024 12:59:12 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20549ddda8csm39274615ad.258.2024.09.02.12.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 12:59:12 -0700 (PDT)
Date: Tue, 3 Sep 2024 03:59:08 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: create a variant to syncfs error test xfs/546
Message-ID: <20240902195908.eldee3ey5kpb5lty@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240830180844.857283-1-amir73il@gmail.com>
 <20240902190726.GA6220@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240902190726.GA6220@frogsfrogsfrogs>

On Mon, Sep 02, 2024 at 12:07:26PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 30, 2024 at 08:08:44PM +0200, Amir Goldstein wrote:
> > Test overlayfs over xfs with and without "volatile" mount option.
> > 
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> > 
> > Zorro,
> > 
> > I was going to make a generic test from xfs/546, so that overlayfs could
> > also run it, but then I realized that ext4 does not behave as xfs in
> > that case (it returns success on syncfs post shutdown).
> > 
> > Unless and until this behavior is made a standard, I made an overlayfs
> > specialized test instead, which checks for underlying fs xfs.
> > While at it, I also added test coverage for the "volatile" mount options
> > that is expected to return succuss in that case regardles of the
> > behavior of the underlying fs.
> 
> As I said elsewhere in the thread, I think that's a bug in ext4 that
> needs fixing, not a divergence of a testcase.  Perhaps we ought to
> promote xfs/546 to generic/ and (if Ted disagrees with me about the EIO)
> add a _notrun for the overlayfs-on-ext4 case?

Agree, move xfs/546 to generic/, and help it to work with overlay. If ext4
won't change its behavior, then add comment and notrun.

Thanks,
Zorro

> 
> --D
> 
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
> > +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
> > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > +#
> > +# During a code inspection, I noticed that sync_filesystem ignores the return
> > +# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
> > +# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
> > +# that syncfs(2) does not capture internal filesystem errors that are neither
> > +# visible from the block device (e.g. media error) nor recorded in s_wb_err.
> > +# XFS historically returned 0 from ->sync_fs even if there were log failures,
> > +# so that had to be corrected as well.
> > +#
> > +# The kernel commits above fix this problem, so this test tries to trigger the
> > +# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
> > +# hope that the EIO generated as a result of the filesystem being shut down is
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
> > +[ "$OVL_BASE_FSTYP" == "xfs" ] || \
> > +	_notrun "base fs $OVL_BASE_FSTYP has unknown behavior with syncfs after shutdown"
> > +
> > +# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
> > +# bother checking the filesystem afterwards since we never wrote anything.
> > +echo "=== syncfs after shutdown"
> > +_scratch_mount
> > +# This command is complicated a bit because in the case of overlayfs the
> > +# syncfs fd needs to be opened before shutdown and it is different from the
> > +# shutdown fd, so we cannot use the _scratch_shutdown() helper.
> > +# Filter out xfs_io output of active fds.
> > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> > +	grep -vF '[00'
> > +
> > +# Now repeat the same test with a volatile overlayfs mount and expect no error
> > +_scratch_unmount
> > +echo "=== syncfs after shutdown (volatile)"
> > +_scratch_mount -o volatile
> > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> > +	grep -vF '[00'
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/overlay/087.out b/tests/overlay/087.out
> > new file mode 100644
> > index 00000000..44b538d8
> > --- /dev/null
> > +++ b/tests/overlay/087.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 087
> > +=== syncfs after shutdown
> > +syncfs: Input/output error
> > +=== syncfs after shutdown (volatile)
> > -- 
> > 2.34.1
> > 
> > 
> 

