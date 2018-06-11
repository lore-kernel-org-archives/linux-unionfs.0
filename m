From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 07/39] vfs: export vfs_ioctl() to modules
Date: Mon, 11 Jun 2018 09:19:01 +0200
Message-ID: <CAJfpegtGtAR25qWgpNisvL8F51h3K6s44zkWBSVVbqecut6tBQ@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-8-mszeredi@redhat.com>
 <20180604084904.GF11333@infradead.org> <20180610045657.GM30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180610045657.GM30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jun 10, 2018 at 6:57 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jun 04, 2018 at 01:49:04AM -0700, Christoph Hellwig wrote:
>> On Tue, May 29, 2018 at 04:43:07PM +0200, Miklos Szeredi wrote:
>> > This is needed by the stacked ioctl implementation in overlayfs.
>>
>> EXPORT_SYMBOL_GPL for exporting random internals, please.  Same
>> for any following patches.
>
> *blink*
>
> Christoph, get real and RTFS - vfs_ioctl() simply calls ->unlocked_ioctl();
> all there is to it.
>
> This isn't even a case of "using that function establishes that the
> caller is a derived work" - *anyone* who can see definition of
> file_operations can bloody well open-code it.  There isn't anything
> establishing derivation here.
>
> Hell, it could've been a static inline in include/linux/fs.h and it would
> neither differ from many other inlines in there nor need an export at all.
>
> This is really getting close to lxo-worthy levels of bogosity...
>
> More interesting question is why do we want to pass those ioctls to layers
> in the first place, especially if it's something with different availability
> (or, worse yet, argument layouts) before and after copyup.

We don't.  Obviously need to make sure to only ever do ioctl's in
overlayfs that have a common definition across filesystems.  Not a lot
of those, luckily...

Thanks,
Miklos
