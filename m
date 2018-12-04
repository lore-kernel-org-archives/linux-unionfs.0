Return-Path: <metan@suse.de>
Date: Tue, 4 Dec 2018 15:10:12 +0100
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [PATCH v4 6/6] syscalls/readahead02: test readahead using
 posix_fadvise()
Message-ID: <20181204141012.GB24114@rei.lan>
References: <20181128164645.783-1-amir73il@gmail.com>
 <20181128164645.783-7-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128164645.783-7-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi!
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  .../kernel/syscalls/readahead/readahead02.c   | 41 +++++++++++++++----
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
> index 73c8a6ce6..44475487e 100644
> --- a/testcases/kernel/syscalls/readahead/readahead02.c
> +++ b/testcases/kernel/syscalls/readahead/readahead02.c
> @@ -54,12 +54,30 @@ static struct tst_option options[] = {
>  static struct tcase {
>  	const char *tname;
>  	int use_overlay;
> +	int use_fadvise;
>  } tcases[] = {
> -	{ "readahead on file", 0 },
> -	{ "readahead on overlayfs file", 1 },
> +	{ "readahead on file", 0, 0 },
> +	{ "readahead on overlayfs file", 1, 0 },
> +	{ "POSIX_FADV_WILLNEED on file", 0, 1 },
> +	{ "POSIX_FADV_WILLNEED on overlayfs file", 1, 1 },
>  };
>  
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

It's kind of useless to typedef a new type just to define one variable.

Also as we are making wrappers around these functions we should really
handle the differencies in error reporting inside of these wrappers,
i.e. change the fadvise_willneed() so that the function sets errno on a
failure to avoid details like that leaking into the test code.

Also if we want to switch later on to the all_filesystems we have to
avoid having preset values so it would make sense to have the readahead
function pointer in the tcase structure.

>  static int readahead_supported = 1;
> +static int fadvise_supported = 1;
>  
>  static int has_file(const char *fname, int required)
>  {
> @@ -135,7 +153,6 @@ static void create_testfile(int use_overlay)
>  	free(tmp);
>  }
>  
> -
>  /* read_testfile - mmap testfile and read every page.
>   * This functions measures how many I/O and time it takes to fully
>   * read contents of test file.
> @@ -163,7 +180,7 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
>  	if (do_readahead) {
>  		cached_start = get_cached_size();
>  		do {
> -			TEST(readahead(fd, offset, fsize - offset));
> +			TEST(readahead_func(fd, offset, fsize - offset));
>  			if (TST_RET != 0) {
>  				SAFE_CLOSE(fd);
>  				return;
> @@ -241,6 +258,9 @@ static void test_readahead(unsigned int n)
>  
>  	create_testfile(tc->use_overlay);
>  
> +	/* Use either readahead() syscall or POSIX_FADV_WILLNEED */
> +	readahead_func = tc->use_fadvise ? fadvise_willneed : libc_readahead;
> +
>  	/* find out how much can cache hold if we read whole file */
>  	read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
>  	cached_high = get_cached_size();
> @@ -263,13 +283,20 @@ static void test_readahead(unsigned int n)
>  	read_testfile(1, testfile, testfile_size, &read_bytes_ra,
>  		      &usec_ra, &cached_ra);
>  	if (TST_RET != 0) {
> -		if (TST_ERR == EINVAL &&
> -		    (!tc->use_overlay || !readahead_supported)) {
> +		/* posix_fadvise returns error number (not in errno) */
> +		if (tc->use_fadvise && (TST_ERR = TST_RET) == EINVAL &&
> +		    (!tc->use_overlay || !fadvise_supported)) {
> +			fadvise_supported = 0;
> +			tst_res(TCONF, "fadvise not supported on %s",
> +				tst_device->fs_type);
> +		} else if (TST_ERR == EINVAL &&
> +			   (!tc->use_overlay || !readahead_supported)) {
>  			readahead_supported = 0;
>  			tst_res(TCONF, "readahead not supported on %s",
>  				tst_device->fs_type);
>  		} else {
> -			tst_res(TFAIL | TTERRNO, "readahead failed on %s",
> +			tst_res(TFAIL | TTERRNO, "%s failed on %s",
> +				tc->use_fadvise ? "fadvise" : "readahead",
>  				tc->use_overlay ? "overlayfs" :
>  				tst_device->fs_type);
>  		}
> -- 
> 2.17.1
> 

-- 
Cyril Hrubis
chrubis@suse.cz
