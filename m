From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v10 00/18] overlayfs: Delayed copy up of data
Date: Sat, 27 Jan 2018 18:38:53 +0200
Message-ID: <CAOQ4uxg4nzMh1YHJnUbt8+iDQnHmkBAz_Q5vcrnaSpxRgyU0dA@mail.gmail.com>
References: <20180122184004.26026-1-vgoyal@redhat.com> <CAJfpegtdEJp7+QZj16uGY4wZ8eaTDO_0YH5T0qPnS=L5tMS8-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:44463 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbeA0Qiy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 27 Jan 2018 11:38:54 -0500
Received: by mail-yw0-f181.google.com with SMTP id x62so1280388ywg.11
        for <linux-unionfs@vger.kernel.org>; Sat, 27 Jan 2018 08:38:54 -0800 (PST)
In-Reply-To: <CAJfpegtdEJp7+QZj16uGY4wZ8eaTDO_0YH5T0qPnS=L5tMS8-A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Matthew Wilcox <mawilcox@microsoft.com>

On Wed, Jan 24, 2018 at 11:05 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Jan 22, 2018 at 7:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> Hi,
>>
>> Please find attached V10 of the metadata only copy up patches. I think
>> I have taken care of review comments and I will start writing automated
>> test cases now.
>>
>> One thing which concerns me about these patches is the fact that during
>> file open d_real() will return lower inode which actually contains file
>> data and that inode will be installed in f->f_inode. So while f->f_inode
>> is perfectly fine for data operations, it is not fine for metadata
>> operations. Because metadata has been copied up and is represented by
>> a different inode.
>>
>> I am concerned that this is a subtle behavior change and especially
>> security modules might be surprised by it. I will spend now more time
>> looking at what security modules are doing with f->f_inode. Thoughts?
>
> This is exactly the same situation where there is an r/o open and
> copy-up later.  Except this makes it more widespread.  So I don't
> think any new issues are introduced (doesn't mean there aren't any old
> ones).
>
> The only risk I see with this feature is exactly the fact that the
> ro/rw inconsistency can happen more often, which might break more
> cases.  I'd really like to work on getting rid of this issue.
> Hopefully next cycle...
>

About that. I suppose you mean taking the route of intercepting
overlayfs file operations, so the only remaining concern would be
mmap?

FYI, I am still maintaining my "copy on read" patches [1] and use them for
snapshots. The last patch is a late addition that is aimed at integrating
with metacopy for "copy on read" for non-clone/non-same fs case.

Rummer has it [2] that Matthew Wilcox is going to tackle sharing page
cache between cloned inodes.

Mathew,

I wanted to bring the overlayfs "metacopy" use case to your attention,
so you can take it into account when implementing page cache sharing.
This was more or less the solution proposed by Al to inconsistent data
of a r/o open file:
- Create a "metacopy" inode in upper layer when opening a file for read
- Share page cache of lower layer inode with upper layer "metacopy" inode
- When upper file is opened for write, data is copied to upper inode and
  page cache sharing is broken.
- After breaking page cache sharing, the upper inode becomes the backing
  inode, but unshared pages content is guarantied to be uptodate and non
  dirty

So "metacopy" is an all-or-nothing private case of file cloning.
If undelying fs supports clones, then page cache sharing is not broken
on open for write, but it is converted from "metacopy" situation, to the
common cloned file situation - the backing inode is the upper inode,
bit its shares all the blocks with lower inode.

Please keep linux-unionfs posted when you have any progress.
I'd be happy to test any WIP you might have.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-rocopyup
[2] https://marc.info/?l=linux-xfs&m=151705246227384&w=2
