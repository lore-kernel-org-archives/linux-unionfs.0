From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [QUESTION] problem about origin xattr
Date: Thu, 1 Feb 2018 01:26:58 +0200
Message-ID: <CAOQ4uxjxKjwjmJmHJPJfjHvkokVd0_4r5ENLXcs-8VnQ4eBBBQ@mail.gmail.com>
References: <CAOQ4uxgf=Vkq+bikz7eYcFQqvWbyUoucq3UiEZ811Fge=Y2gqg@mail.gmail.com>
 <CAJfpegtpsV+T6kMAVy9+Mr_1kuk4xWUeYaa6MPTzKNjJ28Nq=A@mail.gmail.com>
 <20180131165522.GD8087@redhat.com> <CAJfpegsWhJJdVKi+ZW+5MoYeo87xwtn27sZ2xjExL8-Qk8BPSA@mail.gmail.com>
 <20180131190503.GA2699@redhat.com> <CAOQ4uxghhXgtXSwKN2nGUGEtoB42GtT0fboc5MxT4ieZ2-rbnw@mail.gmail.com>
 <20180131203438.GB2699@redhat.com> <CAJfpegtd_qP7FmKuad5=6kmJeBvz8YmwgA7AS8rhU+D3vgaX3g@mail.gmail.com>
 <20180131205807.GA11643@redhat.com> <CAJfpeguaEdLEkRtMBoQkAHtis0LChEAaOTcU0xvzMb=kAQ-aWg@mail.gmail.com>
 <20180131211223.GB11643@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33380 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbeAaX1A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 18:27:00 -0500
