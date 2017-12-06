From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/2] overlay/045: add test for syncfs
Date: Wed, 6 Dec 2017 15:11:35 +0800
Message-ID: <20171206071135.GP2749@eguan.usersys.redhat.com>
References: <B4077824-4B28-4DC1-9407-33EF2316A4F2@icloud.com>
 <CAOQ4uximkTSb5R=KwW55-+ekj1HimfYshXwWmngoYyg1cbLjYw@mail.gmail.com>
 <828CB46A-440A-46CE-9CEF-F3980D36C59B@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752692AbdLFHLh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 02:11:37 -0500
Content-Disposition: inline
In-Reply-To: <828CB46A-440A-46CE-9CEF-F3980D36C59B@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Dec 06, 2017 at 09:34:51AM +0800, Chengguang Xu wrote:
> 
> > 在 2017年12月6日，上午4:38，Amir Goldstein <amir73il@gmail.com> 写道：
> > 
> > On Tue, Dec 5, 2017 at 5:50 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
> >> Run syncfs and shutdown upper filesystem to check syncfs result.
> >> 
> > 
> > Sorry to be zigzagging you from generic to overlay and back, but the test
> > you wrote is completely generic, which is a good thing, so it belongs in
> > generic IMO.
> > Eryu?
> 
> If Eryu thinks it’s acceptable, I can move to generic again.

I agreed, if overlay gets proper _require_scratch_shutdown support, test
should be made generic too.

> 
> > 
> >> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> >> ---
> >> tests/overlay/045     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >> tests/overlay/045.out |   2 +
> >> tests/overlay/group   |   1 +
> >> 3 files changed, 110 insertions(+)
> >> create mode 100755 tests/overlay/045
> >> create mode 100644 tests/overlay/045.out
> >> 
> >> diff --git a/tests/overlay/045 b/tests/overlay/045
> >> new file mode 100755
> >> index 0000000..402a955
> >> --- /dev/null
> >> +++ b/tests/overlay/045
> >> @@ -0,0 +1,107 @@
> >> +#! /bin/bash
> >> +# FS QA Test 045
> >> +#
> >> +# Inspired by syncfs bug of overlayfs.
> >> +# Run syncfs and shutdown upper filesystem to check syncfs result.
> >> +# Test will be skipped if underlying upper filesystem does not support
> >> +# shutdown or syncfs syscall.

It's better to describe the overlay bug more and mention the patch that
fixed the bug if available. It helps to understand the test, especially
when you look at some test failures months or years later..

> >> +#
> >> +#-----------------------------------------------------------------------
> >> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>.
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
> >> +status=0
> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
> >> +
> >> +_cleanup()
> >> +{
> >> +       cd /
> >> +       rm -f $tmp.*
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
> >> +# Modify as appropriate.
> >> +_supported_fs overlay
> >> +_supported_os Linux
> >> +_require_test
> >> +_require_scratch
> >> +_require_scratch_shutdown
> >> +_require_xfs_io_command "syncfs"
> >> +
> >> +# if error

Comments from template, can be removed.

> >> +
> >> +PREFIX=${seq}-testfile
> >> +TESTFILES=${PREFIX}-*

This $TESTFILES usage was not fixed since v1..

> >> +FCNT=1000
> >> +
> >> +write_data()
> >> +{
> >> +       if [ $1 -eq 0 ]; then
> >> +               TARGET=$TEST_DIR
> >> +       else
> >> +               TARGET=$SCRATCH_MNT
> >> +       fi
> >> +
> >> +       rm -f $TARGET/$TESTFILES >/dev/null 2>&1
> >> +       for i in `seq 1 $FCNT`; do
> >> +               $XFS_IO_PROG -f -c "pwrite 1K 1K" \
> >> +                               ${TARGET}/${PREFIX}-$i >/dev/null 2>&1
> >> +       done

It's not clear to me, just from the test, why you need to write many
small files to trigger the bug. Better to have more comments to explain
the steps in test.

> >> +}
> >> +
> >> +
> >> +check_data()
> >> +{
> >> +       diff -r $TEST_DIR $SCRATCH_MNT
> > 
> > TEST_DIR is typically filled with other stuff, so this won't work.
> > I would have gone for md5sum -c $TEST_DIR/$seq-md5, but diff
> > is fine as long as you keep it contained inside $TEST_DIR/$seq-dir
> > or something.
> 
> In my test it works fine. but as you said it’s better make test dir inside $TEST_DIR.

I don't think you need $TEST_DIR at all, take a look at src/fssum.c and
_require_fssum and tests that take use of $FSSUM_PROG, the fssum program
is used to record & compare checksums of a bunch of files. I guess it
fits your need perfectly?

> 
> > 
> >> +       if [ $? -ne 0 ]; then
> >> +               status=1
> >> +       fi
> >> +}
> >> +
> >> +_scratch_mkfs >/dev/null 2>&1
> >> +_scratch_mount
> >> +
> >> +write_data 0
> > 
> > Why 0/1? pass the TARGET path as argument.
> > Or use md5sum instead or writing twice.
> 
> Need modify as your advice.
> 
> > 
> >> +echo 3 > /proc/sys/vm/drop_caches
> > 
> > Why is this needed? if it is really needed add a comment why
> 
> Main purpose is to mitigate interference from write-back, 
> but it seems having side effect to outside, I think if
> we have enough test files then avoid dropping caches is reasonable.
> This is also the reason why I’m using diff two directories instead of
> using md5sum to one test file.

Yeah, this is something you need to document as comments in the test :)

> 
> > 
> >> +
> >> +write_data 1
> >> +$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT/${PREFIX}-${FCNT} >/dev/null 2>&1
> >> +
> >> +_scratch_shutdown
> >> +_scratch_cycle_mount
> >> +check_data
> >> +
> >> +rm -f $TEST_DIR/$TESTFILES >/dev/null 2>&1
> >> +rm -f $SCRATCH_MNT/$TESTFILES >/dev/null 2>&1
> > 
> > In TEST_DIR we leave garbage behind on purpose, clean the dir (e.g. $seq-dir)
> > on test start.
> > scratch gets formatted so you don't need to clean it.
> 
> You are right, I did too much here.
> 
> > 
> >> +
> >> +echo "Silence is golden"
> >> +exit
> >> diff --git a/tests/overlay/045.out b/tests/overlay/045.out
> >> new file mode 100644
> >> index 0000000..66276cf
> >> --- /dev/null
> >> +++ b/tests/overlay/045.out
> >> @@ -0,0 +1,2 @@
> >> +QA output created by 045
> >> +Silence is golden
> >> diff --git a/tests/overlay/group b/tests/overlay/group
> >> index b32c6cd..eccd7d0 100644
> >> --- a/tests/overlay/group
> >> +++ b/tests/overlay/group
> >> @@ -47,3 +47,4 @@
> >> 042 auto quick copyup hardlink
> >> 043 auto quick copyup nonsamefs
> >> 044 auto quick copyup hardlink nonsamefs
> >> +045 auto quick sync
> > 
> > Shutdown group seems in order.
> 
> I think shutdown is a way or method to make this test work,
> but it seems not purpose of test itself.

shutdown is used to simulate power failure, and all other tests that
shut the filesystem down are in 'shutdown' group too.

Thanks,
Eryu
