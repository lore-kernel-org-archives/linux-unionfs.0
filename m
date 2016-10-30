From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 31 Oct 2016 00:00:27 +0200
Message-ID: <CAOQ4uxgqGkioGZ9=rG3+m-SQEBCGH-9zvsC0-+KtRP0yuL0jRQ@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <CAOQ4uxhTOw9vHVSQURakYgamXMxXDTnZYFjUDZYx1Hnf=TA9dA@mail.gmail.com>
 <CAJfpegs+NDycOda67y5-8zDYHk90gxdQuQsRQ2pLq58UcUqa9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegs+NDycOda67y5-8zDYHk90gxdQuQsRQ2pLq58UcUqa9A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Oct 26, 2016 at 2:26 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>

...

>
> BTW I don't remember having tested this, so it might possibly be
> buggy.  Automatic multi-layer testing would really be good.  What we
> basically need is:
>
>  - create normal (two layer) overlay (with interesting constructs,
> whiteout, opaque dir, redirect)
>  - umount
>  - create three layer overlay where the two lower layers come from the
> previous upper/lower layers
>  - do more interesting things
>
> There's one such test in xfstests but it would be good to have more.
>

I have a POC for generic addition of layers for unionmount-testsuite
I pushed it to my github:
https://github.com/amir73il/unionmount-testsuite.git #ovl_rename_dir

remount(ctx) rotates upper to top of lower layers and adds a new upper layer
For now, remount(ctx) is called after successful mkdir and rename dir to
catch directory redirect bugs.

As it happens, it is very easy to find a bug, because it is enough to
just umount an mount the overlay without even adding a new layer
after directory rename to corrupt the overlayfs lookup.

Almost every rename-*-dir test demonstrates the problem

Going forward, I intend to hook the remount(ctx) event
in a cleaner way, so for every VFS op in every subtest,
it is possible to configure a test where the operation happens:
- without any remount
- with umount + mount
- with umount + mount with a new layer

Cheers,
Amir.
