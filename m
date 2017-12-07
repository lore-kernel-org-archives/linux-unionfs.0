From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 3/3] generic/470: add syncfs test
Date: Thu, 7 Dec 2017 10:17:51 +0200
Message-ID: <CAOQ4uxgiqZBKUksWv-0gomKP4Ov7NB6zUw2TdnzUz7x6VUcpUw@mail.gmail.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
 <1512613327-218016-3-git-send-email-cgxu519@icloud.com> <20171207054418.GC2749@eguan.usersys.redhat.com>
 <423B3F2E-73F1-4B29-93D7-BC6F1AA6CCC6@icloud.com> <20171207071317.GE2749@eguan.usersys.redhat.com>
 <EB49C2D0-6500-4588-803F-40F4B9FA6DE3@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:45451 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752182AbdLGIRw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 03:17:52 -0500
In-Reply-To: <EB49C2D0-6500-4588-803F-40F4B9FA6DE3@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Dec 7, 2017 at 9:42 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> =E5=9C=A8 2017=E5=B9=B412=E6=9C=887=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=883:=
13=EF=BC=8CEryu Guan <eguan@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Thu, Dec 07, 2017 at 02:20:26PM +0800, Chengguang Xu wrote:
>>>>
>>>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=887=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=
=881:44=EF=BC=8CEryu Guan <eguan@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>
>>>> On Thu, Dec 07, 2017 at 10:22:07AM +0800, Chengguang Xu wrote:
>>>>> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes i=
n
>>>>> underlying filesystem.
>>>>> Run syncfs and shutdown filesystem(or underlying filesystem of overla=
yfs)
>>>>> to check syncfs result.
>>>>>
>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>> ---
>>>>>
>>>>> Changes since v1:
>>>>> Use fs shutdown and fssum to check syncfs result instead of
>>>>> checking delalloc state of extents.
>>>>>
>>>>> tests/generic/470     | 88 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++
>>>>> tests/generic/470.out |  2 ++
>>>>> tests/generic/group   |  1 +
>>>>> 3 files changed, 91 insertions(+)
>>>>> create mode 100755 tests/generic/470
>>>>> create mode 100644 tests/generic/470.out
>>>>>
>>>>> diff --git a/tests/generic/470 b/tests/generic/470
>>>>> new file mode 100755
>>>>> index 0000000..b488747
>>>>> --- /dev/null
>>>>> +++ b/tests/generic/470
>>>>> @@ -0,0 +1,88 @@
>>>>> +#! /bin/bash
>>>>> +# FS QA Test 470
>>>>> +#
>>>>> +# Inspired by syncfs bug of overlayfs which does not sync dirty inod=
es in
>>>>> +# underlying filesystem.
>>>>
>>>> Trailing whitespace in above line.
>>>>
>>>>> +#
>>>>> +# Run syncfs and shutdown filesystem(or underlying filesystem of ove=
rlayfs)
>>>>> +# to check syncfs result.
>>>>> +#
>>>>> +# Test will be skipped if filesystem(or underlying filesystem of ove=
rlayfs)
>>>>> +# does not support shutdown.
>>>>> +#
>>>>> +#-------------------------------------------------------------------=
----
>>>>> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>
>>>>> +# All Rights Reserved.
>>>>> +#
>>>>> +# This program is free software; you can redistribute it and/or
>>>>> +# modify it under the terms of the GNU General Public License as
>>>>> +# published by the Free Software Foundation.
>>>>> +#
>>>>> +# This program is distributed in the hope that it would be useful,
>>>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>> +# GNU General Public License for more details.
>>>>> +#
>>>>> +# You should have received a copy of the GNU General Public License
>>>>> +# along with this program; if not, write the Free Software Foundatio=
n,
>>>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>>>> +#-------------------------------------------------------------------=
----
>>>>> +#
>>>>> +
>>>>> +seq=3D`basename $0`
>>>>> +seqres=3D$RESULT_DIR/$seq
>>>>> +echo "QA output created by $seq"
>>>>> +
>>>>> +here=3D`pwd`
>>>>> +tmp=3D/tmp/$$
>>>>> +status=3D1
>>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>>> +
>>>>> +_cleanup()
>>>>> +{
>>>>> +  cd /
>>>>> +  rm -f $tmp.*
>>>>> +}
>>>>> +
>>>>> +# get standard environment, filters and checks
>>>>> +. ./common/rc
>>>>> +. ./common/filter
>>>>> +
>>>>> +# remove previous $seqres.full before test
>>>>> +rm -f $seqres.full
>>>>> +
>>>>> +# real QA test starts here
>>>>> +
>>>>> +_supported_fs generic
>>>>> +_supported_os Linux
>>>>> +_require_test
>>>>> +_require_fssum
>>>>> +_require_scratch
>>>>> +_require_scratch_shutdown
>>>>> +_require_xfs_io_command "syncfs"
>>>>> +
>>>>> +
>>>>> +FCNT=3D1000
>>>>> +
>>>>> +_scratch_mkfs >/dev/null 2>&1
>>>>> +_scratch_mount
>>>>> +
>>>>> +# In order to mitigate interference of write-back,
>>>>> +# create many files for test.
>>>>
>>>> Sorry, I still don't understand how writeback could interfere this tes=
t
>>>> from this comment, what happens if we don't create such files? Why
>>>> writing files starting from offset 1k?
>>>
>>> There is no explicit explanation how writeback interferes this case,
>>> also there are many triggers make writeback starts syncing work.
>>> I just want to increase hit ratio of failure by make many test files,
>>> as many as possible, but it=E2=80=99s also limited by time and other re=
source.
>>>
>>> The reason of offset 1k is same as above, compare to test a normal file=
,
>>> I think file with hole can increase failure ratio sometimes.
>>
>> Yeah, increasing the reproducibility would be a good reason too. Do you
>> happen to tune the number of files to see if 1000 is a good fit? e.g.
>> with 100 files test reproduced the overlay bug 20% of times, with 1000
>> files the reproducibility increased to 80%, etc. And the hole in the
>> beginning too, what's the actual impact on the reproducibility?
>>
>> And you're right about the test time, usually we want to balance between
>> test time and reproducibility too, so we need to tune and measure the
>> numbers like test files, loop counts etc.
>>
>> I think these are all good comments for test :)
>
> I didn=E2=80=99t do much accurate testing about reproducibility, and also=
 don=E2=80=99t have
