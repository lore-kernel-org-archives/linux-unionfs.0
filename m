From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] overlay: fix INDEX=y regressions
Date: Tue, 19 Sep 2017 14:39:42 +0300
Message-ID: <1505821184-3913-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32964 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdISLjO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Sep 2017 07:39:14 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

When you added the comment to overlay/014, I said Looks good to me,
but I wasn't looking well.
Second patch is the same treatment to overlay/031 (with the correct
comment).

Test overlay/031 does not pass on master, but with INDEX=y, it fails
on the wrong errors.
The test passes on my development branch:
https://github.com/amir73il/linux/commits/overlayfs-devel

Amir.

Amir Goldstein (2):
  overlay/014: correct comment relating to workdir reuse
  overlay/031: fix test with inodes index enabled

 tests/overlay/014 |  7 +++----
 tests/overlay/031 | 23 ++++++++++++++++-------
 2 files changed, 19 insertions(+), 11 deletions(-)

-- 
2.7.4
