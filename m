From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v2 3/3] generic/470: add syncfs test
Date: Mon, 11 Dec 2017 18:03:01 +0800
Message-ID: <E541A51A-D9B3-4596-8222-453132512449@icloud.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
 <1512613327-218016-3-git-send-email-cgxu519@icloud.com>
 <20171207054418.GC2749@eguan.usersys.redhat.com>
 <423B3F2E-73F1-4B29-93D7-BC6F1AA6CCC6@icloud.com>
 <20171207071317.GE2749@eguan.usersys.redhat.com>
 <EB49C2D0-6500-4588-803F-40F4B9FA6DE3@icloud.com>
 <CAOQ4uxgiqZBKUksWv-0gomKP4Ov7NB6zUw2TdnzUz7x6VUcpUw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:30689 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbdLKLDY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Dec 2017 06:03:24 -0500
In-reply-to: <CAOQ4uxgiqZBKUksWv-0gomKP4Ov7NB6zUw2TdnzUz7x6VUcpUw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2017=C4=EA12=D4=C27=C8=D5=A3=AC=CF=C2=CE=E74:17=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Thu, Dec 7, 2017 at 9:42 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>> =D4=DA 2017=C4=EA12=D4=C27=C8=D5=A3=AC=CF=C2=CE=E73:13=A3=ACEryu Guan =
<eguan@redhat.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Thu, Dec 07, 2017 at 02:20:26PM +0800, Chengguang Xu wrote:
>>>>>=20
>>>>> =D4=DA 2017=C4=EA12=D4=C27=C8=D5=A3=AC=CF=C2=CE=E71:44=A3=ACEryu =
Guan <eguan@redhat.com> =D0=B4=B5=C0=A3=BA
>>>>>=20
>>>>> On Thu, Dec 07, 2017 at 10:22:07AM +0800, Chengguang Xu wrote:
>>>>>> Inspired by syncfs bug of overlayfs which does not sync =
dirtyinodes in
>>>>>> underlying filesystem.
>>>>>> Run syncfs and shutdown filesystem(or underlying filesystem of =
overlayfs)
>>>>>> to check syncfs result.
>>>>>>=20
>>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>>> ---
>>>>>>=20
>>>>>> Changes since v1:
>>>>>> Use fs shutdown and fssum to check syncfs result instead of
>>>>>> checking delalloc state of extents.
>>>>>>=20
>>>>>> tests/generic/470     | 88 =
+++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>> tests/generic/470.out |  2 ++
>>>>>> tests/generic/group   |  1 +
>>>>>> 3 files changed, 91 insertions(+)
>>>>>> create mode 100755 tests/generic/470
>>>>>> create mode 100644 tests/generic/470.out
>>>>>>=20
>>>>>> diff --git a/tests/generic/470 b/tests/generic/470
>>>>>> new file mode 100755
>>>>>> index 0000000..b488747
>>>>>> --- /dev/null
>>>>>> +++ b/tests/generic/470
>>>>>> @@ -0,0 +1,88 @@
>>>>>> +#! /bin/bash
>>>>>> +# FS QA Test 470
>>>>>> +#
>>>>>> +# Inspired by syncfs bug of overlayfs which does not sync dirty =
inodes in
>>>>>> +# underlying filesystem.
>>>>>=20
>>>>> Trailing whitespace in above line.
>>>>>=20
>>>>>> +#
>>>>>> +# Run syncfs and shutdown filesystem(or underlying filesystem of =
overlayfs)
>>>>>> +# to check syncfs result.
>>>>>> +#
>>>>>> +# Test will be skipped if filesystem(or underlying filesystem of =
overlayfs)
>>>>>> +# does not support shutdown.
>>>>>> +#
>>>>>> =
+#-----------------------------------------------------------------------
>>>>>> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>
>>>>>> +# All Rights Reserved.
>>>>>> +#
>>>>>> +# This program is free software; you can redistribute it and/or
>>>>>> +# modify it under the terms of the GNU General Public License as
>>>>>> +# published by the Free Software Foundation.
>>>>>> +#
>>>>>> +# This program is distributed in the hope that it would be =
useful,
>>>>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>>> +# GNU General Public License for more details.
>>>>>> +#
>>>>>> +# You should have received a copy of the GNU General Public =
License
>>>>>> +# along with this program; if not, write the Free Software =
Foundation,
>>>>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  =
USA
>>>>>> =
+#-----------------------------------------------------------------------
>>>>>> +#
>>>>>> +
>>>>>> +seq=3D`basename $0`
>>>>>> +seqres=3D$RESULT_DIR/$seq
>>>>>> +echo "QA output created by $seq"
>>>>>> +
>>>>>> +here=3D`pwd`
>>>>>> +tmp=3D/tmp/$$
>>>>>> +status=3D1
>>>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>>>> +
>>>>>> +_cleanup()
>>>>>> +{
>>>>>> +  cd /
>>>>>> +  rm -f $tmp.*
>>>>>> +}
>>>>>> +
>>>>>> +# get standard environment, filters and checks
>>>>>> +. ./common/rc
>>>>>> +. ./common/filter
>>>>>> +
>>>>>> +# remove previous $seqres.full before test
>>>>>> +rm -f $seqres.full
>>>>>> +
>>>>>> +# real QA test starts here
>>>>>> +
>>>>>> +_supported_fs generic
>>>>>> +_supported_os Linux
>>>>>> +_require_test
>>>>>> +_require_fssum
>>>>>> +_require_scratch
>>>>>> +_require_scratch_shutdown
>>>>>> +_require_xfs_io_command "syncfs"
>>>>>> +
>>>>>> +
>>>>>> +FCNT=3D1000
>>>>>> +
>>>>>> +_scratch_mkfs >/dev/null 2>&1
>>>>>> +_scratch_mount
>>>>>> +
>>>>>> +# In order to mitigate interference of write-back,
>>>>>> +# create many files for test.
>>>>>=20
>>>>> Sorry, I still don't understand how writeback could interfere this =
test
>>>>> from this comment, what happens if we don't create such files? Why
>>>>> writing files starting from offset 1k?
>>>>=20
>>>> There is no explicit explanation how writeback interferes this =
case,
>>>> also there are many triggers make writeback starts syncing work.
>>>> I just want to increase hit ratio of failure by make many test =
files,
>>>> as many as possible, but it=A1=AFs also limited by time and other =
resource.
>>>>=20
>>>> The reason of offset 1k is same as above, compare to test a normal =
file,
>>>> I think file with hole can increase failure ratio sometimes.
>>>=20
>>> Yeah, increasing the reproducibility would be a good reason too. Do =
you
>>> happen to tune the number of files to see if 1000 is a good fit? =
e.g.
>>> with 100 files test reproduced the overlay bug 20% of times, with =
1000
>>> files the reproducibility increased to 80%, etc. And the hole in the
>>> beginning too, what's the actual impact on the reproducibility?
>>>=20
>>> And you're right about the test time, usually we want to balance =
between
>>> test time and reproducibility too, so we need to tune and measure =
the
>>> numbers like test files, loop counts etc.
>>>=20
>>> I think these are all good comments for test :)
>>=20
>> I didn=A1=AFt do much accurate testing about reproducibility, and =
also don=A1=AFt have
>> a plan to do that. Actually in my testing ENV, the BUG is always =
reproducible
>> even for only a few of test files.
>=20
> What is the underlying fs you are testing with?

