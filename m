From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Fri, 11 Nov 2016 16:43:57 +0200
Message-ID: <CAOQ4uxibJf7BVSOeRdfcE7VtU2rkrii=Pu9OL0uZPavpudODeQ@mail.gmail.com>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
 <1478817883-27662-5-git-send-email-amir73il@gmail.com> <20161110230221.GL19539@ZenIV.linux.org.uk>
 <20161110230557.GM19539@ZenIV.linux.org.uk> <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
 <20161110231757.GN19539@ZenIV.linux.org.uk> <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
 <20161110235444.GO19539@ZenIV.linux.org.uk> <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
 <20161111002756.GP19539@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34929 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755744AbcKKOn7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Nov 2016 09:43:59 -0500
In-Reply-To: <20161111002756.GP19539@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Nov 11, 2016 at 2:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Nov 11, 2016 at 02:11:56AM +0200, Amir Goldstein wrote:
>> Yeah, I wrote in the cover letter that I did not generate performance
>> numbers yet,
>> which is a must for this sort of work, and that I am hoping to get some feedback
>> from testers.
>> But the serialization I am trying to avoid is between copy-ups and whiteouts of
>> different overlay mounts, all on the same fs, which is the case with
>> docker/rocket
>> containers.
>>
>> Not ruling out that I am barking up the wrong tree. The burden of
>> proof is on me.
>
> Surely, the copying of data itself is outside of that lock, isn't it?

Mmmmmm, no it isn't, but I am going to make it right.

> And renames proper, especially if there is any kind of contention going on,
> will be on the metadata hot in cache, so I would really like to see the
> actual evidence of contention-related performance issues...

I am afraid I won't find these evidence.
I did a small benchmark of 2 parallel rm -rf processes on 2 different
overlay mount
over the same fs.
In that test, every process spends 20% of the time on vfs_whiteout and 10% on
vfs_rename (of those whiteouts).  mutex_lock/unlock of s_vfs_rename_mutex
takes 4% of the time, but the lock covers both the whiteout and rename.

I estimate that after we fix the coarse grained rename_lock, it will be quite
hard to demonstrate contention-related performance issues due to
s_vfs_rename_mutex.

Thanks for taking the time to set me straight.
Amir.
