From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 03/39] vfs: dedupe: extract helper for a single dedup
Date: Tue, 29 May 2018 19:04:47 +0300
Message-ID: <CAOQ4uxiUUtLAMxvDg8hMcgqZUV96dLs8stJPgh6w-pj4KGvabw@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-4-mszeredi@redhat.com>
 <CAOQ4uxi5Y4mF9b9g5a_ggEUWPToKbRUsuzwN4aGjvnQ6itRkUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxi5Y4mF9b9g5a_ggEUWPToKbRUsuzwN4aGjvnQ6itRkUw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 6:41 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, May 29, 2018 at 5:43 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>> Extract vfs_dedupe_file_range_one() helper to deal with a single dedup
>> request.
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> ---
>>  fs/read_write.c | 89 +++++++++++++++++++++++++++++++--------------------------
>>  1 file changed, 49 insertions(+), 40 deletions(-)
>>
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 1818581cadf6..82a53c44c0aa 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -1964,6 +1964,44 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>>  }
>>  EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
>>
>> +static s64 vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
>> +                                    struct file *dst_file, loff_t dst_pos,
>> +                                    u64 len)
>> +{
>> +       s64 ret;
>> +
>> +       ret = mnt_want_write_file(dst_file);
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = clone_verify_area(dst_file, dst_pos, len, true);
>> +       if (ret < 0)
>> +               goto out_drop_write;
>> +
>> +       ret = -EINVAL;
>> +       if (!(capable(CAP_SYS_ADMIN) || (dst_file->f_mode & FMODE_WRITE)))
>> +               goto out_drop_write;
>> +
>> +       ret = -EXDEV;
>> +       if (src_file->f_path.mnt != dst_file->f_path.mnt)
>> +               goto out_drop_write;
>> +
>> +       ret = -EISDIR;
>> +       if (S_ISDIR(file_inode(dst_file)->i_mode))
>> +               goto out_drop_write;
>> +
>> +       ret = -EINVAL;
>> +       if (!dst_file->f_op->dedupe_file_range)
>> +               goto out_drop_write;
>> +
>> +       ret = dst_file->f_op->dedupe_file_range(src_file, src_pos,
>> +                                               dst_file, dst_pos, len);
>> +out_drop_write:
>> +       mnt_drop_write_file(dst_file);
>> +
>> +       return ret;
>> +}
>> +
>>  int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>>  {
>>         struct file_dedupe_range_info *info;
>> @@ -1972,10 +2010,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>>         u64 len;
>>         int i;
>>         int ret;
>> -       bool is_admin = capable(CAP_SYS_ADMIN);
>>         u16 count = same->dest_count;
>> -       struct file *dst_file;
>> -       loff_t dst_off;
>>         loff_t deduped;
>>
>>         if (!(file->f_mode & FMODE_READ))
>> @@ -2010,54 +2045,28 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>>         }
>>
>>         for (i = 0, info = same->info; i < count; i++, info++) {
>> -               struct inode *dst;
>>                 struct fd dst_fd = fdget(info->dest_fd);
>> +               struct file *dst_file = dst_fd.file;
>>
>> -               dst_file = dst_fd.file;
>>                 if (!dst_file) {
>>                         info->status = -EBADF;
>>                         goto next_loop;
>>                 }
>> -               dst = file_inode(dst_file);
>> -
>> -               ret = mnt_want_write_file(dst_file);
>> -               if (ret) {
>> -                       info->status = ret;
>> -                       goto next_loop;
>> -               }
>> -
>> -               dst_off = info->dest_offset;
>> -               ret = clone_verify_area(dst_file, dst_off, len, true);
>> -               if (ret < 0) {
>> -                       info->status = ret;
>> -                       goto next_file;
>> -               }
>> -               ret = 0;
>>
>>                 if (info->reserved) {
>>                         info->status = -EINVAL;
>> -               } else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
>> -                       info->status = -EINVAL;
>> -               } else if (file->f_path.mnt != dst_file->f_path.mnt) {
>> -                       info->status = -EXDEV;
>> -               } else if (S_ISDIR(dst->i_mode)) {
>> -                       info->status = -EISDIR;
>> -               } else if (dst_file->f_op->dedupe_file_range == NULL) {
>> -                       info->status = -EINVAL;
>> -               } else {
>> -                       deduped = dst_file->f_op->dedupe_file_range(file, off,
>> -                                                       dst_file,
>> -                                                       info->dest_offset, len);
>> -                       if (deduped == -EBADE)
>> -                               info->status = FILE_DEDUPE_RANGE_DIFFERS;
>> -                       else if (deduped < 0)
>> -                               info->status = deduped;
>> -                       else
>> -                               info->bytes_deduped += deduped;
>> +                       goto next_loop;
>>                 }
>>
>> -next_file:
>> -               mnt_drop_write_file(dst_file);
>> +               deduped = vfs_dedupe_file_range_one(file, off, dst_file,
>> +                                                   info->dest_offset, len);
>> +               if (deduped == -EBADE)
>> +                       info->status = FILE_DEDUPE_RANGE_DIFFERS;
>> +               else if (deduped < 0)
>> +                       info->status = deduped;
>> +               else
>> +                       info->bytes_deduped += deduped;
>> +
>>  next_loop:
>>                 fdput(dst_fd);
>>
>
> Please note that this patch conflicts with but is also an alternative to commit
> 227627114799 fs: avoid fdput() after failed fdget() in vfs_dedupe_file_range()
> on Al's fixes => for-next branch.
>

Sorry, that's a conflict, and a rather trivial one, but Miklos' patch is not
an alternative fix.

Thanks,
Amir.
