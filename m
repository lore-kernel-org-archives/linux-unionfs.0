Return-Path: <cgxu519@gmx.com>
Subject: Re: Postpone copy-up until first real write?
References: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com>
 <CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
 <CAJfpegvJU32_9_mVh7kem0s529-8Qs02fPSr4ChCC3ZJ2pRhLw@mail.gmail.com>
 <CAOQ4uxg=Qzau99ZWwNRoEHAKgpMTapDFxjQhCE+ntEbV2AFVOg@mail.gmail.com>
From: cgxu519 <cgxu519@gmx.com>
Message-ID: <cc831a7a-c515-fdd2-6971-e79d389058a0@gmx.com>
Date: Mon, 14 Jan 2019 16:21:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxg=Qzau99ZWwNRoEHAKgpMTapDFxjQhCE+ntEbV2AFVOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>


On 1/13/19 7:25 PM, Amir Goldstein wrote:
> On Mon, Oct 8, 2018 at 5:41 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, Jun 29, 2018 at 12:28 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Fri, Jun 29, 2018 at 6:35 AM, cgxu519 <cgxu519@gmx.com> wrote:
>>>> Hi guys,
>>>>
>>>> I have a simple question about copy-up timing after implementing stacked
>>>> file operation.
>>>> Could we postpone copy-up until first real write happens?
>>>>
>>>> The background is consuming much time on open is unexpected for some of our
>>>> applications.
>>>>
> Getting back to this with some more questions...
>
>>> I need this behavior as well for snapshots.
>>> On first glance it looks feasible to me.
>>> Seems like we could relax copy up on open(O_RDWR) if there were no special
>>> open flags (O_TRUNC, O_CREATE, O_APPEND...), then mask out O_ACCMODE
>>> if opening a lower inode and defer copy up to ovl_real_fdget_meta() in case the
>>> O_ACCMODE flags of file and real->file don't match.
>>>
>>> Then we can introduce ovl_real_fdget_read() call to be used in ovl_read_iter()
>>> and ovl_copyfile() (in_file) in which cases the mismatch O_ACCMODE flags
>>> doesn't need to be corrected with copy up.
>>>
>>> Miklos? Does this sound reasonable to you?
>> So now that the stacked file ops are merged we can take a look at
>> these somewhat related issues:
>>
>>   - shared r/o mmap of lower file
>>   - delayed copy up until first write
>>   - delayed copy up until first write fault on shared r/w mmap.
>>
> These 3 issues map closely together, but do not cover all "delayed copy up"
> cases. Even if we do implement copy up on first write fault, we'd still need
> to perform delayed copy up for fallocate(),clone_range(),dedupe_range(),
> so perhaps my suggestion above for simpler(?) first step implementation of
> "delayed copy up until first write" without bundling it together with the
> shared maps issues still makes some sense?
>
>> My idea would be to have three (or four) states for each in core overlay inode:
>>
>>    LOWER:  opened only for read or not opened at all and mmaped with
>> MAP_PRIVATE  or not mapped at all
>>    LOWER_SHARED: opened for read/write or mmaped MAP_SHARED
>>    UPPER_SHARED: copied up
>>    (UPPER:  copied up and all open files referring to the inode were
>> opened in the UPPER state)
>>
>> The LOWER_SHARED state is basically in anticipation of copy-up,
>> without actually committing to the upper layer.
>>
>> The UPPER state could just be an optimization, that would be otherwise
>> equivalent to the UPPER_SHARED state.
>>
>> I/O paths for the different states would be:
>>
>> LOWER/UPPER: just like now: read/write are stacked, mmap goes directly
>> to "realfile"
>> *_SHARED: just like a normal filesystem: uses
>> generic_file_{read|write}_iter, generic_mmap, defines own a_ops,
>> vm_ops.
>>
>> So basically the _SHARED mode loses the cache sharing property of
>> LOWER, but gains the consistency offered by a unified page cache
>> regardless of which layer the file is stored in.
>>
>> Thoughts?
>>
> Did you give any consideration to the locking order of copy up
> from write fault context?
>
> I suppose you are aware of this hence the proposal of pre_mmap op:
> https://marc.info/?l=linux-fsdevel&m=152760695502640&w=2
>
> Do we gain anything (simplicity? relaxed locking order) if we always
> copy up metadata on open O_RDWR and only delay data copy up
> until first write/page fault?
>
> Chengguang,
>
> For your use case, is it acceptable if we copy up metadata
> (and parents) before first write?

In our use case that will be fine if copy up metadata(and parents) is 
quick enough.



>
> Anyway, if no one else is working on this I am willing to take
> a swing at it, but it seems to me like it would be best to leave
> stacked a_ops for phase two. Thoughts?

I'm sorry that I could not focus on this because now I'm in some
other urgent projects. So please take it up if you can.

Thanks,
Chengguang.
