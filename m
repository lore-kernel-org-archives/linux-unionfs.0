Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180313150250.GB2982@redhat.com>
References: <20180312174607.GC2718@redhat.com> <CAOQ4uxgm6wecBYPhuByHGBXTfyToEjakWtiprLJL6CUQQ_Kr5w@mail.gmail.com>
 <20180313150250.GB2982@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 13 Mar 2018 22:22:59 +0200
Message-ID: <CAOQ4uxjRQ1jZfSk2CQ=6nJKyNW=9nETtg5WrWxYYukYmTf2rNQ@mail.gmail.com>
Subject: Re: [PATCH] xfstest: overlay: Absolute redirect should be followed
 even if ancestor is opaque
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 13, 2018 at 5:02 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Mar 12, 2018 at 10:10:36PM +0200, Amir Goldstein wrote:
>> On Mon, Mar 12, 2018 at 7:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Typically, when following absolute redirect, if an opauqe dentry is
>> > found, lookup in further lower directories is stopped. But if a
>> > child dentry has another absolute redirect, then lookup in further
>> > lower layers should continue.
>> >
>> > Say, following is example setup.
>> > upper:  /redirect (redirect=/a/b/c)
>> > lower1: /a/[b]/c       ([b] is opaque) (c has absolute redirect=/a/b/d/)
>> > lower0: /a/b/d/foo
>> >
>> > "redirect" directory in upper should merge with lower1:/a/b/c/ and
>> > lower0:/a/b/d/, despite lower1:/a/b/ being opaque.
>> >
>> > This example and kernel fix has come from Amir Goldstein. I am just putting
>> > a test for it to make sure its not broken down the line.
>>
>> Thanks!!
>>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> Thanks. I will capture your Reviewed-by in V2.
>
>>
>> Some nits and commentary below..
>>
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  tests/overlay/057     |   97 ++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  tests/overlay/057.out |    2 +
>> >  tests/overlay/group   |    1
>> >  3 files changed, 100 insertions(+)
>> >
>> > Index: xfstests-dev/tests/overlay/057
>> > ===================================================================
>> > --- /dev/null   1970-01-01 00:00:00.000000000 +0000
>> > +++ xfstests-dev/tests/overlay/057      2018-03-12 13:28:02.274818432 -0400
>> > @@ -0,0 +1,97 @@
>> > +#! /bin/bash
>> > +# FS QA Test No. 057
>> > +#
>> > +# Test absolute redirect is followed even if ancestor is opaque
>> > +#
>> > +# Typically, when following absolute redirect, if an opauqe dentry is
>> > +# found, lookup in further lower directories is stopped. But if a
>> > +# child dentry has another absolute redirect, then lookup in further
>> > +# lower layers should continue.
>> > +#
>> > +# Say, following is example setup.
>> > +# upper:  /redirect (redirect=/a/b/c)
>> > +# lower1: /a/[b]/c       ([b] is opaque) (c has absolute redirect=/a/b/d/)
>> > +# lower0: /a/b/d/foo
>> > +#
>> > +# "redirect" directory in upper should merge with lower1:/a/b/c/ and
>> > +# lower0:/a/b/d/, despite lower1:/a/b/ being opaque.
>> > +#
>> > +#-----------------------------------------------------------------------
>> > +# Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
>> > +# Author: Vivek Goyal <vgoyal@redhat.com>
>> > +#
>> > +# This program is free software; you can redistribute it and/or
>> > +# modify it under the terms of the GNU General Public License as
>> > +# published by the Free Software Foundation.
>> > +#
>> > +# This program is distributed in the hope that it would be useful,
>> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> > +# GNU General Public License for more details.
>> > +#
>> > +# You should have received a copy of the GNU General Public License
>> > +# along with this program; if not, write the Free Software Foundation,
>> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> > +#-----------------------------------------------------------------------
>> > +#
>> > +
>> > +seq=`basename $0`
>> > +seqres=$RESULT_DIR/$seq
>> > +echo "QA output created by $seq"
>> > +
>> > +here=`pwd`
>> > +tmp=/tmp/$$
>> > +status=1       # failure is the default!
>> > +trap "_cleanup; exit \$status" 0 1 2 3 15
>> > +
>> > +_cleanup()
>> > +{
>> > +       cd /
>> > +       rm -f $tmp.*
>> > +}
>> > +
>> > +# get standard environment, filters and checks
>> > +. ./common/rc
>> > +. ./common/filter
>> > +
>> > +# remove previous $seqres.full before test
>> > +rm -f $seqres.full
>> > +
>> > +# real QA test starts here
>> > +_supported_fs overlay
>> > +_supported_os Linux
>> > +_require_scratch_nocheck
>> > +_require_scratch_overlay_features redirect_dir
>> > +
>> > +# remove all files from previous tests
>> > +_scratch_mkfs
>> > +
>> > +# Create test directories
>> > +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
>> > +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
>> > +upperdir=$OVL_BASE_SCRATCH_MNT/upper
>> > +workdir=$OVL_BASE_SCRATCH_MNT/workdir
>> > +workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
>> > +
>> > +make_test_dirs()
>> > +{
>> > +       rm -rf $lowerdir $lowerdir2 $upperdir $workdir $workdir2
>>
>> No need for rm, we are after scratch_mkfs, so not sure we need a helper here.
>
> Will remove.
>
>>
>> > +        mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir2
>> > +}
>> > +
>> > +make_test_dirs
>> > +mkdir -p $lowerdir/origin
>> > +touch $lowerdir/origin/foo
>> > +_overlay_scratch_mount_dirs $lowerdir $lowerdir2 $workdir2
>>
>>  -o redirect_dir=on
>
> Will fix.
>
>>
>> # Create opaque parent with absolute redirect child in middle layer
>>

