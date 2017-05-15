From: ziegler@uni-freiburg.de
Subject: overlayfs in 4.12-rc1. Files in lower become unwritable in the overlay
Date: Mon, 15 May 2017 17:41:28 +0200
Message-ID: <E1dAI7k-0006Fd-6q@tux00.mathematik.uni-freiburg.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from email.mathematik.uni-freiburg.de ([132.230.30.5]:47116 "EHLO
        email.mathematik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750999AbdEOQTi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 May 2017 12:19:38 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>


How to reproduce: Make sure that the kernel is compiled with
CONFIG_TMPFS_XATTR not set. (Otherwise, as Miklos suggested, the bug
does not occur)

Start with a directory "lower" (btrfs in my case) containing an empty
file "x", and three empty directories "upper", "workdir", "over" on
"/tmp" (tmpfs). Then mount the overlayfs

   sudo mount -t overlay -o \
     lowerdir=lower,upperdir=/tmp/upper,workdir=/tmp/workdir overlay \
     /tmp/over

Then the commands

   sudo touch /tmp/over/x
   sudo mv /tmp/over/x /tmp/over/z

fail:
  touch: cannot touch '/tmp/over/x': Operation not supported
  mv: cannot move '/tmp/over/x' to '/tmp/over/z': Operation not
  supported

despite the permissions

  -rw-r--r-- 1 ziegler ziegler 0 Mai 14 12:27 /tmp/over/y

------------------------------------------------------------------

------------------------------------------------------------------

Bisection between 4.11.0 and 4.12-rc1 yielded

commit 3a1e819b4e80216e00ef6a4dfe67fa142450c5e1
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Thu Mar 30 15:22:16 2017 +0300

    ovl: store file handle of lower inode on copy up

as responsible for this.

------------------------------------------------------------------


------------------------------------------------------------------


Regards,

Martin
