From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay/038: Miscellaneous fixes
Date: Sun, 15 Oct 2017 16:10:10 +0300
Message-ID: <CAOQ4uxh9tbhaOa+=qkBngq_ZydbYrHn=g2H7AAS3EcM3HuxrJQ@mail.gmail.com>
References: <20171008112535.18975-1-chandan@linux.vnet.ibm.com> <CAOQ4uxgJrexT9AHe4rKD-AQhsd70EyFLn2tFW++4MEUQfpP+Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33754 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbdJONKL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Oct 2017 09:10:11 -0400
In-Reply-To: <CAOQ4uxgJrexT9AHe4rKD-AQhsd70EyFLn2tFW++4MEUQfpP+Jw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Sun, Oct 8, 2017 at 9:39 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sun, Oct 8, 2017 at 2:25 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
>> This commit removes the redundant chown operation which was supposed to
>> cause the test file to be copied up. Also, _overlay_scratch_unmount() is
>> used to unmount the overlay filesystem rather than invoking $UMOUNT_PROG.
>>
>> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> ---
>>  tests/overlay/038 | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/tests/overlay/038 b/tests/overlay/038
>> index 57281fa..148995b 100755
>> --- a/tests/overlay/038
>> +++ b/tests/overlay/038
>> @@ -1,7 +1,7 @@
>>  #! /bin/bash
>>  # FSQA Test No. 038
>>  #
>> -# Test constant d_ino numbers
>> +# Test consistent d_ino numbers for samefs setup.
>>  #
>>  #-----------------------------------------------------------------------
>>  #
>> @@ -102,10 +102,8 @@ current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
>>  [[ $current_d == ". d" ]] || \
>>      echo "Before dir becomes impure: Invalid d_ino reported for ."
>>
>> -chown -h 100 $SCRATCH_MNT/test_file
>> -test_file_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_file)
>> -
>>  mv $SCRATCH_MNT/test_file $impure_dir
>> +test_file_st_ino=$(stat -c '%i' $impure_dir/test_file)
>>
>>  impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impure' \
>>                         $upperdir/test_dir/impure_dir)
>> @@ -187,7 +185,7 @@ parent_d=$($here/src/t_dir_type $SCRATCH_MNT/test_dir/pure_lower_dir $test_dir_s
>>  [[ $parent_d == ".. d" ]] || \
>>         echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
>>
>> -$UMOUNT_PROG $SCRATCH_MNT
>> +_overlay_scratch_unmount
>>
>
> Neither variant is really needed at end of test but fine.
>

This got merged with _overlay_scratch_unmount which is not intended to be used
directly. I overlooked this in review. Not really a problem though.
Should probably remove this final umount from the test in a cleanup patch.

Amir.
