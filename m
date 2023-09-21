Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA88E7D0A5
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 18:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjIUSMf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 14:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjIUSME (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 14:12:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DAB84F08
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 10:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318653; x=1726854653;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=dxEYuqSML8f9hESZ1gjHaHq8kJixT+6+9MSCfHoUjV8=;
  b=NoCeF/zwCxmHQ3USr6CLWWC4HbAsBH5JYBObyMnO4oFhD7h4xRiIMWzY
   v2+2vc97r9BVs0+ZEyBzGdnQbRpuKEMe9kaaEEmZBPAXjAcJCfDR1oWjW
   0kqMCCJGxm1y5Dvl8MTrehnI0qx1Mab8VDlw2tFcTt1bMV1xIunpESyV6
   7Exx2M8ryDx5lb4niACVGhdJnFC4h1bUOIC1MZKU6+bx36OVGNFrERWiw
   P4LGBzw3aLzNIQur+TVoaPiYXIuS37WtBKSGU8u9nPRo1eqgYMY9EN0VX
   W1LReRxkE2VTUkWmIKTKB+xAZHdgm9ILr/Kx+xn04BkbjZT5KnZuHaEEM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="379315972"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="379315972"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 23:33:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="1077781932"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="1077781932"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 20 Sep 2023 23:33:10 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qjDFL-0009ei-0v;
        Thu, 21 Sep 2023 06:33:07 +0000
Date:   Thu, 21 Sep 2023 14:33:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount-v2 2/3] fs/namespace.c:4869: undefined
 reference to `show_path'
Message-ID: <202309211427.pt52GuFm-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount-v2
head:   9b5ff63d2b9b94298e6c9fbac4df9e77e6901fc9
commit: 43d6746354fa23a231946542c476e14f483c44c5 [2/3] add statmount(2) syscall
config: i386-buildonly-randconfig-001-20230921 (https://download.01.org/0day-ci/archive/20230921/202309211427.pt52GuFm-lkp@intel.com/config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230921/202309211427.pt52GuFm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309211427.pt52GuFm-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: fs/namespace.o: in function `stmt_mnt_root':
>> fs/namespace.c:4869: undefined reference to `show_path'


vim +4869 fs/namespace.c

  4865	
  4866	static int stmt_mnt_root(struct stmt_state *s)
  4867	{
  4868		struct seq_file *seq = &s->seq;
> 4869		int err = show_path(seq, s->mnt->mnt_root);
  4870	
  4871		if (!err && !seq_has_overflowed(seq)) {
  4872			seq->buf[seq->count] = '\0';
  4873			seq->count = string_unescape_inplace(seq->buf, UNESCAPE_OCTAL);
  4874		}
  4875		return err;
  4876	}
  4877	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
