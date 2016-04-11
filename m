From: Yuki Machida <machida.yuki@jp.fujitsu.com>
Subject: Backport a Security Fix for CVE-2015-8660 to v4.1
Date: Mon, 11 Apr 2016 14:33:41 +0900
Message-ID: <570B3735.6030600@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:46643 "EHLO
	mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbcDKFdp (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 11 Apr 2016 01:33:45 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: sasha.levin@oracle.com
Cc: stable@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, viro@zeniv.linux.org.uk

Hi Sasha,

I conformed that this patch for CVE-2015-8660 not applied at v4.1.21.
acff81ec2c79492b180fade3c2894425cd35a545
Could you please apply this patch for 4.1-stable ?

References:
https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2015-8660

Regards,
Yuki Machida
