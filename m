Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191029055713.28191-1-cgxu519@mykernel.net> <CAOQ4uxgzZHXOv7K++BArYmaTEHbYr5oCkgXw8WVUsQgh0uyqhg@mail.gmail.com>
 <16e173c434a.11f8ced8d40796.3954073574203284331@mykernel.net>
 <CAOQ4uxjddbot29=cYqLMLyqT=w=pWmLOPqVzvi-5mcXQ3AB3EQ@mail.gmail.com>
 <CAOQ4uxiZgmA6Z8Lq=ac7O9f1+CMnSmyLoAA7TDu6Hyt=-pUctw@mail.gmail.com>
 <16e1afc4097.118c98c8b43000.1263688409904269456@mykernel.net>
 <CAOQ4uxjqMTFc-Fmpg3oGChy01X2JzQoG_jqxk5iEz+bR4yoQjg@mail.gmail.com> <16e3a265656.134a9f8341853.6895214917865048335@mykernel.net>
In-Reply-To: <16e3a265656.134a9f8341853.6895214917865048335@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 5 Nov 2019 09:37:36 +0200
Message-ID: <CAOQ4uxhOM7XdmE2hTn=H_trR-Qx1GGdWrN0GmLJ9dveAySMJ2Q@mail.gmail.com>
Subject: Re: [PATCH] overlay/066: adjust test file size && add more test patterns
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

>  > There is a difference between understanding what happened and
>  > reproducing, but there is no reason to choose one method over
>  > the other.
>  >
>  > As a developer, when I get a bug report I would rather have both
>  > an easy reproducer and all the postmortem  information available.
>  > Therefore, please echo xfs_io commands, at least for creation of
>  > random files to full log AND filefrag info, at least for the random
>  > files to full log.
>  >
>
> Actually, xfs_io itself will leave detail information for write operation (pos+write size)
> See below, IMO, it is almost no difference compare to echo xfs_io command.
> So I just added title for those write scenarios in v2.
>
> ---
> iosize=2048K hole test write scenarios --- (This is what I added in v2)
>
> wrote 2097152/2097152 bytes at offset 2097152
> 2 MiB, 512 ops; 0.0007 sec (2.732 GiB/sec and 716083.9161 ops/sec)
> wrote 2097152/2097152 bytes at offset 6291456
> 2 MiB, 512 ops; 0.0006 sec (2.889 GiB/sec and 757396.4497 ops/sec)
> wrote 2097152/2097152 bytes at offset 10485760
> 2 MiB, 512 ops; 0.0007 sec (2.728 GiB/sec and 715083.7989 ops/sec)
> wrote 2097152/2097152 bytes at offset 14680064
> 2 MiB, 512 ops; 0.0007 sec (2.778 GiB/sec and 728307.2546 ops/sec)
>

It's good that you added the titles, but not enough IMO.

It is a social engineering issue, not a technical one.
It is *nicer* for a test to provide a reproducer, than to provide information
that needs to be converted to a reproducer by a developer.

And the main reason to be *nicer* in this case, is that it is zero effort
for the test writer to provide the report in the form of reproducer, simply
by echoing the xfs_io commands via a helper, (e.g. do_io).

Please understand that most of xfstests are reproducers by themselves.
Some random tests (like fsx/fsstress) leave a recorded log of operations
to be used to reproduce a failure.
Some random xfstests log the random seed to log, so it can be used to
reproduce.
In any case, leaving a *simple* one to reproduce a failure is essential.

Thanks,
Amir.
