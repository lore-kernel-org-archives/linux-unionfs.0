Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A245CE743C1
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Sep 2023 20:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjI1U2c (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 16:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjI1U2c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Sep 2023 16:28:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79397193
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Sep 2023 13:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695932910; x=1727468910;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=sHCwWjwsx53xp1HeAsNEt/O+wi63WkKkc9B6hjQRK40=;
  b=n63qC4SW6SLwF52AMkYxbbM/wDNH0BxqD7EcDQ6fyqsGYUNAtLNpZqTj
   0mXRzxosiHca0B7T+yaMZkhvdF3chUQdeLXOt1gGGBzOkzclEtagGZ7kt
   POXozfO7rAt8rTwu+mWdRNh22T1tffn0Yfs1U38f7dWjDOsLqtvnfhJSe
   PiCL5SuLGN+zFlOfoYpSs6jNZoFjJZcQBg7CkdShgbZVT3fV2sOXNTNWY
   KKvxkE/huIWhapatYuPRK1HVXSfk6MKVf8wGcvULUGI5y2XiyGiP85mv1
   7lq+a6o/Smcym9Hy/EGN9kDrWQc4ztBwosl+92AyURAKwJ18QzgLLu1FL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="382070575"
X-IronPort-AV: E=Sophos;i="6.03,185,1694761200"; 
   d="scan'208";a="382070575"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 13:28:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="753132719"
X-IronPort-AV: E=Sophos;i="6.03,185,1694761200"; 
   d="scan'208";a="753132719"
Received: from lkp-server02.sh.intel.com (HELO c3b01524d57c) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 28 Sep 2023 13:28:28 -0700
Received: from kbuild by c3b01524d57c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qlxcY-0001vS-2f;
        Thu, 28 Sep 2023 20:28:26 +0000
Date:   Fri, 29 Sep 2023 04:28:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount-v3 4/4] <stdin>:1576:2: warning: #warning
 syscall listmount not implemented
Message-ID: <202309290415.ZLowlHzk-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount-v3
head:   5321994510f383b43dd2d49fcbdaedcf8cba1306
commit: 5321994510f383b43dd2d49fcbdaedcf8cba1306 [4/4] add listmount(2) syscall
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230929/202309290415.ZLowlHzk-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230929/202309290415.ZLowlHzk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309290415.ZLowlHzk-lkp@intel.com/

All warnings (new ones prefixed by >>):

   <stdin>:1573:2: warning: #warning syscall statmount not implemented [-Wcpp]
>> <stdin>:1576:2: warning: #warning syscall listmount not implemented [-Wcpp]
--
   <stdin>:1573:2: warning: #warning syscall statmount not implemented [-Wcpp]
>> <stdin>:1576:2: warning: #warning syscall listmount not implemented [-Wcpp]
--
   scripts/genksyms/parse.y: warning: 9 shift/reduce conflicts [-Wconflicts-sr]
   scripts/genksyms/parse.y: warning: 5 reduce/reduce conflicts [-Wconflicts-rr]
   scripts/genksyms/parse.y: note: rerun with option '-Wcounterexamples' to generate conflict counterexamples
   <stdin>:1573:2: warning: #warning syscall statmount not implemented [-Wcpp]
>> <stdin>:1576:2: warning: #warning syscall listmount not implemented [-Wcpp]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
