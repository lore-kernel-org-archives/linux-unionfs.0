Return-Path: <darrick.wong@oracle.com>
Date: Thu, 27 Jun 2019 08:25:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] generic/486: filter out irrelevant attrs
Message-ID: <20190627152536.GA5167@magnolia>
References: <20190627090100.18542-1-jencce.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627090100.18542-1-jencce.kernel@gmail.com>
To: Murphy Zhou <jencce.kernel@gmail.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Jun 27, 2019 at 05:00:59PM +0800, Murphy Zhou wrote:
> In some setup, there could be extra attrs printed, like selinux.
> They are breaking golden output and irrelevant for this test.
> So focus on the attr we are testing on to avoid false alarm.
> Print the output to .full for debug.
> 
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/generic/486 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/486 b/tests/generic/486
> index ff115a07..ea571efe 100755
> --- a/tests/generic/486
> +++ b/tests/generic/486
> @@ -46,10 +46,12 @@ _scratch_mkfs >>$seqres.full 2>&1
>  _scratch_mount >>$seqres.full 2>&1
>  
>  filter_attr_output() {
> -	_filter_scratch | sed -e 's/has a [0-9]* byte value/has a NNNN byte value/g'
> +	_filter_scratch | grep world | \
> +		sed -e 's/has a [0-9]* byte value/has a NNNN byte value/g'
>  }
>  
>  ./src/attr_replace_test $SCRATCH_MNT/hello
> +$ATTR_PROG -l $SCRATCH_MNT/hello >>$seqres.full 2>&1
>  $ATTR_PROG -l $SCRATCH_MNT/hello | filter_attr_output
>  
>  status=0
> -- 
> 2.21.0
> 
