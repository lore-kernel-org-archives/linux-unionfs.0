Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay/061: remove from auto and quick groups
Date: Tue, 18 Jun 2019 09:43:55 +0300
Message-Id: <20190618064355.29398-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

In late 2016, tests overlay/01[6-8] where merged to track the
state of several ilong standing posix compliance issues on overlayfs.

This practice was somewhat of an exception for xfstests project,
which more often merges tests for issues that are expected to be
resolved in the short term.

Over the years, some test cases have been fixed and more tests
where created to cover the remaining issues (e.g. overlay/04[34]).

Currently, the only failing test from this category is overlay/061
which covers item b) in the "Non-standard behavior" section of
Documentation/filesystems/overlayfs.txt.

Since there is no clear design, roadmap nor allocated resources
to resolve this remaining issue, the test is removed from the
"auto" and "quick" groups, following a suggestion that Darrick
has made for a similarly long failing generic test.

The test was added to the new "posix" group, to allow testing
for posix compliance.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

With this change, check -overlay -g overlay/quick run is expdected
to be all green.

I did not observe any regressing with check -overlay -g generic/quick
compared to check -g generic/quick on xfs with recent kernel.
I did not test all filesystems and -g generic/auto with recent kernel,
but I am not aware of any expected failures specific for -overlay run
on generic tests.

check -overlay -g overlay/auto has one non-quick stress test
(overlay/019) which is failing on lockdep circular locking dependency
warning (if you have lockdep enabled).
This is a known issue that has also been reported by syzbot.

Thanks,
Amir.

 tests/overlay/group | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/overlay/group b/tests/overlay/group
index 8bde6ea1..ef8517a1 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -63,7 +63,7 @@
 058 auto quick exportfs
 059 auto quick copyup
 060 auto quick metacopy
-061 auto quick copyup
+061 posix copyup
 062 auto quick exportfs
 063 auto quick whiteout
 064 auto quick copyup
-- 
2.17.1
