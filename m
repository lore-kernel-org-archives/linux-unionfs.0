From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [xfstests PATCH v6 2/8] overlay: add filesystem check helper
Date: Wed, 24 Jan 2018 18:53:35 +0800
Message-ID: <21bd824d-49cd-5749-ca1d-238154e321e7@huawei.com>
References: <20180124073344.31970-1-yi.zhang@huawei.com>
 <20180124073344.31970-3-yi.zhang@huawei.com>
 <CAOQ4uxjwrFDKn6iYTNLA02z-GvG-X+72Vs4TYs1sL0_8wiuksg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4691 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932953AbeAXKyO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Jan 2018 05:54:14 -0500
In-Reply-To: <CAOQ4uxjwrFDKn6iYTNLA02z-GvG-X+72Vs4TYs1sL0_8wiuksg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On 2018/1/24 17:31, Amir Goldstein Write:
> On Wed, Jan 24, 2018 at 9:33 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
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
>> +       local base_mounted=""
>> +       [ -z "$base_dev" ] || base_mounted=`_is_mounted $base_dev`
> 
> That looks like I have a bug in my original implementation of _overlay_check_fs
> because $FSTYP" = overlay _is_mounted here will not actually find a mounted
> base dev. Need to pass $OVL_BASE_FSTYP to your improved _is_mounted
> helper.
> No?
> 
Yes, we not found this bug becasue previous _is_mounted missing $FSTYP check,
I will improve it as you suggested.

Thanks,
Yi.
