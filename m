Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181027200450.GA5909@thunk.org> <CAJfpegtCYkXiSYtw4dWGc=Fj2U3GaWiOiub+JmZ8pRXHNk4ERQ@mail.gmail.com>
 <20181029220404.GB15839@thunk.org>
In-Reply-To: <20181029220404.GB15839@thunk.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 30 Oct 2018 06:44:14 +0200
Message-ID: <CAOQ4uxiu6iS-VuEtPhequVp7Ukx7Kh0FUpECSXfkaZN==o7sJw@mail.gmail.com>
Subject: Re: overlayfs 4.19: unable to make backup link: Invalid cross-device link
Content-Type: text/plain; charset="UTF-8"
To: Theodore Tso <tytso@mit.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Oct 30, 2018 at 12:05 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Mon, Oct 29, 2018 at 09:31:58AM +0100, Miklos Szeredi wrote:
> > Can you please post
> >
> >   grep OVERLAY_FS .config
>
> Sure, here you go:
>
> % zgrep OVERLAY_FS /proc/config.gz
> CONFIG_OVERLAY_FS=m
> CONFIG_OVERLAY_FS_REDIRECT_DIR=y
> CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
> CONFIG_OVERLAY_FS_INDEX=y
> # CONFIG_OVERLAY_FS_XINO_AUTO is not set
> CONFIG_OVERLAY_FS_METACOPY=y
>
> And this was the config on the working 4.18 kernel:
>
> % grep OVERLAY_FS /boot/config-4.18.0-2-amd64
> CONFIG_OVERLAY_FS=m
> # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
> CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
> # CONFIG_OVERLAY_FS_INDEX is not set
> # CONFIG_OVERLAY_FS_XINO_AUTO is not set
>

So let's try to bisect the offending feature first.
If we can't find an offending feature, then there may be an offending
commit in 4.18..4.19

With kernel 4.19, please try to reproduce after:
echo N > /sys/module/overlay/parameters/metacopy
and then after:
echo N > /sys/module/overlay/parameters/index
and then after:
echo N > /sys/module/overlay/parameters/redirect_dir

With kernel 4.18, please try to reproduce after:
echo Y > /sys/module/overlay/parameters/redirect_dir
and then after:
echo Y > /sys/module/overlay/parameters/index

My immediate suspect w.r.t hardlink issues would be the index feature.

FYI, I had already verified that unionmount testsuite passes on kernel 4.19
with same overlay config as your kernel 4.19.

Thanks,
Amir.
