Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Dec 2019 08:31:49 +0200
Message-ID: <CAOQ4uxh7fszXGXV0U5K4yz4o3WwDk40LmOi+dH2Nwi+yq_5+Pw@mail.gmail.com>
Subject: Overlayfs fixes queue
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Miklos,

Will you have time to queue some of the queued fixed [1] and docs .rst
conversion [2] for 5.5, maybe rc2?

The timestamp limits issue is also being addressed by Deepa in vfs as
you suggested, so not critical but nice to have.

I posted an xfstest [3] that demonstrates the corner case of
non-unique st_dev;st_ino (v4.17 regression).

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-fixes

* f25e33779931 - ovl: fix corner case of non-unique st_dev;st_ino
* c0eb8296e077 - ovl: don't use a temp buf for encoding real fh
* 84d7f2d7d93d - ovl: make sure that real fid is 32bit aligned in memory
* b2d4f0ea5af4 - ovl: fix lookup failure on multi lower squashfs
* e930bd4d5e9d - ovl: fix timestamp limits

[2] https://github.com/amir73il/linux/commits/ovl-docs

* 80efb1bb664f - docs: filesystems: overlayfs: Fix restview warnings
* 28329d8b3cb2 - docs: filesystems: overlayfs: Rename overlayfs.txt to .rst

[3] https://lore.kernel.org/fstests/20191124142957.20873-1-amir73il@gmail.com/
