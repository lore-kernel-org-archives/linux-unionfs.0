Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498EDCE79A8
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Sep 2023 01:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjITBfe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Sep 2023 21:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjITBfd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Sep 2023 21:35:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FE3B3
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Sep 2023 18:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695173728; x=1726709728;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=0C4/0fmCEM7h8hq0XYCI9JfdTUtmHSzEs4ctDSBT/OQ=;
  b=LQcfKJtSohqwI0YIACAb3iqb9IIX5m+4RFV/3NJubjA7p9bz4B2ijzRk
   fcERTp7c9uAyFWV4/d1zwavyOlMcjkLKp+5bzWuKHTyu3k6pSk/tpk1g0
   CQbmyUS75IPIWNNxXmBZC6siDd/HcI2+cR9FPIU4CANNZa1FbDWWS9gLl
   cripLFIFVvSyWpKxNi5CwTaQr9Nns5/67+wfu5wFjHK41ddzvE3S/hplw
   N1M6vSnRsfNbDIF5XWOOnyVgZ6fq+Irn1lDhF+A0HFtJF0bJ0Ovxr+2eu
   xGFVjfk5hX6b271hHIpyoWFu8Ctkfpi5qdUU+kVZ5nqjIRi5ChciAb6Jl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="377410166"
X-IronPort-AV: E=Sophos;i="6.02,160,1688454000"; 
   d="scan'208";a="377410166"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 18:35:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="861768503"
X-IronPort-AV: E=Sophos;i="6.02,160,1688454000"; 
   d="scan'208";a="861768503"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 19 Sep 2023 18:35:26 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qim7g-00089M-2o;
        Wed, 20 Sep 2023 01:35:24 +0000
Date:   Wed, 20 Sep 2023 09:34:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-unionfs@vger.kernel.org
Subject: [mszeredi-vfs:statmount 2/3] fs/namespace.c:4868:undefined reference
 to `show_path'
Message-ID: <202309200921.zzKu32lP-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git statmount
head:   519d04c265dadbaf8c742e3af3141b7caf673412
commit: 6ece52ce99c69f998a436fbd735a0dafe1391eeb [2/3] add statmount(2) syscall
config: powerpc-randconfig-001-20230920 (https://download.01.org/0day-ci/archive/20230920/202309200921.zzKu32lP-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230920/202309200921.zzKu32lP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309200921.zzKu32lP-lkp@intel.com/

All errors (new ones prefixed by >>):

   powerpc-linux-ld: fs/namespace.o: in function `stmt_mnt_root':
>> fs/namespace.c:4868:(.text+0x1ae4): undefined reference to `show_path'


vim +4868 fs/namespace.c

  4864	
  4865	static int stmt_mnt_root(struct stmt_state *s)
  4866	{
  4867		struct seq_file *seq = &s->seq;
> 4868		int err = show_path(seq, s->mnt->mnt_root);
  4869	
  4870		if (!err && !seq_has_overflowed(seq)) {
  4871			seq->buf[seq->count] = '\0';
  4872			seq->count = string_unescape_inplace(seq->buf, UNESCAPE_OCTAL);
  4873		}
  4874		return err;
  4875	}
  4876	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
