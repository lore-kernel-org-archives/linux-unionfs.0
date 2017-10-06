From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 7/7] ovl: Fix ovl_getattr() to get size from lower
Date: Fri, 6 Oct 2017 18:32:15 +0300
Message-ID: <CAOQ4uxj1vpQVCaUNf5ajzTxur_Z-wQ_38Mo+b_ikD83j=QmUeg@mail.gmail.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
 <1506951605-31440-8-git-send-email-vgoyal@redhat.com> <CAOQ4uxhvN7xTK9Y7LXfuWoDY6NYRB9t+r=tb=_4oQO-2Ce_KRA@mail.gmail.com>
 <20171006151347.GA10750@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34955 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbdJFPcR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 11:32:17 -0400
Received: by mail-qt0-f196.google.com with SMTP id p15so4991737qtp.2
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2017 08:32:16 -0700 (PDT)
In-Reply-To: <20171006151347.GA10750@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 6, 2017 at 6:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Oct 02, 2017 at 10:40:07PM +0300, Amir Goldstein wrote:
>> On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > If an inode has been copied up metadata only, then we need to query the
>> > size from lower and fill up the stat->size.
>>
>> So you won't need this patch if you copy st_size on metadata_copy,
>> which seems like the logical thing to do.
>> Thinking very far into the future when METACOPY and ORIGIN will
>> be able to share page mappings, they will have to start with the same size.
>
> Hi Amir,
>
> What about "st_blocks"? After metadata copy up, doing stat on overlay file
> shows "st_blocks" as 0. I think I still will need to intervene and get
> st_blocks from lower file instead?
>

Yeh, I guess you would.
BTW, if it were up to me I would prefer a single call to vfs_getattr()
instead of one for STATX_INO and then another for STATX_BLOCKS.
Even though current code queries STATX_INO only for samefs case,
there are patches by Chandan to relax samefs in ovl_getattr().

Amir.
