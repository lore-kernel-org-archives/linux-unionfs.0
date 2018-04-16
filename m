Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v7 0/3] option validation in remount
Date: Mon, 16 Apr 2018 09:37:05 +0800
Message-Id: <1523842628-11651-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Some overlayfs mount options cannot be changed via remount,
but current remount does not validate options even if specifying
unrecognized options.

This patch series adjust option parsing to support remount,
Considering backward compatibility, in current stage we only print
warning message but not return error when detecting unchangeable
options in remount. However, if user specify unrecognized or invalid
options then return -EINVAL.

This is also a starting point to exploring how to change options
(e.g. ro->rw with specifying workdir&upperdir) in remount.

Thanks,
Chengguang.

---
Chengguang Xu (3):
  ovl: adjust option parsing for supporting remount
  ovl: move the code of ovl_remount() to behind ovl_parse_opt()
  ovl: print warning when specifying unchangeable options in remount

 fs/overlayfs/super.c | 152 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 109 insertions(+), 43 deletions(-)

-- 
1.8.3.1
