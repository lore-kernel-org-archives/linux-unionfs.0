MIME-Version: 1.0
In-Reply-To: <CAOQ4uxi2Ts+=4NhOyTCpoBxsW1_tAuVS3s_reNz0Nuba+AEDUA@mail.gmail.com>
References: <20180306040223.2970-1-yangerkun@huawei.com>
	<CAOQ4uxi2Ts+=4NhOyTCpoBxsW1_tAuVS3s_reNz0Nuba+AEDUA@mail.gmail.com>
Date: Tue, 6 Mar 2018 09:16:30 +0100
Message-ID: <CAJfpegt_QW8ByGtDhNWy5rT70H+kxoW5duRNOAKA5Az_QsoJ_Q@mail.gmail.com>
Subject: Re: [PATCH] overlay: ovl_get_inode should treat file and dir as same
 while no upper_mnt
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: yangerkun <yangerkun@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, zhaohongjiang@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 6, 2018 at 7:44 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Mar 6, 2018 at 6:02 AM, yangerkun <yangerkun@huawei.com> wrote:
>>
>> When there is no upper_mnt, lower multi hardlink should not construct
>> multi inode for overlay since there won't copyup.
>>
>
> This doesn't really describe a problem.
> AFAIK, the only problem has to do with fsnotify and the fix is already in
> overlayfs-next:
> 764baba80168 ovl: hash non-dir by lower inode for fsnotify
>
> Miklos,
>
> Are you planning to send a pull request soon?

OK, I'll submit the pending patches for -rc5.

Do you see any fixes that I missed?

Thanks,
Miklos
