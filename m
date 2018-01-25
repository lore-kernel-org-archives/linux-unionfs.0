From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [xfstests PATCH 2/5] overlay: hook filesystem check helper
Date: Thu, 25 Jan 2018 17:35:26 +0800
Message-ID: <d68eb63f-0903-5674-f564-ed76a414d477@huawei.com>
References: <20180125063949.12916-1-yi.zhang@huawei.com>
 <20180125063949.12916-3-yi.zhang@huawei.com>
 <CAOQ4uxia8y4xWwcx-6bvLxqv=E4i_oytZxQQ=VHDKCH0rCKpsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:44386 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751727AbeAYJfu (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Jan 2018 04:35:50 -0500
In-Reply-To: <CAOQ4uxia8y4xWwcx-6bvLxqv=E4i_oytZxQQ=VHDKCH0rCKpsg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On 2018/1/25 16:21, Amir Goldstein Wrote:
> On Thu, Jan 25, 2018 at 8:39 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
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
>> +       local ovl_mounted=`_is_mounted $SCRATCH_MNT`
>> +       [ -z "$ovl_mounted" ] || $UMOUNT_PROG $SCRATCH_MNT
>> +
>> +       _overlay_check_dirs $lowerdir $upperdir $workdir
>> +       local ret=$?
>> +
>> +       if [ $ret -eq 0 -a -n "$ovl_mounted" ]; then
>> +               # overlay was mounted, remount besides extra mount options
>> +               _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> 
> I think that 'shift 3' and passing $* to _overlay_scratch_mount_dirs
> would be good practice here.
> Especially, because extra mount options may affect fsck.overlay
> someday. Imagine that fsck.overlay ... -oindex=on may be used to
> verify consistency and rebuild index for hardlinks and -onfs_export=on may
> be used to specify consistency check and rebuild of index for all
> files and directories.
> 
Good suggestion, fsck.overlay will handles these extra options sooner or later.

[..]
>> +
>> +       [ "$FSTYP" = overlay ] || return 0
>> +
>> +       # Base fs needs to be mounted to check overlay dirs
>> +       local base_mounted=""
>> +       [ -z "$base_dev" ] || \
>> +               base_mounted=`_is_mounted $base_dev $OVL_BASE_FSTYP`
> 
> Not that I am proposing to support -overlay run where FSTYP is not
> defined in config file, but how does this behave in such a case?
> Perhaps add || [ -z "$OVL_BASE_FSTYP" ] above?
> 
If FSTYP is not defined, _is_mounted will check the wrong fs and base_mounted
becomes empty, and it's same to add [ -z "$OVL_BASE_FSTYP" ], both will lead
to double mount.

I think it's better to use _fs_type as _check_generic_filesystem does.

Thanks,
Yi.
