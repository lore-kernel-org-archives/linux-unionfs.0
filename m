Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:5658 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751669AbeBVIBL (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Feb 2018 03:01:11 -0500
Subject: Re: [xfstests PATCH v4 2/5] overlay: hook filesystem check helper
References: <20180222021834.26145-1-yi.zhang@huawei.com>
 <20180222021834.26145-3-yi.zhang@huawei.com>
 <CAOQ4uxhH3ZLO6zehBY=U3guSvrZc_-bmBK1-2wQMZ+NMqVsX+A@mail.gmail.com>
 <1396234c-0cc1-2f4e-8187-dae7ae452c21@huawei.com>
 <CAOQ4uxi+aRsaB0ZBDCJqr2TaX-aVrx_mgdRTc1yFKoP=aAKBmQ@mail.gmail.com>
 <4d7e461c-0cb1-a47e-7e5d-562418a9442e@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <7ff1f864-c993-ea08-48cb-6859b600dbd4@huawei.com>
Date: Thu, 22 Feb 2018 16:00:03 +0800
MIME-Version: 1.0
In-Reply-To: <4d7e461c-0cb1-a47e-7e5d-562418a9442e@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/2/22 15:51, zhangyi (F) Wrote:
> On 2018/2/22 15:06, Amir Goldstein Wrote:
>> On Thu, Feb 22, 2018 at 8:27 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>> On 2018/2/22 11:26, Amir Goldstein Wrote:
>>>> Zhangyi,
>>>>
>>>> Sorry for dropping lists because replying from mobile. Feel free to add back.
>>>>
>>>>
>>>>
>>>> On Feb 22, 2018 3:09 AM, "zhangyi (F)" <yi.zhang@huawei.com <mailto:yi.zhang@huawei.com>> wrote:
>>>>
>>>>     Hook filesystem check helper to _check_test_fs and _check_scratch_fs for
>>>>     constants underlying dirs of overlay filesystem, and introduce scratch
>>>>     check helpers for optionally lower/upper/work dirs. These helpers works
>>>>     only if fsck.overlay exists.
>>>>
>>>>     This patch introduce OVERLAY_FSCK_OPTIONS use for check overlayfs like
>>>>     OVERLAY_MOUNT_OPTIONS, and also introduce a mount point check helper in
>>>>     common/rc to detect a dir is a mount point or not.
>>>>
>>>>     [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>>>>
>>>>     Signed-off-by: zhangyi (F) <yi.zhang@huawei.com <mailto:yi.zhang@huawei.com>>
>>>>     ---
>>>>      README.overlay |  10 ++++-
>>>>      common/config  |   4 ++
>>>>      common/overlay | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>      common/rc      |  18 ++++++++-
>>>>      4 files changed, 153 insertions(+), 4 deletions(-)
>>>>
>>>>     diff --git a/README.overlay b/README.overlay
>>>>     index dfb8234..9feaa6a 100644
>>>>     --- a/README.overlay
>>>>     +++ b/README.overlay
>>>>     @@ -22,6 +22,10 @@ the base fs should be pre-formatted before starting the -overlay run.
>>>>      An easy way to accomplish this is by running './check <some test>' once,
>>>>      before running './check -overlay'.
>>>>
>>>>     +'./check -overlay' support check overlay test and scratch dirs,
>>>>     +OVERLAY_FSCK_OPTIONS should be set instead of FSCK_OPTIONS if fsck
>>>>     +options need to given directly.
>>>>     +
>>>>      Because of the lack of mkfs support, multi-section config files are only
>>>>      partly supported with './check -overlay'. Only multi-section files that
>>>>      do not change FSTYP and MKFS_OPTIONS can be safely used with -overlay.
>>>>     @@ -40,7 +44,9 @@ run overlay tests on the same base fs, but with different mount options:
>>>>       MOUNT_OPTIONS="-o pquota"
>>>>       TEST_FS_MOUNT_OPTS="-o noatime"
>>>>       OVERLAY_MOUNT_OPTIONS="-o redirect_dir=off"
>>>>     + OVERLAY_FSCK_OPTIONS="-n"
>>>>
>>>>
>>>> I may have missed this before but was under the impression that -n was the fsck option by default for post test fs check.
>>>>
>>>> I believe that's how it usually is with fstests.
>>>>
>>> Yes, you are right, -n is the default option. Current OVERLAY_FSCK_OPTIONS is
>>> used to avoid getting the base filesystem's FSCK_OPTIONS in multi sections config
>>> case, becasue we cannot distinguish between leftover FSCK_OPTIONS and user specified
>>> FSCK_OPTIONS, so introduce OVERLAY_FSCK_OPTIONS and set -n to default as example.
>>>
>>
>> I don't follow. How are FSCK_OPTIONS differ from MOUNT_OPTIONS in that sense?
>> When restoring base fs options, we check if MOUNT_OPTIONS differ from
>> OVERLAY_MOUNT_OPTIONS to distinguish between leftover MOUNT_OPTIONS.
>> My point is that specifying OVERLAY_FSCK_OPTIONS="-n" is the example is quite
>> confusing, because it suggests that use needs to set OVERLAY_FSCK_OPTIONS="-n"
>> in order to get the expected default behavior.
>> If that is indeed the case then it should be fixed.
>> And the example should be changed IMO to something like this, to be more
>> relevant to current code base and near (?) future fsck options:
>>
>> OVERLAY_MOUNT_OPTIONS="-o index=on"
>> OVERLAY_FSCK_OPTIONS="-o index=on"
>>
> 
> I understand what you mean, but the option arguments we pass to mount and
> fsck.overlay were not quite the same, we only reuse overlay's special part
> of MOUNT_OPTIONS(e.g. index=xx,redirect_dir=xx...), and we still need to pass
> the fsck.overlay's own options(e.g. -n, maybe -f in future) through
> OVERLAY_FSCK_OPTIONS (and I think there is no reason to hide this if user
> want to given options directly). Like this:
> 
> OVERLAY_MOUNT_OPTIONS="-o index=on"
> OVERLAY_FSCK_OPTIONS="-n -o index=on"
> 
> Now specifying OVERLAY_FSCK_OPTIONS="-n" is not necessary, I can modify to
> OVERLAY_MOUNT_OPTIONS="-n, -o redirect_dir=off" after fsck.overlay can actually
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  OVERLAY_FSCK_OPTIONS="-n -o redirect_dir=off", sorry
> handle this. If you think it's confusing, modify it now is also not harmful.
> 
> Thanks.
> Yi.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 

