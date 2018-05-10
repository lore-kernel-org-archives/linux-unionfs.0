Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:37853 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753901AbeEJExA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 May 2018 00:53:00 -0400
MIME-Version: 1.0
In-Reply-To: <254dfd61-8c9a-9cc9-5f95-c0227eef484c@suse.de>
References: <20180508212405.15297-1-rgoldwyn@suse.de> <20180508212405.15297-5-rgoldwyn@suse.de>
 <CAOQ4uxhsjHjRy1hKwFyH7nkEE0Y_tv9sSh2dMLLwrVoM6fBeJw@mail.gmail.com> <254dfd61-8c9a-9cc9-5f95-c0227eef484c@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 10 May 2018 07:52:59 +0300
Message-ID: <CAOQ4uxgzveJKYVSKmYZAtwrb=r6dkHjxXqSyWfS64SDWgDc-EA@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: Use do_copy_file_range() in copy_up_data()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 9, 2018 at 10:13 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
>
> On 05/09/2018 12:50 AM, Amir Goldstein wrote:
>> On Wed, May 9, 2018 at 12:24 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>
>>> This will preserve the holes and will clone(), if available.
>>>
>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>>
>> Only please mention in commit message that it changes behavoir
>> slightly for a very large file (clone in chunks).
>
> Change behavior? Only it will have holes. It will still respect length.
> Actually, I found a bug when it would not respect length if offset is
> father than length which I have fixed.

What I meant is the change of behavior for when underlying fs supports
clone.
Your patch changes the behavior for a very large file from single call
to vfs_clone_file_range() on entire length to several calls in a loop.

Nevermind. It's too insignificant for anyone to care.
If overlayfs ever supports NFS as upper layer, we may want to rethink
this.

Thanks,
Amir.
