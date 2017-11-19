From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V3] overlay: Test consistent st_ino numbers for non-samefs scenario
Date: Sun, 19 Nov 2017 13:30:03 +0200
Message-ID: <CAOQ4uxiey0b9wdsteUr38nEtzJ8j5ELwRUy+1YU8NBVRH8Y44w@mail.gmail.com>
References: <20171118055700.17442-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxgDO+32gU_WvOKgg=ex1j-+gVX3EUfMiMG-o+CrUog72w@mail.gmail.com> <20171119111119.GE2749@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:41037 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdKSLaE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Nov 2017 06:30:04 -0500
In-Reply-To: <20171119111119.GE2749@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Sun, Nov 19, 2017 at 1:11 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Sat, Nov 18, 2017 at 10:33:34PM +0200, Amir Goldstein wrote:
>> On Sat, Nov 18, 2017 at 7:57 AM, Chandan Rajendra
>> <chandan@linux.vnet.ibm.com> wrote:
>> > This commit adds a test to verify consistent st_ino feature when
>> > the overlayfs instance is composed of two different underlying
>> > filesystem instances.
>> >
>> > For example,
>> > $ mount -t xfs /dev/loop0 /mnt/test
>> > $ mount -t xfs /dev/loop1 /mnt/scratch
>> > $ mkdir /mnt/scratch/upper
>> > $ mkdir /mnt/scratch/work
>> > $ mount -t overlay overlay -o lowerdir=/mnt/test \
>> >         -o upperdir=/mnt/scratch/upper \
>> >         -o workdir=/mnt/scratch/work /mnt/merge
>> >
>> > The goal of this test is to verify that overlayfs returns consistent
>> > st_ino for the following scenarios,
>> > - Copy-up of lowerdir files
>> > - Rename files and drop dentry/inode cache
>> > - Remount the overlayfs instance
>> >
>> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>
>> Looks good.
>>
>> I reviewed and verified that all test you modified and added work as expected
>> with index=on/off (does not change result) and with/without 32bit inode/xino
>> (new tests fail on 64 ino and pass with 32bit ino or -o xino)
>>
>> For Eryu, it would have been more clear if you posted this test in
>> the same series as 017,018,044 and re-post the "t_dir_type strtoul" change
>
> I've taken the "t_dir_type strtoul" patch and am about to push new
> patches to upstream for this week's update.
>

Reading back my email, I would like to clarify one point:
All old and new "nonsmaefs" tests (041,043,044) are expected to
fail on current upstream master.

My statement regarding those tests passing on 32bit ino fs
was referring to kernel with my ovl-xino patches, which are RFC
patches at this point.

Thanks,
Amir.
