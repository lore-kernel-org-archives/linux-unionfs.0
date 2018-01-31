From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] Two more overlayfs exportfs tests
Date: Wed, 31 Jan 2018 13:44:53 +0200
Message-ID: <1517399095-28512-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:42941 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752097AbeAaLny (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 06:43:54 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

The tests just keep on coming... sorry about the high paste ;-)

The two new tests fail on overlayfs-next and pass with the patch
I just posted ("ovl: check lower ancestry on encode of lower dir file
handle").

The first test failure is a failure to decode lower file handle after
rename of a non-indexed merge ancestor.

The second tests would have failed without commit 05e1f11816d7 ("ovl:
copy up before encoding non-connectable dir file handle"). However,
because the mentioned commit applies a strict rule to copy up on encode
a lower dir on layer > 1, the test failure is just "unexpected copy up",
and not a failure to decode.

Thanks,
Amir.

Amir Goldstein (2):
  overlay: test overlay file handles of lower dir with non-indexed
    ancestor
  overlay: test overlay file handle of dir with ancestor under lower
    redirect

 tests/overlay/054     | 162 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/054.out |  11 ++++
 tests/overlay/055     | 170 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/055.out |  10 +++
 tests/overlay/group   |   2 +
 5 files changed, 355 insertions(+)
 create mode 100755 tests/overlay/054
 create mode 100644 tests/overlay/054.out
 create mode 100755 tests/overlay/055
 create mode 100644 tests/overlay/055.out

-- 
2.7.4
