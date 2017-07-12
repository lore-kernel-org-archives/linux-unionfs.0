From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/5] overlay: test cases that force read-only mount
Date: Wed, 12 Jul 2017 13:37:13 +0300
Message-ID: <CAOQ4uxjnha7Y2gQ=x1ot+65JYjnvPjQXvK9s=NSRSEmnMPETPQ@mail.gmail.com>
References: <1499802726-11045-1-git-send-email-amir73il@gmail.com>
 <1499802726-11045-5-git-send-email-amir73il@gmail.com> <20170712103158.GB7015@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170712103158.GB7015@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jul 12, 2017 at 1:31 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Jul 11, 2017 at 10:52:05PM +0300, Amir Goldstein wrote:
>> - Mount with no upper dir
>> - Failure to create work dir
>>
>> Verify that overlay is mounted read-only and that it cannot
>> be remounted rw.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  tests/overlay/035     | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/035.out |  5 +++
>>  tests/overlay/group   |  1 +
>>  3 files changed, 93 insertions(+)
>>  create mode 100755 tests/overlay/035
>>  create mode 100644 tests/overlay/035.out
>>
>> diff --git a/tests/overlay/035 b/tests/overlay/035
>> new file mode 100755
>> index 0000000..e3fbed7
>> --- /dev/null
>> +++ b/tests/overlay/035
>> @@ -0,0 +1,87 @@
>> +#! /bin/bash
>> +# FS QA Test 035
>> +#
>> +# Test cases that force read-only mount
>> +#
>> +# - No upper dir
>> +# - Failure to create work dir
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
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
>> +     cd /
>> +     $CHATTR_PROG -i $workdir
>> +     rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +_supported_fs overlay
>> +_supported_os Linux
>> +_require_scratch
>> +_require_chattr i
>> +
>> +# Remove all files from previous tests
>> +_scratch_mkfs
>> +
>> +# Create multiple lowerdirs and upperdir, workdir
>> +lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
>> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
>> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
>> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
>> +mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
>> +
>> +# Mount overlay with lower layers only.
>> +# Verify that overlay is mounted read-only and that it cannot be remounted rw.
>> +$MOUNT_PROG -t overlay -o"lowerdir=$lowerdir2:$lowerdir1" \
>> +                     $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>> +touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
>> +$MOUNT_PROG $SCRATCH_MNT -o"remount,rw" 2>&1 | _filter_scratch
>
> _scratch_remount rw 2>&1 | _filter_scratch ?

yes. that's better.

>
>> +$UMOUNT_PROG $SCRATCH_MNT
>> +
>> +# Make workdir immutable to prevent workdir re-create on mount
>> +$CHATTR_PROG +i $workdir
>> +
>> +# Mount overlay with upper and wordir and expect failure to re-create workdir.
>                                   ^^^^^^ workdir
>> +# Verify that overlay is mounted read-only and that it cannot be remounted rw.
>> +_overlay_mount_dirs $lowerdir2 $upperdir $workdir \
>> +                 $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>> +touch $SCRATCH_MNT/bar 2>&1 | _filter_scratch
>> +$MOUNT_PROG $SCRATCH_MNT -o"remount,rw" 2>&1 | _filter_scratch
>
> Same here.
>
> Otherwise test looks good to me. I can fix them at commit time if you
> think _scratch_remount is OK (it works for me in my test).
>

Sure thanks
