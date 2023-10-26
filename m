Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14000C25B48
	for <linux-unionfs@archiver.kernel.org>; Thu, 26 Oct 2023 13:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjJZNj2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 26 Oct 2023 09:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjJZNj1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2023 09:39:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D11CBD
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Oct 2023 06:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698327565; x=1729863565;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=d4HmDVpW+a9DmAYNHKeyF52AXNv8DGGaRiuuJw66sq4=;
  b=iGIILakbuvlbpI7HwjGOGEDTg7sC+wC9VaVTqFeWkSa1tj/Q5F1OQzLA
   Erdb5aeKyct18CeYZNhbgDi8cU3Fek3x28rLxTlOPFmRQLziksK5dZJJR
   3cyuuwgMiP/u9MwAPfm+/Upxy76abzUi++rqjeykv0v7NKGtkXBOpxITF
   VERE+vwwmwidjSMkfVnunGnUq3PCtuzrx9JY1+HbhE7y7WNb/oCtKKhkr
   42d/oP/Gmb8l5vIpLIVkUcayJ3+UnfzN9FOGxJ4xH5WSajFIRisS5/GHN
   tlKQtR6Z1y5KA0N5kfHyY67mDZ+CUQiGFPp9Jbpx+9fJVLVHtVdFQF6cZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="451788589"
X-IronPort-AV: E=Sophos;i="6.03,253,1694761200"; 
   d="scan'208";a="451788589"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 06:39:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="735748170"
X-IronPort-AV: E=Sophos;i="6.03,253,1694761200"; 
   d="scan'208";a="735748170"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 26 Oct 2023 06:39:23 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qw0a0-0009pL-2L;
        Thu, 26 Oct 2023 13:39:20 +0000
Date:   Thu, 26 Oct 2023 21:38:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount-v4 6/6] arch/arm64/kernel/sys32.c:130:40:
 warning: excess elements in array initializer
