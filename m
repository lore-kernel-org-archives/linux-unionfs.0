From: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
Subject: Issues with OvelayFS + 9P FS
Date: Tue, 28 Nov 2017 18:32:54 -0600
Message-ID: <20171129003254.GA3570@miguelinux-clr.zpn.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56367 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751486AbdK2Ac6 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 19:32:58 -0500
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>

Hi Miklos,

I've seen issues when I try to use a Qemu/KVM + 9P and a Overlay FS.

The issue started to show from v4.14 and I bisected the guilty commit to

4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")

The issue is showed when ovl_iterate_real(file, ctx) is called, if I
commented out that *if* block to just load iterate_dir(od->realfile, ctx),
everything works fine.

To reproduce the issue just create a OverlayFS and use the merged
directory as a 9P share directory to the VM.
You will see that the upper ONLY files/directories are seen good, but 
when you try to list the lower and merged files the process couldn't
finish and ends with a "ls: Memory exhausted"

I've tried to fix it but my knowledge is not enough on FS.
I've done small script to reproduce the issue, they are at
https://github.com/miguelinux/overlay-9p-issue

-- 
Regards,

Miguel Bernal Marin                     Open Source Technology Center
https://clearlinux.org                              Intel Corporation