> a plan to do that. Actually in my testing ENV, the BUG is always reproduc=
ible
> even for only a few of test files.

What is the underlying fs you are testing with?

> 1000 is just my definition for
> quite many files, and it=E2=80=99s really hard and meaningless to guess w=
hat number is
> best suit for variety of testing ENVs. So if you think the number 1000 is
> improper number, then I can modify it to right number that you think. Hol=
e is
> the same.
>

I agree with Eryu that you should not invent numbers, unless test completes
in a few seconds and reproduces reliably - then you can invent numbers...

But this got me thinking about the details of overlayfs syncfs bug.
Overlayfs syncfs *will* actually call underlying fs syncfs (I fixed that)
but *will not* flush dirty inode data. What that means depends on
the underlying fs. For ext4 with default jounal=3Dordered, syncfs will
commit uncommitted journal transactions to disk, that will force data write=
back
for all inodes, whose *metadata* is modified in uncommitted transactions.

Ted, please correct me if I am wrong.

For xfs, situation is a bit different, create operations are also delayed,
so your test could fail on overlayfs over xfs more easily.

I think that means that if you create the files and write them in the same
transaction, syncfs *will* actually sync on inodes data, so it is anyway
only the very last files that you write that won't be flushed no matter how
many files you will write.
What you should try to do to increase the changes of the bug on more fs:
- create new files and truncate them to final size but leaving them sparse
- sync
- buffered write to all files
- syncfs
- shutdown
- cycle_mount

The rules for choosing the right amount of files/data should be:
- After first sync, all inodes in the system is not dirty
- During the time it takes to write all files, flusher thread may kick in
  (default 30 seconds), flush data of your tests files and interfere with
  the test. Lets rule out another user doing sync, because most test
  machines are VMs that just run the tests
- If one loop iteration of the test above takes less than X second for a
  valid fs on a slow disk, then if flusher thread does interfere, its
  interference will be over in less then X second
  (because we are the only ones dirtying data on the system).
- If X < 10 seconds, then running 2 or 3 loops of the iteration should
  be enough to guaranty that we run at least one iteration without
  interference.

So I think if you actually write as little files and data as possible,
but loop several times.
IMO, tune the parameters, so an iteration takes ~1 second on slow disk
and run 3 iterations.
I have a test setup with spinning disk I can run your test on xfs/ext4 if
you like more samples then your own test environment.

And please write comments about those heuristics...

Thanks,
Amir.
