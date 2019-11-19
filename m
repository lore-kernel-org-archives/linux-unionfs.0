Return-Path: <jiufei.xue@linux.alibaba.com>
Subject: Re: [PATCH 1/2] vfs: add vfs_iocb_iter_[read|write] helper functions
References: <1574129643-14664-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1574129643-14664-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <CAOQ4uxgZZ=noynAZWmiuJupdqsfPw1AkG3TJc+JBk6fAv7ofOA@mail.gmail.com>
From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <f22addae-7fb5-4f3d-28eb-c738597053cb@linux.alibaba.com>
Date: Tue, 19 Nov 2019 16:40:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgZZ=noynAZWmiuJupdqsfPw1AkG3TJc+JBk6fAv7ofOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>


Hi Amir,
On 2019/11/19 上午11:14, Amir Goldstein wrote:
> On Tue, Nov 19, 2019 at 4:14 AM Jiufei Xue <jiufei.xue@linux.alibaba.com> wrote:
>>
>> This isn't cause any behavior changes and will be used by overlay
>> async IO implementation.
>>
>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>> ---
>>  fs/read_write.c    | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/fs.h | 16 +++++++++++++++
>>  2 files changed, 74 insertions(+)
>>
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 5bbf587..3dfbcec 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -984,6 +984,64 @@ ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
>>  }
>>  EXPORT_SYMBOL(vfs_iter_write);
>>
>> +ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
>> +                          struct iov_iter *iter)
>> +{
>> +       ssize_t ret = 0;
>> +       ssize_t tot_len;
>> +
>> +       if (!file->f_op->read_iter)
>> +               return -EINVAL;
>> +       if (!(file->f_mode & FMODE_READ))
>> +               return -EBADF;
>> +       if (!(file->f_mode & FMODE_CAN_READ))
>> +               return -EINVAL;
>> +
>> +       tot_len = iov_iter_count(iter);
>> +       if (!tot_len)
>> +               return 0;
>> +
>> +       ret = rw_verify_area(READ, file, &iocb->ki_pos, tot_len);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       ret = call_read_iter(file, iocb, iter);
>> +       if (ret >= 0)
>> +               fsnotify_access(file);
>> +
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL(vfs_iocb_iter_read);
>> +
>> +ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
>> +                           struct iov_iter *iter)
>> +{
>> +       ssize_t ret = 0;
>> +       ssize_t tot_len;
>> +
>> +       if (!file->f_op->write_iter)
>> +               return -EINVAL;
>> +       if (!(file->f_mode & FMODE_WRITE))
>> +               return -EBADF;
>> +       if (!(file->f_mode & FMODE_CAN_WRITE))
>> +               return -EINVAL;
>> +
>> +       tot_len = iov_iter_count(iter);
>> +       if (!tot_len)
>> +               return 0;
>> +
>> +       ret = rw_verify_area(WRITE, file, &iocb->ki_pos, tot_len);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       ret = call_write_iter(file, iocb, iter);
>> +       if (ret >= 0)
>> +               fsnotify_modify(file);
>> +
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL(vfs_iocb_iter_write);
>> +
> 
> If it was up to me, I would pass down an optional iocb pointer
> to the do_iter_XXX static helpers, instead of duplicating the code.
> Others may find your approach cleaner, so let's see what other
> people think.
>

Thanks for your review. I have considered your suggestion and
still think that adding new helpers are more clearly.

Let's wait for other people's opinions.

Thanks,
Jiufei

> Thanks,
> Amir.
> 
