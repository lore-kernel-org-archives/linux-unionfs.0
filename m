From: Amir Goldstein <amir73il@gmail.com>
Subject: Overlayfs backport for kernel v4.9.y
Date: Thu, 7 Dec 2017 19:14:49 +0200
Message-ID: <CAOQ4uxiYg11XGjzNhD-2gOd-s-FgnzScgzDwwuWpp+518EHv6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:38607 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932156AbdLGROu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 12:14:50 -0500
Received: by mail-yb0-f196.google.com with SMTP id v12so3249613ybj.5
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Dec 2017 09:14:50 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>

Hi All,

For whom it may concern, I have backported latest overlayfs
features to stable kernel v4.9.y. The patches are available on
overlayfs-4.9.y branch on my github [1]. I intend to update and
test this branch with patches applied to upstream.

This work was verified with with xfstests master branch and
with unionmount-testsuite master branch on my github [2].

DO NOT mistake this for code that can be compiled and loaded
as a kernel module to kernel v4.9.y!
The branch pulls in some minor infrastructure changes that
were required for ease of backporting (mostly uuid_t helpers).
Most of the remaining diff from v4.15-rc1 in overlayfs code
is due to STATX vfs API change.

All backported patches have my S-O-B, but most of them
don't have the upstream commit id in the commit message
expect a few tree wide patches which I selectively picked
their changes only to overlayfs (e.g. add include <cred.h>).

Please feel free to use this code, review my work and test it.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/overlayfs-4.9.y
[2] https://github.com/amir73il/unionmount-testsuite
