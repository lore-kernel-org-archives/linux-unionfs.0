Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC067C6FA82
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Sep 2022 00:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiIUAp3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 20:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiIUApR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Sep 2022 20:45:17 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64A177E94
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Sep 2022 17:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663721115; x=1695257115;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y+Z3IQhvAcuVr8clZld7beepjWNwhZh7CmOclRFo0lY=;
  b=JLu3nIl24ALt+4CyAnZkVAYNswfhBWJriusw02650GIXLmkq662k2469
   7W4rBep9Ehbo+ay28aVNsoOFIBc2FVADBt2T7S3eLRda8LSeS8JYagOP3
   8m8c9DMk4eRCjBashJ8hHHvWIm4RjSyL2qzaVVwjn90O5XdCnT5hKCB58
   wKbGQ347OLqXuCtBLVMD7PqkQPjALdaG9QG/mw1tm4G+vvD04TK/83cWC
   k1uMBVauY0eiJXMLlgV1Yo3h+sRvbxyd++Qa79ZF4hZhP/QByXMHgGnpS
   w0FhFyno2B19HzVtJDppqloqLcq7jly2JeqCmq9r8CyvAQQsdc6mvLNV7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="280233972"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="280233972"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 17:45:15 -0700
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="761528766"
Received: from yjie-desk.jf.intel.com (HELO [10.24.96.90]) ([10.24.96.90])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 17:45:15 -0700
Message-ID: <5fbb3634-187f-ea3b-0b9d-6e40e1254d6d@linux.intel.com>
Date:   Tue, 20 Sep 2022 17:45:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Does overlay driver work if built in to the kernel?
Content-Language: en-US
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, keyon.jie@intel.com
References: <6810f0fa-ded3-420d-6978-0faf9667d307@linux.intel.com>
From:   Keyon Jie <yang.jie@linux.intel.com>
In-Reply-To: <6810f0fa-ded3-420d-6978-0faf9667d307@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi all,

Sorry for annoys in case the mail is sent twice, it looks to me it was 
moderated that the previous one was sent before subscribing the mailing 
list.


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

