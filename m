From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/9] fstests: sanity check that test partitions are not
 mounted elsewhere
Date: Mon, 13 Feb 2017 15:33:23 +0200
Message-ID: <CAOQ4uxg-DS7+j0DLLr20nZGrA6752D2ZUhfQeHPz5hGDb=DRfA@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-2-git-send-email-amir73il@gmail.com> <20170213111053.GF24562@eguan.usersys.redhat.com>
 <CAOQ4uxiWwVCN07yxwWQbp5Yi011TYV509RqWov9+szJnmP5NkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33103 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752684AbdBMNdZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Feb 2017 08:33:25 -0500
In-Reply-To: <CAOQ4uxiWwVCN07yxwWQbp5Yi011TYV509RqWov9+szJnmP5NkA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Mon, Feb 13, 2017 at 1:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Feb 13, 2017 at 1:10 PM, Eryu Guan <eguan@redhat.com> wrote:
>> On Sun, Feb 12, 2017 at 10:43:36PM +0200, Amir Goldstein wrote:
>>> When $TEST_DEV is mounted at a different location then $TEST_DIR,
>>> _require_test() aborts the test with an error:
>>>  TEST_DEV=/dev/sda5 is mounted but not on TEST_DIR=/mnt/test
>>>
>>> There are several problems with current sanity check:
>>> 1. the output of the error is mixed into out.bad and hard to see
>>> 2. the test partition is unmounted at the end of the test regardless
>>>    of the fact that it not pass the sanity that we have exclusivity
>>> 3. scratch partition has a similar sanity check in _require_scratch(),
>>>    but we may not get to it, because $SCRATCH_DEV is unmounted prior
>>>    to running the tests (which could unmount another mount point).
>>>
>>> To solve all these problems, introduce a helper _check_mounted_on().
>>> It checks if a device is mounted on a given mount point and optionally
>>> checks the mounted fs type.
>>>
>>> The sanity checks in _require_scratch() and _require_test() are
>>> converted to use the helper and gain the check for correct fs type.
>>>
>>> The helper is used in init_rc() to sanity check both test and scratch
>>> partitions, before tests are run and before $SCRATCH_DEV is unmounted.
>>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  common/rc | 83 +++++++++++++++++++++++++++++++++++++--------------------------
>>>  1 file changed, 49 insertions(+), 34 deletions(-)
>
> ...
>
>> My test configs look like:
>>
>> TEST_DEV=/dev/sda5
>> SCRATCH_DEV=/dev/sda6
>> TEST_DIR=/mnt/testarea/test
>> SCRATCH_MNT=/mnt/testarea/scratch
>>
>> and if I mount SCRATCH_DEV at /mnt/xfs (or some other mountpoints rather
>> than SCRATCH_MNT), ./check -overlay overlay/??? isn't able to detect
>> this mis-configuration.
>>
>> [root@dhcp-66-86-11 xfstests]# ./check  -overlay overlay/002
>> FSTYP         -- overlay
>> PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.10.0-rc7
>> MKFS_OPTIONS  -- /mnt/testarea/scratch
>> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 -o lowerdir=/mnt/testarea/scratch/ovl-lower,upperdir=/mnt/testarea/scratch/ovl-upper,workdir=/mnt/testarea/scratch/ovl-work
>>
>> [root@dhcp-66-86-11 xfstests]#
>>
>> And nothing useful was printed. This is because my rootfs has no
>> filetype support, but the _notrun message is redirected to a file in
>> check, as
>>
>> "if ! _scratch_mkfs >$tmp.err 2>&1"
>>
>> Adding _check_mounted_on against OVL_BASE_TEST/SCRATCH_DEV here could
>> fix it for me.
>>
>
> Actually, there that test already exists in:
>
> _scratch_mkfs
>   _scratch_cleanup_files
>     _overlay_base_scratch_mount
>       _check_mounted_on
>
> Only I forgot to cleanup an unneeded _overlay_base_scratch_unmount()
> from _scratch_cleanup_files()..
>
> @@ -698,8 +698,6 @@ _scratch_cleanup_files()
>         overlay)
>                 # Avoid rm -rf /* if we messed up
>                 [ -n "$OVL_BASE_SCRATCH_MNT" ] || return 1
> -               # overlay 'mkfs' needs to make sure base fs is mounted and clean
> -               _overlay_base_scratch_unmount 2>/dev/null
>                 _overlay_base_scratch_mount
>                 rm -rf $OVL_BASE_SCRATCH_MNT/*
>                 _overlay_mkdirs $OVL_BASE_SCRATCH_MNT
>
> With this patch, test does abort for _check_mounted_on() failure,
> (please verify)
> but output is still lost inside tmp.err.
> To fix this I would need to not exit 1 inside _check_mounted_on() but
> always by callers.
> Is that what you prefer that I do?

How about something more general like this:
(tested with your test case and with wipefs -a $SCRATCH_DEV):

@@ -376,6 +376,11 @@ _wrapup()
        seq="check"
        check="$RESULT_BASE/check"

+       if [ -n "$check_err" ]; then
+               echo "check: $check_err"
+               check_err=""
+       fi
+

@@ -466,6 +471,7 @@ _check_filesystems()

 _prepare_test_list

+check_err=""
 if $OPTIONS_HAVE_SECTIONS; then
        trap "_summary; exit \$status" 0 1 2 3 15
 else

@@ -567,10 +576,10 @@ for section in $HOST_OPTIONS_SECTIONS; do
          # call the overridden mkfs - make sure the FS is built
          # the same as we'll create it later.

-         if ! _scratch_mkfs >$tmp.err 2>&1
+         check_err=`_scratch_mkfs 2>&1`
+         if [ $? -ne 0 ]
          then
              echo "our local _scratch_mkfs routine ..."
-             cat $tmp.err
              echo "check: failed to mkfs \$SCRATCH_DEV using specified options"
              status=1
              exit
@@ -578,14 +587,15 @@ for section in $HOST_OPTIONS_SECTIONS; do

          # call the overridden mount - make sure the FS mounts with
          # the same options that we'll mount with later.
-         if ! _scratch_mount >$tmp.err 2>&1
+         check_err=`_scratch_mount 2>&1`
+         if [ $? -ne 0 ]
          then
              echo "our local mount routine ..."
-             cat $tmp.err
              echo "check: failed to mount \$SCRATCH_DEV using
specified options"
              status=1
              exit
          fi
+         check_err=""
        fi
