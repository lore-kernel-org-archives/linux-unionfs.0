Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvowiBB7-2aaEgMEyykaZd+Web4zmPPUkx492Wq2CUNhkQ@mail.gmail.com>
References: <CALLuPvowiBB7-2aaEgMEyykaZd+Web4zmPPUkx492Wq2CUNhkQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 19 Jun 2018 14:03:36 +0300
Message-ID: <CAOQ4uxi37A0Nrfhjwc0bxEkrAvjjA47s+aGg6RdOt7J-s0z5BQ@mail.gmail.com>
Subject: Re: Invalid argument reading file caps for file
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jun 19, 2018 at 12:59 PM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
> Hi Amir,
> I'd like to report a file access error case, happened while building a
> yocto codebase on overlay mount dir.
> After compiling gets error, dmesg shows warning message like:
> [13181.958681] Invalid argument reading file caps for
> /vol/mnt/m/build/tmp/work/x86_64-linux/gobject-introspection-native/1.50.0-r0/build/.libs/lt-g-ir-compiler
>
> Mount config is like:
> none /vol/mnt/m overlay
> rw,relatime,lowerdir=/vol/yocto,upperdir=/vol/mnt/u,workdir=/vol/mnt/w,xino=off
> 0 0
> The error accessed file and its dir build/ is created after mount.

What is the underlying filesystem?
Do you if your system also tries to set security.capability xattr
or just tries to read them?

>
> I don't have simple step to reproduce the case, it just happens soon
> or later in the progress of build.
> Nearly everytime the error happens in clean build, but not 100%
> happening, occasionally build progress can pass without error.
>
> Cross test on versions and configs: it shows 4.9 and 4.10 don't have
> the issue ( 4.11~4.15 are not tested).
> - 4.17.0: samefs: reproduced
> - 4.17.0: non-samefs: reproduced
> - 4.17.0: non-samefs, mount with index=on,xino=on: reproduced
> - 4.16.0: non-samefs: reproduced
> - 4.9.x and 4.10.x: non-samefs: NOT reproduced
>
> I tried to trace where the message "Invalid argument reading file caps
> ..."  comes from, it's like:
> handler->get() => ovl_other_xattr_get
> fs/xattr.c: __vfs_getxattr (xattr name=security.capability)
>   handler->get() returns -EINVAL
> security/commoncap.c: get_vfs_caps_from_disk
> security/commoncap.c: get_file_caps
>
> Would you suggest where I can check more or which changes I can test?
>

I would check the change (from v4.14):
8db6c34f1dbc Introduce v3 namespaced file capabilities

I suggest that you continue down the rabbit hole to see
which check returns -EINVAL, whether inside ovl_xattr_get()
or deeper inside nested vfs_getxattr().

Other than that, you can try this overlayfs backport branch:
https://github.com/amir73il/linux/commits/overlayfs-4.9.y-17
It contains backported overlayfs patches up to v4.17 based
off of v4.9.102.

If problem is not reproduced on the backported branch then
chances are the problem has to do with interaction between
overlayfs and a change to another subsystem (e.g. v3
namespaced file capabilities).

Thanks,
Amir.
