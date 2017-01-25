From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH] common: mount overlay base fs for running tests
Date: Wed, 25 Jan 2017 12:33:06 +0200
Message-ID: <CAOQ4uxhivG451A0Oh_ajYcto03FVM87OOFR9ffb+dnPWe5mZHA@mail.gmail.com>
References: <1485327084-26190-1-git-send-email-amir73il@gmail.com> <20170125100535.GI1859@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33536 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdAYKdH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Jan 2017 05:33:07 -0500
In-Reply-To: <20170125100535.GI1859@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Wed, Jan 25, 2017 at 12:05 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Jan 25, 2017 at 08:51:24AM +0200, Amir Goldstein wrote:
>> Instead of setting the fake TEST/SCRATCH_DEV vars to existing overlay
>> directories, allow setting the vars OVERLAY_BASE_DEV/MNT, to configure
>> the base fs where overlay directories are created. For example:
>>
>> -export TEST_DEV=/mnt/xfs/ovl/test
>> -export SCRATCH_DEV=/mnt/xfs/ovl/scratch
>> +export OVERLAY_BASE_DEV=/dev/mapper/test-xfs
>> +export OVERLAY_BASE_MNT=/mnt/xfs
>> export TEST_DIR=/mnt/test
>> export SCRATCH_MNT=/mnt/scratch
>> export FSTYP=overlay
>>
>> With this change, the base fs is mounted before running the tests
>> unmounted after running the tests and recycled on _test_cycle_mount.
>> This helps catching overlayfs bugs related to leaking objects in
>> underlying (base) fs.
>
> This looks useful to me, actually overlay/005 is one test that is
> testing a memleak bug, but it uses loop device as a underlying fs and
> umount the loop dev to trigger memleak bug.
>
> But having two methods to config overlayfs testing worries me a bit, it
> can be confusing to users. At least we should document them well.
> Perhaps eventually we can kill the old way?
>

I would love to kill the old way and replace all explicit references to
TEST/SCRATCH_DEV as directory in tests/overlay with
TEST/SCRATCH_BASE_DIR
I'll let you define the phasing out procedure...
Let me know if you want me to add a "deprecated!!!" warning for
old style config.

>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  common/config | 35 ++++++++++++++++++++++++++++++++++-
>>  common/rc     |  8 ++++++++
>>  2 files changed, 42 insertions(+), 1 deletion(-)
>>
>> Eryu,
>>
>> I was planning to also support _test_mkfs for base fs (as kvm-xfstests does),
>> but decided to make a RFC rest stop after _test_mount, which seems useful in
>> its own right.
>
> I'm not sure about this. One down side of doing this is it introduces
> the complexity of handling FSTYP and MKFS_OPTIONS of underlying fs,
> which seems way too complex at this point. I think a user pre-mkfs'ed
> device would be sufficient?
>

Me too. That's why I stopped here.

>>
>> The main point to consider is whether it is worth separating OVERLAY_BASE_DEV
>> to test and scratch base devices. This patch (with shared dev) is much simpler
>> to configure to I am sending it out to see if folk think it is sufficiently
>> useful as is.
>
> I'd prefer separating test and scratch devices, so we have a fine
> control on them in tests. One problem with this shared dev is it's
> possible for either _overlay_test_unmount or _overlay_scratch_unmount to
> unmount the underlying fs, while the other overlay is still mounted.
>
> That's a strange behavior, I expected umount the base dev return EBUSY
> in this case, but it doesn't (but a subsequent mkfs does return EBUSY,
> so the device is not really usable).  I reported this bug in RH bugzilla
> (a private bug) and it was closed as WONTFIX.
>

Right... overlay holds a reference to a private clone of the base fs mount.
It's true that the only reason this patch is "correct" is because
there is no test
(at the moment) that calls _test_cycle_mount and also mounts scratch,
so I agree that separating is the right thing to do, I just hate the
variable names
it implies (OVERLAY_SCRATCH_BASE_DEV???)
Would you accept that I use variable names TEST/SCRATCH_BASE_* without
the OVERLAY prefix?
I guess BASE_ is a generic enough name to describe testing of any
stackable fs (e.g. ecryptfs) although I doubt anyone is going to add those.
