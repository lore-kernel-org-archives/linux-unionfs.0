Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B561DC54EE9
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Sep 2022 00:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiIUAan (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 20:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiIUAaj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Sep 2022 20:30:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2646DAFD
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Sep 2022 17:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663720238; x=1695256238;
  h=message-id:date:mime-version:to:cc:from:subject:
   content-transfer-encoding;
  bh=52RSSAxv9kTPz6+QXwDfp32+Ged+YNWXNWvsoD+bTPQ=;
  b=XN5tGiKoW7jRnbbqnRVcJPDlT9civB35ZOapjNTZpVspp8phad2EPgXa
   T+C7MpHTNe9bQZ4Gz1iUZ0w7TWnIslpREnAZvevIdqyCOQXVMdCPIddSK
   GBWxwuNgqdS4qp9Adga21FdfasoXWluwLFgOhhDUqqZorwiaMQQ7gpVA+
   rMIwCqlubarGJW785rV/cCEh16privp/GJaieUPoesj8ia7/88VwYMMP0
   w7yIdy0S50i3se5m/gi7tg66akbyxH82IO/iqMZJcXF1r+NjA2tJbdF6Y
   WrYydeCK/aveBv8vd8ZeDVBpQv4hH6IBfS14tdNRg/ZwYr+VkhXRVz7B4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="297453180"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="297453180"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 17:30:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="761524444"
Received: from yjie-desk.jf.intel.com (HELO [10.24.96.90]) ([10.24.96.90])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 17:30:38 -0700
Message-ID: <6810f0fa-ded3-420d-6978-0faf9667d307@linux.intel.com>
Date:   Tue, 20 Sep 2022 17:30:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, keyon.jie@intel.com
From:   Keyon Jie <yang.jie@linux.intel.com>
Subject: Does overlay driver work if built in to the kernel?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi all,

I am new to the overlayfs, I am hitting issues to make kernel modules 
work in a container environment where the Kubernetes feature really need 
the overlayfs support.

I figured out to make overlay driver built-in to the VM kernel (and then 
shared to the container), but looks like the Kubernetes always fail when 
trying to create overlayfs mounts, with errors like 'permission denied'.


I am seeing that overlay driver is released with modular 
(CONFIG_OVERLAY_FS=m) in most (not sure if it is all) Linux 
distributions, so I am wondering if the overlay driver work when built 
in to the kernel?


Thanks,

~Keyon




