From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay: stress test changes to top and bottom layers simultaneously
Date: Thu, 8 Dec 2016 08:37:58 +0200
Message-ID: <CAOQ4uxhKvQKMqUtGS+meRyt3WRzH=-DkGndCqmEUD1d+v1_Dog@mail.gmail.com>
References: <20161208035844.18544-1-tytso@mit.edu> <20161208043739.GF29149@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:36528 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932221AbcLHGiA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Dec 2016 01:38:00 -0500
In-Reply-To: <20161208043739.GF29149@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>, Theodore Ts'o <tytso@mit.edu>
Cc: fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Thu, Dec 8, 2016 at 6:37 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Dec 07, 2016 at 10:58:44PM -0500, Theodore Ts'o wrote:
>> Introduce a test which runs fsstress on the top and bottom overlayfs
>> directories simultaneously to find potential races that plagued wrapfs
>> derived file systems.
>

Good idea! Ted,
do you have a reference for said races in past fs?
I am asking because it could be useful to focus on more specific
concurrent access patterns.

I think it is also very relevant to check for race with upper vs. top.
lower vs. top gives you only write/read races.
upper vs. top gives you also write/write races.

I am not that familiar with fsstress modes, but I suppose it is possible
to setup a work set in lower before starting the concurrent access test.
I have a feeling that would be beneficial to catching yet another class of bugs.

> I'm not sure if overlayfs supports doing changes to lowerdir when
> overlay is mounted. cc'ed linux-unionfs@vger.kernel.org for some inputs.
>
> But from kernel Documentation:
>
> "Changes to the underlying filesystems while part of a mounted overlay
> filesystem are not allowed.  If the underlying filesystem is changed,
> the behavior of the overlay is undefined, though it will not result in
> a crash or deadlock."
>
> So at least kernel should not crash or deadlock.
>

Yes, that is the only thing that this test should be verifying.

>>
>> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>> ---
>>  tests/overlay/017     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/017.out |  2 ++
>>  tests/overlay/group   |  1 +
>>  3 files changed, 84 insertions(+)
>>  create mode 100755 tests/overlay/017
>>  create mode 100644 tests/overlay/017.out
>>
>> diff --git a/tests/overlay/017 b/tests/overlay/017
>> new file mode 100755
>> index 00000000..1dbde766
>> --- /dev/null
>> +++ b/tests/overlay/017
>> @@ -0,0 +1,81 @@
>> +#! /bin/bash
>> +# FS QA Test 017
>> +#
>> +# Run fsstress on lower dir and top dir at the same time
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
>> +lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
>> +mkdir -p $lowerdir
>> +
>> +_scratch_mount
>> +
>> +echo "Silence is golden"
>> +
>> +d_low=$lowerdir/fsstress
>> +d_top=$SCRATCH_MNT/fsstress
>> +mkdir -p $d_low $d_top
>
> I think you need to create $d_low before mounting overlayfs. As online
> changes to lower dir is not supported. e.g.
>
> lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
> d_low=$lowerdir/fsstress
> d_top=$SCRATCH_MNT/fsstress
> mkdir -p $d_low
>
> _scratch_mount
>

Correct. Although technically, the existence of $d_low is only checked
on the first access to $d_top.

>> +
>> +echo $FSSTRESS_PROG -s 42 -d $d_low -p 4 -n 1000 -l100 -v > $seqres.full.1
>> +$FSSTRESS_PROG -s 42 -d $d_low -p 4 -n 1000 -l100 -v >> $seqres.full.1 2>&1 &
>> +
>> +echo $FSSTRESS_PROG -s 42 -d $d_top -p 4 -n 1000 -l100 -v > $seqres.full.2
>> +$FSSTRESS_PROG -s 42 -d $d_top -p 4 -n 1000 -l100 -v >> $seqres.full.2 2>&1 &
>> +
>> +ret=0
>> +if ! wait %1
>> +then
>> +        echo "--------------------------------------"       >>$seqres.full.1
>> +     echo "fsstress on lower directory returned $? - see $seqres.full.1"
>> +        echo "--------------------------------------"       >>$seqres.full.1
>> +     ret=1
>> +fi
>> +
>> +if ! wait %2
>> +then
>> +        echo "--------------------------------------"       >>$seqres.full.2
>> +     echo "fsstress on overlay directory returned $? - see $seqres.full.2"
>> +        echo "--------------------------------------"       >>$seqres.full.2
>> +     ret=1
>> +fi
>
> I'm not sure if we can depend on the return status from fsstress, as the
> documentation says this results in undefined behavior. I think we can
> skip all the return value check and set status to 0 and exit as long as
> fsstress processes exit and don't crash or deadlock the kernel.
>
>> +
>> +cat $seqres.full.1 $seqres.full.2 > $seqres.full
>> +rm $seqres.full.1 $seqres.full.2
>> +
>> +if [ "$ret" -eq 1 ]
>> +then
>> +     status=1
>> +else
>> +     status=0
>> +fi
>> +
>> +exit $status
>> diff --git a/tests/overlay/017.out b/tests/overlay/017.out
>> new file mode 100644
>> index 00000000..82228448
>> --- /dev/null
>> +++ b/tests/overlay/017.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 017
>> +Silence is golden
>> diff --git a/tests/overlay/group b/tests/overlay/group
>> index 5740d2a2..b310aebe 100644
>> --- a/tests/overlay/group
>> +++ b/tests/overlay/group
>> @@ -19,3 +19,4 @@
>>  014 auto quick copyup
>>  015 auto quick whiteout
>>  016 auto quick
>> +017 auto quick
>
> It runs for 10 minutes, not a "quick" test :)
>
> Thanks,
> Eryu
>> --
>> 2.11.0.rc0.7.gbe5a750
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
