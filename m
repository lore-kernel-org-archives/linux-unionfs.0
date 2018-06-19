Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Tue, 19 Jun 2018 17:59:51 +0800
Message-ID: <CALLuPvowiBB7-2aaEgMEyykaZd+Web4zmPPUkx492Wq2CUNhkQ@mail.gmail.com>
Subject: Invalid argument reading file caps for file
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir,
I'd like to report a file access error case, happened while building a
yocto codebase on overlay mount dir.
After compiling gets error, dmesg shows warning message like:
[13181.958681] Invalid argument reading file caps for
/vol/mnt/m/build/tmp/work/x86_64-linux/gobject-introspection-native/1.50.0-r0/build/.libs/lt-g-ir-compiler

Mount config is like:
none /vol/mnt/m overlay
rw,relatime,lowerdir=/vol/yocto,upperdir=/vol/mnt/u,workdir=/vol/mnt/w,xino=off
0 0
The error accessed file and its dir build/ is created after mount.

I don't have simple step to reproduce the case, it just happens soon
or later in the progress of build.
Nearly everytime the error happens in clean build, but not 100%
happening, occasionally build progress can pass without error.

Cross test on versions and configs: it shows 4.9 and 4.10 don't have
the issue ( 4.11~4.15 are not tested).
- 4.17.0: samefs: reproduced
- 4.17.0: non-samefs: reproduced
- 4.17.0: non-samefs, mount with index=on,xino=on: reproduced
- 4.16.0: non-samefs: reproduced
- 4.9.x and 4.10.x: non-samefs: NOT reproduced

I tried to trace where the message "Invalid argument reading file caps
..."  comes from, it's like:
handler->get() => ovl_other_xattr_get
fs/xattr.c: __vfs_getxattr (xattr name=security.capability)
  handler->get() returns -EINVAL
security/commoncap.c: get_vfs_caps_from_disk
security/commoncap.c: get_file_caps

Would you suggest where I can check more or which changes I can test?

thanks,
Eddie
