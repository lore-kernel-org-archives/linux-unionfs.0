From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 3/3] generic/470: add syncfs test
Date: Thu, 7 Dec 2017 15:13:17 +0800
Message-ID: <20171207071317.GE2749@eguan.usersys.redhat.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
 <1512613327-218016-3-git-send-email-cgxu519@icloud.com>
 <20171207054418.GC2749@eguan.usersys.redhat.com>
 <423B3F2E-73F1-4B29-93D7-BC6F1AA6CCC6@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750919AbdLGHNU (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 02:13:20 -0500
Content-Disposition: inline
In-Reply-To: <423B3F2E-73F1-4B29-93D7-BC6F1AA6CCC6@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Thu, Dec 07, 2017 at 02:20:26PM +0800, Chengguang Xu wrote:
> > 
> > 在 2017年12月7日，下午1:44，Eryu Guan <eguan@redhat.com> 写道：
> > 
> > On Thu, Dec 07, 2017 at 10:22:07AM +0800, Chengguang Xu wrote:
> >> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes in
> >> underlying filesystem.
> >> Run syncfs and shutdown filesystem(or underlying filesystem of overlayfs)
> >> to check syncfs result.
> >> 
> >> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> >> ---
> >> 
> >> Changes since v1:
> >> Use fs shutdown and fssum to check syncfs result instead of
> >> checking delalloc state of extents.
> >> 
> >> tests/generic/470     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >> tests/generic/470.out |  2 ++
> >> tests/generic/group   |  1 +
> >> 3 files changed, 91 insertions(+)
> >> create mode 100755 tests/generic/470
> >> create mode 100644 tests/generic/470.out
> >> 
> >> diff --git a/tests/generic/470 b/tests/generic/470
> >> new file mode 100755
> >> index 0000000..b488747
> >> --- /dev/null
> >> +++ b/tests/generic/470
> >> @@ -0,0 +1,88 @@
> >> +#! /bin/bash
> >> +# FS QA Test 470
> >> +#
> >> +# Inspired by syncfs bug of overlayfs which does not sync dirty inodes in
> >> +# underlying filesystem. 
> > 
> > Trailing whitespace in above line.
> > 
> >> +#
> >> +# Run syncfs and shutdown filesystem(or underlying filesystem of overlayfs)
> >> +# to check syncfs result.
> >> +#
> >> +# Test will be skipped if filesystem(or underlying filesystem of overlayfs)
> >> +# does not support shutdown.
> >> +#
> >> +#-----------------------------------------------------------------------
> >> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>
> >> +# All Rights Reserved.
> >> +#
> >> +# This program is free software; you can redistribute it and/or
> >> +# modify it under the terms of the GNU General Public License as
> >> +# published by the Free Software Foundation.
> >> +#
> >> +# This program is distributed in the hope that it would be useful,
> >> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> +# GNU General Public License for more details.
> >> +#
> >> +# You should have received a copy of the GNU General Public License
> >> +# along with this program; if not, write the Free Software Foundation,
> >> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >> +#-----------------------------------------------------------------------
> >> +#
> >> +
> >> +seq=`basename $0`
> >> +seqres=$RESULT_DIR/$seq
> >> +echo "QA output created by $seq"
> >> +
> >> +here=`pwd`
> >> +tmp=/tmp/$$
> >> +status=1
> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
> >> +
> >> +_cleanup()
> >> +{
> >> +	cd /
> >> +	rm -f $tmp.*
> >> +}
> >> +
> >> +# get standard environment, filters and checks
> >> +. ./common/rc
> >> +. ./common/filter
> >> +
> >> +# remove previous $seqres.full before test
> >> +rm -f $seqres.full
> >> +
> >> +# real QA test starts here
> >> +
> >> +_supported_fs generic
> >> +_supported_os Linux
> >> +_require_test
> >> +_require_fssum
> >> +_require_scratch
> >> +_require_scratch_shutdown
> >> +_require_xfs_io_command "syncfs"
> >> +
> >> +
> >> +FCNT=1000
> >> +
> >> +_scratch_mkfs >/dev/null 2>&1
> >> +_scratch_mount
> >> +
> >> +# In order to mitigate interference of write-back,
> >> +# create many files for test.
> > 
> > Sorry, I still don't understand how writeback could interfere this test
> > from this comment, what happens if we don't create such files? Why
> > writing files starting from offset 1k?
> 
> There is no explicit explanation how writeback interferes this case,
> also there are many triggers make writeback starts syncing work.
> I just want to increase hit ratio of failure by make many test files,
> as many as possible, but it’s also limited by time and other resource.
> 
> The reason of offset 1k is same as above, compare to test a normal file, 
> I think file with hole can increase failure ratio sometimes.

Yeah, increasing the reproducibility would be a good reason too. Do you
happen to tune the number of files to see if 1000 is a good fit? e.g.
with 100 files test reproduced the overlay bug 20% of times, with 1000
files the reproducibility increased to 80%, etc. And the hole in the
beginning too, what's the actual impact on the reproducibility?

And you're right about the test time, usually we want to balance between
test time and reproducibility too, so we need to tune and measure the
numbers like test files, loop counts etc.

I think these are all good comments for test :)

Thanks,
Eryu