Please add these comments to your test.

>> > +mkdir $SCRATCH_MNT/pure
>> > +mv $SCRATCH_MNT/origin $SCRATCH_MNT/pure/redirect
>> > +$UMOUNT_PROG $SCRATCH_MNT
>> > +_overlay_scratch_mount_dirs $lowerdir2:$lowerdir $upperdir $workdir
>>
>>  -o redirect_dir=on
>
> Will fix.
>
>>
>> > +mv $SCRATCH_MNT/pure/redirect $SCRATCH_MNT/redirect
>>
>> # Verify that redirects are followed after mount cycle

This one as well.

>>
>> > +$UMOUNT_PROG $SCRATCH_MNT
>> > +_overlay_scratch_mount_dirs $lowerdir2:$lowerdir $upperdir $workdir
>>
>>  -o redirect_dir=on
>
> Will fix.
>>
>> > +ls $SCRATCH_MNT/redirect/
>> > +
>>
>> How about _overlay_check_scratch_dirs? This maybe an interesting
>> case for fsck.overlay as well.
>
> This does not look necessary at this point. In general I agree that
> running fsck makes sense. In fact probably makes sense after all the
> tests. But IIUC, as of now fsck.overlay is not widely available and
> in that case test will be skipped.
>
> I would first rather wait for fsck.overlay to be widely available
> and then add this to make sure this test is not skipped.
>

That's not how fsck.overlay intergartion behaves.
Patches by Zhangyi that were recently merged will auto check
overlay at _scratch_umount IFF fsck.overlay is installed.

Tests that use _overlay_scratch_mount_dirs (and not
_scratch_mount) should _require_scratch_nocheck (as you did)
to avoid running fsck with wrong (default) dirs, but test author
should instead call _overlay_check_scratch_dirs at the end
of the test with the specialized scratch dirs and mount options.

The only case where _overlay_check_scratch_dirs should NOT
be called is if overlay is expected to be inconsistent see
3ba014a overlay: skip check for tests finished with corrupt filesystem

It ended up being a little confusing, but in order to avert confusion,
you should add comments above _require_scratch_nocheck, see
697e465 overlay: correct scratch dirs check

Thanks,
Amir.
