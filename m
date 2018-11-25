Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <ca0a6866-4f68-8066-2530-684c2ea36630@gmx.com>
In-Reply-To: <ca0a6866-4f68-8066-2530-684c2ea36630@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 25 Nov 2018 18:11:35 +0200
Message-ID: <CAOQ4uxhinux4ZEVSxYnCS5rpiY9NQNGJtC7VQyvK4PX1vAu12A@mail.gmail.com>
Subject: Re: fadvise in overlayfs
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Nov 25, 2018 at 4:03 PM cgxu519 <cgxu519@gmx.com> wrote:
>
> Hello,
>
>
> I noticed overlayfs will possibly do fadvise operation on upper or lower
> files.
>
> So I'm little curious when doing fadvise with flag 'POSIX_FADV_DONTNEED'
>
> to evict page cache on lower file which is shared with other overlayfs
> instances,
>
> isn't there any unexpected side effect?

Maybe, but user can also evict pages belonging to shared libraries?
And user can also use madvise(2) to evict lower file pages event if
we do drop fadvise() on lower file.

Other advice like POSIX_FADV_RANDOM, can also be counter
productive if different applications access the same file with different
access patterns.

>
> I have not done very detail test for exact result for it but when
>
> I run vmtouch(to evict page cache) and append write(to copy-up) in
> different instances,
>
> sometimes, copy-up seems failed with EIO.

?? it will be interesting if you have a reproducer...

>
> If above is correct, I would like to propose to do fadvise only for
> upper layer.
>
> What do you think for this?
>

Doesn't sound wrong, but not sure a real world use case
really justifies this??

Thanks,
Amir.
