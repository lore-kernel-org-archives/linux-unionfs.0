Return-Path: <cgxu519@gmx.com>
Subject: Re: Postpone copy-up until first real write?
References: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com>
 <CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
From: cgxu519 <cgxu519@gmx.com>
Message-ID: <53e5935f-71bd-4a3f-6349-e23a8fd8395b@gmx.com>
Date: Fri, 29 Jun 2018 19:57:33 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On 06/29/2018 06:28 PM, Amir Goldstein wrote:
> On Fri, Jun 29, 2018 at 6:35 AM, cgxu519 <cgxu519@gmx.com> wrote:
>> Hi guys,
>>
>> I have a simple question about copy-up timing after implementing stacked
>> file operation.
>> Could we postpone copy-up until first real write happens?
>>
>> The background is consuming much time on open is unexpected for some of our
>> applications.
>>
> I need this behavior as well for snapshots.
> On first glance it looks feasible to me.
> Seems like we could relax copy up on open(O_RDWR) if there were no special
> open flags (O_TRUNC, O_CREATE, O_APPEND...), then mask out O_ACCMODE
> if opening a lower inode and defer copy up to ovl_real_fdget_meta() in case the
> O_ACCMODE flags of file and real->file don't match.
>
> Then we can introduce ovl_real_fdget_read() call to be used in ovl_read_iter()
> and ovl_copyfile() (in_file) in which cases the mismatch O_ACCMODE flags
> doesn't need to be corrected with copy up.
>
> Miklos? Does this sound reasonable to you?
>
> Chengguang,
>
> Will you take a swing at implementing this if there are no holes found
> in the plan?
Sure, I'll do if the behavior is welcomed.

> Do you know if your applications typically open files with O_RDWR? any
> other flags?
> Deferring copy up to first write with O_WRONLY seems a bit more tricky.

Most of them open with O_RDWR but I'm not sure there is no O_WRONLY with 
complain in the future. :-/

Thanks,
Chengguang
