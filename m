Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181128164645.783-1-amir73il@gmail.com> <20181128164645.783-3-amir73il@gmail.com>
 <20181203142748.GA4974@rei.lan>
In-Reply-To: <20181203142748.GA4974@rei.lan>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 16:52:56 +0200
Message-ID: <CAOQ4uxgedas+Hazxxy-7vJQa6mE=mHHoTOPoHff4oSo++YBG9g@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] syscalls/readahead02: abort test if readahead
 syscall fails
Content-Type: text/plain; charset="UTF-8"
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Dec 3, 2018 at 4:29 PM Cyril Hrubis <chrubis@suse.cz> wrote:
>
> Hi!
> > There is no reason to continue the test if readahead syscall fails
> > and we can also check and report TCONF if filesystem does not support
> > readahead.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  .../kernel/syscalls/readahead/readahead02.c   | 27 +++++++++----------
> >  1 file changed, 12 insertions(+), 15 deletions(-)
> >
> > diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
> > index 956a1d5e5..88eb5fbff 100644
> > --- a/testcases/kernel/syscalls/readahead/readahead02.c
> > +++ b/testcases/kernel/syscalls/readahead/readahead02.c
> > @@ -44,19 +44,6 @@ static struct tst_option options[] = {
> >       {NULL, NULL, NULL}
> >  };
> >
> > -static int check_ret(long expected_ret)
> > -{
> > -     if (expected_ret == TST_RET) {
> > -             tst_res(TPASS, "expected ret success - "
> > -                     "returned value = %ld", TST_RET);
> > -             return 0;
> > -     }
> > -     tst_res(TFAIL | TTERRNO, "unexpected failure - "
> > -             "returned value = %ld, expected: %ld",
> > -             TST_RET, expected_ret);
> > -     return 1;
> > -}
> > -
> >  static int has_file(const char *fname, int required)
> >  {
> >       struct stat buf;
> > @@ -162,8 +149,8 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
> >               do {
> >                       TEST(readahead(fd, offset, fsize - offset));
> >                       if (TST_RET != 0) {
> > -                             check_ret(0);
> > -                             break;
> > +                             SAFE_CLOSE(fd);
> > +                             return;
> >                       }
> >
> >                       /* estimate max readahead size based on first call */
> > @@ -251,6 +238,16 @@ static void test_readahead(void)
> >       tst_res(TINFO, "read_testfile(1)");
> >       read_testfile(1, testfile, testfile_size, &read_bytes_ra,
> >                     &usec_ra, &cached_ra);
> > +     if (TST_RET != 0) {
> > +             if (TST_ERR == EINVAL) {
> > +                     tst_res(TCONF, "readahead not supported on %s",
> > +                             tst_device->fs_type);
> > +             } else {
> > +                     tst_res(TFAIL | TTERRNO, "readahead failed on %s",
> > +                             tst_device->fs_type);
> > +             }
> > +             return;
> > +     }
>
> I do not like that we depend on the fact that TST_RET is not set
> read_testfile() function. Can we rather than that explicitely return
> the TST_ERR from the read_testfile() function instead? As it is zeroed
> before the call in the TEST() macro we can just do return TST_ERR in the
> read_testfile() and then ret = read_testfile() if (ret) ...
>
> Also no need to resend, if you agree with the change I will fix that
> before applying.

Fine by me.

Thanks,
Amir.
