From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Xattr issues with overlayfs
Date: Tue, 25 Nov 2014 15:41:32 +0100
Message-ID: <CAJfpegtvTZYk2V7a94g_CDKhw4Fn8_bS-cSJKHWHqvvU4abygg@mail.gmail.com>
References: <54730565.4040308@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <54730565.4040308@huawei.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Nov 24, 2014 at 11:16 AM, hujianyang <hujianyang@huawei.com> wrote:

> I'd like to introduce some of my work.
>
> 1) Use macros to indicate overlayfs_private_xattr.

Okay.

> 2) Enable overlayfs_private_xattr setting an removing in userspace.
>    * I'm not clear with this one

No, I don't think this makes any sense.  Maintenance can be done by
unmounting the overlay and doing modification directly on the upper
layer.  After this is done (adding/removing opaque flag, adding
removing whiteouts, etc) the overlay can be mounted again and the
modifications will be applied.

I don't think online modification of the internal attributes of the
overlay makes much sense.

Except maybe, maybe a privileged undelete, but even that one is
tricky: the whiteout was either from deletion of the lower layer or
the upper layer file, the later not being undeleteable.  But the two
cases are currently indistinguishable, so the undelete would always
recover the lower layer file, which is probably not what the user
wants and might cause more harm than good.

Thanks,
Miklos
