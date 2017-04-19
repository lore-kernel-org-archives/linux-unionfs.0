From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/4] fstests: generic test for NFS handles
Date: Wed, 19 Apr 2017 19:29:15 +0300
Message-ID: <1492619359-24763-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33395 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937939AbdDSQ3K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 12:29:10 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Eryu,

Changes since v1:
- Build time checks for open_by_handle_at()
- Update docs
- Improve usage and commit messages
- Remove unused program open_unlink
- Squash _require_exportfs into patch 3
- Change test to run on $TEST_DIR/$seq-dir

Amir Goldstein (4):
  fstests: remove IRIX test program open_unlink
  src/open_by_handle: program to exercise open_by_handle_at() syscall
  src/open_by_handle: flexible usage options
  fstests: add generic test for file handles

 .gitignore                   |   1 +
 aclocal.m4                   |  15 +++
 common/rc                    |  10 ++
 configure.ac                 |   1 +
 doc/auxiliary-programs.txt   |  16 ++-
 doc/requirement-checking.txt |   7 ++
 include/builddefs.in         |   1 +
 src/Makefile                 |   7 +-
 src/open_by_handle.c         | 261 +++++++++++++++++++++++++++++++++++++++++++
 src/open_unlink.c            | 147 ------------------------
 tests/generic/426            |  74 ++++++++++++
 tests/generic/426.out        |   2 +
 tests/generic/group          |   1 +
 13 files changed, 390 insertions(+), 153 deletions(-)
 create mode 100644 src/open_by_handle.c
 delete mode 100644 src/open_unlink.c
 create mode 100755 tests/generic/426
 create mode 100644 tests/generic/426.out

-- 
2.7.4
