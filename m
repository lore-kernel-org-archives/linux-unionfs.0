Return-Path: <yangerkun@huawei.com>
Subject: Re: [fsck.overlay RFC PATCH] overlay: add fsck utility
References: <20171117054919.712-1-yi.zhang@huawei.com>
 <CAOQ4uxgCN-ZdLsZQmYYW-PyJLB4WWsr9A8gqOtcSC6S9Uj8qZA@mail.gmail.com>
From: yangerkun <yangerkun@huawei.com>
Message-ID: <8d55fcce-ebbf-4779-87de-8406fe475073@huawei.com>
Date: Wed, 7 Mar 2018 17:25:42 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgCN-ZdLsZQmYYW-PyJLB4WWsr9A8gqOtcSC6S9Uj8qZA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>



On 11/18/2017 1:13 AM, Amir Goldstein wrote:
> [adding fstests in CC with full patch inline to collect wisdom from
> other fs developers]
> 
> On Fri, Nov 17, 2017 at 7:49 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Hi,
[...]
>>
>> Todo
>> ====
>>
>> 1. Overlay filesystem mounted check. Prevent fscking when overlay is
>> online. Now, We cannot distinguish mounted directories if overlayfs was
>> mounted with relative path.
> 
> This should be handled by kernel.
> We now already grab an advisory exclusive I_OVL_INUSE lock on both
> upperdir and workdir.
> fsck.overlay can try to open upperdir/workdir with O_EXCL|O_DIRECTORY
> and kernel should fail this open if overlayfs is holding the  I_OVL_INUSE.
> Read the man page section on O_EXCL and block device. This is how
> e2fsck and friends get exclusive access w.r.t mount.
> 

In fsck.overlay, lower layer file/dir may be modified with there is not 
I_OVL_INUSE in lower layer, but we cannot check does lower layer mounted 
with I_OVL_INUSE.

Maybe we need adopt another way? How about store pwd in ofs.config when 
we mount the overlay.

Thanks,
yangerkun.
