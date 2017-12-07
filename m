From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4] ovl: Sync upper dirty data when sync overlayfs
Date: Thu, 7 Dec 2017 13:03:04 +0200
Message-ID: <CAOQ4uxj01coeCOjWCtDgrGZJhoe-_hRQahEiiCyEyO92kks6Kg@mail.gmail.com>
References: <1511920892-50942-1-git-send-email-cgxu@mykernel.net> <CAJfpegvtVm3kpU=Evm5bBS506btdgZxfU6dP7WEwj+sBaYNY2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:40980 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752766AbdLGLDG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 06:03:06 -0500
Received: by mail-yb0-f196.google.com with SMTP id y7so2791686ybm.8
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Dec 2017 03:03:05 -0800 (PST)
In-Reply-To: <CAJfpegvtVm3kpU=Evm5bBS506btdgZxfU6dP7WEwj+sBaYNY2A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chengguang Xu <cgxu@mykernel.net>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Dec 7, 2017 at 12:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Nov 29, 2017 at 3:01 AM, Chengguang Xu <cgxu@mykernel.net> wrote:
>> When executing filesystem sync or umount on overlayfs,
>> dirty data does not get synced as expected on upper filesystem.
>> This patch fixes sync filesystem method to keep data consistency
>> for overlayfs.
>
> Do we really need to export __sync_filesystem()?
>
> Just skipping wait == 0 and calling sync_filesystem() for wait == 1
> should be equivalent.
>
> Fixed up patch queued.  Let me know if I missed something...
>

Looks right to me.
There is even a bonus - emergency_sync() will invoke a single
__sync_filesystem(sb, 0) underlying fs regardless of the number of
mounted overlayfs.

Amir.
