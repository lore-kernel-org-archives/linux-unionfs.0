From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Small code issue
Date: Thu, 5 Mar 2015 17:46:17 +0100
Message-ID: <CAJfpegsxSFPHMb-V1g2hNo8mihW6+wtZoBpvNcjiUiLQXV5V0g@mail.gmail.com>
References: <54CF1F01.5000204@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45746 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784AbbCEQqS (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 5 Mar 2015 11:46:18 -0500
Received: by qcwb13 with SMTP id b13so6335140qcw.12
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Mar 2015 08:46:17 -0800 (PST)
In-Reply-To: <54CF1F01.5000204@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Feb 2, 2015 at 7:53 AM, hujianyang <hujianyang@huawei.com> wrote:
> Hi Miklos,
>
> I was backporting overlayfs for linux 3.16 last week and
> found a small issue in the patch:
>
> commit c771d683: vfs: introduce clone_private_mount()
>
> this patch adds *struct path* to include/linux/mount.h,
> but actually *struct path* is already added to this file
> by
>
> commit 3064c356: death to mnt_pinned
>
>
> It's bother to send a patch for fixing an issue like this,
> so if you've got other same problems, you could merge
> them with this together.

Lets just create a separate patch.

Thanks,
Miklos
