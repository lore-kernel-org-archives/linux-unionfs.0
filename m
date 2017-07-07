From: Amir Goldstein <amir73il@gmail.com>
Subject: [ANNOUNCE] Amir's unionmount-testsuite master branch
Date: Fri, 7 Jul 2017 19:10:49 +0300
Message-ID: <CAOQ4uxiPdec5O0kW=J8LjAi9eK2+=n2Y2f8DH4g8EqyL9AFSXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:34225 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752378AbdGGQKu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Jul 2017 12:10:50 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

Eryu,

I realize I have never made a formal public [ANNOUNCE] about the
unionmount-testsuite tree that I am maintaining [1], except for
referring to it occasionally on my patch postings, so here goes.

The head of the master branch is commit:
bbd2bdb Verify constant inode number with --verify option

The main features that have been added since Dave's master:
- Test rotating N layers (run --ov=N)
- Support for directory rename with kernel >= v4.10 and OVERLAYFS_REDIRECT_DIR=y
- Add more test coverage for directory rename
- Test lower/upper on the same underlying fs (run --ov --samefs)
- Support running tests over block device file systems (instead of tmpfs)
- Adapt check_layer() to work correctly with kernel >= v4.12
- Add optional flag to verify constant inode number on copy up (run
--samefs --verify)

The main branch is going to be forward only and tests should not regress
on current upstream kernel nor on older kernels (*).

A known failure with kernel v4.12 is the test:
  run --ov=1 --samefs --verify rename-mass-5

It fails because lower hardlink copy up does not keep constant inode number
in kernel v4.12. The fix is queued for v4.13-rc1.
On kernels < v4.12 testers should not use the --verify flag, because
inode numbers are not constant on copy up.

(*) While I aim not to break tests on older kernels, I never tested kernels
older than v4.10 and I don't test older kernels regularly at all, so whoever is
interested in using my branch to test older kernels, please inform me of any
breakage or better yet, send me patches.

Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite
