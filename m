From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH for xfstests 1/4] overlay: add filesystem check helper
Date: Thu, 14 Dec 2017 20:40:05 +0800
Message-ID: <0860e6d0-cbdb-bc0d-33e3-ba0f800bdbf2@huawei.com>
References: <20171214064846.21587-1-yi.zhang@huawei.com>
 <20171214064846.21587-2-yi.zhang@huawei.com>
 <CAOQ4uximBJqFpsBMLQMWTJpJsoigBnYemtb7z1h-3PPWyjrkXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11939 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdLNMkq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 07:40:46 -0500
In-Reply-To: <CAOQ4uximBJqFpsBMLQMWTJpJsoigBnYemtb7z1h-3PPWyjrkXA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On 2017/12/14 17:05, Amir Goldstein Write:
> On Thu, Dec 14, 2017 at 8:48 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Add filesystem check helpers for the upcoming fsck.overlay utility,
>> and hook them to _check_test_fs and _check_scratch_fs. This helper
>> works only if fsck.overlay exists.
>>
>> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  common/config  |  1 +
>>  common/overlay | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  common/rc      |  4 +--
>>  3 files changed, 81 insertions(+), 2 deletions(-)
>>
[..]
>> +_overlay_check_dirs()
>> +{
>> +       local lowerdir=$1
>> +       local upperdir=$2
>> +       local workdir=$3
>> +       local err=0
>> +
>> +       _overlay_fsck_dirs $FSCK_OPTIONS $* >>$tmp.fsck 2>&1
>> +       if [ $? -ne 0 ]; then
>> +               _log_err "_overlay_check_fs: overlayfs on $lowerdir,$upperdir,$workdir is inconsistent"
>> +               echo "*** fsck.overlay output ***"      >>$seqres.full
>> +               cat $tmp.fsck                           >>$seqres.full
>> +               echo "*** end fsck.overlay output"      >>$seqres.full
>> +               echo "*** mount output ***"             >>$seqres.full
>> +               _mount                                  >>$seqres.full
>> +               echo "*** end mount output"             >>$seqres.full
>> +               err=1
>> +       fi
> 
> Maybe the tmp.fsck output reporting to seqres.full should be done in
> _overlay_fsck_dirs?
> I think this output could be useful for understanding fsck tests failure.

If we do these in _overlay_fsck_dirs, we can get output only when fsck return
fail, but this output maybe useful for understanding fsck.overlay even through
fsck pass when we test it. So I call _overlay_fsck_dirs and put output to
seqres.full alone in each test case now, see 0002-0004 patches.
But it's also fine to put these into _overlay_fsck_dirs.

[..]
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2507,7 +2507,7 @@ _check_test_fs()
>>         # no way to check consistency for GlusterFS
>>         ;;
>>      overlay)
>> -       # no way to check consistency for overlay
>> +       _check_overlay_test_fs
>>         ;;
>>      pvfs2)
>>         ;;
>> @@ -2562,7 +2562,7 @@ _check_scratch_fs()
>>         # no way to check consistency for GlusterFS
>>         ;;
>>      overlay)
>> -       # no way to check consistency for overlay
>> +       _check_overlay_test_fs
> 
> _check_overlay_scratch_fs
> 

will fix

Thanks,
Yi.
