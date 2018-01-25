From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay: hardlink all whiteout files into a single whiteout
Date: Thu, 25 Jan 2018 13:34:43 +0200
Message-ID: <CAOQ4uxhm2KHwQ7bzZWF=9OHW=w2Vu8cWYr=sN6CQc1UDXvA7nw@mail.gmail.com>
References: <20180125095800.19434-1-houtao1@huawei.com> <CAJfpegtmX9euEZirYFn6hyjTWkv2UaK2uFrcOekJUhtBADZ01g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:33301 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751720AbeAYLeo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Jan 2018 06:34:44 -0500
Received: by mail-yw0-f180.google.com with SMTP id x24so2777144ywj.0
        for <linux-unionfs@vger.kernel.org>; Thu, 25 Jan 2018 03:34:44 -0800 (PST)
In-Reply-To: <CAJfpegtmX9euEZirYFn6hyjTWkv2UaK2uFrcOekJUhtBADZ01g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Hou Tao <houtao1@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 25, 2018 at 12:17 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 25, 2018 at 10:58 AM, Hou Tao <houtao1@huawei.com> wrote:
>> Now each whiteout file will be assigned a new inode. To reduce the
>> overhead of allocating and freeing inodes in upper fs, creating a
>> whiteout file under workbasedir and hardlink all whiteout files into it.
>>
>> The effect is obvious: under my VM, the time used for removing the
>> linux kernel source tree will be reduced from 17s to 10s.
>>
>> Got the idea from autofs.
>
> Yep, this was talked about, then forgotten.  Thanks for bringing it up.
>
> The implementation is a little more difficult though, because there's
> a limit to how many hard links to a single file are allowed.
>
> So it should be something like:
>
> - try hard linking "singleton", if succeeds then fine
> - else unlink old singleton from workdir, create new one and use that one
(only in case link error is EMLINK)
- else if error is EXDEV then upper probably has a project id different
than the singleton, so fall back to no hardlink

>
> If it's possible to get a filesystem as upper that doesn't support
> hard links at all, then that also needs to be taken care of, to fall
> back to non-hard linked whiteouts.

Chengguang's patch for project id already does a test link on
mount, so that is a good starting point. if link fails and NOT because
of EXDEV, then index also cannot be used...

Thanks,
Amir.
