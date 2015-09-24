From: Alexey Naidyonov <alexey.naidyonov@gmail.com>
Subject: overlayfs + linux user namespace issue
Date: Thu, 24 Sep 2015 13:43:23 +0300
Message-ID: <CAM45rib8eDrSkRwXo+0ZhannWNmyUe1Tqq9T13csGVdfWXbwXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:36546 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbbIXKnZ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 24 Sep 2015 06:43:25 -0400
Received: by lacao8 with SMTP id ao8so58636965lac.3
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Sep 2015 03:43:23 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hello;

I found that writing to overlayfs mount may be denied to a process
with own user namespace and uid=0 inside that namespace, unless I
explicitly chown lower-work/work directory to a parent namespace uid
corresponding to that user namespace uid 0.

The test case might be found at
https://unix.stackexchange.com/questions/229782/overlayfs-doesnt-work-with-unprivileged-user-namespace

Tried with debian's 4.1.6 and 4.2-trunk.

Could someone please clarify if this is a bug or a feature, and if
this might be changed in future?

Thank you!

Regards,
-- 
 Alexey Naidyonov
