Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0E1C25B48
	for <linux-unionfs@archiver.kernel.org>; Thu, 26 Oct 2023 18:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjJZSQ4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 26 Oct 2023 14:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbjJZSQy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2023 14:16:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3BB1B1
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Oct 2023 11:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698344205; x=1729880205;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=le8UoEwRmRsbagMFWVniA780wTxf1qc72N+Gxuj4UXY=;
  b=e0Xjn8mhWzXqULXpoWJU3c1oyDx8sit8QobVz49VeslYd55SbH69lIE/
   4s7dFOPdUpAxc46A1zuHt6duTdV/o5rvrkAbReoOgtPO/eiOqW+dmB5Hn
   uOw8qcKj+fN3VNRrza3dKO4h8id91QMVMik/EEVb1K7Gj13glsPWzviO4
   Ubv415NNKF0U/1AvU1HB8KaMxdNU2LJavzwLqYAU2VPE9rgCfjJpD9uEe
   BCncy0MKvjFuWeBCpORhUqJdqA+94jahSQ7LcZbD++aJ1OK2gMWWP9UR+
   7MGQJFLOmouu2aHIh6Lv6SSBjp2hgvlPc0YIu/c8efhWjkE4RUOZffH4U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="418732750"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="418732750"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 11:16:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="825085999"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="825085999"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 26 Oct 2023 11:16:35 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qw4uH-000A1X-0L;
        Thu, 26 Oct 2023 18:16:33 +0000
Date:   Fri, 27 Oct 2023 02:16:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount-v4 6/6]
 arch/arm64/include/asm/unistd32.h:914:24: error: array index in initializer
 exceeds array bounds
