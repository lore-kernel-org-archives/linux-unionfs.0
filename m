Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180508142617.GG3501@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <20180507174102.24086-18-vgoyal@redhat.com>
 <CAOQ4uxiXqKF1Vbg6HitUg6ax_Xy67mKDVS1t+P7pMT_57X=L5g@mail.gmail.com>
 <20180507205937.GB2945@redhat.com> <CAOQ4uxjozJMc6dLoj-tbX06YKYaBN7t5QUq1C0w+apV=Y=K-7w@mail.gmail.com>
 <20180508125043.GA3501@redhat.com> <CAOQ4uxiwc+8wxom4b_aJwV1VospoADx5U9iqyPpgmJayyFKZSw@mail.gmail.com>
 <20180508142617.GG3501@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 8 May 2018 18:04:09 +0300
Message-ID: <CAOQ4uxia4LjhrTBEJEGvaUe6k=STxmLRchOF2Xqw3zw4Fe0G7g@mail.gmail.com>
Subject: Re: [PATCH v15 17/30] ovl: Open file with data except for the case of fsync
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 8, 2018 at 5:26 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, May 08, 2018 at 05:14:42PM +0300, Amir Goldstein wrote:
>> On Tue, May 8, 2018 at 3:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >
>> [...]
>> >
>> > Ok, here is the updated patch. I have not defined quivalent of
>> > ovl_real_meta_file() as there are no users.
>> >
>> >
>> > Subject: ovl: Open file with data except for the case of fsync
>> >
>> > ovl_open() should open file which contains data and not open metacopy
>> > inode. With the introduction of metacopy inodes, with current implementaion
>> > we will end up opening metacopy inode as well.
>> >
>> > But there can be certain circumstances like ovl_fsync() where we
>> > want to allow opening a metacopy inode instead.
>> >
>> > Hence, change ovl_open_realfile() and ovl_open_real() and add extra
>> > parameter which specifies whether to allow opening metacopy inode or not.
>> > If this parameter is false, we look for data inode and open that.
>> >
>> > This should allow covering both the cases.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>
>> Nice! much shorter. You can add
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>>
>> BTW, I have never given that much thought, but I see that you
>> added Reviewed-by before Signed-off-by in some of the patches
>> and after SOB in other patches.
>> Of course it doesn't really matter and there isn't a single convention
>> in the kernel, but the way I always thought about it is:
>> You sign-off at the bottom on the complete work including all the tags
>> may have added.
>
> I was thinking about it and looked at some of the kernel commits and
> there seem to be a mix. There does not seem to be a fixed convention
> on the order of these tags.
>
> My take away was that they seem to be ordered FIFO order. So I
> do my Signed-off-by:, then you have your Reviewed-by and when
> Miklos merges these, he will put his sign-off-by.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>
> If you do not disagree with above, I will make order of Reviewed-by
> consistent in whole series and push again metacopy-next branch.
>

I am fine with the above.

Thanks,
Amir.
