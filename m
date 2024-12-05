Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE571C174E
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Dec 2024 21:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733433723; cv=none; b=YEE30+F6Yag1KxZlskpb/ztp1C4u2Y6yPhqroGqEMaptJK70meKW/F9mX78qQC5Ue/XVwni554n2Gz7MaLK2x3oEvIzd8elCLKcudXfAlkw5cZs1bLuxEtjW4GTm8ClwhRjWxuJt5Hbmu1COWAaDjk7I6ThvOV1xH2YFHk266V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733433723; c=relaxed/simple;
	bh=eRFAA9DWFWIxgZd9+GOp4EoScSXfnoxSy5F0bScB5iQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6kiFujlDiMGhsi88hN7AQdd+pdy1axE4r6UsEkdzQ5ogrQKQiUrA878X8OBB33r771AHcI7cihEcc4fj7TMsBLBDqILfZQO7/41cpLIbvbijdVEHb+CzhN5y4Vas5QYZZijAH6T+RoKlYaS2aXKQoyebAuJ4VypucDe5iCjvvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eu8JjF+z; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eu8JjF+z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733433722; x=1764969722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eRFAA9DWFWIxgZd9+GOp4EoScSXfnoxSy5F0bScB5iQ=;
  b=eu8JjF+zwEScq2c/wB9ythPokVkdJQNL+3qyykxfIuEAu4Jh1TZJU72o
   LDIIEdbfJ5LGDTaWDBLVtH5zjyF18CXIEZtClu2+8Xt+LlrVYwo1Dd+BV
   WhtenlxLxlsMtuMctradZMqzPV5nriIe+PWaJx0IoWIzLiQQ5u7QN5a2f
   Yjmyp6/1tfda9x/hkp2ygaUS23JL9jTS5pQzwYBC+mKubgBbNTjsfhkJG
   YXuH0RRghRoWW9TI/Pn+MRCJFunyvcKAwUWHh/SdKjVq6FzX8esTjHhnD
   5oRPgfFmD18TGJ8mHChvGcYSAbsWDIomVYANJuNhiwpvbE7BMiuY4bogf
   A==;
X-CSE-ConnectionGUID: XVpbAyL+Sg2FMpB/po0gKw==
X-CSE-MsgGUID: LgwGNsO/TPinujF85foyaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="37445962"
X-IronPort-AV: E=Sophos;i="6.12,211,1728975600"; 
   d="scan'208";a="37445962"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 13:22:01 -0800
X-CSE-ConnectionGUID: tdMu0cXCRaqnpiowSdJ8ag==
X-CSE-MsgGUID: DS9pWP53Sxu5hwEW0y9CXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,211,1728975600"; 
   d="scan'208";a="99177457"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 05 Dec 2024 13:21:58 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tJJIJ-0000Ot-0v;
	Thu, 05 Dec 2024 21:21:55 +0000
Date: Fri, 6 Dec 2024 05:21:25 +0800
From: kernel test robot <lkp@intel.com>
To: Jinjiang Tu <tujinjiang@huawei.com>, miklos@szeredi.hu,
	amir73il@gmail.com, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-unionfs@vger.kernel.org, wangkefeng.wang@huawei.com,
	sunnanyong@huawei.com, yi.zhang@huawei.com, tujinjiang@huawe.com
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <202412060524.5Ata5N0H-lkp@intel.com>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205143038.3260233-1-tujinjiang@huawei.com>

Hi Jinjiang,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20241204]

url:    https://github.com/intel-lab-lkp/linux/commits/Jinjiang-Tu/ovl-respect-underlying-filesystem-s-get_unmapped_area/20241205-224026
base:   next-20241204
patch link:    https://lore.kernel.org/r/20241205143038.3260233-1-tujinjiang%40huawei.com
patch subject: [PATCH -next] ovl: respect underlying filesystem's get_unmapped_area()
config: arm-randconfig-001-20241206 (https://download.01.org/0day-ci/archive/20241206/202412060524.5Ata5N0H-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241206/202412060524.5Ata5N0H-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412060524.5Ata5N0H-lkp@intel.com/

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: fs/overlayfs/file.o: in function `ovl_get_unmapped_area':
>> file.c:(.text+0x998): undefined reference to `__get_unmapped_area'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
