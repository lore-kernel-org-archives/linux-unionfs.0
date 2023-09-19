Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877F0CD5BCD
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Sep 2023 14:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjISO4d (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Sep 2023 10:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbjISO42 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Sep 2023 10:56:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3974ED
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Sep 2023 07:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695135382; x=1726671382;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=LHrlqSonm9QimiEHisXj0ptWKJJKWXogrkTeKut83LM=;
  b=YaO9bxp77r0NGTLy1zpvHWRP+8aqBSEa6YV+P8DRr6JuOE7SdWszBi7s
   Bvi4odDF/o/Fa09JRb+lKpKmvgErRVFadBfphqz71Tjbobe9AfEG3NGqo
   LRG6asJctBI5vQT8hrfhpKrxkn1ppCfzs3T8rLuSd0Ge696SOU6Za9onQ
   fHFoIiKrS8XCTa1DVnfP7S8S/ywyU9HosRBzj0GORQyA5ViXwmoTibMS5
   eewFxRRN6gReHZQ0GlZNutB6kPVUk/KrDL/Herfe8aV4ZgFMzLsSFlw5h
   bfyH13ButJGSKTB/n/9hDB9trXUHOzEop8MmhFAOI45IzEG2tDd7r84DG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="377274445"
X-IronPort-AV: E=Sophos;i="6.02,159,1688454000"; 
   d="scan'208";a="377274445"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 07:56:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="781328849"
X-IronPort-AV: E=Sophos;i="6.02,159,1688454000"; 
   d="scan'208";a="781328849"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 19 Sep 2023 07:56:20 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qic9C-0007US-0c;
        Tue, 19 Sep 2023 14:56:18 +0000
Date:   Tue, 19 Sep 2023 22:55:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount 2/3] namespace.c:undefined reference to
 `show_path'
Message-ID: <202309192237.5R2xaVOm-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount
head:   519d04c265dadbaf8c742e3af3141b7caf673412
commit: 6ece52ce99c69f998a436fbd735a0dafe1391eeb [2/3] add statmount(2) syscall
config: i386-tinyconfig (https://download.01.org/0day-ci/archive/20230919/202309192237.5R2xaVOm-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230919/202309192237.5R2xaVOm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309192237.5R2xaVOm-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: fs/namespace.o: in function `stmt_mnt_root':
>> namespace.c:(.text+0x7db): undefined reference to `show_path'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
