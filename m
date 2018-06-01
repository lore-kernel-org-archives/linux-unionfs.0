Return-Path: <vgoyal@redhat.com>
Date: Fri, 1 Jun 2018 10:45:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/2] overlay/016: split into two tests
Message-ID: <20180601144543.GC3259@redhat.com>
References: <1527849857-22951-1-git-send-email-amir73il@gmail.com>
 <1527849857-22951-3-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527849857-22951-3-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jun 01, 2018 at 01:44:17PM +0300, Amir Goldstein wrote:

[..]
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
> +_require_scratch_feature copy_up_shared
> +_require_xfs_io_command "open"
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +
> +# Create our test files.
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +mkdir -p $lowerdir
> +echo "This is old news" > $lowerdir/foo

foo is not being used in this new test now. Similarly, bar is not being
used in 016. May be just get rid of file "bar" and just use file
"foo" in both the tests.

Vivek
