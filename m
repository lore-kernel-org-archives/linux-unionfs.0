From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [QUESTION] problem about origin xattr
Date: Wed, 31 Jan 2018 19:08:18 +0100
Message-ID: <CAJfpegsWhJJdVKi+ZW+5MoYeo87xwtn27sZ2xjExL8-Qk8BPSA@mail.gmail.com>
References: <1594ffa4-1877-0331-d662-bf9e1e0dcca1@huawei.com>
 <CAOQ4uxhGmD2g4Z9EY504OfssyiVvUskKGec0vqraHOHia88PPQ@mail.gmail.com>
 <20180131152041.GA8087@redhat.com> <CAOQ4uxgK+fsRp=gRmQa-9zp8BZFwaJNxTP9ioCg+gOij2G-RCQ@mail.gmail.com>
 <20180131154637.GB8087@redhat.com> <CAOQ4uxgf=Vkq+bikz7eYcFQqvWbyUoucq3UiEZ811Fge=Y2gqg@mail.gmail.com>
 <CAJfpegtpsV+T6kMAVy9+Mr_1kuk4xWUeYaa6MPTzKNjJ28Nq=A@mail.gmail.com> <20180131165522.GD8087@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34225 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752618AbeAaSIU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 13:08:20 -0500
Received: by mail-qt0-f169.google.com with SMTP id a27so23030104qtd.1
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 10:08:19 -0800 (PST)
In-Reply-To: <20180131165522.GD8087@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, yangerkun <yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 31, 2018 at 5:55 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jan 31, 2018 at 05:10:28PM +0100, Miklos Szeredi wrote:
>> On Wed, Jan 31, 2018 at 4:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > On Wed, Jan 31, 2018 at 5:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> On Wed, Jan 31, 2018 at 05:38:45PM +0200, Amir Goldstein wrote:
>> >>> On Wed, Jan 31, 2018 at 5:20 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >>> > On Wed, Jan 31, 2018 at 03:57:12PM +0200, Amir Goldstein wrote:
>> >>> >
>> >>> > ORIGIN behavior is little unintuitive though. Despite the fact that file
>> >>> > is not searchable through lower, it is visible through decoding of file
>> >>> > handle and it is atleast non-intuitive.
>> >>> >
>> >>>
>> >>> Maybe not intuitive at first glance, but try again:
>> >>>
>> >>> The only thing we *need* from underlying fs is to provide us with a unique
>> >>> and persistent inode number we can use for the overlay object.
>> >>>
>> >>> Even if the inode number we get from underlying fs is not in any of the
>> >>> layers, it is still a  viable inode number we can use in overlay coupled
>> >>> with overlay unique st_dev, to create a system wide unique st_dev;st_ino
>> >>> tuple.
>> >>
>> >> As long as we use only inode number, it probably is still fine.
>> >>
>> >> But I look at ORIGIN as a generic infrastructure which other features can
>> >> make use of it. For example, metacopy is using it to copy up file later.
>> >> And there it will be non-intuitive that a file is not in any of the
>> >> lower, still ORIGIN was decoded and file was copied up. It can come
>> >> as a surprise to user. Atleast I was surprised when I ran into this
>> >> while testing the feature.
>>
>> How about using REDIRECT for metacopy origin?   Keeping ORIGIN only
>> for inode, also meaning ORIGIN is only ever used on upper layer, never
>> on middle layers.
>
> Hi Miklos,
>
> Trying to understand it better. So proposal seems to be that when a file
> is copied up metacopy only, we store both REDIRECT and ORIGIN in upper
> inode. When traversing metacopy inode chain, use ORIGIN info on upper
> inode and REDIRECT info on lower/midlayer metacopy inode.
>
> I am assuming that this is to handle the use case of tar of upper layer
> and untaring it as lower layer.
>
> One of the concerns Amir had raised with usage of REDIRECT was that it
> will be significantly slower as comapred to decoding ORIGIN. So by using
> ORIGIN on upper, we are trying to mitigate it up to some extent? We will
> still pay the cost of decoding REDIECT in midlayer.
>
> Am I understanding it right.

Like directories, we'd only need to set REDIRECT on rename.

So when file has METACOPY, but not REDIRECT, we just fall through to
next layer below one we are currently operating on.  If we find
METACOPY there, we just continue looking until we find a file
containing the data.

When we rename or hardlink a file with METACOPY, we add REDIRECT.

If file has METACOPY and REDIRECT, we follow REDIRECT to find a file
on the next level and keep iterating until we have the one with the
data.

ORIGIN would not be used in this case.  We might be able to use ORIGIN
for some kind of verification, like we do for directories.   Amir has
a better idea, I think.

Another way to think about it is: METACOPY is the opposite of OPAQUE.
For directories the default is "metacopy" and contents are merged.
For files the default is "opaque" and content is not merged.  METACOPY
turns that around and enables "merging" of data from a lower layer.
I could even imagine real merging of data, but it's unlikely to be
worth the effort, clone is much better for that; METACOPY is just a
very restricted (and so much simpler) way of merging data.

Thanks,
Miklos

>
> Vivek
