Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20180928130621.28932-1-amir73il@gmail.com> <20180928130621.28932-3-amir73il@gmail.com>
 <1801488452.55763249.1538570871657.JavaMail.zimbra@redhat.com>
In-Reply-To: <1801488452.55763249.1538570871657.JavaMail.zimbra@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 Oct 2018 16:51:25 +0300
Message-ID: <CAOQ4uxjCgVYeG1eGUF1whFmMnorzaCk_d0KjXYni1=zpSwRHfQ@mail.gmail.com>
Subject: Re: [LTP] [PATCH 2/4] syscalls/readahead02: Convert to newlib and cleanup
Content-Type: text/plain; charset="UTF-8"
To: jstancek@redhat.com
Cc: overlayfs <linux-unionfs@vger.kernel.org>, ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>, Cyril Hrubis <chrubis@suse.cz>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 3, 2018 at 3:47 PM Jan Stancek <jstancek@redhat.com> wrote:
>
>
> ----- Original Message -----
> > * Use SAFE macros
> >
> > * Use SPDX-License-Identifier
> >
> > * No need to cleanup test file from temp dir
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Hi,
>
> ack to 1/4
>
> >
> >  static int has_file(const char *fname, int required)
> >  {
> > -     int ret;
> >       struct stat buf;
> > -     ret = stat(fname, &buf);
> > -     if (ret == -1) {
> > -             if (errno == ENOENT)
> > -                     if (required)
> > -                             tst_brkm(TCONF, cleanup, "%s not available",
> > -                                      fname);
> > -                     else
> > -                             return 0;
> > -             else
> > -                     tst_brkm(TBROK | TERRNO, cleanup, "stat %s", fname);
> > +
> > +     if (stat(fname, &buf) == -1) {
> > +             if (errno != ENOENT)
> > +                     tst_brk(TBROK | TERRNO, "stat %s", fname);
> > +             if (required)
> > +                     tst_brk(TCONF, "%s not available", fname);
> >       }
> >       return 1;
> >  }
>
> This will return 1 even when file doesn't exist.
> (Not that it makes big difference for test)
>

Oops. better fix it anyway.
I think it matters if /proc/pid/io does not exist.

>
> > +static struct tst_test test = {
> > +     .needs_root = 1,
> > +     .needs_tmpdir = 1,
> > +     .mount_device = 1,
> > +     .mntpoint = mntpoint,
> > +     .setup = setup,
> > +     .options = options,
> > +     .test_all = test_readahead,
> > +};
>
> Would it make sense to enable this for 'all_filesystems = 1'?

I don't know. Not sure which tests are good candidates for that.
But anyway it's a different change.

> Previously we used whatever fs /tmp was, now we seem to default
> always to ext2.
>

Not exactly. Before cleanup we either used whatever fs /tmp was
or if it was tmpfs we created a loop backed default fs (ext2?).

Now we skip the conditional part and always format fs.
Do you think that matters for the test?

Thanks,
Amir.
