From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [ANNOUNCE] fsck.overlayfs: update master branch
Date: Wed, 31 Jan 2018 18:23:33 +0800
Message-ID: <19ac0eea-d57f-169b-503b-ad734b30a495@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4750 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751619AbeAaKXw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 05:23:52 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3A68C5EA060DD
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 18:23:39 +0800 (CST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>

Hi All,

The master branch on my overlayfs-progs [1] has been updated.

No feature add, just handle comments form Amir in last iterations and
fix some bugs:
- Improve header comments for many functions, these becomes more readable.
- Fix some path manipulation bugs in path.c.
- Improve impurities check.
- Split out functions and constants from kernel into overlayfs.c/.h.
- Update README, split out and detail TODO list.

Thanks,
Yi.

[1] https://github.com/hisilicon/overlayfs-progs/tree/master
