Return-Path: <jstancek@redhat.com>
Date: Wed, 3 Oct 2018 08:47:51 -0400 (EDT)
From: Jan Stancek <jstancek@redhat.com>
Message-ID: <1801488452.55763249.1538570871657.JavaMail.zimbra@redhat.com>
In-Reply-To: <20180928130621.28932-3-amir73il@gmail.com>
References: <20180928130621.28932-1-amir73il@gmail.com> <20180928130621.28932-3-amir73il@gmail.com>
Subject: Re: [LTP] [PATCH 2/4] syscalls/readahead02: Convert to newlib and
	cleanup
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>, Cyril Hrubis <chrubis@suse.cz>
List-ID: <linux-unionfs@vger.kernel.org>


----- Original Message -----
> * Use SAFE macros
> 
> * Use SPDX-License-Identifier
> 
> * No need to cleanup test file from temp dir
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Hi,

ack to 1/4

>  
>  static int has_file(const char *fname, int required)
>  {
> -	int ret;
>  	struct stat buf;
> -	ret = stat(fname, &buf);
> -	if (ret == -1) {
> -		if (errno == ENOENT)
> -			if (required)
> -				tst_brkm(TCONF, cleanup, "%s not available",
> -					 fname);
> -			else
> -				return 0;
> -		else
> -			tst_brkm(TBROK | TERRNO, cleanup, "stat %s", fname);
> +
> +	if (stat(fname, &buf) == -1) {
> +		if (errno != ENOENT)
> +			tst_brk(TBROK | TERRNO, "stat %s", fname);
> +		if (required)
> +			tst_brk(TCONF, "%s not available", fname);
>  	}
>  	return 1;
>  }

This will return 1 even when file doesn't exist.
(Not that it makes big difference for test)

<snip>

> +static struct tst_test test = {
> +	.needs_root = 1,
> +	.needs_tmpdir = 1,
> +	.mount_device = 1,
> +	.mntpoint = mntpoint,
> +	.setup = setup,
> +	.options = options,
> +	.test_all = test_readahead,
> +};

Would it make sense to enable this for 'all_filesystems = 1'?
Previously we used whatever fs /tmp was, now we seem to default
always to ext2.

Regards,
Jan

>  
>  #else /* __NR_readahead */
> -int main(void)
> -{
> -	tst_brkm(TCONF, NULL, "System doesn't support __NR_readahead");
> -}
> +	TST_TEST_TCONF("System doesn't support __NR_readahead");
>  #endif
> --
> 2.17.1
> 
> 
> --
> Mailing list info: https://lists.linux.it/listinfo/ltp
> 
