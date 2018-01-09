From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 17/23] ovl: whiteout index when union nlink drops to zero
Date: Tue, 9 Jan 2018 18:41:05 +0200
Message-ID: <CAOQ4uxgpth2vm3fxm816GTjmy8oOkGeNG5TbgY3XtCo3A4uTRw@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-18-git-send-email-amir73il@gmail.com> <CAJfpegth4_NaeWLskFnd1uWrwXtJFkr72ps7LLDnngmvjPXP4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:37963 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759336AbeAIQlG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:41:06 -0500
Received: by mail-yb0-f195.google.com with SMTP id b132so3039744yba.5
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 08:41:06 -0800 (PST)
In-Reply-To: <CAJfpegth4_NaeWLskFnd1uWrwXtJFkr72ps7LLDnngmvjPXP4A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 9, 2018 at 6:28 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> With the 'verify' feature enabled, when overlay inode nlink drops to
>> zero, instead of removing the index entry, replace it with a whiteout
>> index entry.
>>
>> This is needed for NFS export in order to prevent future open by handle
>> from opening the lower file directly.
>
> Just thinking out loud: how could we get rid of index whiteouts in the
> "rm -rf" case?  Only way is if encoding parent as well, and we
> recursively check for a whiteout in the ancestors.   Probably not
> worth bothering with in the first version, but later maybe?
>

Right.

Current implementation already checks for whiteout in ancestors
for dir file handles, so in theory, cleanup of dir whiteouts is not far
from reach, except for the fact that decoding dir file handles is expensive,
so every cleanup attempt is going to cost.

For non-dir this is a more complicated.
If you encode parent (i.e. connectable file handle) then for lower hardlinks
you find a specific parent, but not all hardlink parents.

Anyway, maybe later.

Thanks,
Amir.
