From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fix for 4.10-rc5
Date: Fri, 20 Jan 2017 11:43:18 +0100
Message-ID: <20170120104318.GI27207@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32862 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdATKnZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Jan 2017 05:43:25 -0500
Received: by mail-wm0-f66.google.com with SMTP id r144so5746555wme.0
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Jan 2017 02:43:24 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This fixes a regression introduced in this cycle.

Thanks,
Miklos

---
Amir Goldstein (1):
      ovl: fix possible use after free on redirect dir lookup

---
 fs/overlayfs/namei.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)
