Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v4 0/3] option validation in remount
Date: Fri, 13 Apr 2018 20:39:13 +0800
Message-Id: <1523623156-6035-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Some overlayfs mount options cannot be changed via remount,
but current remount does not return error even if we specify
different value to unchangeable options.

This patch series adjust option parsing to support remount
and return proper error message and code when recogonizing
unchangeable options in remount.

Thanks,
Chengguang.

---
Chengguang Xu (3):
  ovl: adjust option parsing for supporting remount
  ovl: move the code of ovl_remount() to behind ovl_parse_opt()
  ovl: return error when specifying unchangeable options in remount

 fs/overlayfs/super.c | 150 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 108 insertions(+), 42 deletions(-)

-- 
1.8.3.1
