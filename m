Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4245 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbeJCThF (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Oct 2018 15:37:05 -0400
Date: Wed, 3 Oct 2018 08:48:49 -0400 (EDT)
From: Jan Stancek <jstancek@redhat.com>
Message-ID: <459121114.55763310.1538570929368.JavaMail.zimbra@redhat.com>
In-Reply-To: <20180928130621.28932-5-amir73il@gmail.com>
References: <20180928130621.28932-1-amir73il@gmail.com> <20180928130621.28932-5-amir73il@gmail.com>
Subject: Re: [LTP] [PATCH 4/4] syscalls/readahead02: test readahead using
        posix_fadvise()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Cyril Hrubis <chrubis@suse.cz>, linux-unionfs@vger.kernel.org, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>



----- Original Message -----
> The call to posix_fadvise(POSIX_FADV_WILLNEED) should have the same
> effect as the call to readahead() syscall.
> 
> Repeat the test cases for local file and overlayfs file with
> posix_fadvise().
> 
> The new test case is a regression test for kernel commit b833a3660394
> ("ovl: add ovl_fadvise()") which fixes a regression of fadvise() on
> an overlay file that was introduced by kernel commit 5b910bd615ba
> ("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs").
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  .../kernel/syscalls/readahead/readahead02.c   | 57 +++++++++++++++++--
>  1 file changed, 51 insertions(+), 6 deletions(-)
> 
> diff --git a/testcases/kernel/syscalls/readahead/readahead02.c
> b/testcases/kernel/syscalls/readahead/readahead02.c
> index 191116f62..9ebed359d 100644
> --- a/testcases/kernel/syscalls/readahead/readahead02.c
> +++ b/testcases/kernel/syscalls/readahead/readahead02.c
> @@ -51,6 +51,42 @@ static struct tst_option options[] = {
>  	{NULL, NULL, NULL}
>  };
>  
> +#ifndef _FILE_OFFSET_BITS
> +#define _FILE_OFFSET_BITS 32
> +#endif

I don't think we should be touching this.

> +
> +#ifndef __NR_fadvise64
> +#define __NR_fadvise64 0
> +#endif
> +
> +static struct tcase {
> +	const char *tname;
> +	int use_overlay;
> +	int use_fadvise;
> +} tcases[] = {
> +	{ "readahead on file", 0, 0 },
> +	{ "readahead on overlayfs file", 1, 0 },
> +/* Check this system has fadvise64 system which is used in posix_fadvise. */
> +#if ((_FILE_OFFSET_BITS == 64) || (__NR_fadvise64 != 0))

Can you elaborate on this check? Why do we need to care
about _FILE_OFFSET_BITS?

> +	{ "POSIX_FADV_WILLNEED on file", 0, 1 },
> +	{ "POSIX_FADV_WILLNEED on overlayfs file", 1, 1 },
> +#endif
> +};
> +
> +static int fadvise_willneed(int fd, off_t offset, size_t len)
> +{
> +	/* Should have the same effect as readahead() syscall */
> +	return posix_fadvise(fd, offset, len, POSIX_FADV_WILLNEED);
> +}
> +
> +static int libc_readahead(int fd, off_t offset, size_t len)
> +{
> +	return readahead(fd, offset, len);
> +}
> +
> +typedef int (*readahead_func_t)(int, off_t, size_t);
> +static readahead_func_t readahead_func = libc_readahead;
> +
>  static int check_ret(long expected_ret)
>  {
>  	if (expected_ret == TST_RET) {
> @@ -120,6 +156,9 @@ static int setup_overlay(void)
>  {
>  	int ret;
>  
> +	if (ovl_mounted)
> +		return 0;
> +

You could call it once from setup() and drop check above
and other call from create_testfile().

Regards,
Jan

>  	/* Setup an overlay mount with lower dir and file */
>  	SAFE_MKDIR(OVL_LOWER, 0755);
>  	SAFE_MKDIR(OVL_UPPER, 0755);
> @@ -139,7 +178,7 @@ static int setup_overlay(void)
>  	return 0;
>  }
>  
> -static int create_testfile(unsigned int use_overlay)
> +static int create_testfile(int use_overlay)
>  {
>  	int fd;
>  	char *tmp;
> @@ -164,7 +203,6 @@ static int create_testfile(unsigned int use_overlay)
>  	return 0;
>  }
>  
> -
>  /* read_testfile - mmap testfile and read every page.
>   * This functions measures how many I/O and time it takes to fully
>   * read contents of test file.
> @@ -194,7 +232,7 @@ static void read_testfile(int do_readahead, const char
> *fname, size_t fsize,
>  	if (do_readahead) {
>  		cached_start = get_cached_size();
>  		do {
> -			TEST(readahead(fd, offset, fsize - offset));
> +			TEST(readahead_func(fd, offset, fsize - offset));
>  			if (TST_RET != 0) {
>  				check_ret(0);
>  				break;
> @@ -256,17 +294,24 @@ static void read_testfile(int do_readahead, const char
> *fname, size_t fsize,
>  	SAFE_CLOSE(fd);
>  }
>  
> -static void test_readahead(unsigned int use_overlay)
> +static void test_readahead(unsigned int n)
>  {
>  	unsigned long read_bytes, read_bytes_ra;
>  	long usec, usec_ra;
>  	unsigned long cached_max, cached_low, cached, cached_ra;
>  	char proc_io_fname[128];
> +	struct tcase *tc = &tcases[n];
> +
> +	tst_res(TINFO, "Test #%d: %s", n, tc->tname);
> +
>  	sprintf(proc_io_fname, "/proc/%u/io", getpid());
>  
> -	if (create_testfile(use_overlay) != 0)
> +	if (create_testfile(tc->use_overlay) != 0)
>  		return;
>  
> +	/* Use either readahead() syscall or POSIX_FADV_WILLNEED */
> +	readahead_func = tc->use_fadvise ? fadvise_willneed : libc_readahead;
> +
>  	/* find out how much can cache hold if we read whole file */
>  	read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
>  	cached_max = get_cached_size();
> @@ -357,7 +402,7 @@ static struct tst_test test = {
>  	.cleanup = cleanup,
>  	.options = options,
>  	.test = test_readahead,
> -	.tcnt = 2, /* Repeat with overlayfs */
> +	.tcnt = ARRAY_SIZE(tcases),
>  };
>  
>  #else /* __NR_readahead */
> --
> 2.17.1
> 
> 
> --
> Mailing list info: https://lists.linux.it/listinfo/ltp
> 
