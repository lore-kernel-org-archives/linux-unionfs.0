Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190506074102.87444-1-jiufei.xue@linux.alibaba.com> <CAOQ4uxgptpGyaG5-Wtr8v6SnAvYqXQ-fkmkM0Cjg0jJzij4b8w@mail.gmail.com>
In-Reply-To: <CAOQ4uxgptpGyaG5-Wtr8v6SnAvYqXQ-fkmkM0Cjg0jJzij4b8w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 6 May 2019 13:53:18 +0300
Message-ID: <CAOQ4uxh2==_TVR0GHgoBf075PhfmhmD7jO+h4YVv4yzdS+Q=Lg@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: check the capability before cred overridden
Content-Type: text/plain; charset="UTF-8"
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: Cgroups <cgroups@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, joseph.qi@linux.alibaba.com
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 6, 2019 at 1:51 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, May 6, 2019 at 10:41 AM Jiufei Xue <jiufei.xue@linux.alibaba.com> wrote:
> >
> > We found that it return success when we set IMMUTABLE_FL flag to a
> > file in docker even though the docker didn't have the capability
> > CAP_LINUX_IMMUTABLE.
> >
> > The commit d1d04ef8572b ("ovl: stack file ops") and
> > dab5ca8fd9dd ("ovl: add lsattr/chattr support") implemented chattr
> > operations on a regular overlay file. ovl_real_ioctl() overridden the
> > current process's subjective credentials with ofs->creator_cred which
> > have the capability CAP_LINUX_IMMUTABLE so that it will return success
> > in vfs_ioctl()->cap_capable().
> >
> > Fix this by checking the capability before cred overriden. And here we
> > only care about APPEND_FL and IMMUTABLE_FL, so get these information from
> > inode.
>
> Good idea. My idea was less good ;-)
> See one minor comment below.
>
> Will you be able to write an xfstest to cover this bug?
> See for reference tests/generic/159 and tests/generic/099
>

To clarify, I mean a generic test that will pass on non-overlayfs
and fail when xfstests are run with check -overlay without your fix.

Thanks,
Amir.
