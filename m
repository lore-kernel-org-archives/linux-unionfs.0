MIME-Version: 1.0
Date: Tue, 17 Sep 2019 10:10:11 +0200
References: <23935.36189.612024.342204@informatik.uni-koeln.de>
In-Reply-To: <23935.36189.612024.342204@informatik.uni-koeln.de>
Message-ID: <CAJfpegsk30wCJY1WaQWJOibfw35TGYxUuPBYx8v7xObJBSgTAw@mail.gmail.com>
Subject: Re: can overlayfs work wit NFS v4 as lower fs?
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: lange@debian.org
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Sep 16, 2019 at 3:25 PM <lange@debian.org> wrote:
>
> Hi,
>
> I'm using overlayfs with NFS v3 as a lower (mounted read-only) and a
> tmpfs as an upper filesystem. This works nicely since several years.
> So I get a writeable directory tree on an nfs client even the nfs was
> mounted ro.
>
> But then I mount the lower filesystem as NFS v4 (4.2) it does not
> work. Is this combination supposed to work?
> I tested this with kernels up to 5.2 yet but still no success.
>
>
> Here's my current test setup:
>
> NFS server kernel 5.2.0-0.bpo.2-amd64 (Debian 10 with newer kernel)
> NFS client kernel 5.2.0-0.bpo.2-amd64 (Debian 10 with newer kernel)
>
> On the NFS server I did once
> # mkdir /files/scratch/t/etc; echo test-buster > /files/scratch/t/etc/test1
>
> /etc/exports: /files/scratch  11.22.33.128/25(async,ro,no_subtree_check,no_root_squash)
>
> I can do more tests if you tell me what I can change.
> Here are the two tests result, one using nfs v3 the other using NFS v4.
>
> P.S.: After more research I think this may be a problem of a
>       filesystem missing xattr support. Do you have any experiences
>       using overlayfs using NFS v4 as lower fs?

This is most probably about nfs4 acl support.   Does "noacl" export
option fix it?

Thanks,
Miklos



>
