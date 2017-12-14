From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 00/18] overlay: implement fsck.overlay utility
Date: Thu, 14 Dec 2017 14:47:29 +0800
Message-ID: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2285 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750873AbdLNGlz (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:41:55 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Hi all,

Here is the second version of original fsck.overlay. Changes split to
each patch from first version "overlay: implement fsck utility" for
readability.

I have already handled most of comments from the first iteration and
add/fix some infrastructure, no big features, move tests to xfstests
(already tested).

I will push this "incubator" version to github after review and fix.
Any comments is helpful, thanks!

Changes since v1:

- Add "-n -p -y" options. (Comment from Amir and Darrick)
- Move test cases to xfstests. (Amir, Eryu and Ted)
- * Check lowers use base fd + relative path to speed up iterations. (Amir)
- Handle missing case of redirect xattr check. (Amir)
- Correct copyright and License. (Amir)
- Remove duplicate redirect xattr in 'yes' mode.
- Add objects counter.
- Not enforce fs offline in 'no' mode.
- Fix some code mistakes.

*) This change will cost a lot of 'fd' (up to 500) and will not work
if sysctl_nr_open is lower than lowerdir number (special case, default
is 1024*1024). I think expand sysctl_nr_open temporary may have some side
effect, so just return failure.

Thanks!

zhangyi (F) (18):
  overlay: implement fsck utility
  fsck.overlay: fix uninitialized variable
  fsck.overlay: add -n -p and -y options
  fsck.overlay: add path package and split helper
  fsck.overlay: convert path parse to use helper function
  fsck.overlay: open lowerdirs in advance
  fsck.overlay: check lowers use relative path
  fsck.overlay: fix spelling mistakes
  fsck.overlay: add counter of checked objects
  fsck.overlay: fix verbose flag
  fsck.overlay: add ovl_ask_invalid helper
  fsck.overlay: remove duplicate redirect xattr in yes mode
  fsck.overlay: handle missing case of redirecte directory
  fsck.overlay: correct copyright and License
  fsck.overlay: fix word mistake
  fsck.overlay: remove test cases
  fsck.overlay: not enforce overlayfs is offline in 'no changes' mode
  fsck.overlay: use relative path when checking lowers
