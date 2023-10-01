Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4A0E748E6
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Oct 2023 00:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbjJAAII (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 30 Sep 2023 20:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjJAAIH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 30 Sep 2023 20:08:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFC8DD
        for <linux-unionfs@vger.kernel.org>; Sat, 30 Sep 2023 17:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696118885; x=1727654885;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=M3PXI17An+e0kxHW7sxlHzj9blKu1QRTw0lZ0OM6YzI=;
  b=IDfyvXoun+4ISdOhqgDTXyI/seunsqfzlpp/SAFHSUxiNyI9ri+6WNag
   3wYZNLCPYmNLMG9oq+kTX/C12uaje89c7QiXSlM2SurANNF91VEL1O7cr
   v4QZ6hzRLNkt6cSIHe8Ukaw3xh6a71iC26dm8xLieTmToDu2wQu42xMTy
   AeiythLAL/YNRqyGPIfaG3wBzi1NSnEhY0d7HbwkyC5V3b5xGeNal+2G8
   AdRQUqij6+f1d22gFMb/0CAJX7Imd5CKT0hcbxV1EFSqbUVVdsGHRLwJx
   cW17bGfj/ZIUNWf2pPCYUzGYvsQ0gjBBq3ezFw5xXe8cAbZA5k8lDpBJl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10849"; a="382389756"
X-IronPort-AV: E=Sophos;i="6.03,191,1694761200"; 
   d="scan'208";a="382389756"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2023 17:08:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10849"; a="726913306"
X-IronPort-AV: E=Sophos;i="6.03,191,1694761200"; 
   d="scan'208";a="726913306"
Received: from lkp-server02.sh.intel.com (HELO c3b01524d57c) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 30 Sep 2023 17:08:02 -0700
Received: from kbuild by c3b01524d57c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qmk07-0004b1-2e;
        Sun, 01 Oct 2023 00:07:59 +0000
Date:   Sun, 1 Oct 2023 08:07:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount-v3 4/4] <stdin>:1576:2: warning: syscall
 listmount not implemented
Message-ID: <202310010835.jn5IpgV5-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount-v3
head:   5321994510f383b43dd2d49fcbdaedcf8cba1306
commit: 5321994510f383b43dd2d49fcbdaedcf8cba1306 [4/4] add listmount(2) syscall
config: mips-ath25_defconfig (https://download.01.org/0day-ci/archive/20231001/202310010835.jn5IpgV5-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231001/202310010835.jn5IpgV5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310010835.jn5IpgV5-lkp@intel.com/

All warnings (new ones prefixed by >>):

   <stdin>:1573:2: warning: syscall statmount not implemented [-W#warnings]
    1573 | #warning syscall statmount not implemented
         |  ^
>> <stdin>:1576:2: warning: syscall listmount not implemented [-W#warnings]
    1576 | #warning syscall listmount not implemented
         |  ^
   2 warnings generated.
--
   <stdin>:1573:2: warning: syscall statmount not implemented [-W#warnings]
    1573 | #warning syscall statmount not implemented
         |  ^
>> <stdin>:1576:2: warning: syscall listmount not implemented [-W#warnings]
    1576 | #warning syscall listmount not implemented
         |  ^
   2 warnings generated.
--
   <stdin>:1573:2: warning: syscall statmount not implemented [-W#warnings]
    1573 | #warning syscall statmount not implemented
         |  ^
>> <stdin>:1576:2: warning: syscall listmount not implemented [-W#warnings]
    1576 | #warning syscall listmount not implemented
         |  ^
   2 warnings generated.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
