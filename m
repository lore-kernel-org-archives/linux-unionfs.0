Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37781 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728388AbeLNSSy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Dec 2018 13:18:54 -0500
Received: by mail-yw1-f66.google.com with SMTP id h193so2663246ywc.4
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Dec 2018 10:18:53 -0800 (PST)
MIME-Version: 1.0
References: <20181204153528.26176-1-amir73il@gmail.com>
In-Reply-To: <20181204153528.26176-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Dec 2018 20:18:41 +0200
Message-ID: <CAOQ4uxhy_3DWiPwO3kcwkMZSb6DvcY1m2aXjFZoRTL7HtqHAFg@mail.gmail.com>
Subject: Re: [PATCH v5] syscalls/readahead02: test readahead using posix_fadvise()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Dec 4, 2018 at 5:35 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> The call to posix_fadvise(POSIX_FADV_WILLNEED) should have the same
> effect as the call to readahead() syscall.
>
> Repeat the test cases for local file and overlayfs file with
> posix_fadvise().
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>

Cyril,

PING.

I think this should address all your comments on v4.

Thanks,
Amir.

>  .../kernel/syscalls/readahead/readahead02.c   | 61 ++++++++++++++-----
>  1 file changed, 45 insertions(+), 16 deletions(-)
>
> diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
> index de12ba114..d74753dcf 100644
> --- a/testcases/kernel/syscalls/readahead/readahead02.c
> +++ b/testcases/kernel/syscalls/readahead/readahead02.c
> @@ -58,15 +58,34 @@ static struct tst_option options[] = {
>         {NULL, NULL, NULL}
>  };
>
> +static int libc_readahead(int fd, off_t offset, size_t len)
> +{
> +       return readahead(fd, offset, len);
> +}
> +
> +static int fadvise_willneed(int fd, off_t offset, size_t len)
> +{
> +       /* Should have the same effect as readahead() syscall */
> +       errno = posix_fadvise(fd, offset, len, POSIX_FADV_WILLNEED);
> +       /* posix_fadvise returns error number (not in errno) */
> +       return errno ? -1 : 0;
> +}
> +
>  static struct tcase {
>         const char *tname;
>         int use_overlay;
> +       int use_fadvise;
> +       /* Use either readahead() syscall or POSIX_FADV_WILLNEED */
> +       int (*readahead)(int, off_t, size_t);
>  } tcases[] = {
> -       { "readahead on file", 0 },
> -       { "readahead on overlayfs file", 1 },
> +       { "readahead on file", 0, 0, libc_readahead },
> +       { "readahead on overlayfs file", 1, 0, libc_readahead },
> +       { "POSIX_FADV_WILLNEED on file", 0, 1, fadvise_willneed },
> +       { "POSIX_FADV_WILLNEED on overlayfs file", 1, 1, fadvise_willneed },
>  };
>
>  static int readahead_supported = 1;
> +static int fadvise_supported = 1;
>
>  static int has_file(const char *fname, int required)
>  {
> @@ -126,7 +145,6 @@ static void create_testfile(int use_overlay)
>         free(tmp);
>  }
>
> -
>  /* read_testfile - mmap testfile and read every page.
>   * This functions measures how many I/O and time it takes to fully
>   * read contents of test file.
> @@ -138,7 +156,8 @@ static void create_testfile(int use_overlay)
>   * @usec: returns how many microsecond it took to go over fsize bytes
>   * @cached: returns cached kB from /proc/meminfo
>   */
> -static int read_testfile(int do_readahead, const char *fname, size_t fsize,
> +static int read_testfile(struct tcase *tc, int do_readahead,
> +                        const char *fname, size_t fsize,
>                          unsigned long *read_bytes, long long *usec,
>                          unsigned long *cached)
>  {
> @@ -154,7 +173,7 @@ static int read_testfile(int do_readahead, const char *fname, size_t fsize,
>         if (do_readahead) {
>                 cached_start = get_cached_size();
>                 do {
> -                       TEST(readahead(fd, offset, fsize - offset));
> +                       TEST(tc->readahead(fd, offset, fsize - offset));
>                         if (TST_RET != 0) {
>                                 SAFE_CLOSE(fd);
>                                 return TST_ERR;
> @@ -233,7 +252,8 @@ static void test_readahead(unsigned int n)
>         create_testfile(tc->use_overlay);
>
>         /* find out how much can cache hold if we read whole file */
> -       read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
> +       read_testfile(tc, 0, testfile, testfile_size, &read_bytes, &usec,
> +                     &cached);
>         cached_high = get_cached_size();
>         sync();
>         drop_caches();
> @@ -241,7 +261,8 @@ static void test_readahead(unsigned int n)
>         cached_max = MAX(cached_max, cached_high - cached_low);
>
>         tst_res(TINFO, "read_testfile(0)");
> -       read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
> +       read_testfile(tc, 0, testfile, testfile_size, &read_bytes, &usec,
> +                     &cached);
>         if (cached > cached_low)
>                 cached = cached - cached_low;
>         else
> @@ -251,20 +272,28 @@ static void test_readahead(unsigned int n)
>         drop_caches();
>         cached_low = get_cached_size();
>         tst_res(TINFO, "read_testfile(1)");
> -       ret = read_testfile(1, testfile, testfile_size, &read_bytes_ra,
> +       ret = read_testfile(tc, 1, testfile, testfile_size, &read_bytes_ra,
>                             &usec_ra, &cached_ra);
>
> -       if (ret == EINVAL &&
> -           (!tc->use_overlay || !readahead_supported)) {
> -               readahead_supported = 0;
> -               tst_res(TCONF, "readahead not supported on %s",
> -                       tst_device->fs_type);
> -               return;
> +       if (ret == EINVAL) {
> +               if (tc->use_fadvise &&
> +                   (!tc->use_overlay || !fadvise_supported)) {
> +                       fadvise_supported = 0;
> +                       tst_res(TCONF, "CONFIG_ADVISE_SYSCALLS not configured "
> +                               "in kernel?");
> +                       return;
> +               } else if (!tc->use_overlay || !readahead_supported) {
> +                       readahead_supported = 0;
> +                       tst_res(TCONF, "readahead not supported on %s",
> +                               tst_device->fs_type);
> +                       return;
> +               }
>         }
>
>         if (ret) {
> -               tst_res(TFAIL | TTERRNO, "readahead failed on %s%s",
> -                       tc->use_overlay ? "overlayfs on " : "",
> +               tst_res(TFAIL | TTERRNO, "%s failed on %s",
> +                       tc->use_fadvise ? "fadvise" : "readahead",
> +                       tc->use_overlay ? "overlayfs" :
>                         tst_device->fs_type);
>                 return;
>         }
> --
> 2.17.1
>
