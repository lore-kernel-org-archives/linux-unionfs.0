From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [xfstests PATCH v2 2/5] overlay: hook filesystem check helper
Date: Thu, 8 Feb 2018 20:46:29 +0800
Message-ID: <4ef2eeaa-ed7a-b643-614d-8cdc2d99dd41@huawei.com>
References: <20180131102759.40997-1-yi.zhang@huawei.com>
 <20180131102759.40997-3-yi.zhang@huawei.com>
 <20180206155325.GS18267@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5210 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750847AbeBHMrY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Feb 2018 07:47:24 -0500
In-Reply-To: <20180206155325.GS18267@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com

On 2018/2/6 23:53, Eryu Guan Wrote:
> On Wed, Jan 31, 2018 at 06:27:56PM +0800, zhangyi (F) wrote:
>> Hook filesystem check helper to _check_test_fs and _check_scratch_fs for
>> constants underlying dirs of overlay filesystem, and introduce scratch
>> check helpers for optionally lower/upper/work dirs. These helpers works
>> only if fsck.overlay exists.
>>
>> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>>
[..]
>> +_check_overlay_test_fs()
>> +{
>> +	_overlay_check_fs "$TEST_DIR" \
>> +		OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
>> +		"$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
>> +		$TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS
> 
> Using $TEST_FS_MOUNT_OPTS doesn't look correct to me, the mount options
> provided here are meant for mounting base test device, and
> TEST_FS_MOUNT_OPTS is meant for mounting overlay. (I know that you're
> copying from _overlay_base_test_mount(), and I think that's a bug in the
> existing code.)
> 
> The problem is that both TEST_FS_MOUNT_OPTS and MOUNT_OPTIONS should be
> set to OVERLAY_MOUNT_OPTIONS if it's not empty. But currently only
> MOUNT_OPTIONS is set in common/config::_mount_opts, TEST_FS_MOUNT_OPTS
> isn't set in common/config::_test_mount_opts.
> 
Sorry, I was a little confuse that it conflict with comments in README.overlay.

IIUC, XXX_MOUNT_OPTIONS act as an "default mount options" when user not specify
MOUNT_OPTIONS explicity, so we set MOUNT_OPTIONS and TEST_FS_MOUNT_OPTS to
XXX_MOUNT_OPTIONS in _mount_opts and _test_mount_opts for other filesystems.

But overlayfs is different, OVERLAY_MOUNT_OPTIONS is used for overlayfs mount
options, so we first set OVL_BASE_MOUNT_OPTIONS to MOUNT_OPTIONS and then set
MOUNT_OPTIONS to OVERLAY_MOUNT_OPTIONS. So MOUNT_OPTIONS=$OVERLAY_MOUNT_OPTIONS
in _mount_opts is not correct? (It seem that it will not lead to mistack because
"8df8ad0c overlay: fix _overlay_config_override of MOUNT_OPTIONS").

Do you think we shoud use OVL_BASE_MOUNT_OPTIONS instead of OVERLAY_MOUNT_OPTIONS
as "default mount options" and set MOUNT_OPTIONS and TEST_FS_MOUNT_OPTS in
_mount_opts and _test_mount_opts if user not set either of them ?

Thanks,
Yi.
> But, as mentioned above, this is a different issue, using
> OVL_BASE_MOUNT_OPTIONS for both _check_overlay_test|scratch_fs should be
> fine for now. But if you can fix the bug too in next version of this
> patchset, it'd be great!
> 
> Thanks,
> Eryu
> 
>> +}
>> +
>> +_check_overlay_scratch_fs()
>> +{
>> +	_overlay_check_fs "$SCRATCH_MNT" \
>> +		OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
>> +		"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
>> +		$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
>> +}
>> diff --git a/common/rc b/common/rc
>> index 3351f00..7b84bb5 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2585,7 +2585,7 @@ _check_test_fs()
>>  	# no way to check consistency for GlusterFS
>>  	;;
>>      overlay)
>> -	# no way to check consistency for overlay
>> +	_check_overlay_test_fs
>>  	;;
>>      pvfs2)
>>  	;;
>> @@ -2643,7 +2643,7 @@ _check_scratch_fs()
>>  	# no way to check consistency for GlusterFS
>>  	;;
>>      overlay)
>> -	# no way to check consistency for overlay
>> +	_check_overlay_scratch_fs
>>  	;;
>>      pvfs2)
>>  	;;
>> -- 
>> 2.5.0
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 
