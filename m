Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190724195719.218307-1-salyzyn@android.com> <20190724195719.218307-6-salyzyn@android.com>
 <CAOQ4uxim8zZN5YHZs2OJz5A=3B0U10wyf371yadpe2B7hA8pZw@mail.gmail.com> <9acceab1-86af-758a-ec00-8f6d33f3da87@android.com>
In-Reply-To: <9acceab1-86af-758a-ec00-8f6d33f3da87@android.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 25 Jul 2019 19:12:24 +0300
Message-ID: <CAOQ4uxhLQGpG0=K46hAgPFgQ3KrDipUCqNs_=L6xNwG-dS_jtw@mail.gmail.com>
Subject: Re: [PATCH v10 5/5] overlayfs: override_creds=off option bypass creator_cred
Content-Type: text/plain; charset="UTF-8"
To: Mark Salyzyn <salyzyn@android.com>
Cc: kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

[reduce CC list]

>
> >
> > I am fine with this patch, but would like to request that you add @sb arg
> > to the ovl_revert_creds() helper, so it is more useful for other things in the
> > future that scope the underlying layers access (like shutdown).
>
> Will respin and retest.
>

Apropos testing, I wanted to bring up this issue.
I noticed that the test coverage I have for unprivileged user access to
overlayfs is lacking.

xfstests has several generic tests that use _runas and run on overlayfs,
but that's only for pure upper files.

unionmount-testsuite is always run as root, because it needs to
mount/umount/etc.
I am working on a new mode ./run --ov --runas=1
to seteuid(1);setegid(1) before every test (after set_up and mount)
That's fine for basic UNIX permission and capability checks, but does not cover
more complex setups like with sepolicy.

I was thinking maybe to execute "./run --ov --set-up" with mounter process
credentials (e.g. initd) and then add a new mode "./run --ov --no-set-up"
which uses the mount prepared by the mounter and runs the tests.

I wanted to get feedback on the ideas above if they are useful for
your use cases? Is that enough or is there more functionality required
to cover more use cases?

Thanks,
Amir.
