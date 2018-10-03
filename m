Return-Path: <jstancek@redhat.com>
Date: Wed, 3 Oct 2018 08:48:25 -0400 (EDT)
From: Jan Stancek <jstancek@redhat.com>
Message-ID: <71991096.55763280.1538570905233.JavaMail.zimbra@redhat.com>
In-Reply-To: <20180928130621.28932-4-amir73il@gmail.com>
References: <20180928130621.28932-1-amir73il@gmail.com> <20180928130621.28932-4-amir73il@gmail.com>
Subject: Re: [LTP] [PATCH 3/4] syscalls/readahead02: test readahead() on an
	overlayfs file
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: Cyril Hrubis <chrubis@suse.cz>, linux-unionfs@vger.kernel.org, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>



----- Original Message -----
> Repeat the test case on an overlayfs file.
> 
> The new test case is a regression test for kernel commit b833a3660394
> ("ovl: add ovl_fadvise()") which fixes a regression of readahead() on
> an overlay file that was introduced by kernel commit 5b910bd615ba
> ("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs").
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  .../kernel/syscalls/readahead/readahead02.c   | 55 +++++++++++++++++--
>  1 file changed, 49 insertions(+), 6 deletions(-)
> 
> diff --git a/testcases/kernel/syscalls/readahead/readahead02.c
> b/testcases/kernel/syscalls/readahead/readahead02.c
> index 4132b4de1..191116f62 100644
> --- a/testcases/kernel/syscalls/readahead/readahead02.c
> +++ b/testcases/kernel/syscalls/readahead/readahead02.c
> @@ -14,6 +14,7 @@
>  #include <sys/types.h>
>  #include <sys/syscall.h>
>  #include <sys/mman.h>
> +#include <sys/mount.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <sys/time.h>
> @@ -34,9 +35,15 @@ static const char meminfo_fname[] = "/proc/meminfo";
>  static size_t testfile_size = 64 * 1024 * 1024;
>  static char *opt_fsizestr;
>  static int pagesize;
> +static int ovl_mounted;
>  
>  #define MNTPOINT        "mntpoint"
> -static const char mntpoint[] = "mntpoint";
> +#define OVL_LOWER	MNTPOINT"/lower"
> +#define OVL_UPPER	MNTPOINT"/upper"
> +#define OVL_WORK	MNTPOINT"/work"
> +#define OVL_MNT		MNTPOINT"/ovl"
> +
> +static const char mntpoint[] = MNTPOINT;
>  #define MIN_SANE_READAHEAD (4u * 1024u)
>  
>  static struct tst_option options[] = {
> @@ -109,12 +116,39 @@ static unsigned long get_cached_size(void)
>  	return parse_entry(meminfo_fname, entry);
>  }
>  
> -static void create_testfile(void)
> +static int setup_overlay(void)
> +{
> +	int ret;
> +
> +	/* Setup an overlay mount with lower dir and file */
> +	SAFE_MKDIR(OVL_LOWER, 0755);
> +	SAFE_MKDIR(OVL_UPPER, 0755);
> +	SAFE_MKDIR(OVL_WORK, 0755);
> +	SAFE_MKDIR(OVL_MNT, 0755);
> +	ret = mount("overlay", OVL_MNT, "overlay", 0, "lowerdir="OVL_LOWER
> +		    ",upperdir="OVL_UPPER",workdir="OVL_WORK);
> +	if (ret < 0) {
> +		if (errno == ENODEV) {
> +			tst_res(TCONF,
> +				"overlayfs is not configured in this kernel.");
> +			return ret;
> +		}
> +		tst_brk(TBROK | TERRNO, "overlayfs mount failed");
> +	}
> +	ovl_mounted = 1;
> +	return 0;
> +}
> +
> +static int create_testfile(unsigned int use_overlay)
>  {
>  	int fd;
>  	char *tmp;
>  	size_t i;
>  
> +	if (use_overlay && setup_overlay() != 0)
> +		return -1;
> +
> +	sprintf(testfile, "%s/testfile", use_overlay ? OVL_MNT : MNTPOINT);
>  	tst_res(TINFO, "creating test file of size: %zu", testfile_size);
>  	tmp = SAFE_MALLOC(pagesize);
>  
> @@ -127,6 +161,7 @@ static void create_testfile(void)
>  	SAFE_FSYNC(fd);
>  	SAFE_CLOSE(fd);
>  	free(tmp);
> +	return 0;
>  }
>  
>  
> @@ -221,7 +256,7 @@ static void read_testfile(int do_readahead, const char
> *fname, size_t fsize,
>  	SAFE_CLOSE(fd);
>  }
>  
> -static void test_readahead(void)
> +static void test_readahead(unsigned int use_overlay)
>  {
>  	unsigned long read_bytes, read_bytes_ra;
>  	long usec, usec_ra;
> @@ -229,6 +264,9 @@ static void test_readahead(void)
>  	char proc_io_fname[128];
>  	sprintf(proc_io_fname, "/proc/%u/io", getpid());
>  
> +	if (create_testfile(use_overlay) != 0)
> +		return;
> +

This could use some TINFO message, what is being tested.
.. and I see you added it in 4/4.

>  	/* find out how much can cache hold if we read whole file */
>  	read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
>  	cached_max = get_cached_size();
> @@ -302,9 +340,12 @@ static void setup(void)
>  	tst_syscall(__NR_readahead, 0, 0, 0);
>  
>  	pagesize = getpagesize();
> +}
>  
> -	sprintf(testfile, "%s/testfile", mntpoint);
> -	create_testfile();
> +static void cleanup(void)
> +{
> +	if (ovl_mounted)
> +		SAFE_UMOUNT(OVL_MNT);
>  }

This creates a small conflict, because setup and cleanup don't match.
If you run this with multiple iterations (parameter -i), it's going
to fail:
  safe_macros.c:169: BROK: readahead02.c:124: mkdir(mntpoint/lower,0755) failed: EEXIST

>  
>  static struct tst_test test = {
> @@ -313,8 +354,10 @@ static struct tst_test test = {
>  	.mount_device = 1,
>  	.mntpoint = mntpoint,
>  	.setup = setup,
> +	.cleanup = cleanup,
>  	.options = options,
> -	.test_all = test_readahead,
> +	.test = test_readahead,
> +	.tcnt = 2, /* Repeat with overlayfs */

I'd rather add a function to call old and new test,
single int will make it harder to add additional tests in future.
.. and I see you changed this in 4/4 already.

Regards,
Jan

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
