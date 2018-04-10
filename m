Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:48075 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752212AbeDJB3Y (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Apr 2018 21:29:24 -0400
Received: from [172.17.46.226] ([122.224.77.194]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LjquD-1eUjWN2seH-00brzV for
 <linux-unionfs@vger.kernel.org>; Tue, 10 Apr 2018 03:29:23 +0200
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
Content-Type: text/plain;
        charset=gb2312
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: question of copying stack in ovl_lookup()
Message-Id: <779D1CE1-7805-4026-BC7D-3773D5E37B34@gmx.com>
Date: Tue, 10 Apr 2018 09:29:19 +0800
Sender: linux-unionfs-owner@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi guys,

I��m a little curious for below code in ovl_lookup, is there any background for
copy stack instead of directly using it?

memcpy(oe->lowerstack, stack, sizeof(struct ovl_path) * ctr);


Thanks,
Chengguang.