Message-ID: <202310270230.lv9FaVQW-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount-v4
head:   6b10e0e8daeb6fcbc706a7e1e30c7e48243ffb88
commit: 6b10e0e8daeb6fcbc706a7e1e30c7e48243ffb88 [6/6] wire up syscalls for statmount/listmount
config: arm64-randconfig-004-20231026 (https://download.01.org/0day-ci/archive/20231027/202310270230.lv9FaVQW-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231027/202310270230.lv9FaVQW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310270230.lv9FaVQW-lkp@intel.com/

All errors (new ones prefixed by >>):

         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:897:1: note: in expansion of macro '__SYSCALL'
     897 | __SYSCALL(__NR_quotactl_fd, sys_quotactl_fd)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: warning: initialized field overwritten [-Woverride-init]
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:899:1: note: in expansion of macro '__SYSCALL'
     899 | __SYSCALL(__NR_landlock_create_ruleset, sys_landlock_create_ruleset)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: note: (near initialization for 'compat_sys_call_table[444]')
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
         |                                        ^~~~~~~~
   arch/arm64/include/asm/unistd32.h:899:1: note: in expansion of macro '__SYSCALL'
     899 | __SYSCALL(__NR_landlock_create_ruleset, sys_landlock_create_ruleset)
         | ^~~~~~~~~
   arch/arm64/kernel/sys32.c:130:40: warning: initialized field overwritten [-Woverride-init]
     130 | #define __SYSCALL(nr, sym)      [nr] = __arm64_##sym,
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
>> arch/arm64/include/asm/unistd32.h:914:24: error: array index in initializer exceeds array bounds
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
   arch/arm64/kernel/sys32.c:130:40: warning: excess elements in array initializer
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
   arch/arm64/kernel/sys32.c:130:40: warning: excess elements in array initializer
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


vim +914 arch/arm64/include/asm/unistd32.h

    12	
    13	#define __NR_restart_syscall 0
    14	__SYSCALL(__NR_restart_syscall, sys_restart_syscall)
    15	#define __NR_exit 1
    16	__SYSCALL(__NR_exit, sys_exit)
    17	#define __NR_fork 2
    18	__SYSCALL(__NR_fork, sys_fork)
    19	#define __NR_read 3
    20	__SYSCALL(__NR_read, sys_read)
    21	#define __NR_write 4
    22	__SYSCALL(__NR_write, sys_write)
    23	#define __NR_open 5
    24	__SYSCALL(__NR_open, compat_sys_open)
    25	#define __NR_close 6
    26	__SYSCALL(__NR_close, sys_close)
    27				/* 7 was sys_waitpid */
    28	__SYSCALL(7, sys_ni_syscall)
    29	#define __NR_creat 8
    30	__SYSCALL(__NR_creat, sys_creat)
    31	#define __NR_link 9
    32	__SYSCALL(__NR_link, sys_link)
    33	#define __NR_unlink 10
    34	__SYSCALL(__NR_unlink, sys_unlink)
    35	#define __NR_execve 11
    36	__SYSCALL(__NR_execve, compat_sys_execve)
    37	#define __NR_chdir 12
    38	__SYSCALL(__NR_chdir, sys_chdir)
    39				/* 13 was sys_time */
    40	__SYSCALL(13, sys_ni_syscall)
    41	#define __NR_mknod 14
    42	__SYSCALL(__NR_mknod, sys_mknod)
    43	#define __NR_chmod 15
    44	__SYSCALL(__NR_chmod, sys_chmod)
    45	#define __NR_lchown 16
    46	__SYSCALL(__NR_lchown, sys_lchown16)
    47				/* 17 was sys_break */
    48	__SYSCALL(17, sys_ni_syscall)
    49				/* 18 was sys_stat */
    50	__SYSCALL(18, sys_ni_syscall)
    51	#define __NR_lseek 19
    52	__SYSCALL(__NR_lseek, compat_sys_lseek)
    53	#define __NR_getpid 20
    54	__SYSCALL(__NR_getpid, sys_getpid)
    55	#define __NR_mount 21
    56	__SYSCALL(__NR_mount, sys_mount)
    57				/* 22 was sys_umount */
    58	__SYSCALL(22, sys_ni_syscall)
    59	#define __NR_setuid 23
    60	__SYSCALL(__NR_setuid, sys_setuid16)
    61	#define __NR_getuid 24
    62	__SYSCALL(__NR_getuid, sys_getuid16)
    63				/* 25 was sys_stime */
    64	__SYSCALL(25, sys_ni_syscall)
    65	#define __NR_ptrace 26
    66	__SYSCALL(__NR_ptrace, compat_sys_ptrace)
    67				/* 27 was sys_alarm */
    68	__SYSCALL(27, sys_ni_syscall)
    69				/* 28 was sys_fstat */
    70	__SYSCALL(28, sys_ni_syscall)
    71	#define __NR_pause 29
    72	__SYSCALL(__NR_pause, sys_pause)
    73				/* 30 was sys_utime */
    74	__SYSCALL(30, sys_ni_syscall)
    75				/* 31 was sys_stty */
    76	__SYSCALL(31, sys_ni_syscall)
    77				/* 32 was sys_gtty */
    78	__SYSCALL(32, sys_ni_syscall)
    79	#define __NR_access 33
    80	__SYSCALL(__NR_access, sys_access)
    81	#define __NR_nice 34
    82	__SYSCALL(__NR_nice, sys_nice)
    83				/* 35 was sys_ftime */
    84	__SYSCALL(35, sys_ni_syscall)
    85	#define __NR_sync 36
    86	__SYSCALL(__NR_sync, sys_sync)
    87	#define __NR_kill 37
    88	__SYSCALL(__NR_kill, sys_kill)
    89	#define __NR_rename 38
    90	__SYSCALL(__NR_rename, sys_rename)
    91	#define __NR_mkdir 39
    92	__SYSCALL(__NR_mkdir, sys_mkdir)
    93	#define __NR_rmdir 40
    94	__SYSCALL(__NR_rmdir, sys_rmdir)
    95	#define __NR_dup 41
    96	__SYSCALL(__NR_dup, sys_dup)
    97	#define __NR_pipe 42
    98	__SYSCALL(__NR_pipe, sys_pipe)
    99	#define __NR_times 43
   100	__SYSCALL(__NR_times, compat_sys_times)
   101				/* 44 was sys_prof */
   102	__SYSCALL(44, sys_ni_syscall)
   103	#define __NR_brk 45
   104	__SYSCALL(__NR_brk, sys_brk)
   105	#define __NR_setgid 46
   106	__SYSCALL(__NR_setgid, sys_setgid16)
   107	#define __NR_getgid 47
   108	__SYSCALL(__NR_getgid, sys_getgid16)
   109				/* 48 was sys_signal */
   110	__SYSCALL(48, sys_ni_syscall)
   111	#define __NR_geteuid 49
   112	__SYSCALL(__NR_geteuid, sys_geteuid16)
   113	#define __NR_getegid 50
   114	__SYSCALL(__NR_getegid, sys_getegid16)
   115	#define __NR_acct 51
   116	__SYSCALL(__NR_acct, sys_acct)
   117	#define __NR_umount2 52
   118	__SYSCALL(__NR_umount2, sys_umount)
   119				/* 53 was sys_lock */
   120	__SYSCALL(53, sys_ni_syscall)
   121	#define __NR_ioctl 54
   122	__SYSCALL(__NR_ioctl, compat_sys_ioctl)
   123	#define __NR_fcntl 55
   124	__SYSCALL(__NR_fcntl, compat_sys_fcntl)
   125				/* 56 was sys_mpx */
   126	__SYSCALL(56, sys_ni_syscall)
   127	#define __NR_setpgid 57
   128	__SYSCALL(__NR_setpgid, sys_setpgid)
   129				/* 58 was sys_ulimit */
   130	__SYSCALL(58, sys_ni_syscall)
   131				/* 59 was sys_olduname */
   132	__SYSCALL(59, sys_ni_syscall)
   133	#define __NR_umask 60
   134	__SYSCALL(__NR_umask, sys_umask)
   135	#define __NR_chroot 61
   136	__SYSCALL(__NR_chroot, sys_chroot)
   137	#define __NR_ustat 62
   138	__SYSCALL(__NR_ustat, compat_sys_ustat)
   139	#define __NR_dup2 63
   140	__SYSCALL(__NR_dup2, sys_dup2)
   141	#define __NR_getppid 64
   142	__SYSCALL(__NR_getppid, sys_getppid)
   143	#define __NR_getpgrp 65
   144	__SYSCALL(__NR_getpgrp, sys_getpgrp)
   145	#define __NR_setsid 66
   146	__SYSCALL(__NR_setsid, sys_setsid)
   147	#define __NR_sigaction 67
   148	__SYSCALL(__NR_sigaction, compat_sys_sigaction)
   149				/* 68 was sys_sgetmask */
   150	__SYSCALL(68, sys_ni_syscall)
   151				/* 69 was sys_ssetmask */
   152	__SYSCALL(69, sys_ni_syscall)
   153	#define __NR_setreuid 70
   154	__SYSCALL(__NR_setreuid, sys_setreuid16)
   155	#define __NR_setregid 71
   156	__SYSCALL(__NR_setregid, sys_setregid16)
   157	#define __NR_sigsuspend 72
   158	__SYSCALL(__NR_sigsuspend, sys_sigsuspend)
   159	#define __NR_sigpending 73
   160	__SYSCALL(__NR_sigpending, compat_sys_sigpending)
   161	#define __NR_sethostname 74
   162	__SYSCALL(__NR_sethostname, sys_sethostname)
   163	#define __NR_setrlimit 75
   164	__SYSCALL(__NR_setrlimit, compat_sys_setrlimit)
   165				/* 76 was compat_sys_getrlimit */
   166	__SYSCALL(76, sys_ni_syscall)
   167	#define __NR_getrusage 77
   168	__SYSCALL(__NR_getrusage, compat_sys_getrusage)
   169	#define __NR_gettimeofday 78
   170	__SYSCALL(__NR_gettimeofday, compat_sys_gettimeofday)
   171	#define __NR_settimeofday 79
   172	__SYSCALL(__NR_settimeofday, compat_sys_settimeofday)
   173	#define __NR_getgroups 80
   174	__SYSCALL(__NR_getgroups, sys_getgroups16)
   175	#define __NR_setgroups 81
   176	__SYSCALL(__NR_setgroups, sys_setgroups16)
   177				/* 82 was compat_sys_select */
   178	__SYSCALL(82, sys_ni_syscall)
   179	#define __NR_symlink 83
   180	__SYSCALL(__NR_symlink, sys_symlink)
   181				/* 84 was sys_lstat */
   182	__SYSCALL(84, sys_ni_syscall)
   183	#define __NR_readlink 85
   184	__SYSCALL(__NR_readlink, sys_readlink)
   185	#define __NR_uselib 86
   186	__SYSCALL(__NR_uselib, sys_uselib)
   187	#define __NR_swapon 87
   188	__SYSCALL(__NR_swapon, sys_swapon)
   189	#define __NR_reboot 88
   190	__SYSCALL(__NR_reboot, sys_reboot)
   191				/* 89 was sys_readdir */
   192	__SYSCALL(89, sys_ni_syscall)
   193				/* 90 was sys_mmap */
   194	__SYSCALL(90, sys_ni_syscall)
   195	#define __NR_munmap 91
   196	__SYSCALL(__NR_munmap, sys_munmap)
   197	#define __NR_truncate 92
   198	__SYSCALL(__NR_truncate, compat_sys_truncate)
   199	#define __NR_ftruncate 93
   200	__SYSCALL(__NR_ftruncate, compat_sys_ftruncate)
   201	#define __NR_fchmod 94
   202	__SYSCALL(__NR_fchmod, sys_fchmod)
   203	#define __NR_fchown 95
   204	__SYSCALL(__NR_fchown, sys_fchown16)
   205	#define __NR_getpriority 96
   206	__SYSCALL(__NR_getpriority, sys_getpriority)
   207	#define __NR_setpriority 97
   208	__SYSCALL(__NR_setpriority, sys_setpriority)
   209				/* 98 was sys_profil */
   210	__SYSCALL(98, sys_ni_syscall)
   211	#define __NR_statfs 99
   212	__SYSCALL(__NR_statfs, compat_sys_statfs)
   213	#define __NR_fstatfs 100
   214	__SYSCALL(__NR_fstatfs, compat_sys_fstatfs)
   215				/* 101 was sys_ioperm */
   216	__SYSCALL(101, sys_ni_syscall)
   217				/* 102 was sys_socketcall */
   218	__SYSCALL(102, sys_ni_syscall)
   219	#define __NR_syslog 103
   220	__SYSCALL(__NR_syslog, sys_syslog)
   221	#define __NR_setitimer 104
   222	__SYSCALL(__NR_setitimer, compat_sys_setitimer)
   223	#define __NR_getitimer 105
   224	__SYSCALL(__NR_getitimer, compat_sys_getitimer)
   225	#define __NR_stat 106
   226	__SYSCALL(__NR_stat, compat_sys_newstat)
   227	#define __NR_lstat 107
   228	__SYSCALL(__NR_lstat, compat_sys_newlstat)
   229	#define __NR_fstat 108
   230	__SYSCALL(__NR_fstat, compat_sys_newfstat)
   231				/* 109 was sys_uname */
   232	__SYSCALL(109, sys_ni_syscall)
   233				/* 110 was sys_iopl */
   234	__SYSCALL(110, sys_ni_syscall)
   235	#define __NR_vhangup 111
   236	__SYSCALL(__NR_vhangup, sys_vhangup)
   237				/* 112 was sys_idle */
   238	__SYSCALL(112, sys_ni_syscall)
   239				/* 113 was sys_syscall */
   240	__SYSCALL(113, sys_ni_syscall)
   241	#define __NR_wait4 114
   242	__SYSCALL(__NR_wait4, compat_sys_wait4)
   243	#define __NR_swapoff 115
   244	__SYSCALL(__NR_swapoff, sys_swapoff)
   245	#define __NR_sysinfo 116
   246	__SYSCALL(__NR_sysinfo, compat_sys_sysinfo)
   247				/* 117 was sys_ipc */
   248	__SYSCALL(117, sys_ni_syscall)
   249	#define __NR_fsync 118
   250	__SYSCALL(__NR_fsync, sys_fsync)
   251	#define __NR_sigreturn 119
   252	__SYSCALL(__NR_sigreturn, compat_sys_sigreturn)
   253	#define __NR_clone 120
   254	__SYSCALL(__NR_clone, sys_clone)
   255	#define __NR_setdomainname 121
   256	__SYSCALL(__NR_setdomainname, sys_setdomainname)
   257	#define __NR_uname 122
   258	__SYSCALL(__NR_uname, sys_newuname)
   259				/* 123 was sys_modify_ldt */
   260	__SYSCALL(123, sys_ni_syscall)
   261	#define __NR_adjtimex 124
   262	__SYSCALL(__NR_adjtimex, sys_adjtimex_time32)
   263	#define __NR_mprotect 125
   264	__SYSCALL(__NR_mprotect, sys_mprotect)
   265	#define __NR_sigprocmask 126
   266	__SYSCALL(__NR_sigprocmask, compat_sys_sigprocmask)
   267				/* 127 was sys_create_module */
   268	__SYSCALL(127, sys_ni_syscall)
   269	#define __NR_init_module 128
   270	__SYSCALL(__NR_init_module, sys_init_module)
   271	#define __NR_delete_module 129
   272	__SYSCALL(__NR_delete_module, sys_delete_module)
   273				/* 130 was sys_get_kernel_syms */
   274	__SYSCALL(130, sys_ni_syscall)
   275	#define __NR_quotactl 131
   276	__SYSCALL(__NR_quotactl, sys_quotactl)
   277	#define __NR_getpgid 132
   278	__SYSCALL(__NR_getpgid, sys_getpgid)
   279	#define __NR_fchdir 133
   280	__SYSCALL(__NR_fchdir, sys_fchdir)
   281	#define __NR_bdflush 134
   282	__SYSCALL(__NR_bdflush, sys_ni_syscall)
   283	#define __NR_sysfs 135
   284	__SYSCALL(__NR_sysfs, sys_sysfs)
   285	#define __NR_personality 136
   286	__SYSCALL(__NR_personality, sys_personality)
   287				/* 137 was sys_afs_syscall */
   288	__SYSCALL(137, sys_ni_syscall)
   289	#define __NR_setfsuid 138
   290	__SYSCALL(__NR_setfsuid, sys_setfsuid16)
   291	#define __NR_setfsgid 139
   292	__SYSCALL(__NR_setfsgid, sys_setfsgid16)
   293	#define __NR__llseek 140
   294	__SYSCALL(__NR__llseek, sys_llseek)
   295	#define __NR_getdents 141
   296	__SYSCALL(__NR_getdents, compat_sys_getdents)
   297	#define __NR__newselect 142
   298	__SYSCALL(__NR__newselect, compat_sys_select)
   299	#define __NR_flock 143
   300	__SYSCALL(__NR_flock, sys_flock)
   301	#define __NR_msync 144
   302	__SYSCALL(__NR_msync, sys_msync)
   303	#define __NR_readv 145
   304	__SYSCALL(__NR_readv, sys_readv)
   305	#define __NR_writev 146
   306	__SYSCALL(__NR_writev, sys_writev)
   307	#define __NR_getsid 147
   308	__SYSCALL(__NR_getsid, sys_getsid)
   309	#define __NR_fdatasync 148
   310	__SYSCALL(__NR_fdatasync, sys_fdatasync)
   311				/* 149 was sys_sysctl */
   312	__SYSCALL(149, sys_ni_syscall)
   313	#define __NR_mlock 150
   314	__SYSCALL(__NR_mlock, sys_mlock)
   315	#define __NR_munlock 151
   316	__SYSCALL(__NR_munlock, sys_munlock)
   317	#define __NR_mlockall 152
   318	__SYSCALL(__NR_mlockall, sys_mlockall)
   319	#define __NR_munlockall 153
   320	__SYSCALL(__NR_munlockall, sys_munlockall)
   321	#define __NR_sched_setparam 154
   322	__SYSCALL(__NR_sched_setparam, sys_sched_setparam)
   323	#define __NR_sched_getparam 155
   324	__SYSCALL(__NR_sched_getparam, sys_sched_getparam)
   325	#define __NR_sched_setscheduler 156
   326	__SYSCALL(__NR_sched_setscheduler, sys_sched_setscheduler)
   327	#define __NR_sched_getscheduler 157
   328	__SYSCALL(__NR_sched_getscheduler, sys_sched_getscheduler)
   329	#define __NR_sched_yield 158
   330	__SYSCALL(__NR_sched_yield, sys_sched_yield)
   331	#define __NR_sched_get_priority_max 159
   332	__SYSCALL(__NR_sched_get_priority_max, sys_sched_get_priority_max)
   333	#define __NR_sched_get_priority_min 160
   334	__SYSCALL(__NR_sched_get_priority_min, sys_sched_get_priority_min)
   335	#define __NR_sched_rr_get_interval 161
   336	__SYSCALL(__NR_sched_rr_get_interval, sys_sched_rr_get_interval_time32)
   337	#define __NR_nanosleep 162
   338	__SYSCALL(__NR_nanosleep, sys_nanosleep_time32)
   339	#define __NR_mremap 163
   340	__SYSCALL(__NR_mremap, sys_mremap)
   341	#define __NR_setresuid 164
   342	__SYSCALL(__NR_setresuid, sys_setresuid16)
   343	#define __NR_getresuid 165
   344	__SYSCALL(__NR_getresuid, sys_getresuid16)
   345				/* 166 was sys_vm86 */
   346	__SYSCALL(166, sys_ni_syscall)
   347				/* 167 was sys_query_module */
   348	__SYSCALL(167, sys_ni_syscall)
   349	#define __NR_poll 168
   350	__SYSCALL(__NR_poll, sys_poll)
   351	#define __NR_nfsservctl 169
   352	__SYSCALL(__NR_nfsservctl, sys_ni_syscall)
   353	#define __NR_setresgid 170
   354	__SYSCALL(__NR_setresgid, sys_setresgid16)
   355	#define __NR_getresgid 171
   356	__SYSCALL(__NR_getresgid, sys_getresgid16)
   357	#define __NR_prctl 172
   358	__SYSCALL(__NR_prctl, sys_prctl)
   359	#define __NR_rt_sigreturn 173
   360	__SYSCALL(__NR_rt_sigreturn, compat_sys_rt_sigreturn)
   361	#define __NR_rt_sigaction 174
   362	__SYSCALL(__NR_rt_sigaction, compat_sys_rt_sigaction)
   363	#define __NR_rt_sigprocmask 175
   364	__SYSCALL(__NR_rt_sigprocmask, compat_sys_rt_sigprocmask)
   365	#define __NR_rt_sigpending 176
   366	__SYSCALL(__NR_rt_sigpending, compat_sys_rt_sigpending)
   367	#define __NR_rt_sigtimedwait 177
   368	__SYSCALL(__NR_rt_sigtimedwait, compat_sys_rt_sigtimedwait_time32)
   369	#define __NR_rt_sigqueueinfo 178
   370	__SYSCALL(__NR_rt_sigqueueinfo, compat_sys_rt_sigqueueinfo)
   371	#define __NR_rt_sigsuspend 179
   372	__SYSCALL(__NR_rt_sigsuspend, compat_sys_rt_sigsuspend)
   373	#define __NR_pread64 180
   374	__SYSCALL(__NR_pread64, compat_sys_aarch32_pread64)
   375	#define __NR_pwrite64 181
   376	__SYSCALL(__NR_pwrite64, compat_sys_aarch32_pwrite64)
   377	#define __NR_chown 182
   378	__SYSCALL(__NR_chown, sys_chown16)
   379	#define __NR_getcwd 183
   380	__SYSCALL(__NR_getcwd, sys_getcwd)
   381	#define __NR_capget 184
   382	__SYSCALL(__NR_capget, sys_capget)
   383	#define __NR_capset 185
   384	__SYSCALL(__NR_capset, sys_capset)
   385	#define __NR_sigaltstack 186
   386	__SYSCALL(__NR_sigaltstack, compat_sys_sigaltstack)
   387	#define __NR_sendfile 187
   388	__SYSCALL(__NR_sendfile, compat_sys_sendfile)
   389				/* 188 reserved */
   390	__SYSCALL(188, sys_ni_syscall)
   391				/* 189 reserved */
   392	__SYSCALL(189, sys_ni_syscall)
   393	#define __NR_vfork 190
   394	__SYSCALL(__NR_vfork, sys_vfork)
   395	#define __NR_ugetrlimit 191	/* SuS compliant getrlimit */
   396	__SYSCALL(__NR_ugetrlimit, compat_sys_getrlimit)		/* SuS compliant getrlimit */
   397	#define __NR_mmap2 192
   398	__SYSCALL(__NR_mmap2, compat_sys_aarch32_mmap2)
   399	#define __NR_truncate64 193
   400	__SYSCALL(__NR_truncate64, compat_sys_aarch32_truncate64)
   401	#define __NR_ftruncate64 194
   402	__SYSCALL(__NR_ftruncate64, compat_sys_aarch32_ftruncate64)
   403	#define __NR_stat64 195
   404	__SYSCALL(__NR_stat64, sys_stat64)
   405	#define __NR_lstat64 196
   406	__SYSCALL(__NR_lstat64, sys_lstat64)
   407	#define __NR_fstat64 197
   408	__SYSCALL(__NR_fstat64, sys_fstat64)
   409	#define __NR_lchown32 198
   410	__SYSCALL(__NR_lchown32, sys_lchown)
   411	#define __NR_getuid32 199
   412	__SYSCALL(__NR_getuid32, sys_getuid)
   413	#define __NR_getgid32 200
   414	__SYSCALL(__NR_getgid32, sys_getgid)
   415	#define __NR_geteuid32 201
   416	__SYSCALL(__NR_geteuid32, sys_geteuid)
   417	#define __NR_getegid32 202
   418	__SYSCALL(__NR_getegid32, sys_getegid)
   419	#define __NR_setreuid32 203
   420	__SYSCALL(__NR_setreuid32, sys_setreuid)
   421	#define __NR_setregid32 204
   422	__SYSCALL(__NR_setregid32, sys_setregid)
   423	#define __NR_getgroups32 205
   424	__SYSCALL(__NR_getgroups32, sys_getgroups)
   425	#define __NR_setgroups32 206
   426	__SYSCALL(__NR_setgroups32, sys_setgroups)
   427	#define __NR_fchown32 207
   428	__SYSCALL(__NR_fchown32, sys_fchown)
   429	#define __NR_setresuid32 208
   430	__SYSCALL(__NR_setresuid32, sys_setresuid)
   431	#define __NR_getresuid32 209
   432	__SYSCALL(__NR_getresuid32, sys_getresuid)
   433	#define __NR_setresgid32 210
   434	__SYSCALL(__NR_setresgid32, sys_setresgid)
   435	#define __NR_getresgid32 211
   436	__SYSCALL(__NR_getresgid32, sys_getresgid)
   437	#define __NR_chown32 212
   438	__SYSCALL(__NR_chown32, sys_chown)
   439	#define __NR_setuid32 213
   440	__SYSCALL(__NR_setuid32, sys_setuid)
   441	#define __NR_setgid32 214
   442	__SYSCALL(__NR_setgid32, sys_setgid)
   443	#define __NR_setfsuid32 215
   444	__SYSCALL(__NR_setfsuid32, sys_setfsuid)
   445	#define __NR_setfsgid32 216
   446	__SYSCALL(__NR_setfsgid32, sys_setfsgid)
   447	#define __NR_getdents64 217
   448	__SYSCALL(__NR_getdents64, sys_getdents64)
   449	#define __NR_pivot_root 218
   450	__SYSCALL(__NR_pivot_root, sys_pivot_root)
   451	#define __NR_mincore 219
   452	__SYSCALL(__NR_mincore, sys_mincore)
   453	#define __NR_madvise 220
   454	__SYSCALL(__NR_madvise, sys_madvise)
   455	#define __NR_fcntl64 221
   456	__SYSCALL(__NR_fcntl64, compat_sys_fcntl64)
   457				/* 222 for tux */
   458	__SYSCALL(222, sys_ni_syscall)
   459				/* 223 is unused */
   460	__SYSCALL(223, sys_ni_syscall)
   461	#define __NR_gettid 224
   462	__SYSCALL(__NR_gettid, sys_gettid)
   463	#define __NR_readahead 225
   464	__SYSCALL(__NR_readahead, compat_sys_aarch32_readahead)
   465	#define __NR_setxattr 226
   466	__SYSCALL(__NR_setxattr, sys_setxattr)
   467	#define __NR_lsetxattr 227
   468	__SYSCALL(__NR_lsetxattr, sys_lsetxattr)
   469	#define __NR_fsetxattr 228
   470	__SYSCALL(__NR_fsetxattr, sys_fsetxattr)
   471	#define __NR_getxattr 229
   472	__SYSCALL(__NR_getxattr, sys_getxattr)
   473	#define __NR_lgetxattr 230
   474	__SYSCALL(__NR_lgetxattr, sys_lgetxattr)
   475	#define __NR_fgetxattr 231
   476	__SYSCALL(__NR_fgetxattr, sys_fgetxattr)
   477	#define __NR_listxattr 232
   478	__SYSCALL(__NR_listxattr, sys_listxattr)
   479	#define __NR_llistxattr 233
   480	__SYSCALL(__NR_llistxattr, sys_llistxattr)
   481	#define __NR_flistxattr 234
   482	__SYSCALL(__NR_flistxattr, sys_flistxattr)
   483	#define __NR_removexattr 235
   484	__SYSCALL(__NR_removexattr, sys_removexattr)
   485	#define __NR_lremovexattr 236
   486	__SYSCALL(__NR_lremovexattr, sys_lremovexattr)
   487	#define __NR_fremovexattr 237
   488	__SYSCALL(__NR_fremovexattr, sys_fremovexattr)
   489	#define __NR_tkill 238
   490	__SYSCALL(__NR_tkill, sys_tkill)
   491	#define __NR_sendfile64 239
   492	__SYSCALL(__NR_sendfile64, sys_sendfile64)
   493	#define __NR_futex 240
   494	__SYSCALL(__NR_futex, sys_futex_time32)
   495	#define __NR_sched_setaffinity 241
   496	__SYSCALL(__NR_sched_setaffinity, compat_sys_sched_setaffinity)
   497	#define __NR_sched_getaffinity 242
   498	__SYSCALL(__NR_sched_getaffinity, compat_sys_sched_getaffinity)
   499	#define __NR_io_setup 243
   500	__SYSCALL(__NR_io_setup, compat_sys_io_setup)
   501	#define __NR_io_destroy 244
   502	__SYSCALL(__NR_io_destroy, sys_io_destroy)
   503	#define __NR_io_getevents 245
   504	__SYSCALL(__NR_io_getevents, sys_io_getevents_time32)
   505	#define __NR_io_submit 246
   506	__SYSCALL(__NR_io_submit, compat_sys_io_submit)
   507	#define __NR_io_cancel 247
   508	__SYSCALL(__NR_io_cancel, sys_io_cancel)
   509	#define __NR_exit_group 248
   510	__SYSCALL(__NR_exit_group, sys_exit_group)
   511	#define __NR_lookup_dcookie 249
   512	__SYSCALL(__NR_lookup_dcookie, compat_sys_lookup_dcookie)
   513	#define __NR_epoll_create 250
   514	__SYSCALL(__NR_epoll_create, sys_epoll_create)
   515	#define __NR_epoll_ctl 251
   516	__SYSCALL(__NR_epoll_ctl, sys_epoll_ctl)
   517	#define __NR_epoll_wait 252
   518	__SYSCALL(__NR_epoll_wait, sys_epoll_wait)
   519	#define __NR_remap_file_pages 253
   520	__SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
   521				/* 254 for set_thread_area */
   522	__SYSCALL(254, sys_ni_syscall)
   523				/* 255 for get_thread_area */
   524	__SYSCALL(255, sys_ni_syscall)
   525	#define __NR_set_tid_address 256
   526	__SYSCALL(__NR_set_tid_address, sys_set_tid_address)
   527	#define __NR_timer_create 257
   528	__SYSCALL(__NR_timer_create, compat_sys_timer_create)
   529	#define __NR_timer_settime 258
   530	__SYSCALL(__NR_timer_settime, sys_timer_settime32)
   531	#define __NR_timer_gettime 259
   532	__SYSCALL(__NR_timer_gettime, sys_timer_gettime32)
   533	#define __NR_timer_getoverrun 260
   534	__SYSCALL(__NR_timer_getoverrun, sys_timer_getoverrun)
   535	#define __NR_timer_delete 261
   536	__SYSCALL(__NR_timer_delete, sys_timer_delete)
   537	#define __NR_clock_settime 262
   538	__SYSCALL(__NR_clock_settime, sys_clock_settime32)
   539	#define __NR_clock_gettime 263
   540	__SYSCALL(__NR_clock_gettime, sys_clock_gettime32)
   541	#define __NR_clock_getres 264
   542	__SYSCALL(__NR_clock_getres, sys_clock_getres_time32)
   543	#define __NR_clock_nanosleep 265
   544	__SYSCALL(__NR_clock_nanosleep, sys_clock_nanosleep_time32)
   545	#define __NR_statfs64 266
   546	__SYSCALL(__NR_statfs64, compat_sys_aarch32_statfs64)
   547	#define __NR_fstatfs64 267
   548	__SYSCALL(__NR_fstatfs64, compat_sys_aarch32_fstatfs64)
   549	#define __NR_tgkill 268
   550	__SYSCALL(__NR_tgkill, sys_tgkill)
   551	#define __NR_utimes 269
   552	__SYSCALL(__NR_utimes, sys_utimes_time32)
   553	#define __NR_arm_fadvise64_64 270
   554	__SYSCALL(__NR_arm_fadvise64_64, compat_sys_aarch32_fadvise64_64)
   555	#define __NR_pciconfig_iobase 271
   556	__SYSCALL(__NR_pciconfig_iobase, sys_pciconfig_iobase)
   557	#define __NR_pciconfig_read 272
   558	__SYSCALL(__NR_pciconfig_read, sys_pciconfig_read)
   559	#define __NR_pciconfig_write 273
   560	__SYSCALL(__NR_pciconfig_write, sys_pciconfig_write)
   561	#define __NR_mq_open 274
   562	__SYSCALL(__NR_mq_open, compat_sys_mq_open)
   563	#define __NR_mq_unlink 275
   564	__SYSCALL(__NR_mq_unlink, sys_mq_unlink)
   565	#define __NR_mq_timedsend 276
   566	__SYSCALL(__NR_mq_timedsend, sys_mq_timedsend_time32)
   567	#define __NR_mq_timedreceive 277
   568	__SYSCALL(__NR_mq_timedreceive, sys_mq_timedreceive_time32)
   569	#define __NR_mq_notify 278
   570	__SYSCALL(__NR_mq_notify, compat_sys_mq_notify)
   571	#define __NR_mq_getsetattr 279
   572	__SYSCALL(__NR_mq_getsetattr, compat_sys_mq_getsetattr)
   573	#define __NR_waitid 280
   574	__SYSCALL(__NR_waitid, compat_sys_waitid)
   575	#define __NR_socket 281
   576	__SYSCALL(__NR_socket, sys_socket)
   577	#define __NR_bind 282
   578	__SYSCALL(__NR_bind, sys_bind)
   579	#define __NR_connect 283
   580	__SYSCALL(__NR_connect, sys_connect)
   581	#define __NR_listen 284
   582	__SYSCALL(__NR_listen, sys_listen)
   583	#define __NR_accept 285
   584	__SYSCALL(__NR_accept, sys_accept)
   585	#define __NR_getsockname 286
   586	__SYSCALL(__NR_getsockname, sys_getsockname)
   587	#define __NR_getpeername 287
   588	__SYSCALL(__NR_getpeername, sys_getpeername)
   589	#define __NR_socketpair 288
   590	__SYSCALL(__NR_socketpair, sys_socketpair)
   591	#define __NR_send 289
   592	__SYSCALL(__NR_send, sys_send)
   593	#define __NR_sendto 290
   594	__SYSCALL(__NR_sendto, sys_sendto)
   595	#define __NR_recv 291
   596	__SYSCALL(__NR_recv, compat_sys_recv)
   597	#define __NR_recvfrom 292
   598	__SYSCALL(__NR_recvfrom, compat_sys_recvfrom)
   599	#define __NR_shutdown 293
   600	__SYSCALL(__NR_shutdown, sys_shutdown)
   601	#define __NR_setsockopt 294
   602	__SYSCALL(__NR_setsockopt, sys_setsockopt)
   603	#define __NR_getsockopt 295
   604	__SYSCALL(__NR_getsockopt, sys_getsockopt)
   605	#define __NR_sendmsg 296
   606	__SYSCALL(__NR_sendmsg, compat_sys_sendmsg)
   607	#define __NR_recvmsg 297
   608	__SYSCALL(__NR_recvmsg, compat_sys_recvmsg)
   609	#define __NR_semop 298
   610	__SYSCALL(__NR_semop, sys_semop)
   611	#define __NR_semget 299
   612	__SYSCALL(__NR_semget, sys_semget)
   613	#define __NR_semctl 300
   614	__SYSCALL(__NR_semctl, compat_sys_old_semctl)
   615	#define __NR_msgsnd 301
   616	__SYSCALL(__NR_msgsnd, compat_sys_msgsnd)
   617	#define __NR_msgrcv 302
   618	__SYSCALL(__NR_msgrcv, compat_sys_msgrcv)
   619	#define __NR_msgget 303
   620	__SYSCALL(__NR_msgget, sys_msgget)
   621	#define __NR_msgctl 304
   622	__SYSCALL(__NR_msgctl, compat_sys_old_msgctl)
   623	#define __NR_shmat 305
   624	__SYSCALL(__NR_shmat, compat_sys_shmat)
   625	#define __NR_shmdt 306
   626	__SYSCALL(__NR_shmdt, sys_shmdt)
   627	#define __NR_shmget 307
   628	__SYSCALL(__NR_shmget, sys_shmget)
   629	#define __NR_shmctl 308
   630	__SYSCALL(__NR_shmctl, compat_sys_old_shmctl)
   631	#define __NR_add_key 309
   632	__SYSCALL(__NR_add_key, sys_add_key)
   633	#define __NR_request_key 310
   634	__SYSCALL(__NR_request_key, sys_request_key)
   635	#define __NR_keyctl 311
   636	__SYSCALL(__NR_keyctl, compat_sys_keyctl)
   637	#define __NR_semtimedop 312
   638	__SYSCALL(__NR_semtimedop, sys_semtimedop_time32)
   639	#define __NR_vserver 313
   640	__SYSCALL(__NR_vserver, sys_ni_syscall)
   641	#define __NR_ioprio_set 314
   642	__SYSCALL(__NR_ioprio_set, sys_ioprio_set)
   643	#define __NR_ioprio_get 315
   644	__SYSCALL(__NR_ioprio_get, sys_ioprio_get)
   645	#define __NR_inotify_init 316
   646	__SYSCALL(__NR_inotify_init, sys_inotify_init)
   647	#define __NR_inotify_add_watch 317
   648	__SYSCALL(__NR_inotify_add_watch, sys_inotify_add_watch)
   649	#define __NR_inotify_rm_watch 318
   650	__SYSCALL(__NR_inotify_rm_watch, sys_inotify_rm_watch)
   651	#define __NR_mbind 319
   652	__SYSCALL(__NR_mbind, sys_mbind)
   653	#define __NR_get_mempolicy 320
   654	__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
   655	#define __NR_set_mempolicy 321
   656	__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
   657	#define __NR_openat 322
   658	__SYSCALL(__NR_openat, compat_sys_openat)
   659	#define __NR_mkdirat 323
   660	__SYSCALL(__NR_mkdirat, sys_mkdirat)
   661	#define __NR_mknodat 324
   662	__SYSCALL(__NR_mknodat, sys_mknodat)
   663	#define __NR_fchownat 325
   664	__SYSCALL(__NR_fchownat, sys_fchownat)
   665	#define __NR_futimesat 326
   666	__SYSCALL(__NR_futimesat, sys_futimesat_time32)
   667	#define __NR_fstatat64 327
   668	__SYSCALL(__NR_fstatat64, sys_fstatat64)
   669	#define __NR_unlinkat 328
   670	__SYSCALL(__NR_unlinkat, sys_unlinkat)
   671	#define __NR_renameat 329
   672	__SYSCALL(__NR_renameat, sys_renameat)
   673	#define __NR_linkat 330
   674	__SYSCALL(__NR_linkat, sys_linkat)
   675	#define __NR_symlinkat 331
   676	__SYSCALL(__NR_symlinkat, sys_symlinkat)
   677	#define __NR_readlinkat 332
   678	__SYSCALL(__NR_readlinkat, sys_readlinkat)
   679	#define __NR_fchmodat 333
   680	__SYSCALL(__NR_fchmodat, sys_fchmodat)
   681	#define __NR_faccessat 334
   682	__SYSCALL(__NR_faccessat, sys_faccessat)
   683	#define __NR_pselect6 335
   684	__SYSCALL(__NR_pselect6, compat_sys_pselect6_time32)
   685	#define __NR_ppoll 336
   686	__SYSCALL(__NR_ppoll, compat_sys_ppoll_time32)
   687	#define __NR_unshare 337
   688	__SYSCALL(__NR_unshare, sys_unshare)
   689	#define __NR_set_robust_list 338
   690	__SYSCALL(__NR_set_robust_list, compat_sys_set_robust_list)
   691	#define __NR_get_robust_list 339
   692	__SYSCALL(__NR_get_robust_list, compat_sys_get_robust_list)
   693	#define __NR_splice 340
   694	__SYSCALL(__NR_splice, sys_splice)
   695	#define __NR_sync_file_range2 341
   696	__SYSCALL(__NR_sync_file_range2, compat_sys_aarch32_sync_file_range2)
   697	#define __NR_tee 342
   698	__SYSCALL(__NR_tee, sys_tee)
   699	#define __NR_vmsplice 343
   700	__SYSCALL(__NR_vmsplice, sys_vmsplice)
   701	#define __NR_move_pages 344
   702	__SYSCALL(__NR_move_pages, sys_move_pages)
   703	#define __NR_getcpu 345
   704	__SYSCALL(__NR_getcpu, sys_getcpu)
   705	#define __NR_epoll_pwait 346
   706	__SYSCALL(__NR_epoll_pwait, compat_sys_epoll_pwait)
   707	#define __NR_kexec_load 347
   708	__SYSCALL(__NR_kexec_load, compat_sys_kexec_load)
   709	#define __NR_utimensat 348
   710	__SYSCALL(__NR_utimensat, sys_utimensat_time32)
   711	#define __NR_signalfd 349
   712	__SYSCALL(__NR_signalfd, compat_sys_signalfd)
   713	#define __NR_timerfd_create 350
   714	__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
   715	#define __NR_eventfd 351
   716	__SYSCALL(__NR_eventfd, sys_eventfd)
   717	#define __NR_fallocate 352
   718	__SYSCALL(__NR_fallocate, compat_sys_aarch32_fallocate)
   719	#define __NR_timerfd_settime 353
   720	__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime32)
   721	#define __NR_timerfd_gettime 354
   722	__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime32)
   723	#define __NR_signalfd4 355
   724	__SYSCALL(__NR_signalfd4, compat_sys_signalfd4)
   725	#define __NR_eventfd2 356
   726	__SYSCALL(__NR_eventfd2, sys_eventfd2)
   727	#define __NR_epoll_create1 357
   728	__SYSCALL(__NR_epoll_create1, sys_epoll_create1)
   729	#define __NR_dup3 358
   730	__SYSCALL(__NR_dup3, sys_dup3)
   731	#define __NR_pipe2 359
   732	__SYSCALL(__NR_pipe2, sys_pipe2)
   733	#define __NR_inotify_init1 360
   734	__SYSCALL(__NR_inotify_init1, sys_inotify_init1)
   735	#define __NR_preadv 361
   736	__SYSCALL(__NR_preadv, compat_sys_preadv)
   737	#define __NR_pwritev 362
   738	__SYSCALL(__NR_pwritev, compat_sys_pwritev)
   739	#define __NR_rt_tgsigqueueinfo 363
   740	__SYSCALL(__NR_rt_tgsigqueueinfo, compat_sys_rt_tgsigqueueinfo)
   741	#define __NR_perf_event_open 364
   742	__SYSCALL(__NR_perf_event_open, sys_perf_event_open)
   743	#define __NR_recvmmsg 365
   744	__SYSCALL(__NR_recvmmsg, compat_sys_recvmmsg_time32)
   745	#define __NR_accept4 366
   746	__SYSCALL(__NR_accept4, sys_accept4)
   747	#define __NR_fanotify_init 367
   748	__SYSCALL(__NR_fanotify_init, sys_fanotify_init)
   749	#define __NR_fanotify_mark 368
   750	__SYSCALL(__NR_fanotify_mark, compat_sys_fanotify_mark)
   751	#define __NR_prlimit64 369
   752	__SYSCALL(__NR_prlimit64, sys_prlimit64)
   753	#define __NR_name_to_handle_at 370
   754	__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
   755	#define __NR_open_by_handle_at 371
   756	__SYSCALL(__NR_open_by_handle_at, compat_sys_open_by_handle_at)
   757	#define __NR_clock_adjtime 372
   758	__SYSCALL(__NR_clock_adjtime, sys_clock_adjtime32)
   759	#define __NR_syncfs 373
   760	__SYSCALL(__NR_syncfs, sys_syncfs)
   761	#define __NR_sendmmsg 374
   762	__SYSCALL(__NR_sendmmsg, compat_sys_sendmmsg)
   763	#define __NR_setns 375
   764	__SYSCALL(__NR_setns, sys_setns)
   765	#define __NR_process_vm_readv 376
   766	__SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
   767	#define __NR_process_vm_writev 377
   768	__SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
   769	#define __NR_kcmp 378
   770	__SYSCALL(__NR_kcmp, sys_kcmp)
   771	#define __NR_finit_module 379
   772	__SYSCALL(__NR_finit_module, sys_finit_module)
   773	#define __NR_sched_setattr 380
   774	__SYSCALL(__NR_sched_setattr, sys_sched_setattr)
   775	#define __NR_sched_getattr 381
   776	__SYSCALL(__NR_sched_getattr, sys_sched_getattr)
   777	#define __NR_renameat2 382
   778	__SYSCALL(__NR_renameat2, sys_renameat2)
   779	#define __NR_seccomp 383
   780	__SYSCALL(__NR_seccomp, sys_seccomp)
   781	#define __NR_getrandom 384
   782	__SYSCALL(__NR_getrandom, sys_getrandom)
   783	#define __NR_memfd_create 385
   784	__SYSCALL(__NR_memfd_create, sys_memfd_create)
   785	#define __NR_bpf 386
   786	__SYSCALL(__NR_bpf, sys_bpf)
   787	#define __NR_execveat 387
   788	__SYSCALL(__NR_execveat, compat_sys_execveat)
   789	#define __NR_userfaultfd 388
   790	__SYSCALL(__NR_userfaultfd, sys_userfaultfd)
   791	#define __NR_membarrier 389
   792	__SYSCALL(__NR_membarrier, sys_membarrier)
   793	#define __NR_mlock2 390
   794	__SYSCALL(__NR_mlock2, sys_mlock2)
   795	#define __NR_copy_file_range 391
   796	__SYSCALL(__NR_copy_file_range, sys_copy_file_range)
   797	#define __NR_preadv2 392
   798	__SYSCALL(__NR_preadv2, compat_sys_preadv2)
   799	#define __NR_pwritev2 393
   800	__SYSCALL(__NR_pwritev2, compat_sys_pwritev2)
   801	#define __NR_pkey_mprotect 394
   802	__SYSCALL(__NR_pkey_mprotect, sys_pkey_mprotect)
   803	#define __NR_pkey_alloc 395
   804	__SYSCALL(__NR_pkey_alloc, sys_pkey_alloc)
   805	#define __NR_pkey_free 396
   806	__SYSCALL(__NR_pkey_free, sys_pkey_free)
   807	#define __NR_statx 397
   808	__SYSCALL(__NR_statx, sys_statx)
   809	#define __NR_rseq 398
   810	__SYSCALL(__NR_rseq, sys_rseq)
   811	#define __NR_io_pgetevents 399
   812	__SYSCALL(__NR_io_pgetevents, compat_sys_io_pgetevents)
   813	#define __NR_migrate_pages 400
   814	__SYSCALL(__NR_migrate_pages, sys_migrate_pages)
   815	#define __NR_kexec_file_load 401
   816	__SYSCALL(__NR_kexec_file_load, sys_kexec_file_load)
   817	/* 402 is unused */
   818	#define __NR_clock_gettime64 403
   819	__SYSCALL(__NR_clock_gettime64, sys_clock_gettime)
   820	#define __NR_clock_settime64 404
   821	__SYSCALL(__NR_clock_settime64, sys_clock_settime)
   822	#define __NR_clock_adjtime64 405
   823	__SYSCALL(__NR_clock_adjtime64, sys_clock_adjtime)
   824	#define __NR_clock_getres_time64 406
   825	__SYSCALL(__NR_clock_getres_time64, sys_clock_getres)
   826	#define __NR_clock_nanosleep_time64 407
   827	__SYSCALL(__NR_clock_nanosleep_time64, sys_clock_nanosleep)
   828	#define __NR_timer_gettime64 408
   829	__SYSCALL(__NR_timer_gettime64, sys_timer_gettime)
   830	#define __NR_timer_settime64 409
   831	__SYSCALL(__NR_timer_settime64, sys_timer_settime)
   832	#define __NR_timerfd_gettime64 410
   833	__SYSCALL(__NR_timerfd_gettime64, sys_timerfd_gettime)
   834	#define __NR_timerfd_settime64 411
   835	__SYSCALL(__NR_timerfd_settime64, sys_timerfd_settime)
   836	#define __NR_utimensat_time64 412
   837	__SYSCALL(__NR_utimensat_time64, sys_utimensat)
   838	#define __NR_pselect6_time64 413
   839	__SYSCALL(__NR_pselect6_time64, compat_sys_pselect6_time64)
   840	#define __NR_ppoll_time64 414
   841	__SYSCALL(__NR_ppoll_time64, compat_sys_ppoll_time64)
   842	#define __NR_io_pgetevents_time64 416
   843	__SYSCALL(__NR_io_pgetevents_time64, sys_io_pgetevents)
   844	#define __NR_recvmmsg_time64 417
   845	__SYSCALL(__NR_recvmmsg_time64, compat_sys_recvmmsg_time64)
   846	#define __NR_mq_timedsend_time64 418
   847	__SYSCALL(__NR_mq_timedsend_time64, sys_mq_timedsend)
   848	#define __NR_mq_timedreceive_time64 419
   849	__SYSCALL(__NR_mq_timedreceive_time64, sys_mq_timedreceive)
   850	#define __NR_semtimedop_time64 420
   851	__SYSCALL(__NR_semtimedop_time64, sys_semtimedop)
   852	#define __NR_rt_sigtimedwait_time64 421
   853	__SYSCALL(__NR_rt_sigtimedwait_time64, compat_sys_rt_sigtimedwait_time64)
   854	#define __NR_futex_time64 422
   855	__SYSCALL(__NR_futex_time64, sys_futex)
   856	#define __NR_sched_rr_get_interval_time64 423
   857	__SYSCALL(__NR_sched_rr_get_interval_time64, sys_sched_rr_get_interval)
   858	#define __NR_pidfd_send_signal 424
   859	__SYSCALL(__NR_pidfd_send_signal, sys_pidfd_send_signal)
   860	#define __NR_io_uring_setup 425
   861	__SYSCALL(__NR_io_uring_setup, sys_io_uring_setup)
   862	#define __NR_io_uring_enter 426
   863	__SYSCALL(__NR_io_uring_enter, sys_io_uring_enter)
   864	#define __NR_io_uring_register 427
   865	__SYSCALL(__NR_io_uring_register, sys_io_uring_register)
   866	#define __NR_open_tree 428
   867	__SYSCALL(__NR_open_tree, sys_open_tree)
   868	#define __NR_move_mount 429
   869	__SYSCALL(__NR_move_mount, sys_move_mount)
   870	#define __NR_fsopen 430
   871	__SYSCALL(__NR_fsopen, sys_fsopen)
   872	#define __NR_fsconfig 431
   873	__SYSCALL(__NR_fsconfig, sys_fsconfig)
   874	#define __NR_fsmount 432
   875	__SYSCALL(__NR_fsmount, sys_fsmount)
   876	#define __NR_fspick 433
   877	__SYSCALL(__NR_fspick, sys_fspick)
   878	#define __NR_pidfd_open 434
   879	__SYSCALL(__NR_pidfd_open, sys_pidfd_open)
   880	#define __NR_clone3 435
   881	__SYSCALL(__NR_clone3, sys_clone3)
   882	#define __NR_close_range 436
   883	__SYSCALL(__NR_close_range, sys_close_range)
   884	#define __NR_openat2 437
   885	__SYSCALL(__NR_openat2, sys_openat2)
   886	#define __NR_pidfd_getfd 438
   887	__SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
   888	#define __NR_faccessat2 439
   889	__SYSCALL(__NR_faccessat2, sys_faccessat2)
   890	#define __NR_process_madvise 440
   891	__SYSCALL(__NR_process_madvise, sys_process_madvise)
   892	#define __NR_epoll_pwait2 441
   893	__SYSCALL(__NR_epoll_pwait2, compat_sys_epoll_pwait2)
   894	#define __NR_mount_setattr 442
   895	__SYSCALL(__NR_mount_setattr, sys_mount_setattr)
   896	#define __NR_quotactl_fd 443
   897	__SYSCALL(__NR_quotactl_fd, sys_quotactl_fd)
   898	#define __NR_landlock_create_ruleset 444
   899	__SYSCALL(__NR_landlock_create_ruleset, sys_landlock_create_ruleset)
   900	#define __NR_landlock_add_rule 445
   901	__SYSCALL(__NR_landlock_add_rule, sys_landlock_add_rule)
   902	#define __NR_landlock_restrict_self 446
   903	__SYSCALL(__NR_landlock_restrict_self, sys_landlock_restrict_self)
   904	#define __NR_process_mrelease 448
   905	__SYSCALL(__NR_process_mrelease, sys_process_mrelease)
   906	#define __NR_futex_waitv 449
   907	__SYSCALL(__NR_futex_waitv, sys_futex_waitv)
   908	#define __NR_set_mempolicy_home_node 450
   909	__SYSCALL(__NR_set_mempolicy_home_node, sys_set_mempolicy_home_node)
   910	#define __NR_cachestat 451
   911	__SYSCALL(__NR_cachestat, sys_cachestat)
   912	#define __NR_fchmodat2 452
   913	__SYSCALL(__NR_fchmodat2, sys_fchmodat2)
 > 914	#define __NR_statmount 454
   915	__SYSCALL(__NR_statmount, sys_statmount)
   916	#define __NR_listmount 455
   917	__SYSCALL(__NR_listmount, sys_listmount)
   918	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
