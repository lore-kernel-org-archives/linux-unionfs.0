From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [ANNOUNCE PATCH v4 0/5] overlay: implement fsck.overlay utility
Date: Thu, 18 Jan 2018 11:50:51 +0800
Message-ID: <20180118035056.17358-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4244 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753865AbeARDoC (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 Jan 2018 22:44:02 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com, yizhang089@gmail.com

Hi All,

Here is the forth version of fsck.overlay. Most of comments from last
three iterations have been handled. Now, this tool have three basic
features (see README for detail, include TODO list):
1. Check and fix orphan whiteouts,
2. Check and fix invalid/duplicate redirect directories,
3. Check and fix missing impure xattrs.

This incubation tool will post to github repository[1] directly.
Any suggestion is helpful if you review the source code or find
bugs/improvements when you use/test this tool.

Thanks,
Yi.

[1] https://github.com/hisilicon/overlayfs-progs

Changes since v3:
- Use existing library for path manipulation and separate
  self-implemented manipulation helpers. (Comment from Amir)
- Use fstatat() with relative path instead of lstat() with absolute path
  when traverse layers and lookup target. (Amir)
- Split check routines into two pass, the first pass check redirect dir
  to confirm directory structure, the second pass check whiteouts and
  impure xattr.
- Change list to linux kernel style.
- Fix duplicate redirect xattr check, correct questions and default
  actions, and handle cases of duplicate redirect xattr in different
  layers. (Amir)
- Fix impure xattr comments and invalid error message. (Amir & Vivek)

----------------

Changes since v2(v1):

- Add "-n -p -y" options. (Comment from Amir and Darrick)
- Change underlying dirs input to '-o' option like mount(8). (Miklos)
- Remove invalid opaque check. (Miklos)
- Correct redirect xattr check. (Amir and Miklos)
- Fix lower target lookup, handle the missing case of opaque and
  redirect parent.
- Add impure xattr check. (Amir)

zhangyi (F) (5):
  overlay: implement fsck utility
  fsck.overlay: correct redirect xattr check
  fsck.overlay: add origin count
  fsck.overlay: add merge and redirect subdir count
  fsck.overlay: add impure xattr check
