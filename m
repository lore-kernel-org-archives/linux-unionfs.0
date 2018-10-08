Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181004062624.27295-1-amir73il@gmail.com> <1498422724.56763494.1538982674701.JavaMail.zimbra@redhat.com>
In-Reply-To: <1498422724.56763494.1538982674701.JavaMail.zimbra@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 8 Oct 2018 14:26:15 +0300
Message-ID: <CAOQ4uxjBxzF+kyDOvzLG1hg+q-m=cV26GWEEnXUKHehKDxkQwg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Tests for readahead() and fadvise() on overlayfs
Content-Type: text/plain; charset="UTF-8"
To: Jan Stancek <jstancek@redhat.com>
Cc: Cyril Hrubis <chrubis@suse.cz>, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 8, 2018 at 10:11 AM Jan Stancek <jstancek@redhat.com> wrote:
>
>
>
> ----- Original Message -----
> > Cyril,
> >
> > The following series adds test covergae for readahead() syscall
> > over overlayfs file and adds test coverage for a specific
> > posix_fadvise() syscall advice (POSIX_FADV_WILLNEED).
> >
> > So far, the posix_fadvise syscall tests in LTP only test for error
> > conditions, but not functionality.
> >
> > The functionality of the advice POSIX_FADV_WILLNEED is indentical
> > to readahead() and since kernel commit 3d8f7615319b ("vfs: implement
> > readahead(2) using POSIX_FADV_WILLNEED"), the implementations are
> > also bound together.
> >
> > To add test coverage of the advice POSIX_FADV_WILLNEED, I decided not
> > to duplicate the readahead() functional test and add test cases to
> > readahead02 that use the POSIX_FADV_WILLNEED implementation.
> >
> > Thanks,
> > Amir.
> >
> > Changes since v1:
> > - Fix bugs in loop invocation of test (i.e. -i 2)
> > - Address review comments from Jan Stancek
> > - Make cached_max a global maximum over all test cases
> > - Improve reliability of overlayfs readahead test case failure
>
> Looks good to me.
>
> When you say "This is the only system configuration supported by the posix_fadvise tests",
> are you talking about glibc?
>

I was trying to mimic the check in posix_fadvise tests:

        /* Check this system has fadvise64 system which is used
           in posix_fadvise. */
        if ((_FILE_OFFSET_BITS != 64) && (__NR_fadvise64 == 0)) {
                tst_resm(TWARN,
                         "This test can only run on kernels that implements ");
                tst_resm(TWARN, "fadvise64 which is used from posix_fadvise");
                exit(0);
        }

If my understanding of man posix_fadvise(2) is correct, this wants to make sure
that the glibc wrapper posix_fadvise calls the syscall fadvise64 and not some
architecture specific syscall (e.g. arm_fadvise64_64).

I am not really sure why that matters to those tests at all.
and it's probably better just return TCONF if the call fails with ENOSYS?
If someone has ideas, let me know.

Thanks,
Amir.
