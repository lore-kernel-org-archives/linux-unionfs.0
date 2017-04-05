From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 5/6] ovl: copy on read with consistent_fd feature
Date: Wed, 5 Apr 2017 16:20:28 +0300
Message-ID: <CAOQ4uxj_P9ohwwy2sGGrJkNcWfV89C34g0qkY-RGdWoPxfY7Dw@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <1490798166-22310-6-git-send-email-amir73il@gmail.com> <20170331175843.GB3681@redhat.com>
 <CAOQ4uxjgjp8EdZzjuC7QeCQ66YO5fvtWAMiFyjPZw1npQQXHLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34564 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753722AbdDENUa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Apr 2017 09:20:30 -0400
Received: by mail-oi0-f54.google.com with SMTP id d2so14672462oig.1
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Apr 2017 06:20:29 -0700 (PDT)
In-Reply-To: <CAOQ4uxjgjp8EdZzjuC7QeCQ66YO5fvtWAMiFyjPZw1npQQXHLw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Sat, Apr 1, 2017 at 12:27 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Mar 31, 2017 at 8:58 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Wed, Mar 29, 2017 at 05:36:05PM +0300, Amir Goldstein wrote:
>>> Overlayfs copies up a file when the file is opened for write.  Writes
>>> to the returned file descriptor are not visible to file descriptors
>>> that were opened for read prior to copy up.
>>>
>>> If this config option is enabled then overlay filesystems will default
>>> to copy up a file that is opened for read to avoid this inconsistency.
>>> In this case, it is still possible to turn off consistent fd globally
>>> with the "consistent_fd=off" module option or on a filesystem instance
>>> basis with the "consistent_fd=off" mount option.
>>
>> Hi Amir,
>>
>
> Hi Vivek,
>
>> So all readers will pay a small cost of copying up file always (as temp
>> file). I am curious to know if that cost is significant.
>>
>
[...]
>> Are there any other downsides of opting in for this behavior by default.
>> I am assuming page cache usage will not be higher due to clone operation.
>>
>
> Sadly, page cache is not shared between cloned file.
> That's something Miklos is trying to look into.
>
> So at this point, enabling consistent_fd should be done only for
> use cases that really care about consistent fd and willing to pay
> the cost of clone, extra usage of page cache and
> the extra I/O of reading those pages.
>

Miklos,

Did you get a change to look at the patches?
Is this aligned with what you had in mind?

Also, wrt Vivek's question on other impacts, I forgot to mention
that "temp read-only copy up" does an actual copy up of parent directory
ancestry, which does not go away when file is closed.

Which means that it may make sense to couple consistent_fd feature
with your old proposal to opt-in for copy up directory on getattr:
http://www.spinics.net/lists/linux-unionfs/msg00862.html

The logic being: if you care about ro/rw consistency and willing to pay
the cost of copy up of every parent dir of a file that has ever been read,
perhaps the extra cost of copy up dir on getattr is a small extra to pay
to get a bit more consistency?

Or perhaps you think that the cost of parent ancestry copy up
for open for read is too expensive to begin with and I should try to
get rid of this cost?

There are a few reasons I chose to copy up parents on rocopyup:
1. It keeps the code simpler (more code reuse with rw tmpfile copy up)
2. vfs_tmpfile() checks inode_permission(MAY_WRITE | MAY_EXEC)
    on parent dir inode and passes the inode to i_op->tmpfile().
    it's not clear to me if that dir inode is really important or if I
could just
    pass workdir inode or something(?)
3. inode_lock_nested(upperdir->d_inode) is used to serialize ro upper
    copy up with rw upper copy up -
    damn! not only should I have used copyup_wq for that purpose, but
    also I think I got the rocopyup-rocopyup race completely wrong :-/

I'll await your feedback on the series before I fix this race.

Amir.
