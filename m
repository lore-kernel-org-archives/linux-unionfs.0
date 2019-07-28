Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190722050227.24944-1-amir73il@gmail.com> <20190728090440.GL7943@desktop>
In-Reply-To: <20190728090440.GL7943@desktop>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 28 Jul 2019 13:18:00 +0300
Message-ID: <CAOQ4uxihwO++86biDc_vLQ+iXV10=G-Uc7ofTw8db_pdt11Wxg@mail.gmail.com>
Subject: Re: [PATCH] overlay/065: adjust test to expect EBUSY only with index=on
Content-Type: text/plain; charset="UTF-8"
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Jul 28, 2019 at 12:04 PM Eryu Guan <guaneryu@gmail.com> wrote:
>
> On Mon, Jul 22, 2019 at 08:02:27AM +0300, Amir Goldstein wrote:
> > This is needed to support the kernel regression fix commit 0be0bfd2de9d
> > ("ovl: fix regression caused by overlapping layers detection").
> >
> > Overlayfs mount is not supposed to fail due to upper/work dir in-use
> > by other mount unless option index=on is enabled.
>
> Sorry for the late review.. Looks like this patch only mount overlay
> with "index=on" explicitly, but doesn't check that mount succeeds when
> "index=off", which is really regressed. Do we need to add more
> "index=off" tests to ensure we allow re-use upperdir?

Agreed!

Thanks,
Amir.
