From: L A Walsh <lkml@tlinx.org>
Subject: is Documentation/filesystems/overlayfs.txt current?
Date: Sun, 17 Dec 2017 15:41:59 -0800
Message-ID: <5A3700C7.2010602@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:60306 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbdLQXmD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 Dec 2017 18:42:03 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id vBHNfxIw094072
        for <linux-unionfs@vger.kernel.org>; Sun, 17 Dec 2017 15:42:02 -0800
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>


I have a concern regarding something the doc says -- that metadata is only
taken from the upper filesystem.

But if the lower file system is the only one with the meta data, how does
it propagate?  It seems to say it won't be copied, yet aren't things
like ACL's file owner and permission bits all metadata?  Wouldn't
that have to come from the lower file layer?
