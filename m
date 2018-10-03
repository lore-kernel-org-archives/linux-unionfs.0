Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20180928130621.28932-1-amir73il@gmail.com> <20180928130621.28932-5-amir73il@gmail.com>
 <459121114.55763310.1538570929368.JavaMail.zimbra@redhat.com>
In-Reply-To: <459121114.55763310.1538570929368.JavaMail.zimbra@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 Oct 2018 16:37:50 +0300
Message-ID: <CAOQ4uxitEtvFb=EFJ199dCcb1ttY9U4thw+hQ0yjeCLy63XrdA@mail.gmail.com>
Subject: Re: [LTP] [PATCH 4/4] syscalls/readahead02: test readahead using posix_fadvise()
Content-Type: text/plain; charset="UTF-8"
To: jstancek@redhat.com
Cc: Cyril Hrubis <chrubis@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 3, 2018 at 3:48 PM Jan Stancek <jstancek@redhat.com> wrote:
>
>
>
> ----- Original Message -----
> > The call to posix_fadvise(POSIX_FADV_WILLNEED) should have the same
> > effect as the call to readahead() syscall.
> >
> > Repeat the test cases for local file and overlayfs file with
> > posix_fadvise().
> >
> > The new test case is a regression test for kernel commit b833a3660394
> > ("ovl: add ovl_fadvise()") which fixes a regression of fadvise() on
> > an overlay file that was introduced by kernel commit 5b910bd615ba
> > ("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs").
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  .../kernel/syscalls/readahead/readahead02.c   | 57 +++++++++++++++++--
> >  1 file changed, 51 insertions(+), 6 deletions(-)
> >
> > diff --git a/testcases/kernel/syscalls/readahead/readahead02.c
> > b/testcases/kernel/syscalls/readahead/readahead02.c
> > index 191116f62..9ebed359d 100644
> > --- a/testcases/kernel/syscalls/readahead/readahead02.c
> > +++ b/testcases/kernel/syscalls/readahead/readahead02.c
> > @@ -51,6 +51,42 @@ static struct tst_option options[] = {
> >       {NULL, NULL, NULL}
> >  };
> >
> > +#ifndef _FILE_OFFSET_BITS
> > +#define _FILE_OFFSET_BITS 32
> > +#endif
>
> I don't think we should be touching this.
>
> > +
> > +#ifndef __NR_fadvise64
> > +#define __NR_fadvise64 0
> > +#endif
> > +
> > +static struct tcase {
> > +     const char *tname;
> > +     int use_overlay;
> > +     int use_fadvise;
> > +} tcases[] = {
> > +     { "readahead on file", 0, 0 },
> > +     { "readahead on overlayfs file", 1, 0 },
> > +/* Check this system has fadvise64 system which is used in posix_fadvise. */
> > +#if ((_FILE_OFFSET_BITS == 64) || (__NR_fadvise64 != 0))
>
> Can you elaborate on this check? Why do we need to care
> about _FILE_OFFSET_BITS?

I am not completely sure, this is copied along with the comment and ifndefs
above from posix_fadvise tests.

>
> > +     { "POSIX_FADV_WILLNEED on file", 0, 1 },
> > +     { "POSIX_FADV_WILLNEED on overlayfs file", 1, 1 },
> > +#endif
> > +};
> > +
> > +static int fadvise_willneed(int fd, off_t offset, size_t len)
> > +{
> > +     /* Should have the same effect as readahead() syscall */
> > +     return posix_fadvise(fd, offset, len, POSIX_FADV_WILLNEED);
> > +}
> > +
> > +static int libc_readahead(int fd, off_t offset, size_t len)
> > +{
> > +     return readahead(fd, offset, len);
> > +}
> > +
> > +typedef int (*readahead_func_t)(int, off_t, size_t);
> > +static readahead_func_t readahead_func = libc_readahead;
> > +
> >  static int check_ret(long expected_ret)
> >  {
> >       if (expected_ret == TST_RET) {
> > @@ -120,6 +156,9 @@ static int setup_overlay(void)
> >  {
> >       int ret;
> >
> > +     if (ovl_mounted)
> > +             return 0;
> > +
>
> You could call it once from setup() and drop check above
> and other call from create_testfile().
>

Yap. Already fixed in my github overlayfs-devel branch :)

Thanks,
Amir.
