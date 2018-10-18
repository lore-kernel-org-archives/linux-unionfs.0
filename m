Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:13669 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727492AbeJRKgW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Oct 2018 06:36:22 -0400
Subject: Re: [PATCH v2 1/4] overlay: correct fsck.overlay exit code
References: <20181016074559.24728-1-yi.zhang@huawei.com>
 <20181016074559.24728-2-yi.zhang@huawei.com>
 <CAOQ4uxh8YWXprDPp1H6Si+L1QXBwcTp1+P78MqYZD5wMzuJopg@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <25d4f255-7dd0-cfe6-3c33-556365de2c68@huawei.com>
Date: Thu, 18 Oct 2018 10:37:27 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxh8YWXprDPp1H6Si+L1QXBwcTp1+P78MqYZD5wMzuJopg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/10/16 17:45, Amir Goldstein Wrote:
> On Tue, Oct 16, 2018 at 10:32 AM zhangyi (F) <yi.zhang@huawei.com> wrote:
>>
>> fsck.overlay should return correct exit code to show the file system
>> status after fsck, instead of return 0 means consistency and !0 means
>> inconsistency or something bad happened.
>>
>> Fix the following three exit code after running fsck.overlay:
>>
>> - Return FSCK_OK if the input file system is consistent,
>> - Return FSCK_NONDESTRUCT if the file system inconsistent errors
>>   corrected,
>> - Return FSCK_UNCORRECTED if the file system still have inconsistent
>>   errors.
>>
>> This patch also add a helper function to run fsck.overlay and check
>> the return value is expected or not.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  common/overlay    | 29 +++++++++++++++++++++++++++++
>>  tests/overlay/045 | 27 +++++++++------------------
>>  tests/overlay/046 | 36 ++++++++++++------------------------
>>  tests/overlay/056 |  9 +++------
>>  4 files changed, 53 insertions(+), 48 deletions(-)
>>
>> diff --git a/common/overlay b/common/overlay
>> index b526f24..4cc2829 100644
>> --- a/common/overlay
>> +++ b/common/overlay
>> @@ -12,6 +12,16 @@ export OVL_XATTR_NLINK="trusted.overlay.nlink"
>>  export OVL_XATTR_UPPER="trusted.overlay.upper"
>>  export OVL_XATTR_METACOPY="trusted.overlay.metacopy"
>>
>> +# Export exit code used by fsck.overlay program
>> +export FSCK_OK=0
>> +export FSCK_NONDESTRUCT=1
>> +export FSCK_REBOOT=2
>> +export FSCK_UNCORRECTED=4
>> +export FSCK_ERROR=8
>> +export FSCK_USAGE=16
>> +export FSCK_CANCELED=32
>> +export FSCK_LIBRARY=128
>> +
>>  # helper function to do the actual overlayfs mount operation
>>  _overlay_mount_dirs()
>>  {
>> @@ -193,6 +203,25 @@ _overlay_fsck_dirs()
>>                            -o workdir=$workdir $*
>>  }
>>
>> +# Run fsck and check the return value
>> +_run_check_fsck()
>> +{
>> +       # The first arguments is the expected fsck program exit code, the
>> +       # remaining arguments are the input parameters of the fsck program.
>> +       local expect_ret=$1
>> +       local lowerdir=$2
>> +       local upperdir=$3
>> +       local workdir=$4
>> +       shift 4
>> +
>> +       _overlay_fsck_dirs $lowerdir $upperdir $workdir $* >> \
>> +                       $seqres.full 2>&1
>> +       fsck_ret=$?
>> +
>> +       [[ "$fsck_ret" == "$expect_ret" ]] || \
>> +               echo "fsck return unexpected value:$expect_ret,$fsck_ret"
>> +}
> 
> Looks good.
> 
> Please consider the name _overlay_repair_dirs() with reference to
> _repair_scratch_fs(), which is used for roughly the same purpose.
> 

_run_check_fsck() is helper used to test fsck and may expect to return
"error" exit code when we do exception tests(see patch 4), but
_repair_scratch_fs() always want to return "correct" exit code.

> BTW, the tests generic/330 generic/332 when run with -overlay
> over xfs with reflink support seem to call _repair_scratch_fs() which does:
>         # Let's hope fsck -y suffices...
>         fsck -t $FSTYP -y $SCRATCH_DEV 2>&1
>         local res=$?
>         case $res in
>         0|1|2)
>                 res=0
>                 ;;
>         *)
>                 _dump_err2 "fsck.$FSTYP failed, err=$res"
> 
> How come fsck.overlay is not complaining about missing arguments??
> 
> The rest of the generic tests that call _repair_scratch_fs() have
> _require_dm_target() which _require_block_device(), so don't run with overlay.
> 
> If you do sort this out and add overlay support to
> _repair_scratch_fs() its probably
> worth replacing 0|1|2) with FSCK_ constants.
> 

Thanks for pointing this out, I think we do something like below can fix
this problem, what do you think?

diff --git a/common/overlay b/common/overlay
index 2896594..b9fe1ee 100644
--- a/common/overlay
+++ b/common/overlay
@@ -226,6 +226,14 @@ _run_check_fsck()
                echo "fsck return unexpected value:$expect_ret,$fsck_ret"
 }

+_scratch_overlay_repair()
+{
+       _overlay_fsck_dirs $OVL_BASE_SCRATCH_MNT/$OVL_LOWER \
+                          $OVL_BASE_SCRATCH_MNT/$OVL_UPPER \
+                          $OVL_BASE_SCRATCH_MNT/$OVL_WORK \
+                          -y
+}
+
 _overlay_check_dirs()
 {
        local lowerdir=$1
diff --git a/common/rc b/common/rc
index 38d9de7..7127539 100644
--- a/common/rc
+++ b/common/rc
@@ -1100,6 +1100,18 @@ _repair_scratch_fs()
        fi
        return $res
         ;;
+    overlay)
+       _scratch_overlay_repair 2>&1
+       local res=$?
+       case $res in
+       $FSCK_OK|$FSCK_NONDESTRUCT)
+               res=0
+               ;;
+       *)
+               _dump_err2 "fsck.overlay failed, err=$res"
+       esac
+       return $res
+       ;;
     *)
         # Let's hope fsck -y suffices...
         fsck -t $FSTYP -y $SCRATCH_DEV 2>&1

Thanks,
Yi.
