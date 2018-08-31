Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:46291 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbeHaKAT (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Aug 2018 06:00:19 -0400
Date: Fri, 31 Aug 2018 13:51:12 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [miklos-vfs:overlayfs-next 6/6] fs/overlayfs/file.c:334:5: sparse:
 symbol 'ovl_fadvise' was not declared. Should it be static?
Message-ID: <201808311344.jRhJ1LUF%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: kbuild-all@01.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
head:   53e35e7602b1cb11751e1788a888c6d74463c6c0
commit: 53e35e7602b1cb11751e1788a888c6d74463c6c0 [6/6] ovl: add ovl_fadvise()
reproduce:
        # apt-get install sparse
        git checkout 53e35e7602b1cb11751e1788a888c6d74463c6c0
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/overlayfs/file.c:334:5: sparse: symbol 'ovl_fadvise' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
