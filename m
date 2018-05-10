Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:42424 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753696AbeEJFtm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 May 2018 01:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhMH8onqs0H5zZoptD0pLf8jk6JUtHR6EgVZkDembYQGA@mail.gmail.com>
References: <20180510015820.17700-1-rgoldwyn@suse.de> <20180510015820.17700-4-rgoldwyn@suse.de>
 <CAOQ4uxhMH8onqs0H5zZoptD0pLf8jk6JUtHR6EgVZkDembYQGA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 10 May 2018 08:49:40 +0300
Message-ID: <CAOQ4uxiZmEzpvzE8yYCtaUUFeknoF=6tGUS_o1jfYwGybbdjCQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] copy_file_range: splice with holes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 7:42 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, May 10, 2018 at 4:58 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> copy_file_range calls do_splice_direct() if fs->clone_file_range
>> or fs->copy_file_range() is not available. However, do_splice_direct()
>> converts holes to zeros. Detect holes in the file_in range, and
>> create them in the corresponding file_out range.
>>
>> If there is already data present at the offset in file_out, attempt
>> to punch a hole there. If the operation is not supported, fall
>> back to performing splice on the whole range.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/read_write.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 58 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 1b8fc9eada69..e765fec656af 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/compat.h>
>>  #include <linux/mount.h>
>>  #include <linux/fs.h>
>> +#include <linux/falloc.h>
>>  #include "internal.h"
>>
>>  #include <linux/uaccess.h>
>> @@ -1547,7 +1548,8 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
>>  {
>>         struct inode *inode_in = file_inode(file_in);
>>         struct inode *inode_out = file_inode(file_out);
>> -       ssize_t ret = 0;
>> +       ssize_t ret = 0, total = 0;
>> +       loff_t size, end;
>>
>>         if (len == 0)
>>                 return 0;
>> @@ -1572,10 +1574,62 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
>>                 if (ret != -EOPNOTSUPP)
>>                         return ret;
>>         }
>> +
>>  splice:
>> -       ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
>> -                       len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
>> -       return ret;
>> +       while (total < len) {
>> +               end = vfs_llseek(file_in, pos_in, SEEK_HOLE);
>> +
>> +               /* Starting position is already in a hole */
>> +               if (end == pos_in)
>> +                       goto hole;
>> +               size = end - pos_in;
>> +do_splice:
>> +               if (size > len - total)
>> +                       size = len - total;
>> +               ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
>> +                               size, 0);
>
> I wonder, can do_splice_direct() return short copy (< size)?
> If so, code below will try to punch a zero length hole.
> Best put some protection here, don't you think?
>
>> +               if (ret < 0)
>> +                       goto out;
>> +               total += ret;
>> +               if (total == len)
>> +                       break;
>> +hole:
>> +               end = vfs_llseek(file_in, pos_in, SEEK_DATA);
>> +               if (end < 0) {
>> +                       ret = end;
>> +                       goto out;
>> +               }
>> +               size = end - pos_in;
>> +               if (size > len - total)
>> +                       size = len - total;
>> +               /* Data on offset, punch holes */
>> +               if (i_size_read(file_out->f_inode) > pos_out) {
>> +                       ret = vfs_fallocate(file_out,
>> +                                       FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
>> +                                       pos_out, size);
>
> I'm afraid you have more re-factoring to do vfs_fallocate() does
> file_start_write() -
> you probably need do_fallocate().
>
>

I was trying to look for a pattern of what goes in vfs_ helpers and their
corresponding do_ helpers and I can't say I found a single pattern.

What stood out for me is the do_clone_file_range() is a wrapper
around vfs_clone_file_range() while do_truncate() is a helper
of vfs_truncate(). I did not survey all of those helpers, but I have
a feeling that the latter is the more common pattern and I know
who to blame for the former...

Anyway, this anomaly, explains why overlayfs calls
vfs_clone_file_range() and it cannot call vfs_fallocate()
from the copy up loop context.

I advise you to turn on LOCKDEP while testing to be warned
about this sort of things.

Thanks,
Amir.
