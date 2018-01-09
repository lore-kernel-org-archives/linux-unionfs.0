From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 07/23] ovl: verify stored origin fh matches lower dir
Date: Tue, 9 Jan 2018 11:17:11 +0100
Message-ID: <CAJfpegv=0qCECaCW_VCazhgQQHrd5YxJSvLxL4345a5DUAVkKw@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-8-git-send-email-amir73il@gmail.com> <CAJfpegvR5=-GdD1sx81+TuPXNi6BFbpwcRKyOTmH7d59DLwB6w@mail.gmail.com>
 <CAOQ4uxjk4JiWoZgbHG94e=V_5fFOCsH7nWAzMevTV3EhE7ma2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:42803 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbeAIKRM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 05:17:12 -0500
Received: by mail-qk0-f182.google.com with SMTP id q1so807031qkb.9
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 02:17:12 -0800 (PST)
In-Reply-To: <CAOQ4uxjk4JiWoZgbHG94e=V_5fFOCsH7nWAzMevTV3EhE7ma2w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 9, 2018 at 11:04 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Jan 9, 2018 at 11:52 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:

> Yeh, I like that option much better. Especially, I like that it saves me the
> trouble of documenting when it makes sense to turn on "verify" for
> non-NFS case, because I don't know when it makes sense.
>
> I will try to adjust documentation to explain that with NFS export enabled
> lookup of merge dir becomes more "file handle oriented" and is therefore
> less sensitive to some offlline changes (rename) and more sensitive to
> other offline changes (remove+create).

Okay.  So lets start with a broad "nfs_export=on/off" option, and if
later it becomes necessary add more fine grained options controlling
parts of what encompassed by this option.

Thanks,
Miklos
