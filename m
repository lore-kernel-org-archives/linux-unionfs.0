From: Duncan Hare <dh@synoia.com>
Subject: Overlayfs with NFS lower layer
Date: Thu, 1 Feb 2018 09:59:51 -0800
Message-ID: <20180201095951.006e3ca5@raspberrypi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from sonic310-20.consmr.mail.bf2.yahoo.com ([74.6.135.194]:46204
        "EHLO sonic310-20.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751378AbeBASAB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Feb 2018 13:00:01 -0500
Received: from smtp108.rhel.mail.bf1.yahoo.com (EHLO raspberrypi) ([98.139.231.46])
          by smtp405.mail.bf1.yahoo.com (JAMES SMTP Server ) with ESMTPA ID 1cfba85623a1f4e23cc4009cb03ebc73
          for <linux-unionfs@vger.kernel.org>;
          Thu, 01 Feb 2018 17:59:57 +0000 (UTC)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

We are looking at disk less operation:

Some questions
1. Is it possible to use an NFS export as the lower layer on Overlayfs? 
2. If 1 is not possible in the current release, what's needed to do
this?
3. Are whiteouts configurable? That is if a file is deleted in the
upper layer, can Ocerlay fs revert to thefile of the same name in
the lower layer?

Duncan
