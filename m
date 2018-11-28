Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 0/6] Tests for readahead() and fadvise() on overlayfs
Date: Wed, 28 Nov 2018 18:46:39 +0200
Message-Id: <20181128164645.783-1-amir73il@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Cyril,

The following series adds test covergae for readahead() syscall
over overlayfs file and adds test coverage for a specific
posix_fadvise() syscall advice (POSIX_FADV_WILLNEED).

So far, the posix_fadvise syscall tests in LTP only test for error
conditions, but not functionality.

The functionality of the advice POSIX_FADV_WILLNEED is identical
to readahead() and since kernel commit 3d8f7615319b ("vfs: implement
readahead(2) using POSIX_FADV_WILLNEED"), the implementations are
also bound together.

To add test coverage of the advice POSIX_FADV_WILLNEED, I decided not
to duplicate the readahead() functional test and add test cases to
readahead02 that use the POSIX_FADV_WILLNEED implementation.

Thanks,
Amir.

Changed since v3:
- Get rid of check_ret() helper
- Use tst_timer helpers instead of gettimeofday

Changes since v2:
- Runtime check for readahead/fadvise support
- Abort test case immediately if syscall fail

Changes since v1:
- Fix bugs in loop invocation of test (i.e. -i 2)
- Address review comments from Jan Stancek
- Make cached_max a global maximum over all test cases
- Improve reliability of overlayfs readahead test case failure

Amir Goldstein (6):
  syscalls/readahead02: Convert to newlib and cleanup
  syscalls/readahead02: abort test if readahead syscall fails
  syscalls/readahead02: fail test if readahead did not use any cache
  syscalls/readahead02: Convert to tst_timer helpers
  syscalls/readahead02: test readahead() on an overlayfs file
  syscalls/readahead02: test readahead using posix_fadvise()

 .../kernel/syscalls/readahead/readahead02.c   | 355 ++++++++----------
 1 file changed, 164 insertions(+), 191 deletions(-)

-- 
2.17.1
