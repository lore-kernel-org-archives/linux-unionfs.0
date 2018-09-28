Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] Tests for readahead() and fadvise() on overlayfs
Date: Fri, 28 Sep 2018 16:06:17 +0300
Message-Id: <20180928130621.28932-1-amir73il@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Cyril,

The following series adds test covergae for readahead() syscall
over overlayfs file and adds test coverage for a specific
posix_fadvise() syscall advice (POSIX_FADV_WILLNEED).

So far, the posix_fadvise syscall tests in LTP only test for error
conditions, but not functionality. The functionality of the advice
POSIX_FADV_WILLNEED is indentical to readahead(), so I decided not
to duplicate the readahead functional test and add test cases to
readahead02 that use the POSIX_FADV_WILLNEED implementation.

Before I decided not to write new posix_fadvise() tests I converted
the existing tests to newlib. That is available for you as github PR:
https://github.com/linux-test-project/ltp/pull/401

Thanks,
Amir.

Amir Goldstein (4):
  syscalls/readahead01: Convert to newlib
  syscalls/readahead02: Convert to newlib and cleanup
  syscalls/readahead02: test readahead() on an overlayfs file
  syscalls/readahead02: test readahead using posix_fadvise()

 .../kernel/syscalls/readahead/readahead01.c   | 119 ++-----
 .../kernel/syscalls/readahead/readahead02.c   | 332 +++++++++---------
 2 files changed, 191 insertions(+), 260 deletions(-)

-- 
2.17.1
