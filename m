Return-Path: <david@fromorbit.com>
Date: Tue, 15 Jan 2019 14:57:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH][V2] xfstest: overlay: File capabilities should not be
 lost over copy-up
Message-ID: <20190115035759.GU27534@dastard>
References: <20190111183925.GD16012@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111183925.GD16012@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, guaneryu@gmail.com, Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jan 11, 2019 at 01:39:25PM -0500, Vivek Goyal wrote:
> Make sure file capabilities are not lost over copy-up when file is
> opened for WRITE but nothing is actually written to it.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tests/overlay/064     |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/064.out |    2 +
>  tests/overlay/group   |    1 
>  3 files changed, 74 insertions(+)
> 
> Index: xfstests-dev/tests/overlay/064
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/tests/overlay/064	2019-01-11 13:18:16.900461223 -0500
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.

2019 now.

> +# Make sure CAP_SETUID is not cleared over file copy up.

That's the test description.

> +#
> +# Following commit introduced regression where if a lower file with
> +# CAP_SETUID is opened for writing, and capability is cleared over copy up.
> +#
> +# bd64e57586d3 ("ovl: During copy up, first copy up metadata and then data")
> +#
> +# A later kernel patch will fix it. This test will help avoid introducing
> +# such regressions again.

This all belongs in the commit message, not the test description.


> +
> +# Trigger file copy up without actually writing anything to file. This
> +# requires opening file with WRITE and xfs_io seems to open it with
> +# O_RDWR by default.

There's no "seems to" about it. xfs_io will open the file O_RDWR
unless you tell it to open it read only.

> +$XFS_IO_PROG -c "quit" ${SCRATCH_MNT}/file >>$seqres.full

Probably better to use the -c "stat" command to dump the file
metadata into the debug file than to just quit.

> +# Make sure cap_setuid is still there
> +$GETCAP_PROG ${SCRATCH_MNT}/file | _filter_scratch

> +# unmount overlayfs
> +$UMOUNT_PROG $SCRATCH_MNT

No need to do that, the test harness will unmount for you...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
