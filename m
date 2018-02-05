From: kbuild test robot <fengguang.wu@intel.com>
Subject: [miklos-vfs:overlayfs-linus 47/51] fs/overlayfs/export.c:459:10-16:
 WARNING: PTR_ERR_OR_ZERO can be used
Date: Tue, 6 Feb 2018 00:25:16 +0800
Message-ID: <201802060014.IgBGjPbI%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:27477 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753302AbeBEQZv (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Feb 2018 11:25:51 -0500
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: kbuild-all@01.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus
head:   9b6faee074702bbbc207e7027b9416c2d8fea9fe
commit: 4b91c30a5a19332e8dd10b601d05b72caf657730 [47/51] ovl: lookup connected ancestor of dir in inode cache


coccinelle warnings: (new ones prefixed by >>)

>> fs/overlayfs/export.c:459:10-16: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
