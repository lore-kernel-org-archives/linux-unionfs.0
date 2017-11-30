From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic/470: Add check for different sync modes
Date: Thu, 30 Nov 2017 15:22:28 +0800
Message-ID: <20171130072228.GT2749@eguan.usersys.redhat.com>
References: <1512009801-11466-1-git-send-email-cgxu@mykernel.net>
 <CAOQ4uxgnenGaEXnNSjovnF+r06rjV4_VdR4qhaXs5q4yexu=jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58898 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbdK3HWa (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Nov 2017 02:22:30 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgnenGaEXnNSjovnF+r06rjV4_VdR4qhaXs5q4yexu=jA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chengguang Xu <cgxu@mykernel.net>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Nov 30, 2017 at 07:30:41AM +0200, Amir Goldstein wrote:
> Adding fstests list and maintainer in CC, because this is where this
> patch in meant to go.
> 
> Eryu,
> 
> This test is expected to fail with overlayfs on current upstream and
> any past version
> AFAIK.
> Do you this it qualifies for a specific overlay/* regression test? or
> that generic/* test
> would be sufficient to cover the overlayfs issue?

If it reproduces the overlay bug without any special overlay setup, a
generic test would be good, other filesystems could benefit from this
test too.

And Chengguang, can you please send the full version of the test to
fstests@vger.kernel.org again? I can only see and comment on the trimmed
version now.
> 
> On Thu, Nov 30, 2017 at 4:43 AM, Chengguang Xu <cgxu@mykernel.net> wrote:
> > generic/470 should be skipped when delalloc is not supported.

What happens if there's no delalloc support? If test fails due to that's
not a valid setup or wrong usage of overlay (I highly doubt it :), I
agree we should _notrun in this case. If test passes without reproducing
the bug, I'd prefer continuing run the test to get better test coverage,
just write comments to describe this case.

> >
> 
> Test looks very good. One minor nit below.
> 
> 
> Not sure why you choose the minor detail in the line above as the
> commit description?
> Seems like the text in the top comment of the test would have been also
> appropriate for commit description.

Yeah, please describe the test purpose in commit log, if you're testing
a specific overlay bug, describe that bug too and refering to the patch
that fixed the bug would be good. And it's worth mentioning the test
behavior when delalloc is not supported.

> 
> > Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
> > ---
> >  tests/generic/470     | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/470.out |   2 +
> >  tests/generic/group   |   1 +
> >  3 files changed, 136 insertions(+)
> >  create mode 100755 tests/generic/470
> >  create mode 100644 tests/generic/470.out
> >
> > diff --git a/tests/generic/470 b/tests/generic/470
> > new file mode 100755
> > index 0000000..a43fb91
> > --- /dev/null
> > +++ b/tests/generic/470
> > @@ -0,0 +1,133 @@
> > +#! /bin/bash
> > +# FS QA Test No. 470
> > +#
> > +# Run fsync & fdatasync & syncfs & sync to test sync result.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017 Chengguang Xu <cgxu@mykernel.net>. All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=0
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_test
> > +_require_xfs_io_command "fsync"
> > +_require_xfs_io_command "fdatasync"
> > +_require_xfs_io_command "syncfs"
> > +_require_xfs_io_command "sync"

Seems not necessary except the "syncfs" case, as older kernel doesn't
support syncfs(2), but I think there's nothing wrong with having them
checked explicitly.

> > +_require_command "$FILEFRAG_PROG" filefrag
> > +
> > +PREFIX=$TEST_DIR/${seq}-testfile
> > +TESTFILES=$TEST_DIR/${seq}-testfile-*

Why not just use $PREFIX-*?

> > +FCNT=1000
> > +
> > +write_data()
> > +{
> > +       rm -f $TESTFILES >/dev/null 2>&1
> > +       for i in `seq 1 $FCNT`; do
> > +               $XFS_IO_PROG -f -c "pwrite 1K 1K" \
> > +                               ${PREFIX}-$i >/dev/null 2>&1
> > +       done
> > +}
> > +
> > +check_delalloc_support()
> > +{
> > +       write_data
> > +       $FILEFRAG_PROG -e $TESTFILES | grep -w delalloc >/dev/null 2>&1

This looks fragile and requires all the files are not written back to
disk, it's unlikely but still possible someone flushed the files before
filefrag run.

Anyway, I think this function can be dropped if we decide continue to
run test if delalloc is not supported.

Thanks,
Eryu

> > +       if [ $? -ne 0 ]; then
> > +               _notrun "This test requires delayed allocation support!"
> > +       fi
> > +}
> > +
> > +sync_data()
> > +{
> > +       case $1 in
> > +       sync)
> > +               $XFS_IO_PROG -c "sync" >/dev/null 2>&1
> > +               ;;
> > +       syncfs)
> > +               $XFS_IO_PROG -c "syncfs" ${PREFIX}-${FCNT} >/dev/null 2>&1
> > +               ;;
> > +       fsync)
> > +               for i in `seq 1 $FCNT`; do
> > +                       $XFS_IO_PROG -c "fsync" ${PREFIX}-${i} >/dev/null 2>&1
> > +               done
> > +               ;;
> > +       fdatasync)
> > +               for i in `seq 1 $FCNT`; do
> > +                       $XFS_IO_PROG -c "fdatasync" ${PREFIX}-${i} >/dev/null 2>&1
> > +               done
> > +               ;;
> > +       *)
> > +               ;;
> > +       esac
> > +}
> > +
> 
> 
> Technically, you don't need all those cases.
> This command will do almost the same for all cases and more efficiently
> then the for loop.
> 
> $XFS_IO_PROG -c $sync_mode ${PREFIX}-* >/dev/null 2>&1
> 
> sync happens only once, but files are being opened for no reason.
> syncfs happens FCNT times, but that won't change test result.
> 
> So up to you if you use this hack for all modes, but I would certainly
> change fsync and fdatasync to not use the for loop as xfs_io already
> has a built in file iterator.
> 
> Thanks!
> Amir.
