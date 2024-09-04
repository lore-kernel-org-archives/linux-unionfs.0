Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1991D0147
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Sep 2024 11:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725449145; cv=none; b=hvRmAzEDvr0qpybCj8cN6a3eCqGtlfrJhO7Wl66LV5Zz1KaooASgk9ILHNhOc9tHBexgDQfrT9eYQT7CTjmtk80/98OIkizwt7LVfiFoRJ1vOD6ds0oUS1GRaL8datgxAyFZ68bgeUlRgT8PdxD48aI0SQaneBy/eBO1X4NXJWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725449145; c=relaxed/simple;
	bh=7/pq+PjE8IIgXFjWpFzMSWcb5p+02MBpncEI7SKJk+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tgpiLIqK1Sef2x1DyVLxqRrsqMauBKS2pQ154lU7E/2ZsFUFuew87kdUn8xdJBLG52AIsDsx8nC6xp8KrTMHcpqnFzqQ1i6u0eToipS7c+WdlWPc20lAr7ifZw3HdIlO4eyR3CoA3AWyQgbMjvvc06UQqsxitoQ08CQBGvh3LSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6gUDf2l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6gUDf2l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725449142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hm5mSmMuffO/x0xaseQpVxRUOnJhSV9QdqjTJe+D6Qc=;
	b=J6gUDf2lpLoX0b7YvPtRT+R4Ijo2oh4amdPA4TrCrmLt4C7EoR41Q+rKMOJcOJAp4jeFIf
	vuNZ8BcSXSGSAKT9573+jY6ytVQbzL6undzLPq+m1fe0Xh+BW7PHrAEMB7wBi/yvg6HNwe
	9QABF1sAYm7cxR/gnLovPefl57+lAMs=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-Kgu2Cse9OCKFd3id5hME2w-1; Wed, 04 Sep 2024 07:25:40 -0400
X-MC-Unique: Kgu2Cse9OCKFd3id5hME2w-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-778702b9f8fso552676a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Sep 2024 04:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725449139; x=1726053939;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hm5mSmMuffO/x0xaseQpVxRUOnJhSV9QdqjTJe+D6Qc=;
        b=ummkmmPqmwtpLlTYmGopAArKKS1FRBMX3jJ4u+xwENbNxxvo60ASDiHUPQB9mH7J0w
         faS0cWiu5lb0bfbeVT0a8IYb72io6fuRvweO9xlXi5+AerSagzggte5lq92IhFp4H6gO
         uHpKnazB/rneTwPIugLXzW9BahwT3+mjoew318ExkehigWmSPMY+Y7qb0porg8iwmaUz
         mSrA2ssGH9hEqkiJzoE3MtiBkqp1klLPRCWaCLg1yq35plmOaUmhdvcxZGFuiduV6vaQ
         SBYmq51Gh+73V/uOBi76jqonRP6Go7I3DdvNiXS4852GtTS+Hk2FUKqb6rgBOcRuQYeo
         fQ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCV29hMu4YmlDx+/z0vfAaslS+y1IP14rQ7eROnGdTQhr5m9guGg7JHTLDYTnLIg8ZJC8vj7g6RTYJ1kZd2n@vger.kernel.org
X-Gm-Message-State: AOJu0YyPT5B+lj505zStSv9/9bxh9lX1+7MT+o2iQL9dhvjT5TEBh+hY
	9YD6A/BEk2V0F/RLgE54diRbuoWpMKGAAubYxI4Sqx+ud2UJleZl+e1otpBiyf1oFYcE2Eq64wM
	xCINobxN1g9NjxQM0FisFyf0/80FTkv3W2vBRKzELhOPppjEhkymig0lWCcrVCAM=
X-Received: by 2002:a17:902:d484:b0:206:b1fa:ccb0 with SMTP id d9443c01a7336-206b8448696mr24549765ad.25.1725449139050;
        Wed, 04 Sep 2024 04:25:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEy+dst4fWdxJrs+Or5HTn7//IDQo87yqu9c/LphIp/6MkB0ulM7tygE3WinhTcq7ecJiRFgQ==
