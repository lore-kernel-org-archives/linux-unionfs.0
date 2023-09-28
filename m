Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E84BE732FD
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Sep 2023 17:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjI1RkW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 13:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjI1RkW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Sep 2023 13:40:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F0619D
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Sep 2023 10:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695922820; x=1727458820;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Ai2diJdUHqXv9uhPEMOmd+fOGbrl6M1BuaRip/v++OI=;
  b=WaWbEqDJKh9QW2rmsegCaodvtciheCWT3JE9v3P5d5AuDWcg2i5Xdnmq
   WAxm0XT256D3pnnIYw2cR/mCu4luSYaAk9SQp0clHHAesaTe5Ot1z+CxD
   F30VaoQvzi74Hoflgd2qo98QZXwJg9jZbDvGssxF98/RuK4sUa1MfSCrR
   o+BL3xWioUnOE6I9MfV1utLrdPqfFxiEcMJharSLzDxbtoUOaShqqPI5B
   O2BzfI/jBUkOBXaRmEoFWXLAMZDGR9rbvxk5VhvZLLNlpI3wHANPShaH3
   EEh9fzpkfe9qiMRIROxgdgiaVaAkJFr5G1XDOjtRJLkORA4+/XIRBNwhn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="385987367"
X-IronPort-AV: E=Sophos;i="6.03,184,1694761200"; 
   d="scan'208";a="385987367"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 10:40:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="726317007"
X-IronPort-AV: E=Sophos;i="6.03,184,1694761200"; 
   d="scan'208";a="726317007"
Received: from lkp-server02.sh.intel.com (HELO c3b01524d57c) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 28 Sep 2023 10:40:18 -0700
Received: from kbuild by c3b01524d57c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qluzo-0001l9-1E;
        Thu, 28 Sep 2023 17:40:16 +0000
Date:   Fri, 29 Sep 2023 01:39:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount-v3 3/4] <stdin>:1573:2: warning: #warning
 syscall statmount not implemented
Message-ID: <202309290121.SpcTeVBT-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount-v3
head:   5321994510f383b43dd2d49fcbdaedcf8cba1306
commit: 752065afadf4dbffa79febfc8e30d771353c1584 [3/4] add statmount(2) syscall
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230929/202309290121.SpcTeVBT-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230929/202309290121.SpcTeVBT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309290121.SpcTeVBT-lkp@intel.com/

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
