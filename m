Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:11907 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752878AbeDLQNn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Apr 2018 12:13:43 -0400
Date: Fri, 13 Apr 2018 00:13:09 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [miklos-vfs:overlayfs-rorw 35/54] fs/overlayfs/file.c:315:6: sparse:
 symbol 'ovl_ioctl' was not declared. Should it be static?
Message-ID: <201804130058.N6wp9opo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: kbuild-all@01.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw
head:   9b82e69abc05b81650d3be96a50602700fc80bc4
commit: f8395fc9f072cf62488d4b128151650bede9bc00 [35/54] ovl: readd lsattr/chattr support
reproduce:
        # apt-get install sparse
        git checkout f8395fc9f072cf62488d4b128151650bede9bc00
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   fs/overlayfs/file.c:272:6: sparse: symbol 'ovl_fallocate' was not declared. Should it be static?
>> fs/overlayfs/file.c:315:6: sparse: symbol 'ovl_ioctl' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
