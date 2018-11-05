Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAOQ4uxiYg11XGjzNhD-2gOd-s-FgnzScgzDwwuWpp+518EHv6A@mail.gmail.com>
In-Reply-To: <CAOQ4uxiYg11XGjzNhD-2gOd-s-FgnzScgzDwwuWpp+518EHv6A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 5 Nov 2018 08:57:33 +0200
Message-ID: <CAOQ4uxhBjt4aBEjuNk2GvcFu2eR+ZFxogr2+zN7jR4UqtYsU3g@mail.gmail.com>
Subject: Re: Overlayfs backport for kernel v4.9.y
Content-Type: text/plain; charset="UTF-8"
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Dec 7, 2017 at 7:14 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi All,
>
> For whom it may concern, I have backported latest overlayfs
> features to stable kernel v4.9.y. The patches are available on
> overlayfs-4.9.y branch on my github [1]. I intend to update and
> test this branch with patches applied to upstream.
>
> This work was verified with with xfstests master branch and
> with unionmount-testsuite master branch on my github [2].
>
> DO NOT mistake this for code that can be compiled and loaded
> as a kernel module to kernel v4.9.y!
> The branch pulls in some minor infrastructure changes that
> were required for ease of backporting (mostly uuid_t helpers).
> Most of the remaining diff from v4.15-rc1 in overlayfs code
> is due to STATX vfs API change.
>
> All backported patches have my S-O-B, but most of them
> don't have the upstream commit id in the commit message
> expect a few tree wide patches which I selectively picked
> their changes only to overlayfs (e.g. add include <cred.h>).
>
> Please feel free to use this code, review my work and test it.
>

For whom it may concern, the linux-4.9.y-ovl-* backport branches have
been updated to latest stable branch and latest upstream overlayfs [1].
New linux-4.14.y-ovl-* branches are available on my github [2].

I was chancing was appeared to be a backport bug in linux-4.9.y-ovl-4.17
that eventually turned out to be a real v4.17 overlay NFS export regression
unveiled by different drop_caches behavior in kernel v4.9.

Please note that these branches WILL be rebased as overlayfs fix patches
find their way into the stable tree.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/linux-4.9.y-ovl-next
[2] https://github.com/amir73il/linux/commits/linux-4.14.y-ovl-next
