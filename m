From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/4] fstests: add generic test for file handles
Date: Wed, 19 Apr 2017 13:07:47 +0300
Message-ID: <CAOQ4uxhngqyVR20iT+0-4jyk_e9VXgP7zsSQp3tuN=c_A-MYaA@mail.gmail.com>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
 <1492539444-25938-5-git-send-email-amir73il@gmail.com> <20170419095533.GQ8951@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36378 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761631AbdDSKHs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 06:07:48 -0400
In-Reply-To: <20170419095533.GQ8951@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Wed, Apr 19, 2017 at 12:55 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Apr 18, 2017 at 09:17:24PM +0300, Amir Goldstein wrote:
>> Cloned from xfs specific test xfs/238, which checks
>> stale file handles of deleted files.
>>
>> This test uses the generic open_by_handle_at() syscall
>> and also tests for non-stale file handles of linked files.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  tests/generic/426     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/426.out |  2 ++
>>  tests/generic/group   |  1 +
>>  3 files changed, 76 insertions(+)
>>  create mode 100755 tests/generic/426
>>  create mode 100644 tests/generic/426.out
>>
>> diff --git a/tests/generic/426 b/tests/generic/426
>> new file mode 100755
>> index 0000000..62bb85e
>> --- /dev/null
>> +++ b/tests/generic/426
>> @@ -0,0 +1,73 @@
>> +#! /bin/bash
>> +# FS QA Test No. 426
>> +#
>> +# Check stale handles pointing to unlinked files
>> +# and non-stale handles pointing to linked files
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (C) 2016 CTERA Networks. All Rights Reserved.
>                    ^^^^ 2017?
>> +# Author: Amir Goldstein <amir73il@gmail.com>
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1     # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    cd /
>> +    rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_scratch
>> +_require_exportfs
>> +
>> +echo "Silence is golden"
>> +
>> +_scratch_mkfs > /dev/null 2>&1
>> +_scratch_mount > /dev/null 2>&1
>> +
>> +numfiles=1024
>> +
>> +# Check stale handles to deleted files
>> +src/open_by_handle -c $SCRATCH_MNT $numfiles
>> +src/open_by_handle -d $SCRATCH_MNT $numfiles
>> +
>> +# Check non-stale handles to linked files
>> +src/open_by_handle -c $SCRATCH_MNT $numfiles
>> +src/open_by_handle    $SCRATCH_MNT $numfiles
>> +
>> +# Check non-stale handles to files that were hardlinked and original deleted
>> +src/open_by_handle -l $SCRATCH_MNT $numfiles
>> +src/open_by_handle -u $SCRATCH_MNT $numfiles
>
> This third test depends on test files created in second test, and I
> guess this could confuse people at debug time if any of the tests
> failed.
>
> So how about remove all the files and call "open_by_handle -c ..."
> before each test? e.g. (I use testdir and don't remove lost+found dir
> because extN needs it for fsck)
>

Sure. Makes sense.
Going forward, as you might have guessed, I am going to add
_scratch_cycle_mount to the mix.


> testdir=$SCRATCH_MNT/testdir

So I copied using SCRATCH_MNT from xfs/238, but I wonder if
I should go with thsi instead:
testdir=$TEST_DIR/$seq

Maybe some fs is vulnerable to exporting handles from an ages fs
who knows... Any opinion?

> mkdir -p $testdir
>
> # Check stale handles to deleted files
> src/open_by_handle -c $testdir $numfiles
> src/open_by_handle -d $testdir $numfiles
>
> # Check non-stale handles to linked files
> rm -f $testdir/*
> ...
>
> # Check non-stale handles to files that were hardlinked and original
> # deleted
> rm -f $testdir/*
> src/open_by_handle -c $testdir $numfiles
> ...                -l ..
> ...                -u ..
>
> Thanks,
> Eryu
>
>> +
>> +status=$?
>> +exit
>> diff --git a/tests/generic/426.out b/tests/generic/426.out
>> new file mode 100644
>> index 0000000..777cbcd
>> --- /dev/null
>> +++ b/tests/generic/426.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 426
>> +Silence is golden
>> diff --git a/tests/generic/group b/tests/generic/group
>> index 6d6e4f6..f29009c 100644
>> --- a/tests/generic/group
>> +++ b/tests/generic/group
>> @@ -428,3 +428,4 @@
>>  423 auto quick
>>  424 auto quick
>>  425 auto quick attr
>> +426 auto quick exportfs
>> --
>> 2.7.4
>>
