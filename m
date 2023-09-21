Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271DCE7D0A7
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 19:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjIUTua (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjIUTuR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 15:50:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EC87E4C2
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 10:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318645; x=1726854645;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=F1panPiy1eVBxc67IWI2aguQJXLoUTlFdlhSgMxMvP0=;
  b=KJN1RAN6sw/LvSZRWSJkT3tEpaYahMkoZjZFo1AEbgLNunBDuL1TOceY
   U5Zhsq+3sCK4OozX/xofEcpBJzpmZqbxoHnTeSMrV9kolU+v5AHkAFQNE
   rArhZ7bf+vGnf7whtUMqusWcxKLvZvL13YbS0/zBijHY76j5P3L4s00Ko
   1jOWWnptVaecU69xhxmdihQg3tRgve2AL07uex/LBuq4tQze0qAGlYwu8
   YKMQ+uT8EaTaIth2O0VDDscs2gShMQVXnS2JZA6mGw5vr0Pz0f+tCDXGf
   o2BtWJ+VYfpr7zMpIoNvLioxy5gFQADxy5SZ2UQcQVxo4GUtcg2MqisQ5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="384322541"
X-IronPort-AV: E=Sophos;i="6.03,165,1694761200"; 
   d="scan'208";a="384322541"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 03:25:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="812590398"
X-IronPort-AV: E=Sophos;i="6.03,165,1694761200"; 
   d="scan'208";a="812590398"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 21 Sep 2023 03:25:21 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qjGs3-0009t6-1q;
        Thu, 21 Sep 2023 10:25:19 +0000
Date:   Thu, 21 Sep 2023 18:25:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount-v2 2/3] namespace.c:(.rodata.cst4+0x94):
 undefined reference to `show_path'
Message-ID: <202309211802.XJ1Wjhhf-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount-v2
head:   9b5ff63d2b9b94298e6c9fbac4df9e77e6901fc9
commit: 43d6746354fa23a231946542c476e14f483c44c5 [2/3] add statmount(2) syscall
config: parisc-randconfig-001-20230921 (https://download.01.org/0day-ci/archive/20230921/202309211802.XJ1Wjhhf-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230921/202309211802.XJ1Wjhhf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309211802.XJ1Wjhhf-lkp@intel.com/

All errors (new ones prefixed by >>):

   hppa-linux-ld: fs/namespace.o: in function `.LC97':
>> namespace.c:(.rodata.cst4+0x94): undefined reference to `show_path'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
