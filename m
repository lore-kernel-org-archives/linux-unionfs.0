From: hujianyang <hujianyang@huawei.com>
Subject: Re: [PATCH] ovl: Prevent rw remount when it should be ro mount
Date: Wed, 7 Jan 2015 10:56:18 +0800
Message-ID: <54ACA052.8010800@huawei.com>
References: <1420219609-2568-1-git-send-email-waydi1@gmail.com> <54A8AC74.2060106@huawei.com> <54ABEB06.2010008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:36653 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380AbbAGC4d (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 6 Jan 2015 21:56:33 -0500
In-Reply-To: <54ABEB06.2010008@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Seunghun Lee <waydi1@gmail.com>
Cc: miklos@szeredi.hu, sedat.dilek@gmail.com, richard.weinberger@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi,

There maybe some misunderstandings here. I think your patch really
fix an important problem, but not in correct way.

On 2015/1/6 22:02, Seunghun Lee wrote:
> 
> After patch:
> root@qemux86:~# mount -t overlay overlay -olowerdir=lower:lower2 merged
> mount: warning: merged seems to be mounted read-only.
> root@qemux86:~# mount | grep overlay
> overlay on /home/root/merged type overlay (ro,relatime,lowerdir=lower:lower2)
> root@qemux86:~# mount -o remount,rw merged
> mount: warning: /home/root/merged seems to be mounted read-only.
> root@qemux86:~# mount | grep overlay
> overlay on /home/root/merged type overlay (ro,relatime,lowerdir=lower:lower2)
> root@qemux86:~# echo hi > merged/hi
> -sh: merged/hi: Read-only file system
> root@qemux86:~#
> 

If users want a rw mount, can we give them a ro mount? I think it's
wrong, .remount_fs should refuse this request.

So I think your .remount_fs should check both what users in userpace
want and what kernel can offer, then realize legal requests and
refuse illegal requests. Not changing the requests from users.

Further more, can we replace upper/lower/work directories or mount
point by this .remount_fs?

If you want to export a new function, I think you should considering
more about these.

Thanks,
Hu

