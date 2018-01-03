From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH xfstest v2 2/4] overlay: add fsck.overlay whiteout test
Date: Wed, 3 Jan 2018 09:02:47 +0800
Message-ID: <ff880368-da17-b3fc-5412-426f98875506@huawei.com>
References: <20171228114933.47759-1-yi.zhang@huawei.com>
 <20171228114933.47759-3-yi.zhang@huawei.com>
 <20180102200501.GD15274@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3269 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750960AbeACBDT (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jan 2018 20:03:19 -0500
In-Reply-To: <20180102200501.GD15274@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, miaoxie@huawei.com, yangerkun@huawei.com

On 2018/1/3 4:05, Vivek Goyal Wrote:
> On Thu, Dec 28, 2017 at 07:49:31PM +0800, zhangyi (F) wrote:
> 
> [..]
>> +# Create test directories
>> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
>> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
>> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
>> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
>> +
>> +mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir
> 
> Minor nit. Why $workdir has been specified twice. I saw it in another test
> as well.
> 
Will fix, thanks!

zhangyi.
