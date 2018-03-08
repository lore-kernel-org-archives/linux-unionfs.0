Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <f8883059-9e63-ebbc-ac86-e524995dc480@huawei.com>
References: <20171117054919.712-1-yi.zhang@huawei.com> <CAOQ4uxgCN-ZdLsZQmYYW-PyJLB4WWsr9A8gqOtcSC6S9Uj8qZA@mail.gmail.com>
 <8d55fcce-ebbf-4779-87de-8406fe475073@huawei.com> <CAOQ4uxge7XzeJPDSdpQYEHH7iQwJD0-t78gHBbKtMUsO0dQrgw@mail.gmail.com>
 <CAOQ4uxjbgQrg8MX0smdgYrV8_i3086ND_4d+Wpmcg+4G9RqY3Q@mail.gmail.com> <f8883059-9e63-ebbc-ac86-e524995dc480@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Mar 2018 09:51:01 +0200
Message-ID: <CAOQ4uxhuf_vnRsv-D5jJMBE5Wm8X19X1Cuf3XrXYRiSCFKyLmg@mail.gmail.com>
Subject: Re: [fsck.overlay RFC PATCH] overlay: add fsck utility
Content-Type: text/plain; charset="UTF-8"
To: yangerkun <yangerkun@huawei.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, Jeff Layton <jlayton@poochiereds.net>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 8, 2018 at 4:38 AM, yangerkun <yangerkun@huawei.com> wrote:
>
[...]
>>>>
>>>> In fsck.overlay, lower layer file/dir may be modified with there is not
>>>> I_OVL_INUSE in lower layer, but we cannot check does lower layer mounted
>>>> with I_OVL_INUSE.
>>>>
>>>
[...]
>> Also, if we follow my suggestion above for upperdir/workdir
>> fsck.overlay may still
>> try to aquire I_OVL_INUSE on lowerdir with O_EXCL|O_DIRECTORY and kernel
>> can test I_OVL_INUSE flag on lowerdir without trying to set it on mount.
>
>
> It's good when we want to mount overlayfs with fsck.overlay is running; But
> when there is a mounted overlayfs before fsck.overlay, we cannot use this
> way to check if the lower layer has already been used.

Perhaps we should acquire a shared POSIX lock from kernel on lower/upper/work
dirs and fsck.overlay should acquire an exclusive POSIX lock.

I'm not sure how acquiring a POSIX lock from kernel should work and which
task should be the owner of the lock, but generally overlayfs could either have
a single owner task in the kernel for all super blocks or one owner
per sb, in which
case, we could acquire an exclusive lock on work/upper dirs instead of using
the custom  I_OVL_INUSE lock.

Just a thought - not sure if this makes sense. CC'ing Jeff for reality check.

Thanks,
Amir.
