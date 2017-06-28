From: Amir Goldstein <amir73il@gmail.com>
Subject: Overlayfs patches to consider for v4.13
Date: Wed, 28 Jun 2017 16:17:52 +0300
Message-ID: <CAOQ4uxgy8PMhHqQwH9GtpamUOZAuqDibDZm2vu_F=A3h_2BnVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35524 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbdF1NRy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Jun 2017 09:17:54 -0400
Received: by mail-oi0-f43.google.com with SMTP id c189so40940265oia.2
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jun 2017 06:17:53 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

Miklos,

Not that I have not given you enough work with inode index patches,
but just so you know, I have a tested branch [1] based on ovl-hardlinks
with a merge of 3 topic branches:
1. Non-samefs constant inode (Chandan & Amir)
2. Verify & set merge dir origin on lookup (Amir)
3. Check whiteouts in origin dir (Zhangyi & Amir)

The 3 topic branches are completely independent and merge
with no conflicts, so if you choose to, you may pick any one of
them for v4.13.

The patches from Chandan and Zhangyi have gone through several
review cycles and I complemented each with a patch on my own.
Not sure if you had a chance to glimpse.

Tested with a new xfstests whiteout test by Zhangyi [2] and
new unionmount-testsuite run flag [3] to check constant inode on
non-samefs (./run --ov --verify).

Zhangyi,

One thing I have not tested, but that should work is hiding of
whiteouts in a merge dir that was created prior to v4.12.
The test should be:
- Create merge dir and whiteouts with kernel <= v4.12-rc*
- Upgrade to kernel built from overlayfs-devel
- Mount overlay and list merge dir (should fix origin)
- Continue with use case of removing lower dir
  and trying to expose whiteouts

If you can spare the time, please test this use case.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/overlayfs-devel
[2] https://github.com/amir73il/xfstests/commits/overlayfs-devel
[3] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