I usually use xfs as underlying.

>=20
>> 1000 is just my definition for
>> quite many files, and it=A1=AFs really hard and meaningless to guess =
what number is
>> best suit for variety of testing ENVs. So if you think the number =
1000 is
>> improper number, then I can modify it to right number that you think. =
Hole is
>> the same.
>>=20
>=20
> I agree with Eryu that you should not invent numbers, unless test =
completes
> in a few seconds and reproduces reliably - then you can invent =
numbers...
>=20
> But this got me thinking about the details of overlayfs syncfs bug.
> Overlayfs syncfs *will* actually call underlying fs syncfs (I fixed =
that)
> but *will not* flush dirty inode data. What that means depends on
> the underlying fs. For ext4 with default jounal=3Dordered, syncfs will
> commit uncommitted journal transactions to disk, that will force data =
writeback
> for all inodes, whose *metadata* is modified in uncommitted =
transactions.
>=20
> Ted, please correct me if I am wrong.
>=20
> For xfs, situation is a bit different, create operations are also =
delayed,
> so your test could fail on overlayfs over xfs more easily.
>=20
> I think that means that if you create the files and write them in the =
same
> transaction, syncfs *will* actually sync on inodes data, so it is =
anyway
> only the very last files that you write that won't be flushed no =
matter how
> many files you will write.
> What you should try to do to increase the changes of the bug on more =
fs:
> - create new files and truncate them to final size but leaving them =
sparse
> - sync
> - buffered write to all files
> - syncfs
> - shutdown
> - cycle_mount
>=20
> The rules for choosing the right amount of files/data should be:
> - After first sync, all inodes in the system is not dirty
> - During the time it takes to write all files, flusher thread may kick =
in
>  (default 30 seconds), flush data of your tests files and interfere =
with
>  the test. Lets rule out another user doing sync, because most test
>  machines are VMs that just run the tests
> - If one loop iteration of the test above takes less than X second for =
a
>  valid fs on a slow disk, then if flusher thread does interfere, its
>  interference will be over in less then X second
>  (because we are the only ones dirtying data on the system).
> - If X < 10 seconds, then running 2 or 3 loops of the iteration should
>  be enough to guaranty that we run at least one iteration without
>  interference.

I did more detail tests for three different data modes of ext4 and found
the overlayfs syncfs bug is reproducible on data=3Dordered and =
data=3Dwriteback,
but on data=3Djournal mode, data is flushed and correct. I only wrote =
only a few words
to a single file and the bug is always reproducible on my test =
environment.=20

For writeback interferences, AFAIK, from dirty ratio and period.
If we drop all dirty caches & sync before the test, I think we can
avoid interference from it.

So if we don=A1=AFt have anything else to interference test result,=20
I just want to modify to write a small single file as test target.

Am I missing anything?

>=20
> So I think if you actually write as little files and data as possible,
> but loop several times.
> IMO, tune the parameters, so an iteration takes ~1 second on slow disk
> and run 3 iterations.
> I have a test setup with spinning disk I can run your test on xfs/ext4 =
if
> you like more samples then your own test environment.
>=20
> And please write comments about those heuristics...
>=20
> Thanks,
> Amir.
