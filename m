From: Nazarov Sergey <s-nazarov@yandex.ru>
Subject: overlayfs: DAC override capability for ovl_lookup_real(lowerdir)?
Date: Fri, 19 Feb 2016 14:26:01 +0300
Message-ID: <1763481455881161@web15m.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from forward11m.cmail.yandex.net ([5.255.216.137]:45011 "EHLO
	forward11m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1426497AbcBSLdh (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 19 Feb 2016 06:33:37 -0500
Received: from web15m.yandex.ru (web15m.yandex.ru [IPv6:2a02:6b8:0:2519::215])
	by forward11m.cmail.yandex.net (Yandex) with ESMTP id 99BE4211F5
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Feb 2016 14:26:02 +0300 (MSK)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi! The problem is:
if lower directory contains subdirectory foo with permissions 0700 root.root,
upper directory contains same subdirectory with permissions 0700 user.user,
user can't create files in unioned one (EACCES error).
May be ovl_lookup_real for lowerdir need to have DAC_READ_SEARCH capability?
