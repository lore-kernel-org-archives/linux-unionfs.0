Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20180928130621.28932-1-amir73il@gmail.com> <20180928130621.28932-4-amir73il@gmail.com>
 <71991096.55763280.1538570905233.JavaMail.zimbra@redhat.com>
In-Reply-To: <71991096.55763280.1538570905233.JavaMail.zimbra@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 Oct 2018 16:30:51 +0300
Message-ID: <CAOQ4uxgNNeutyLpmQ9tWqJ3rt+E9OMSpcyf1aBZykim_10kpiw@mail.gmail.com>
Subject: Re: [LTP] [PATCH 3/4] syscalls/readahead02: test readahead() on an
 overlayfs file
Content-Type: text/plain; charset="UTF-8"
To: jstancek@redhat.com
Cc: Cyril Hrubis <chrubis@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 3, 2018 at 3:48 PM Jan Stancek <jstancek@redhat.com> wrote:
>
>
>
> ----- Original Message -----
> > Repeat the test case on an overlayfs file.
> >
> > The new test case is a regression test for kernel commit b833a3660394
> > ("ovl: add ovl_fadvise()") which fixes a regression of readahead() on
> > an overlay file that was introduced by kernel commit 5b910bd615ba
> > ("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs").
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
[...]
> This could use some TINFO message, what is being tested.
> .. and I see you added it in 4/4.
>

Yap. I hope you don;t mind this temporary simplicity....

> >       /* find out how much can cache hold if we read whole file */
> >       read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
> >       cached_max = get_cached_size();
> > @@ -302,9 +340,12 @@ static void setup(void)
> >       tst_syscall(__NR_readahead, 0, 0, 0);
> >
> >       pagesize = getpagesize();
> > +}
> >
> > -     sprintf(testfile, "%s/testfile", mntpoint);
> > -     create_testfile();
> > +static void cleanup(void)
> > +{
> > +     if (ovl_mounted)
> > +             SAFE_UMOUNT(OVL_MNT);
> >  }
>
> This creates a small conflict, because setup and cleanup don't match.
> If you run this with multiple iterations (parameter -i), it's going
> to fail:
>   safe_macros.c:169: BROK: readahead02.c:124: mkdir(mntpoint/lower,0755) failed: EEXIST
>

Right. I have noticed and fixes it in
https://github.com/amir73il/ltp/commits/overlayfs-devel
was waiting on more review before posting v2.

Thanks,
Amir.
