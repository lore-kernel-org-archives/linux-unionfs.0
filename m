Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:40273 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752498AbeF2Dfh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Jun 2018 23:35:37 -0400
Received: from [172.17.46.209] ([122.224.77.194]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MMShK-1fW0dt0WAo-008HNh for
 <linux-unionfs@vger.kernel.org>; Fri, 29 Jun 2018 05:35:35 +0200
From: cgxu519 <cgxu519@gmx.com>
Subject: Postpone copy-up until first real write?
Message-ID: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com>
Date: Fri, 29 Jun 2018 11:35:32 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi guys,

I have a simple question about copy-up timing after implementing stacked 
file operation.
Could we postpone copy-up until first real write happens?

The background is consuming much time on open is unexpected for some of 
our applications.

Thanks,
Chengguang


