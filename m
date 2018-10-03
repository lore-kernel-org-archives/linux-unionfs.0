Return-Path: <jstancek@redhat.com>
Date: Wed, 3 Oct 2018 08:50:34 -0400 (EDT)
From: Jan Stancek <jstancek@redhat.com>
Message-ID: <1897735173.55763513.1538571034299.JavaMail.zimbra@redhat.com>
In-Reply-To: <20180929094432.30197-1-amir73il@gmail.com>
References: <20180929094432.30197-1-amir73il@gmail.com>
Subject: Re: [LTP] [PATCH 5/5] syscalls/readahead02: fail test if readahead
 did	not use any cache
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: Cyril Hrubis <chrubis@suse.cz>, linux-unionfs@vger.kernel.org, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>


----- Original Message -----
> The heuristic of failing the test only if not saving any io has false
> negatives with overlayfs readahead() bug, but readahead() with overlayfs
> always warns on "using less cache then expected", when actually, it is
> using no cache at all.
> 
> Add another condition to fail the test if readahead did not use any
> cache at all, which always detected the overlayfs bug.

ack, explicit FAIL here looks reasonable

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Cyril,
> 
> This is a followup for the overlayfs readahead series.
> With the patches already posted, the test fails sometimes, but
> most of the times it just gets a warning.
> 
> With this additional patch test fails reliably.
> Note that test only fails between these upstream commits:
>   good  b833a3660394 ("ovl: add ovl_fadvise()")
>   bad   5b910bd615ba ("ovl: fix GPF in swapfile_activate...")
> 
> I have a few more minor fixes for the v2 series, but I will hold
> them back until v1 is reviewed.
> 
> Thanks,
> Amir.
> 
>  testcases/kernel/syscalls/readahead/readahead02.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/testcases/kernel/syscalls/readahead/readahead02.c
> b/testcases/kernel/syscalls/readahead/readahead02.c
> index b497fb5db..fbcae1df8 100644
> --- a/testcases/kernel/syscalls/readahead/readahead02.c
> +++ b/testcases/kernel/syscalls/readahead/readahead02.c
> @@ -341,6 +341,8 @@ static void test_readahead(unsigned int n)
>  		 */
>  		if (cached_ra * 1024 > testfile_size / 2)
>  			tst_res(TPASS, "using cache as expected");
> +		else if (!cached_ra)
> +			tst_res(TFAIL, "readahead failed to use any cache");
>  		else
>  			tst_res(TWARN, "using less cache than expected");
>  	} else {
> --
> 2.17.1
> 
> 
> --
> Mailing list info: https://lists.linux.it/listinfo/ltp
> 
