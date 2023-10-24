Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8DCC25B47
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Oct 2023 22:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbjJXWSe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 18:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbjJXWSe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2023 18:18:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2B3128
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2023 15:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698185912; x=1729721912;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=W0A+4iyn+/TBexVajdmietYqZnQE7Q8Nb8Omlb3wiRA=;
  b=AI++l+oAt7nNIF/Ze6LMdbPdoeTCWytkYxGYBtrYoeFmy82UA4UOHZFU
   nPavudWr7EHTgI2WMkHBzGc3fxBIRzm8Q2dqtuvcVkOb9It6YYCoZO50e
   NOfhORW1cxz/0kYrtmv9AItPPZ+QoAMeP6dHaePJpoZd4OM2UE59g2fvZ
   MvtCwS91DsZ2UT9hUdC6NkoFmuvN1Jz24j9Y0PyN/gApWBgrhYXCprpF3
   oQc1KGtlALDERc9ka8ZjlAgWJ+sNhTb+jZTFkJL5dz051tKaDM8bF+rZm
   RLdSN6cxy/3ixFVnbfNBokQXz4Nwd4iJjMErdFN0Q1sce1R8rInYWniS5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="8743964"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="8743964"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 15:18:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="735174045"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="735174045"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 24 Oct 2023 15:18:30 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qvPjH-0008Kx-27;
        Tue, 24 Oct 2023 22:18:27 +0000
Date:   Wed, 25 Oct 2023 06:17:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount-v4 4/5] <stdin>:1573:2: warning: #warning
 syscall statmount not implemented
Message-ID: <202310250618.1hCN1tDn-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount-v4
head:   5562c08b885b01e2d1e316d17e5e0b3ab2ebe346
commit: 30c89d480c6848665e1dfffeed508785c97fe7df [4/5] add statmount(2) syscall
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20231025/202310250618.1hCN1tDn-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231025/202310250618.1hCN1tDn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310250618.1hCN1tDn-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> <stdin>:1573:2: warning: #warning syscall statmount not implemented [-Wcpp]
--
>> <stdin>:1573:2: warning: #warning syscall statmount not implemented [-Wcpp]
--
   scripts/genksyms/parse.y: warning: 9 shift/reduce conflicts [-Wconflicts-sr]
   scripts/genksyms/parse.y: warning: 5 reduce/reduce conflicts [-Wconflicts-rr]
   scripts/genksyms/parse.y: note: rerun with option '-Wcounterexamples' to generate conflict counterexamples
>> <stdin>:1573:2: warning: #warning syscall statmount not implemented [-Wcpp]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
