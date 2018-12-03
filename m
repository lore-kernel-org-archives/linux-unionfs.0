Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181128164645.783-1-amir73il@gmail.com> <20181128164645.783-2-amir73il@gmail.com>
 <20181203143934.GB4974@rei.lan>
In-Reply-To: <20181203143934.GB4974@rei.lan>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 16:59:37 +0200
Message-ID: <CAOQ4uxizXQiFSh=e6n3RJnX6-Q1eX4EVjCwOtQC8KAfi-oQzQg@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] syscalls/readahead02: Convert to newlib and cleanup
Content-Type: text/plain; charset="UTF-8"
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Dec 3, 2018 at 4:41 PM Cyril Hrubis <chrubis@suse.cz> wrote:
>
> Hi!
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
> I do wonder if it makes sense to set the all_filesystems flag now.
>

That would be fine by me.

> Also does it make any sense to run the overlay test against all
> filesystems?

It does.
Overlayfs may behave differently on different underlying filesystems
depending on their characteristics.

> I would expect that it does not, so we will have to figure
> out how to run the tests. Maybe it would make most sense to treat the
> overlayfs as another filesystem in all_filesystem tests...
>

It does not make sense to treat overlayfs as another filesystem in
all_filesystem tests IMO because:
- "overlayfs" is not a well defined setup, you will need to define the
  underlying filesystem as well, and which one will it be?
- For good test coverage it is best to test, for each fs
  test over fs directly, test over overlayfs + with fs as underlying fs

Thanks,
Amir.
