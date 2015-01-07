From: Seunghun Lee <waydi1@gmail.com>
Subject: Re: [PATCH] ovl: Prevent rw remount when it should be ro mount
Date: Thu, 08 Jan 2015 00:04:59 +0900
Message-ID: <54AD4B1B.1030801@gmail.com>
References: <1420219609-2568-1-git-send-email-waydi1@gmail.com> <54A8AC74.2060106@huawei.com> <54ABEB06.2010008@gmail.com> <54ACA052.8010800@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54ACA052.8010800@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: miklos@szeredi.hu, sedat.dilek@gmail.com, richard.weinberger@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Hu,

On 01/07/2015 11:56 AM, hujianyang wrote:
> Hi,
>
> There maybe some misunderstandings here. I think your patch really
> fix an important problem, but not in correct way.
>
> On 2015/1/6 22:02, Seunghun Lee wrote:
>> After patch:
>> root@qemux86:~# mount -t overlay overlay -olowerdir=lower:lower2 merged
>> mount: warning: merged seems to be mounted read-only.
>> root@qemux86:~# mount | grep overlay
>> overlay on /home/root/merged type overlay (ro,relatime,lowerdir=lower:lower2)
>> root@qemux86:~# mount -o remount,rw merged
>> mount: warning: /home/root/merged seems to be mounted read-only.
>> root@qemux86:~# mount | grep overlay
>> overlay on /home/root/merged type overlay (ro,relatime,lowerdir=lower:lower2)
>> root@qemux86:~# echo hi > merged/hi
>> -sh: merged/hi: Read-only file system
>> root@qemux86:~#
>>
> If users want a rw mount, can we give them a ro mount? I think it's
> wrong, .remount_fs should refuse this request.
>
> So I think your .remount_fs should check both what users in userpace
> want and what kernel can offer, then realize legal requests and
> refuse illegal requests. Not changing the requests from users.
Many file systems just change flags when user requests read-write remount.
(romfs, squashfs, sysv...)
I thought this case is similar above filesystems.
> Further more, can we replace upper/lower/work directories or mount
> point by this .remount_fs?
>
> If you want to export a new function, I think you should considering
> more about these.
>
> Thanks,
> Hu
>
Yes, you are right. However, this patch is a minimal support to
prevent kernel panic when file system is remounted to read-write mode.
And many file systems have remount_fs function of this kind.

I think what you mentioned is can be added later if it is necessary.

Thanks.
