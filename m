From: ziegler@uni-freiburg.de
Subject: overlayfs stopped working in v4.8-rc4-359-g4b30b6d
Date: Sun, 04 Sep 2016 01:37:36 +0200
Message-ID: <E1bgKVE-0007is-60@tux00.mathematik.uni-freiburg.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from email.mathematik.uni-freiburg.de ([132.230.30.5]:46632 "EHLO
        email.mathematik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750785AbcIDA1O (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 3 Sep 2016 20:27:14 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Dear Miklos,

overlayfs works still in  v4.8-rc4, but not longer in the newest kernel:


If the four directories test_lowerdir,test/upperd, test/workd,
test_mountdir exist, the command

  mount -t overlay -o lowerdir=test_lowerdir,upperdir=test/upperd,workdir=test/workd,noatime overlay test_mountdir

does not produce a writable files system. The kernel says:


  kernel: overlayfs: failed to create directory /root/test/workd/work (errno: 95); mounting read-only


I bisected between v4.8-rc4 and v4.8-rc4-359-g4b30b6d and found

  c11b9fdd6a612f376a5e886505f1c54c16d8c380
  Author: Miklos Szeredi <mszeredi@redhat.com>
  Date:   Thu Sep 1 11:11:59 2016 +0200

    ovl: remove posix_acl_default from workdir

responsible. Reverting this makes overlayfs work again.


Best regards

Martin
