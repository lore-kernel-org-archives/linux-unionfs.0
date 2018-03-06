Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegt_QW8ByGtDhNWy5rT70H+kxoW5duRNOAKA5Az_QsoJ_Q@mail.gmail.com>
References: <20180306040223.2970-1-yangerkun@huawei.com> <CAOQ4uxi2Ts+=4NhOyTCpoBxsW1_tAuVS3s_reNz0Nuba+AEDUA@mail.gmail.com>
 <CAJfpegt_QW8ByGtDhNWy5rT70H+kxoW5duRNOAKA5Az_QsoJ_Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 6 Mar 2018 10:34:12 +0200
Message-ID: <CAOQ4uxhYmOyWFf3ARQ_hdrEwN6vxUb5J4Gq=8E2CUeGWJKDrjg@mail.gmail.com>
Subject: Re: [PATCH] overlay: ovl_get_inode should treat file and dir as same
 while no upper_mnt
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: yangerkun <yangerkun@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, zhaohongjiang@huawei.com, Chengguang Xu <cgxu519@icloud.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 6, 2018 at 10:16 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Mar 6, 2018 at 7:44 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, Mar 6, 2018 at 6:02 AM, yangerkun <yangerkun@huawei.com> wrote:
>>>
>>> When there is no upper_mnt, lower multi hardlink should not construct
>>> multi inode for overlay since there won't copyup.
>>>
>>
>> This doesn't really describe a problem.
>> AFAIK, the only problem has to do with fsnotify and the fix is already in
>> overlayfs-next:
>> 764baba80168 ovl: hash non-dir by lower inode for fsnotify
>>
>> Miklos,
>>
>> Are you planning to send a pull request soon?
>
> OK, I'll submit the pending patches for -rc5.
>
> Do you see any fixes that I missed?
>

No, I don't.

There's Chengguang syncfs optimization, but that is not a fix, so I
reccon, not rc5 material.

Thanks,
Amir.
