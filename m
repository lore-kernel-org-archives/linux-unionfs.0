Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48358E7D0A2
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 19:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjIUTh5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjIUThn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 15:37:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCAB88088
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 10:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318690; x=1726854690;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Rbouvc54V811LMrNGLG/uyLQr9hzO9qEsZRatwpvPhE=;
  b=Zki9YyTO6a2Z3wSE/jBZf2qHBqe0IJlqclOspt9YzvIoZv658yyXASWn
   P4I9cRfsAxtt+ydnIwamnV6RfJyR8UWltwcjVwfNgWkVqe1P6TQCiizx/
   1hm7ySWetPkEplMpACnKwhfEk4MKhFUQ0KJHAWjXGbJCo7JDgdebeLIN7
   cqOALzabThiuzhcJFGMGLM6Y1OQbhsGrQH0f1MlBEwvzQmBmz32BQSk06
   QNg167QjaxfkZfk8cfGj44OA7aHaEmgsAiL/jZzAVXL2qbpMmgO8FaHyI
   3+48nZWrnHEACHs4Bqmy2bTkJcl15o6VdLJdq3XbDkYj1WVZFVFi4d2A3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="379326118"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="379326118"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 00:20:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="862340949"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="862340949"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 21 Sep 2023 00:18:13 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qjDww-0009gw-1I;
        Thu, 21 Sep 2023 07:18:10 +0000
Date:   Thu, 21 Sep 2023 15:17:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount-v2 2/3] fs/namespace.c:4681:17: sparse:
 sparse: symbol 'lookup_mnt_in_ns' was not declared. Should it be static?
Message-ID: <202309211554.PYeIATsU-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount-v2
head:   9b5ff63d2b9b94298e6c9fbac4df9e77e6901fc9
commit: 43d6746354fa23a231946542c476e14f483c44c5 [2/3] add statmount(2) syscall
config: i386-randconfig-062-20230921 (https://download.01.org/0day-ci/archive/20230921/202309211554.PYeIATsU-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230921/202309211554.PYeIATsU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309211554.PYeIATsU-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/namespace.c:4681:17: sparse: sparse: symbol 'lookup_mnt_in_ns' was not declared. Should it be static?

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
