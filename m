Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:37139 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbeDKFlx (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Apr 2018 01:41:53 -0400
Content-Type: text/plain;
        charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: question of copying stack in ovl_lookup()
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxjuO8ZUH_9Y68-y0JQsF9yunTarF6YFCtSW20V_EjXUFA@mail.gmail.com>
Date: Wed, 11 Apr 2018 13:41:46 +0800
Content-Transfer-Encoding: 8BIT
Message-Id: <C665F64A-11F7-4F6F-82D4-8F287A983E30@gmx.com>
References: <779D1CE1-7805-4026-BC7D-3773D5E37B34@gmx.com>
 <CAOQ4uxjuO8ZUH_9Y68-y0JQsF9yunTarF6YFCtSW20V_EjXUFA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>


> �� 2018��4��10�գ�����1:38��Amir Goldstein <amir73il@gmail.com> д����
> 
> On Tue, Apr 10, 2018 at 4:29 AM, cgxu519@gmx.com <cgxu519@gmx.com> wrote:
>> Hi guys,
>> 
>> I��m a little curious for below code in ovl_lookup, is there any background for
>> copy stack instead of directly using it?
>> 
>> memcpy(oe->lowerstack, stack, sizeof(struct ovl_path) * ctr);
>> 
> 
> Memory compaction.
> 
> stack has ofs->numlower entries, which could be very large,
> but after lookup, oe->numlower can end up being much much
> smaller. Also, ovl_alloc_entry() packs lowerstack together with
> ovl_entry, so the overall memory usage of the long lived overlay
> dentry cache entries is lower.

For regular file the maximum numlower is 1, so for optimizing memory
allocation/free maybe we can put one ovl_path entry inside ovl_entry
and allocate/deallocate ovl_entry via cache pool and for dir we can
link to ovl_path array from ovl_entry. Does it make sense?

Thanks,
Chengguang.


