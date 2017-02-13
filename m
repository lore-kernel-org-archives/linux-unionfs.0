From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 9/9] overlay: mount/unmount base fs before/after
 running tests
Date: Mon, 13 Feb 2017 13:59:37 +0200
Message-ID: <CAOQ4uxgEayyD_wVzqz+Z8h-Ee2n_nrPPrfDxrStmOkbig+XNNQ@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-10-git-send-email-amir73il@gmail.com> <20170213113138.GI24562@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33969 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdBML7i (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Feb 2017 06:59:38 -0500
In-Reply-To: <20170213113138.GI24562@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Mon, Feb 13, 2017 at 1:31 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Sun, Feb 12, 2017 at 10:43:44PM +0200, Amir Goldstein wrote:
>> When TEST/SCRATCH_DEV are configured to the base fs block device,
>> use this information to mount base fs before running tests,
>> unmount it after running tests and cycle on _test_cycle_mount
>> along with the overlay mounts.
>>
>> This helps catching overlayfs bugs related to leaking objects in
>> underlying (base) fs.
>>
>> To preserve expected tests behavior, the semantics are:
>> - _scratch_mkfs mounts the base fs, cleans all files, creates
>>   lower/upper dirs and keeps base fs mounted
>> - _scratch_mount mounts base fs (if needed) and mounts overlay
>> - _scratch_unmount unmounts overlay and base fs
>>
>> Tests that use _scratch_unmount to unmount a custom overlay mount
>> and expect to have access to overlay base dir, were fixed to use
>> explicit umount $SCRATCH_MNT instead.
>>
>> The overlay test itself, does not support formatting the base fs.
>> However, it is possible to add overlay sections to a multi section
>> config file after every base fs configuration, to run the overlay
>> tests with the file system that was created on the test partitions
>> in the previous section (see example in README.config-sections).
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  README.config-sections |  6 ++++++
>>  common/rc              | 55 ++++++++++++++++++++++++++++++++++++++++++++++++--
>>  tests/overlay/003      |  3 ++-
>>  tests/overlay/004      |  3 ++-
>>  tests/overlay/014      |  5 +++--
>>  5 files changed, 66 insertions(+), 6 deletions(-)
>>
>> diff --git a/README.config-sections b/README.config-sections
>> index df7c929..d45d6da 100644
>> --- a/README.config-sections
>> +++ b/README.config-sections
>> @@ -102,6 +102,9 @@ MKFS_OPTIONS="-q -F -b4096"
>>  FSTYP=ext4
>>  RESULT_BASE="`pwd`/results/`date +%d%m%y_%H%M%S`"
>>
>> +[ext4_overlay]
>> +FSTYP=overlay
>> +
>>  [ext4_1k_block_size]
>>  MKFS_OPTIONS="-q -F -b1024"
>>
>> @@ -112,6 +115,9 @@ MKFS_OPTIONS="-q -F -b4096 -O ^has_journal"
>>  MKFS_OPTIONS="-f"
>>  FSTYP=xfs
>>
>> +[xfs_overlay]
>> +FSTYP=overlay
>> +
>>  [ext3_filesystem]
>>  FSTYP=ext3
>>  MOUNT_OPTIONS="-o noatime"
>> diff --git a/common/rc b/common/rc
>> index 74168ea..e9ac0df 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -328,24 +328,70 @@ _overlay_mount()
>>                           $SELINUX_MOUNT_OPTIONS $* $dir $mnt
>>  }
>>
>> +_overlay_base_test_mount()
>> +{
>> +     if [ -z "$OVL_BASE_TEST_DEV" -o -z "$OVL_BASE_TEST_DIR" ] || \
>> +             _check_mounted_on OVL_BASE_TEST_DEV $OVL_BASE_TEST_DEV \
>> +                             OVL_BASE_TEST_DIR $OVL_BASE_TEST_DIR
>> +     then
>> +             return 0
>> +     fi
>> +
>> +     _mount $OVL_BASE_MOUNT_OPTIONS \
>
> OVL_BASE_MOUNT_OPTIONS is from MOUNT_OPTIONS, which is used for scratch
> mount. Do we need a ovl base counter part of TEST_FS_MOUNT_OPTS?
>

I suggest that we change this line to:
+     _mount $TEST_FS_MOUNT_OPTS \

MOUNT_OPTIONS in config is used for base scratch mount options
TEST_FS_MOUNT_OPTS in config is used for base test mount options.
OVERLAY_MOUNT_OPTIONS in config is used for both scratch and test overlay mounts

The only case where TEST_FS_MOUNT_OPTS is configured not by user is
for cifs and cheph (in _test_mount_opts) and I don't think that those fs
can be used as overlay base fs. can they?

Good enough?