X-Received: by 2002:a17:902:d484:b0:206:b1fa:ccb0 with SMTP id d9443c01a7336-206b8448696mr24548965ad.25.1725449137517;
        Wed, 04 Sep 2024 04:25:37 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea333dasm11871165ad.163.2024.09.04.04.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 04:25:37 -0700 (PDT)
Date: Wed, 4 Sep 2024 19:25:33 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH] overlay: create a variant to syncfs error test xfs/546
Message-ID: <20240904112533.vbzp3nclece2sukg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240830180844.857283-1-amir73il@gmail.com>
 <20240903042128.ksqua6ha47iayolq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxifYDgCmKEUQrbZWwL8JxmRnmPK3dGtVpMhq2cgGQ_etg@mail.gmail.com>
 <20240904025840.obxcbe22bud6ga2i@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxjDcgm9preuBY_5b+bbHpiLzVw+yKNj7KaeWs_1ye1Tqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjDcgm9preuBY_5b+bbHpiLzVw+yKNj7KaeWs_1ye1Tqw@mail.gmail.com>

On Wed, Sep 04, 2024 at 10:23:16AM +0200, Amir Goldstein wrote:
> On Wed, Sep 4, 2024 at 4:58 AM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Tue, Sep 03, 2024 at 08:41:28AM +0200, Amir Goldstein wrote:
> > > On Tue, Sep 3, 2024 at 6:21 AM Zorro Lang <zlang@redhat.com> wrote:
> > > >
> > > > On Fri, Aug 30, 2024 at 08:08:44PM +0200, Amir Goldstein wrote:
> > > > > Test overlayfs over xfs with and without "volatile" mount option.
> > > > >
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >
> > > > > Zorro,
> > > > >
> > > > > I was going to make a generic test from xfs/546, so that overlayfs could
> > > > > also run it, but then I realized that ext4 does not behave as xfs in
> > > > > that case (it returns success on syncfs post shutdown).
> > > > >
> > > > > Unless and until this behavior is made a standard, I made an overlayfs
> > > > > specialized test instead, which checks for underlying fs xfs.
> > > > > While at it, I also added test coverage for the "volatile" mount options
> > > > > that is expected to return succuss in that case regardles of the
> > > > > behavior of the underlying fs.
> > > > >
> > > > > Thanks,
> > > > > Amir.
> > > > >
> > > > >  tests/overlay/087     | 62 +++++++++++++++++++++++++++++++++++++++++++
> > > > >  tests/overlay/087.out |  4 +++
> > > > >  2 files changed, 66 insertions(+)
> > > > >  create mode 100755 tests/overlay/087
> > > > >  create mode 100644 tests/overlay/087.out
> > > > >
> > > > > diff --git a/tests/overlay/087 b/tests/overlay/087
> > > > > new file mode 100755
> > > > > index 00000000..a5afb0d5
> > > > > --- /dev/null
> > > > > +++ b/tests/overlay/087
> > > > > @@ -0,0 +1,62 @@
> > > > > +#! /bin/bash
> > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > > +# Copyright (c) 2024 CTERA Networks.  All Rights Reserved.
> > > > > +#
> > > > > +# FS QA Test No. 087
> > > > > +#
> > > > > +# This is a variant of test xfs/546 for overlayfs
> > > > > +# with and without the "volatile" mount option.
> > > > > +# It only works over xfs underlying fs.
> > > > > +#
> > > > > +# Regression test for kernel commits:
> > > > > +#
> > > > > +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
> > > > > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > > > > +#
> > > > > +# During a code inspection, I noticed that sync_filesystem ignores the return
> > > > > +# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
> > > > > +# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
> > > > > +# that syncfs(2) does not capture internal filesystem errors that are neither
> > > > > +# visible from the block device (e.g. media error) nor recorded in s_wb_err.
> > > > > +# XFS historically returned 0 from ->sync_fs even if there were log failures,
> > > > > +# so that had to be corrected as well.
> > > > > +#
> > > > > +# The kernel commits above fix this problem, so this test tries to trigger the
> > > > > +# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
> > > > > +# hope that the EIO generated as a result of the filesystem being shut down is
> > > > > +# only visible via ->sync_fs.
> > > > > +#
> > > > > +. ./common/preamble
> > > > > +_begin_fstest auto quick mount shutdown
> > > > > +
> > > > > +
> > > > > +# Modify as appropriate.
> > > > > +_require_xfs_io_command syncfs
> > > > > +_require_scratch_nocheck
> > > > > +_require_scratch_shutdown
> > > > > +
> > > > > +[ "$OVL_BASE_FSTYP" == "xfs" ] || \
> > > > > +     _notrun "base fs $OVL_BASE_FSTYP has unknown behavior with syncfs after shutdown"
> > > > > +
> > > > > +# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
> > > > > +# bother checking the filesystem afterwards since we never wrote anything.
> > > > > +echo "=== syncfs after shutdown"
> > > > > +_scratch_mount
> > > > > +# This command is complicated a bit because in the case of overlayfs the
> > > > > +# syncfs fd needs to be opened before shutdown and it is different from the
> > > > > +# shutdown fd, so we cannot use the _scratch_shutdown() helper.
> > > > > +# Filter out xfs_io output of active fds.
> > > > > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> > > > > +     grep -vF '[00'
> > > > > +
> > > > > +# Now repeat the same test with a volatile overlayfs mount and expect no error
> > > > > +_scratch_unmount
> > > > > +echo "=== syncfs after shutdown (volatile)"
> > > > > +_scratch_mount -o volatile
> > > > > +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> > > > > +     grep -vF '[00'
> > > >
> > > > Oh, the test steps are much different from xfs/546. If we move x/546 to generic/,
> > > > can overlay reproduce this bug by that?
> > >
> > > Yes and no.
> > >
> > > For overlayfs to support this as a generic test, the helper
> > > _scratch_shutdown_handle must be used and the shutdown+syncfs
> > > command must be complicated to something like this:
> > >
> > > $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f
> > > ' -c close -c syncfs $SCRATCH_MNT | \
> > >        grep -vF '[00'
> > >
> > > This is because overlayfs itself does not support the shutdown ioctl.
> > > If the test is moved to generic as it is we get an error when running
> > > overlayfs:
> > >
> > >     XFS_IOC_GOINGDOWN: Inappropriate ioctl for device
> > >
> > > because _require_scratch_shutdown is "supported" by overlayfs
> > > but only when the _scratch_shutdown helpers are used.
> >
> > Yeah, I know this.
> >
> > >
> > > If the test is to be moved as is, it will need to opt-out of overlayfs
> > > explicitly.
> >
> > I mean you have a "-o volatile" option test, that's an overlayfs specific
> > mount option. If you need that test, that's an overlay specific test, that
> > part can be an overlay specific test case. If not, we can use a generic
> > case (from xfs/546) to cover overlay and other fs.
> 
> I need the -o volatile test regardless of moving xfs/546 to generic.
> That's why I posted this patch.

OK, let's have two patches, one moves xfs/546 to generic/, the other
is this overlay specific test case.

> 
> >
> > BTW, we actually we have a common _scratch_shutdown helper, I'm wondering
> > if it works for this test? Likes:
> >
> >   _scratch_shutdown -f
> >   $XFS_IO_PROG -c syncfs $SCRATCH_MNT
> >
> > Can this work?
> 
> Nope, because $XFS_IO_PROG -c syncfs $SCRATCH_MNT
> will fail (EIO) to open the directory after shutdown.
> That's why the dance with -c open -c close is needed.

Oh, although below line:
  $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT

trys to shudown on $(_scratch_shutdown_handle), then syncfs on $SCRATCH_MNT too.
But the difference is it opens $SCRATCH_MNT before shutdown, so that's what you
need.

Thanks,
Zorro

> 
> Thanks,
> Amir.
> 

