From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [QUESTION] problem about origin xattr
Date: Wed, 31 Jan 2018 17:10:28 +0100
Message-ID: <CAJfpegtpsV+T6kMAVy9+Mr_1kuk4xWUeYaa6MPTzKNjJ28Nq=A@mail.gmail.com>
References: <1594ffa4-1877-0331-d662-bf9e1e0dcca1@huawei.com>
 <CAOQ4uxhGmD2g4Z9EY504OfssyiVvUskKGec0vqraHOHia88PPQ@mail.gmail.com>
 <20180131152041.GA8087@redhat.com> <CAOQ4uxgK+fsRp=gRmQa-9zp8BZFwaJNxTP9ioCg+gOij2G-RCQ@mail.gmail.com>
 <20180131154637.GB8087@redhat.com> <CAOQ4uxgf=Vkq+bikz7eYcFQqvWbyUoucq3UiEZ811Fge=Y2gqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:43398 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932152AbeAaQK3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 11:10:29 -0500
Received: by mail-qk0-f182.google.com with SMTP id a5so15392467qkg.10
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 08:10:29 -0800 (PST)
In-Reply-To: <CAOQ4uxgf=Vkq+bikz7eYcFQqvWbyUoucq3UiEZ811Fge=Y2gqg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, yangerkun <yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 31, 2018 at 4:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jan 31, 2018 at 5:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Wed, Jan 31, 2018 at 05:38:45PM +0200, Amir Goldstein wrote:
>>> On Wed, Jan 31, 2018 at 5:20 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> > On Wed, Jan 31, 2018 at 03:57:12PM +0200, Amir Goldstein wrote:
>>> >
>>> > ORIGIN behavior is little unintuitive though. Despite the fact that file
>>> > is not searchable through lower, it is visible through decoding of file
>>> > handle and it is atleast non-intuitive.
>>> >
>>>
>>> Maybe not intuitive at first glance, but try again:
>>>
>>> The only thing we *need* from underlying fs is to provide us with a unique
>>> and persistent inode number we can use for the overlay object.
>>>
>>> Even if the inode number we get from underlying fs is not in any of the
>>> layers, it is still a  viable inode number we can use in overlay coupled
>>> with overlay unique st_dev, to create a system wide unique st_dev;st_ino
>>> tuple.
>>
>> As long as we use only inode number, it probably is still fine.
>>
>> But I look at ORIGIN as a generic infrastructure which other features can
>> make use of it. For example, metacopy is using it to copy up file later.
>> And there it will be non-intuitive that a file is not in any of the
>> lower, still ORIGIN was decoded and file was copied up. It can come
>> as a surprise to user. Atleast I was surprised when I ran into this
>> while testing the feature.

How about using REDIRECT for metacopy origin?   Keeping ORIGIN only
for inode, also meaning ORIGIN is only ever used on upper layer, never
on middle layers.

Thanks,
Miklos
