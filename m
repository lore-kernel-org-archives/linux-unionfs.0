Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:44503 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753027AbeDLPyj (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Apr 2018 11:54:39 -0400
Date: Thu, 12 Apr 2018 23:54:09 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [miklos-vfs:overlayfs-rorw 34/54] fs/overlayfs/file.c:271:6: sparse:
 symbol 'ovl_fallocate' was not declared. Should it be static?
Message-ID: <201804122351.HBN7GKZh%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: kbuild-all@01.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw
head:   9b82e69abc05b81650d3be96a50602700fc80bc4
commit: 9283a5d72622b71db31b85d96733d261eafc2dea [34/54] ovl: readd fallocate
reproduce:
        # apt-get install sparse
        git checkout 9283a5d72622b71db31b85d96733d261eafc2dea
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/overlayfs/file.c:271:6: sparse: symbol 'ovl_fallocate' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
