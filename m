Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 6/6] syscalls/readahead02: fail test if readahead did not use any cache
Date: Thu, 11 Oct 2018 02:34:41 +0300
Message-Id: <20181010233441.5337-7-amir73il@gmail.com>
In-Reply-To: <20181010233441.5337-1-amir73il@gmail.com>
References: <20181010233441.5337-1-amir73il@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The heuristic of failing the test only if not saving any io has false
negatives with overlayfs readahead() bug, but readahead() with overlayfs
always warns on "using less cache then expected", when actually, it is
using no cache at all.

Add another condition to fail the test if readahead did not use any
cache at all, which always detected the overlayfs bug.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Jan Stancek <jstancek@redhat.com>
---
 testcases/kernel/syscalls/readahead/readahead02.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
index d5cc7677b..657461905 100644
--- a/testcases/kernel/syscalls/readahead/readahead02.c
+++ b/testcases/kernel/syscalls/readahead/readahead02.c
@@ -346,6 +346,8 @@ static void test_readahead(unsigned int n)
 		 */
 		if (cached_ra * 1024 > testfile_size / 2)
 			tst_res(TPASS, "using cache as expected");
+		else if (!cached_ra)
+			tst_res(TFAIL, "readahead failed to use any cache");
 		else
 			tst_res(TWARN, "using less cache than expected");
 	} else {
-- 
2.17.1
