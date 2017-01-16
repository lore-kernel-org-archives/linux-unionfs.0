From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay: test concurrent copy up
Date: Mon, 16 Jan 2017 12:20:28 +0200
Message-ID: <CAOQ4uxgPscWvihqEnkO1dcLM3Fk6x6TnfvUdrxCFvciRmv6ipQ@mail.gmail.com>
References: <1484492478-13883-1-git-send-email-amir73il@gmail.com> <20170116091123.GG1859@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170116091123.GG1859@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jan 16, 2017 at 11:11 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Sun, Jan 15, 2017 at 05:01:18PM +0200, Amir Goldstein wrote:
>> Run 4 process pairs, each competing over copy up of 1K files
>> in 1 directory. One opponent touches all files in the directory
>> and the other truncates all files in the directory.
>>
>> This test does NOT check for concurrent copy up support. It only
>> fails on unexpected errors of any of the touch/truncate operations.
>>
>> The test full output should demonstrate the expected results -
>> for kernel with concurrent copy up support, truncate workers are
>> not delayed by touch workers. As a result, truncate workers will
>> finish their work much sooner than a test run without concurrent
>> copy up support.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  tests/overlay/021     | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/021.out |   2 +
>>  tests/overlay/group   |   1 +
>>  3 files changed, 166 insertions(+)
>>  create mode 100755 tests/overlay/021
>>  create mode 100644 tests/overlay/021.out
>>
>> Eryu,
>>
>> I wrote this test to excercise "ovl: concurrent copy up", but it does not
>> require concurrent copy up support to run, nor does it fail due to lack of
>> concurrent copy up support (it may run a bit slower), so there is nothing
>> blocking from merging this test for kernel 4.9.
>
> Agreed.
>
>>
>> Note that although I used fsstress to create/truncate a bunch of files,
>> this is by no means a stress test, so I did not add it to stress group.
>> It is rather 'quick', less than half the time of the 'quick' overlay/001.
>
> Agreed.
>
>>
>> Amir.
>>
>> diff --git a/tests/overlay/021 b/tests/overlay/021
>> new file mode 100755
>> index 0000000..405d3d0
>> --- /dev/null
>> +++ b/tests/overlay/021
>> @@ -0,0 +1,163 @@
>> +#! /bin/bash
>> +# FS QA Test 021
>> +#
>> +# test concurrent copy up
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (C) 2016 CTERA Networks. All Rights Reserved.
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
>> +
>> +# Remove all files from previous tests
>> +_scratch_mkfs
>> +
>> +# overlay copy_up doesn't deal with sparse file well, holes will be filled by
>> +# zeros, so for the worst case of hitting all the copy up bomb files, we need
>> +# (64*(16+32+64+128)M) free space on $SCRATCH_DEV.
>> +# However, triggering more than a total of 16 copy up bombs would require
>> +# really fast data copy (clone up doesn't take up space at all), so let's be
>> +# conservative and reserve space for 16 data copy ups per directory.
>> +_require_fs_space $SCRATCH_DEV $((16*(16+32+64+128)*1024))
>> +
>> +lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
>> +mkdir -p $lowerdir
>> +
>> +_scratch_mount
>> +
>> +echo "Silence is golden"
>> +
>> +testdir=arena
>> +d_low=$lowerdir/$testdir
>> +d_top=$SCRATCH_MNT/$testdir
>> +mkdir -p $d_low
>> +
>> +# Create 4K empty files in 4 directories
>> +echo $FSSTRESS_PROG -d $d_low -p 4 -z -f creat=1 -n 1024 -v >> $seqres.full
>> +$FSSTRESS_PROG -d $d_low -p 4 -z -f creat=1 -n 1024 -v >> $seqres.full 2>&1
>> +echo "--------------------------------------"       >> $seqres.full
>> +echo "Created 1K files in lower directory.  "       >> $seqres.full
>> +
>> +# Plant 64 copy up bombs in each directory
>> +for f in $d_low/p0/*0; do truncate -s 128M $f ;done
>> +for f in $d_low/p1/*4; do truncate -s 64M $f ;done
>> +for f in $d_low/p2/*8; do truncate -s 32M $f ;done
>> +for f in $d_low/p3/*b; do truncate -s 16M $f ;done
>
> Better to use $XFS_IO_PROG -c "truncate <size>" $f, some distros like
> RHEL5 don't have truncate command. RHEL5 is really old and should not be
> a big problem, but we have better choice, so why not :)
>

Oh. That's good to know.

>> +echo "Created 64*4 copy up bombs.           "       >> $seqres.full
>> +echo "--------------------------------------"       >> $seqres.full
>
> All these setups should be done before overlay is mounted, because we're
> writing to the lowerdir directly, which is undefined behavior when
> overlay is mounted. i.e. call _scratch_mount only after all these setups.
>

ok.

>> +
>> +#
>> +# Run 2 process teams - 4 pairs of rival processes
>> +# Each process pair competing on copy up of 1K files in 1 directory.
>> +# Team 'touch' players touch all files in readdir order.
>> +# Team 'truncate' players truncates all files in numeric (name) order.
>> +#
>> +# If player from team 'touch' reaches a copy up bomb before player
>> +# from team 'truncate' does, the copy up of (sparse) data will delay
>> +# the end of the process pair match.
>> +#
>> +# If copy up of bomb is not concurrent with other copy ups, then
>> +# 'touch' player p0 with the largest copy up bombs will delay players
>> +# of both teams and all matches will take longer.
>> +#
>> +# If copy up is concurrent with copy ups in different directories,
>> +# process pair 3 match will be over first and process pair 0 match
>> +# will be over last.
>> +#
>> +# If copy up of data is concurrent with other copy ups on the same directory,
>> +# then all the 'touch' team players will finish far behind their 'truncate'
>> +# opponenets.
>> +#
>> +# This test doesn't verify any of those conditions, it will only fail
>> +# on unexpected errors of any of the touch/truncate operations.
>> +# The test full output should demonstrate the expected game results,
>> +# as described above and depending on concurrent copy up support in kernel.
>> +#
>> +cd $d_top
>> +echo "--------------------------------------"       >> $seqres.full
>> +echo "Go team touch!!                       "       >> $seqres.full
>> +find p0 -type f -print -exec touch {} \; >> $seqres.full 2>&1 &
>> +find p1 -type f -print -exec touch {} \; >> $seqres.full 2>&1 &
>> +find p2 -type f -print -exec touch {} \; >> $seqres.full 2>&1 &
>> +find p3 -type f -print -exec touch {} \; >> $seqres.full 2>&1 &
>
> find seems not returning non-zero if touch fails. I did this experiment
> and find always returned 0.
>
> # create 16 empty files
> ./ltp/fsstress -d testdir -p 1 -z -f creat=1 -n 16
>
> # make all files immutable
> find testdir -type f -exec chattr +i {} \;
>
> # touch all files, touch should report "Operation not permitted", and
> # check return status of find
> find testdir -type f -print -exec touch {} \;
> echo $?
>
>
> So how about letting stderr break golden image when touch error happens?
>
> find p0 -type f -print -exec touch {} \; >> $seqres.full &
>

Yes. Good idea.

>> +cd - > /dev/null
>> +
>> +# Give team 'touch' a 1 second head start.
>> +# Team 'truncate' players should catch up after few copy up bombs.
>> +sleep 1
>> +echo "--------------------------------------"       >> $seqres.full
>> +echo "Go team truncate!!                    "       >> $seqres.full
>> +# Give team 'touch' a 1 second head start.
>> +# Team 'truncate' players should catch up after few copy up bombs.
>> +sleep 1
>
> Redundant "sleep 1" and comments?
>

oops.

>> +$FSSTRESS_PROG -d $d_top -p 4 -z -f creat=1 -n 1024 -v >> $seqres.full 2>&1 &
>> +
>> +err=0
>> +if ! wait %1; then
>> +     echo "Player p0/touch returned $? - see $seqres.full"
>> +     err=1
>> +fi
>> +
>> +if ! wait %2; then
>> +     echo "Player p1/touch returned $? - see $seqres.full"
>> +     err=1
>> +fi
>> +
>> +if ! wait %3; then
>> +     echo "Player p2/touch returned $? - see $seqres.full"
>> +     err=1
>> +fi
>> +
>> +if ! wait %4; then
>> +     echo "Player p3/touch returned $? - see $seqres.full"
>> +     err=1
>> +fi
>
> Then no need to check job %1-4 status, if we rely on stderr of find.
>

Yes, that would be cleaner.
Thank!

> Thanks,
> Eryu
>
>> +
>> +if ! wait %5; then
>> +     echo "Team truncate returned $? - see $seqres.full"
>> +     err=1
>> +fi
>> +
>> +status=$err
>> +
>> +exit $status
>> diff --git a/tests/overlay/021.out b/tests/overlay/021.out
>> new file mode 100644
>> index 0000000..09f4062
>> --- /dev/null
>> +++ b/tests/overlay/021.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 021
>> +Silence is golden
>> diff --git a/tests/overlay/group b/tests/overlay/group
>> index 684ed45..5bcc25e 100644
>> --- a/tests/overlay/group
>> +++ b/tests/overlay/group
>> @@ -23,3 +23,4 @@
>>  018 auto quick copyup
>>  019 auto stress
>>  020 auto quick copyup perms
>> +021 auto quick copyup
>> --
>> 2.7.4
>>
