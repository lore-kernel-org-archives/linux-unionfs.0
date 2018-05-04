Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180504155427.GA2713@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-10-vgoyal@redhat.com>
 <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com>
 <20180430140243.GB7960@redhat.com> <CAOQ4uximhvDrOn6s-5X-BeGvfG0RtTBU-WA6fEjfyYEkn4jvNw@mail.gmail.com>
 <CAOQ4uxg5zDffN8VneWQCTd4N+trCCx0v7=paL9_hdMZj5CidYA@mail.gmail.com>
 <20180503151220.GB10792@redhat.com> <CAOQ4uxj5G33vzQabE7hVfyF9v5YT0XxjxK6u5_Vo-g2e_vgO_A@mail.gmail.com>
 <CAOQ4uxjgymQDswFOQkLOgRXtoZFw77V3ycWy4Uvjrrs5KAQ0rw@mail.gmail.com> <20180504155427.GA2713@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 4 May 2018 21:47:01 +0300
Message-ID: <CAOQ4uxg+noF6dRtE0UQ6M607QkOxz8rAnzrTrvS0PuTcb5VnFQ@mail.gmail.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 4, 2018 at 6:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, May 04, 2018 at 10:04:22AM +0300, Amir Goldstein wrote:
[...]
>> >
>> > Just maybe missing the case of nlink=1 and ORIGIN cannot be
>> > followed because lower fs doesn't support file handles.
>> > I just wanted to make sure this case is handled correctly.
>> >
>>
>> OK. re-read the code and ready to explain the situation.
>>
>> The meaning of new OVL_CONST_INO flag is:
>> "inode preserves st_ino across copy up".
>> If lower fs support file handles it also means:
>> "...and across eviction from inode cache".
>> but if lower fs does not support file handles it means:
>> "...while non-dir inode remains in cache"
>>
>> How does METACOPY change the situation?
>> very slightly - with METACOPY, instead of st_ino change
>> after copy_up+cache_evict, st_ino will not change after
>> meta_copy_up+cache_evict, but will change after
>> data_copy_up+cache_evict, which is not a problem as
>> far as I can tell.
>>
>> Specifically, removing METACOPY xattr will not change
>> st_ino nor hash_by_lower until after cache eviction and as
>> long as we have one-to-one mapping of upper inode to
>> lower inode that's good enough.
>
> Hi Amir,
>
> Thanks for detailed explanation. I now understand your concern.
>
> How about I pass in the origin information in ovl_get_inode() and
> to ovl_hash_bylower(). And we set bylower=1 for a metacopy dentry
> only if an upper origin could be found and verified?
>
> That way behavior will be similar to a file with nlink=1 and ORIGIN
> not there. And we will not have to worry about thinking another
> special corner case and writing test cases for it.
>
> Too many corner cases are bad for future code maintenance and easy
> to break.
>
> WDYT?
>

I think you should leave it for now and maybe we will address
it later. The reason I am not very concerned anymore is because
I realize we are already exposed to situation of lower without
ORIGIN - this is how a just copied up inode looks like when
lower fs doesn't support file handles. So METACOPY is not
adding a corner case, it just increases the window of time
where the corner case exists beyond inode eviction from cache.

Thanks,
Amir.
