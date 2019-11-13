Return-Path: <jiufei.xue@linux.alibaba.com>
Subject: Re: [Regression] performance regression since v4.19
References: <1086cadc-53c3-effd-5ba3-797a015944b5@linux.alibaba.com>
 <CAJfpegu0CkBUTnkgv+C-cXopoj7oPjqsbFwN49EMhTw7=Pv+Tw@mail.gmail.com>
 <CAOQ4uxhKSjubpEnRCDLEYjS77DzT9g6KsXjWv9Sirq-mbQMvHA@mail.gmail.com>
From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <4b0f6b6e-3f72-defa-a064-2cf4c8f0dd30@linux.alibaba.com>
Date: Wed, 13 Nov 2019 14:33:15 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhKSjubpEnRCDLEYjS77DzT9g6KsXjWv9Sirq-mbQMvHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
List-ID: <linux-unionfs@vger.kernel.org>


Hi,
On 2019/11/12 下午6:48, Amir Goldstein wrote:
> On Tue, Nov 12, 2019 at 11:15 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> On Tue, Nov 12, 2019 at 8:53 AM Jiufei Xue <jiufei.xue@linux.alibaba.com> wrote:
>>>
>>> Hi Miklos,
>>>
>>> A performance regression is observed since linux v4.19 when we do aio
>>> test using fio with iodepth 128 on overlayfs. And we found that queue
>>> depth of the device is always 1 which is unexpected.
>>>
>>> After investigation, it is found that commit 16914e6fc7
>>> (“ovl: add ovl_read_iter()”) and commit 2a92e07edc
>>> (“ovl: add ovl_write_iter()”) use do_iter_readv_writev() to submit
>>> requests to real filesystem. Async IOs are converted to sync IOs here
>>> and cause performance regression.
>>>
>>> I wondered that is this a design flaw or supposed to be.
>>
>> It's not theoretically difficult to fix.   The challenge is to do it
>> without too much complexity or code duplication.
>>
>> Maybe best would be to introduce VFS helpers specially for stacked
>> operation such as:
>>
>>   ssize_t vfs_read_iter_on_file(struct file *file, struct kiocb
>> *orig_iocb, struct iov_iter *iter);
>>   ssize_t vfs_write_iter_on_file(struct file *file, struct kiocb
>> *orig_iocb, struct iov_iter *iter);
>>
>> Implementation-wise I'm quite sure we need to allocate a new kiocb and
>> initialize it from the old one, adding our own completion callback.
>>
> 
> Isn't it "just" a matter of implementing ovl-aops and
> generic_file_read/write_iter() will have done the aio properly?
> 
> I don't remember at what state we left the ovl-aops experiment [1]
> IIRC, it passed most xfstests, but had some more corner cases to
> cover.
> 
> Jiufei,
> 
> If you are interested, you can try out the experimental code [2] to
> see how it plays with aio, although since readpages/writepages
> are not implemented, overall performance may not be better
> (or even worse).
>

Thanks for your reply.

I have checked the experimental code [2] and found that ovl_direct_IO()
also converted async IOs to sync. So I don't think it can solve the
regression.

Thanks,
Jiufei.

> Thanks,
> Amir.
> 
> [1] https://marc.info/?l=linux-unionfs&m=154995908004146&w=2
> [2] https://github.com/amir73il/linux/commits/ovl-aops-wip
> 
