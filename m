Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58001 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752246AbeDJKAJ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Apr 2018 06:00:09 -0400
Content-Type: text/plain;
        charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: question of copying stack in ovl_lookup()
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxjuO8ZUH_9Y68-y0JQsF9yunTarF6YFCtSW20V_EjXUFA@mail.gmail.com>
Date: Tue, 10 Apr 2018 18:00:01 +0800
Content-Transfer-Encoding: 8BIT
Message-Id: <B8871EF0-0178-42F0-ABBD-7B82AFBEF393@gmx.com>
References: <779D1CE1-7805-4026-BC7D-3773D5E37B34@gmx.com>
 <CAOQ4uxjuO8ZUH_9Y68-y0JQsF9yunTarF6YFCtSW20V_EjXUFA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir,

Thanks for explanation!


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
> 
> Cheers,
> Amir.

