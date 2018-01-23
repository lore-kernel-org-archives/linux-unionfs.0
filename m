From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [xfstests PATCH v5 1/7] overlay: add filesystem check helper
Date: Tue, 23 Jan 2018 19:10:39 +0800
Message-ID: <8d8c094e-cfac-2cf2-2da4-fe759b7122a4@huawei.com>
References: <20180123073452.19074-1-yi.zhang@huawei.com>
 <20180123073452.19074-2-yi.zhang@huawei.com>
 <CAOQ4uxjBw1N6jQ_Ht3YzWeM=bUTKPJP6Ei+A2Sam+gd3HPxTWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjBw1N6jQ_Ht3YzWeM=bUTKPJP6Ei+A2Sam+gd3HPxTWg@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On 2018/1/23 17:16, Amir Goldstein 写道:
> On Tue, Jan 23, 2018 at 9:34 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Add filesystem check helpers for the upcoming fsck.overlay utility.
>> Hook these helpers to _check_test_fs and _check_scratch_fs for constants
>> underlying dirs of overlay filesystem, and introduce scratch check helpers
>> for optionally lower/upper/work dirs. These helpers works only if
>> fsck.overlay exists.
>>
>> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  common/config  |   1 +
>>  common/overlay | 145 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  common/rc      |   4 +-
>>  3 files changed, 148 insertions(+), 2 deletions(-)
>>
>> diff --git a/common/config b/common/config
>> index 5f40413..71115bd 100644
>> --- a/common/config
>> +++ b/common/config
>> @@ -236,6 +236,7 @@ case "$HOSTOS" in
>>          export MKFS_REISER4_PROG="`set_prog_path mkfs.reiser4`"
>>         export E2FSCK_PROG="`set_prog_path e2fsck`"
>>         export TUNE2FS_PROG="`set_prog_path tune2fs`"
>> +       export FSCK_OVERLAY_PROG="`set_prog_path fsck.overlay`"
>>          ;;
>>  esac
>>
>> diff --git a/common/overlay b/common/overlay
>> index 1da4ab1..c611a49 100644
>> --- a/common/overlay
>> +++ b/common/overlay
>> @@ -151,3 +151,148 @@ _require_scratch_overlay_feature()
>>                 _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
>>         _scratch_unmount
>>  }
>> +
>> +# Require the same scratch device as _require_scratch, but do not check
>> +# the constants OVL_LOWER/OVL_UPPER/OVL_WORK dirs, should use together
>> +# with optionally lower/upper/work dirs and do check explicitly after test.
>> +_require_overlay_scratch_dirs()
>> +{
>> +       _require_scratch_nocheck
>> +}
>> +
>> +_overlay_fsck_dirs()
>> +{
>> +       local lowerdir=$1
>> +       local upperdir=$2
>> +       local workdir=$3
>> +       local options=$4
>> +
>> +       [[ ! -x "$FSCK_OVERLAY_PROG" ]] && return 0
>> +
>> +       $FSCK_OVERLAY_PROG -o lowerdir=$lowerdir -o upperdir=$upperdir \
>> +                          -o workdir=$workdir $options
>> +}
>> +
>> +_overlay_check_dirs()
>> +{
>> +       local lowerdir=$1
>> +       local upperdir=$2
>> +       local workdir=$3
>> +       local err=0
>> +
>> +       _overlay_fsck_dirs $* $FSCK_OPTIONS >>$tmp.fsck 2>&1
>> +       if [ $? -ne 0 ]; then
>> +               _log_err "_overlay_check_fs: overlayfs on $lowerdir,$upperdir,$workdir is inconsistent"
>> +
>> +               echo "*** fsck.overlay output ***"      >>$seqres.full
>> +               cat $tmp.fsck                           >>$seqres.full
>> +               echo "*** end fsck.overlay output"      >>$seqres.full
>> +
>> +               echo "*** mount output ***"             >>$seqres.full
>> +               _mount                                  >>$seqres.full
>> +               echo "*** end mount output"             >>$seqres.full
>> +
>> +               err=1
>> +       fi
>> +       rm -f $tmp.fsck
>> +
>> +       return $err
>> +}
>> +
>> +# Check the same mnt/dev of _check_overlay_scratch_fs, but check optionally
>> +# lower/upper/work dirs of overlay filesystem, should use together with
>> +# _require_overlay_scratch_dirs
>> +_overlay_check_scratch_dirs()
>> +{
>> +       local lowerdir=$1
>> +       local upperdir=$2
>> +       local workdir=$3
>> +
>> +       # Need to umount overlay for scratch dir check
>> +       local type=`_fs_type $OVL_BASE_SCRATCH_MNT`
> 
> This test is fragile because it relies that the mount device name
> specified in mount command was OVL_BASE_SCRATCH_MNT.
> That is true for tests using _require_overlay_scratch_dirs, but not
> always true for tests using  _overlay_mount_dirs.
> For example, you did not end up calling _overlay_check_scratch_dirs
> in overlay/036, but for different reason. If you would have called
> this helper it would do the wrong thing, because device name used
> in this test in 'overlay3'.
> 
> One way to deal with this is to check whether $SCRATCH_MNT
> is an 'overlay' type mount point (instead of checking device name).
> 
>> +
>> +       # If type is set, overlay is mounted
>> +       [ "$type" = "$FSTYP" ] && $UMOUNT_PROG $SCRATCH_MNT
> 
> This is an overlay specific helper, so I rather see [ "$type" = overlay ]
> 
>> +
>> +       _overlay_check_dirs $lowerdir $upperdir $workdir
>> +       local ret=$?
>> +
>> +       if [ $ret = 0 -a "$type" = "$FSTYP" ]; then
> 
> more clear to read if there was an auxiliary variable ovl_mounted
> 
>> +               # overlay was mounted...
>> +
>> +               # If overlayfs have to recover with last mount options,
>> +               # OVERLAY_MOUNT_OPTIONS should be clarified before last
>> +               # mount
>> +               _overlay_scratch_mount_dirs $lowerdir $upperdir \
>> +                       $workdir $OVERLAY_MOUNT_OPTIONS
> 
> 
> This part is a bit obfuscated in check -overlay, but OVERLAY_MOUNT_OPTIONS
> should already be assigned to MOUNT_OPTIONS and included from
> _overlay_mount_dirs -> _common_dev_mount_options
> 
> If anything you should allow to pass in extra mount option variables
> and pass them into _overlay_scratch_mount_dirs in the end ($*)
> for tests that would like to continue testing on a mounted overlay after
> calling _overlay_check_scratch_dirs and have provide specialized
> mount options to _overlay_scratch_mount_dirs.
> But _check_generic_filesystem doesn't handle this case, so I don't
> think you should handle it as well.

Right, I had planned to use OVERLAY_MOUNT_OPTIONS to pass extra mount options($*)
as overlay/044 does, but it seems not necessary because we always check after test
or subtest. For simplicity, I will remove this option.

Thanks,
Yi.

> 
>> +               ret=$?
>> +       fi
>> +
>> +       return $ret
>> +}
>> +
>> +_overlay_check_fs()
>> +{
>> +       local ovl_mnt=$1
>> +       local base_dev=$4
>> +       local base_mnt=$5
>> +       shift 1
>> +
>> +       [ "$FSTYP" = overlay ] || return 0
>> +
>> +       # Base fs needs to be mounted to check overlay dirs
>> +       local mounted=""
>> +       [ -z "$base_dev" ] || mounted=`_is_mounted $base_dev`
>> +
>> +       if [ -z "$mounted" ]; then
>> +               _overlay_base_mount $*
>> +       else
>> +               # Need to umount overlay for dir check
>> +               local type=`_fs_type $base_mnt`
>> +
>> +               # If type is set, overlay is mounted
>> +               [ "$type" = "$FSTYP" ] && $UMOUNT_PROG $ovl_mnt
> 
> Same comments as above
> 
>> +       fi
>> +
>> +       _overlay_check_dirs $base_mnt/$OVL_LOWER $base_mnt/$OVL_UPPER \
>> +                           $base_mnt/$OVL_WORK
>> +       local ret=$?
>> +
>> +       if [ -z "$mounted" ]; then
>> +               _overlay_base_unmount "$base_dev" "$base_mnt"
>> +       elif [ $ret = 0 -a "$type" = "$FSTYP" ]; then
>> +               # overlay was mounted...
>> +
>> +               # If overlayfs have to recover with last mount options,
>> +               # OVERLAY_MOUNT_OPTIONS should be clarified before last
>> +               # mount
>> +               _overlay_mount $base_mnt $ovl_mnt $OVERLAY_MOUNT_OPTIONS
> 
> Same comments as above
> 
> Thanks,
> Amir.
> 
> .
> 
