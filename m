Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44165 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbeH0WPT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Aug 2018 18:15:19 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] fstests: fix overlay test failure over ext4
Date: Mon, 27 Aug 2018 21:29:24 +0300
Message-Id: <1535394566-18837-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org, linux-ext4@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

As I reported earlier, test generic/009 was failing ./check -overlay
run due to a test bug. The test belongs to a class of tests that have
explicit check for a certain $FSTYP, which does not apply when FSTYP is
overlay.

I ran all the tests that check for FSTYP = ext4 with overlay over ext4
and all the tests that check for FSTYP = xfs with overlay over xfs.
generic/009 was the only test that failed because of the exlicit check.
The rest of the tests either passes or did not run for a good reason.

Strangely, tests which _require_seek_data_hole(), that has the exact same
check as generic/009 didn't fail with overlay over ext4. In fact, those
tests also did not with with bare ext4 even when I removed the call
to _ext4_disable_extent_zeroout() from _require_seek_data_hole()???

I tried to come up with a more generic solution, but didn't like any
ideas I had, so I ended up fixing generic/009 in place in the hope that
you either accept it as is or propose a better solution.

The fix depends on the user either setting FSTYP=ext4 in a config file
or setting the variable OVL_BASE_FSTYP before running the test.
I will soon send a patch for kvm-xfstests to Ted that does the latter.

Thanks,
Amir.

Amir Goldstein (2):
  overlay: do not set OVL_BASE_FSTYP value to "overlay"
  generic/009: fix test failure with overlay over ext4

 common/config     | 2 +-
 tests/generic/009 | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.7.4
