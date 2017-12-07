From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v4] ovl: Sync upper dirty data when sync overlayfs
Date: Thu, 7 Dec 2017 11:19:47 +0100
Message-ID: <CAJfpegvtVm3kpU=Evm5bBS506btdgZxfU6dP7WEwj+sBaYNY2A@mail.gmail.com>
References: <1511920892-50942-1-git-send-email-cgxu@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:33536 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbdLGKTs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 05:19:48 -0500
Received: by mail-qt0-f179.google.com with SMTP id e2so16211691qti.0
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Dec 2017 02:19:48 -0800 (PST)
In-Reply-To: <1511920892-50942-1-git-send-email-cgxu@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu@mykernel.net>
Cc: Amir Goldstein <amir73il@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 29, 2017 at 3:01 AM, Chengguang Xu <cgxu@mykernel.net> wrote:
> When executing filesystem sync or umount on overlayfs,
> dirty data does not get synced as expected on upper filesystem.
> This patch fixes sync filesystem method to keep data consistency
> for overlayfs.

Do we really need to export __sync_filesystem()?

Just skipping wait == 0 and calling sync_filesystem() for wait == 1
should be equivalent.

Fixed up patch queued.  Let me know if I missed something...

Thanks,
Miklos