Message-ID: <202310262126.LBc6mDHi-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount-v4
head:   6b10e0e8daeb6fcbc706a7e1e30c7e48243ffb88
commit: 6b10e0e8daeb6fcbc706a7e1e30c7e48243ffb88 [6/6] wire up syscalls for statmount/listmount
config: arm64-randconfig-004-20231026 (https://download.01.org/0day-ci/archive/20231026/202310262126.LBc6mDHi-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231026/202310262126.LBc6mDHi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310262126.LBc6mDHi-lkp@intel.com/

All warnings (new ones prefixed by >>):

         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:901:1: note: in expansion of macro '__SYSCALL'
     901 | __SYSCALL(__NR_landlock_add_rule, sys_landlock_add_rule)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table[445]')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:901:1: note: in expansion of macro '__SYSCALL'
     901 | __SYSCALL(__NR_landlock_add_rule, sys_landlock_add_rule)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: warning: initialized field overwritten [-Woverride-init]
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:903:1: note: in expansion of macro '__SYSCALL'
     903 | __SYSCALL(__NR_landlock_restrict_self, sys_landlock_restrict_self)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table[446]')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:903:1: note: in expansion of macro '__SYSCALL'
     903 | __SYSCALL(__NR_landlock_restrict_self, sys_landlock_restrict_self)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: warning: initialized field overwritten [-Woverride-init]
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:905:1: note: in expansion of macro '__SYSCALL'
     905 | __SYSCALL(__NR_process_mrelease, sys_process_mrelease)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table[448]')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:905:1: note: in expansion of macro '__SYSCALL'
     905 | __SYSCALL(__NR_process_mrelease, sys_process_mrelease)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: warning: initialized field overwritten [-Woverride-init]
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:907:1: note: in expansion of macro '__SYSCALL'
     907 | __SYSCALL(__NR_futex_waitv, sys_futex_waitv)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table[449]')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:907:1: note: in expansion of macro '__SYSCALL'
     907 | __SYSCALL(__NR_futex_waitv, sys_futex_waitv)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: warning: initialized field overwritten [-Woverride-init]
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:909:1: note: in expansion of macro '__SYSCALL'
     909 | __SYSCALL(__NR_set_mempolicy_home_node, sys_set_mempolicy_home_node)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table[450]')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:909:1: note: in expansion of macro '__SYSCALL'
     909 | __SYSCALL(__NR_set_mempolicy_home_node, sys_set_mempolicy_home_node)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: warning: initialized field overwritten [-Woverride-init]
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:911:1: note: in expansion of macro '__SYSCALL'
     911 | __SYSCALL(__NR_cachestat, sys_cachestat)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table[451]')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:911:1: note: in expansion of macro '__SYSCALL'
     911 | __SYSCALL(__NR_cachestat, sys_cachestat)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: warning: initialized field overwritten [-Woverride-init]
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:913:1: note: in expansion of macro '__SYSCALL'
     913 | __SYSCALL(__NR_fchmodat2, sys_fchmodat2)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table[452]')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:913:1: note: in expansion of macro '__SYSCALL'
     913 | __SYSCALL(__NR_fchmodat2, sys_fchmodat2)
         | ^~~~~~~~~
   arch/arm64/include/asm/unistd32.h:914:24: error: array index in initializer exceeds array bounds
     914 | #define __NR_statmount 454
         |                        ^~~
   arch/arm64/kernel/sys32.c:130:34: note: in definition of macro '__SYSCALL'
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                  ^~
   arch/arm64/include/asm/unistd32.h:915:11: note: in expansion of macro '__NR_statmount'
     915 | __SYSCALL(__NR_statmount, sys_statmount)
         |           ^~~~~~~~~~~~~~
   arch/arm64/include/asm/unistd32.h:914:24: note: (near initialization for 'compat_sys_call_table')
     914 | #define __NR_statmount 454
         |                        ^~~
   arch/arm64/kernel/sys32.c:130:34: note: in definition of macro '__SYSCALL'
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                  ^~
   arch/arm64/include/asm/unistd32.h:915:11: note: in expansion of macro '__NR_statmount'
     915 | __SYSCALL(__NR_statmount, sys_statmount)
         |           ^~~~~~~~~~~~~~
>> arch/arm64/kernel/sys32.c:130:40: warning: excess elements in array initializer
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:915:1: note: in expansion of macro '__SYSCALL'
     915 | __SYSCALL(__NR_statmount, sys_statmount)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:915:1: note: in expansion of macro '__SYSCALL'
     915 | __SYSCALL(__NR_statmount, sys_statmount)
         | ^~~~~~~~~
   arch/arm64/include/asm/unistd32.h:916:24: error: array index in initializer exceeds array bounds
     916 | #define __NR_listmount 455
         |                        ^~~
   arch/arm64/kernel/sys32.c:130:34: note: in definition of macro '__SYSCALL'
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                  ^~
   arch/arm64/include/asm/unistd32.h:917:11: note: in expansion of macro '__NR_listmount'
     917 | __SYSCALL(__NR_listmount, sys_listmount)
         |           ^~~~~~~~~~~~~~
   arch/arm64/include/asm/unistd32.h:916:24: note: (near initialization for 'compat_sys_call_table')
     916 | #define __NR_listmount 455
         |                        ^~~
   arch/arm64/kernel/sys32.c:130:34: note: in definition of macro '__SYSCALL'
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                  ^~
   arch/arm64/include/asm/unistd32.h:917:11: note: in expansion of macro '__NR_listmount'
     917 | __SYSCALL(__NR_listmount, sys_listmount)
         |           ^~~~~~~~~~~~~~
>> arch/arm64/kernel/sys32.c:130:40: warning: excess elements in array initializer
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:917:1: note: in expansion of macro '__SYSCALL'
     917 | __SYSCALL(__NR_listmount, sys_listmount)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:917:1: note: in expansion of macro '__SYSCALL'
     917 | __SYSCALL(__NR_listmount, sys_listmount)
         | ^~~~~~~~~


vim +130 arch/arm64/kernel/sys32.c

4378a7d4be30ec Mark Rutland    2018-07-11  128  
0156411b182877 Catalin Marinas 2015-01-06  129  #undef __SYSCALL
1e29ab3186e33c Sami Tolvanen   2019-05-24 @130  #define __SYSCALL(nr, sym)	[nr] = __arm64_##sym,
0156411b182877 Catalin Marinas 2015-01-06  131  

:::::: The code at line 130 was first introduced by commit
:::::: 1e29ab3186e33c77dbb2d7566172a205b59fa390 arm64: use the correct function type for __arm64_sys_ni_syscall

:::::: TO: Sami Tolvanen <samitolvanen@google.com>
:::::: CC: Will Deacon <will.deacon@arm.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