Received: by mail-yw0-f178.google.com with SMTP id x24so8974459ywj.0
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 15:26:59 -0800 (PST)
In-Reply-To: <20180131211223.GB11643@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, yangerkun <yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 31, 2018 at 11:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jan 31, 2018 at 10:06:22PM +0100, Miklos Szeredi wrote:
>> On Wed, Jan 31, 2018 at 9:58 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Wed, Jan 31, 2018 at 09:48:43PM +0100, Miklos Szeredi wrote:
>> >> On Wed, Jan 31, 2018 at 9:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> > On Wed, Jan 31, 2018 at 09:59:07PM +0200, Amir Goldstein wrote:
>> >> >
>> >> > [..]
>> >> >> >> >> >> As long as we use only inode number, it probably is still fine.
>> >> >> >> >> >>
>> >> >> >> >> >> But I look at ORIGIN as a generic infrastructure which other features can
>> >> >> >> >> >> make use of it. For example, metacopy is using it to copy up file later.
>> >> >> >> >> >> And there it will be non-intuitive that a file is not in any of the
>> >> >> >> >> >> lower, still ORIGIN was decoded and file was copied up. It can come
>> >> >> >> >> >> as a surprise to user. Atleast I was surprised when I ran into this
>> >> >> >> >> >> while testing the feature.
>> >> >> >> >>
>> >> >> >> >> How about using REDIRECT for metacopy origin?   Keeping ORIGIN only
>> >> >> >> >> for inode, also meaning ORIGIN is only ever used on upper layer, never
>> >> >> >> >> on middle layers.
>> >> >> >> >
>> >> >> >> > Hi Miklos,
>> >> >> >> >
>> >> >> >> > Trying to understand it better. So proposal seems to be that when a file
>> >> >> >> > is copied up metacopy only, we store both REDIRECT and ORIGIN in upper
>> >> >> >> > inode. When traversing metacopy inode chain, use ORIGIN info on upper
>> >> >> >> > inode and REDIRECT info on lower/midlayer metacopy inode.
>> >> >> >> >
>> >> >> >> > I am assuming that this is to handle the use case of tar of upper layer
>> >> >> >> > and untaring it as lower layer.
>> >> >> >> >
>> >> >> >> > One of the concerns Amir had raised with usage of REDIRECT was that it
>> >> >> >> > will be significantly slower as comapred to decoding ORIGIN. So by using
>> >> >> >> > ORIGIN on upper, we are trying to mitigate it up to some extent? We will
>> >> >> >> > still pay the cost of decoding REDIECT in midlayer.
>> >> >> >> >
>> >> >> >> > Am I understanding it right.
>> >> >> >>
>> >> >> >> Like directories, we'd only need to set REDIRECT on rename.
>> >> >> >>
>> >> >> >> So when file has METACOPY, but not REDIRECT, we just fall through to
>> >> >> >> next layer below one we are currently operating on.  If we find
>> >> >> >> METACOPY there, we just continue looking until we find a file
>> >> >> >> containing the data.
>> >> >> >>
>> >> >> >> When we rename or hardlink a file with METACOPY, we add REDIRECT.
>> >> >> >>
>> >> >> >> If file has METACOPY and REDIRECT, we follow REDIRECT to find a file
>> >> >> >> on the next level and keep iterating until we have the one with the
>> >> >> >> data.
>> >> >> >>
>> >> >> >> ORIGIN would not be used in this case.  We might be able to use ORIGIN
>> >> >> >> for some kind of verification, like we do for directories.   Amir has
>> >> >> >> a better idea, I think.
>> >> >> >>
>> >> >> >> Another way to think about it is: METACOPY is the opposite of OPAQUE.
>> >> >> >> For directories the default is "metacopy" and contents are merged.
>> >> >> >> For files the default is "opaque" and content is not merged.  METACOPY
>> >> >> >> turns that around and enables "merging" of data from a lower layer.
>> >> >> >> I could even imagine real merging of data, but it's unlikely to be
>> >> >> >> worth the effort, clone is much better for that; METACOPY is just a
>> >> >> >> very restricted (and so much simpler) way of merging data.
>> >> >> >
>> >> >> > Ok, thanks. I am beginning to understand it better now.
>> >> >> >
>> >> >> > First implementaion issue which comes to my mind is that stack[0] location
>> >> >> > conflict. Right now this is taken up by dentry which was obtained by following
>> >> >> > ORIGIN from upper and acts as copy up origin.
>> >> >> >
>> >> >> > May be I should continue to use ORIGIN for upper dentry and when stack[0] is
>> >> >> > filled and if its metacopy, then continue to find data dentry using either
>> >> >> > REDIRECT or using same name and store in stack[1].
>> >> >> >
>> >> >>
>> >> >> Question: don't you think it would be beneficial to get metacopy working and
>> >> >> tested only from upper and without taking security considerations into the mix
>> >> >> for first version?
>> >> >
>> >> > metacopy is working even now. I am posting new patches because there are
>> >> > suggestions after posting patches and I try to take care of these.
>> >> >
>> >> >> Do you know there is a real use case for middle layer metacopy and chaining
>> >> >> and all that Jazz?
>> >> >
>> >> > You asked for support of mid layer support in V9. So I did it.
>> >> >
>> >> > https://www.spinics.net/lists/linux-unionfs/msg03712.html
>> >> >
>> >> >> When you first presented metacopy it sounded like you have a very solid use
>> >> >> case (chown -R). Does your specific use case extend to middle layers?
>> >> >
>> >> > I thought about it later and I think docker will probably need mid layer
>> >> > support. Reason being, that they probably will do chown and use that
>> >> > chowned directory as lower layer for container so that they can later
>> >> > do the diff w.r.t chowned copy and figure out what changes container
>> >> > did. If we do chown on upper and let container use it as upper, then it
>> >> > will appear that whole image has been changed by container.
>> >> >
>> >> > So I feel mid layer support is important for proper integration of
>> >> > this feature.
>> >> >
>> >> >> Is metacopy valueable enough without middle layers following?
>> >> >> Heck, AFAIK, container runtime doesn't even know how to deal with redirect
>> >> >> yet when committing an upper layer to an image. right?
>> >> >
>> >> > You probably are right. And they probably will fall back to native diff
>> >> > interface when metacopy feature is on. But even in that case, they will
>> >> > need to figure out what exactly container has changed w.r.t chowned
>> >> > copy and that means chowned copy has to be the lower layer and that
>> >> > means metacopy in mid layer support will be needed.
>> >> >
>> >> > If we can teach them to store REDIRECT xattr, their commit operation will
>> >> > become faster.
>> >> >
>> >> >>
>> >> >> Just wondering...
>> >> >
>> >> > I am just trying to figure out a point where you and miklos are happy
>> >> > with the design and patches. Mid layer support seems to be important.
>> >> >
>> >> > I get a feeling that miklos is still not entirely convinced about the
>> >> > usage of ORIGIN to get to follow metacopy chain and he still somehow
>> >> > wants to see making use of REDIRECT when need be.
>> >> >
>> >> > ORIGIN vs REDIRECT seems to be the only major sticking point w.r.t
>> >> > these patches at this point of time. As long as you and miklos agree
>> >> > on that semantics, things will be fine.
>> >>
>> >> I think there are many problems with using ORIGIN for data.
>> >>
>> >> I also think it should not be difficult to generalize the REDIRECT
>> >> code from directory to regular file.  It should just be adding more
>> >> conditions to create and handle redirects, no?  The actual code is
>> >> already there, because we do it for directories.
>> >
>> > I guess so. We already are doing it for directories so we should be
>> > able to extend it for regular files too. I don't know enough to be
>> > able to say what affect this will have on performance.
>> >
>> >>
>> >> So what's the issue with lowerstack[0]?  Can't we just use the same
>> >> object for both purposes (i.e. the one found by going down the stack,
>> >> just like for directories)?
>> >
>> > I think we should be able to. But then it seems to make ORIGIN redundant.
>> > Because currently we are using ORIGIN to retrieve lowerstack[0]. And if
>> > we change that, that means I will have to rip out ORIGIN logic altogether.
>> > Its a relatively bigger change. So wanted to figure out is that what
>> > we are looking for.
>>
>> Don't rip out ORIGIN logic, just disable it when we find METACOPY.
>>
>> So logic should be:
>>
>>  - check METACOPY xattr, if exists continue to lower layers just like
>> non-opaque directory
>>  - otherwise use ORIGIN xattr, just like we used to

Careful there, when following metacopy by path, you also need to apply
ovl_verify_lower() logic for indexed files, i.e. all files with nfs_export
and lower hardlinks with index=on. same as I did for merge dir lookup
with nfs_export.

Cheers,
Amir.
