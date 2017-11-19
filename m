From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/3] More nonsamefs d_ino test cleanups
Date: Sun, 19 Nov 2017 13:56:26 +0200
Message-ID: <1511092589-29179-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:36700 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdKSLzv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Nov 2017 06:55:51 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Chandan,

Please review my cleanups to overlay/041.
I hope I did not "cleanup" anything important.
This is the version of the test I used for testing xino feature,
because it has improved test coverage for subdirs d_ino.

If you approve of these changes, at least first 2 patches should
be applied to the samefs test flavor (overlay/038), so the flavor
difference remains only the layers setup used by the test.

Let me know if you want me to apply the changes to 038 myself or if
you intend to do that yourself.

Thanks,
Amir.

Amir Goldstein (3):
  overlay/041: code cleanup
  overlay/041: test consistent values of st_ino/d_ino for subdirs
  overlay/041: use user defined overlay mount option

 tests/overlay/041 | 106 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 63 insertions(+), 43 deletions(-)

-- 
2.7.4
