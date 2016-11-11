From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Fri, 11 Nov 2016 02:11:56 +0200
Message-ID: <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
 <1478817883-27662-5-git-send-email-amir73il@gmail.com> <20161110230221.GL19539@ZenIV.linux.org.uk>
 <20161110230557.GM19539@ZenIV.linux.org.uk> <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
 <20161110231757.GN19539@ZenIV.linux.org.uk> <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
 <20161110235444.GO19539@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34125 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935019AbcKKAL6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Nov 2016 19:11:58 -0500
In-Reply-To: <20161110235444.GO19539@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Nov 11, 2016 at 1:54 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Nov 11, 2016 at 01:33:08AM +0200, Amir Goldstein wrote:
>
>> I am certainly looking for this feedback, because there is no other means for
>> me to sanity test if relaxing lock_rename() is safe.
>>
>> When I write "any change of parent" I mean a change between 2 different
>> connected parents. Both work dir and upper dir are connected and with
>> reference held after mount.
>> Are the d_splice_alias() and __d_unalias() cases a real concern for moving
>> work dir around after the overlay mount??
>
> Why not?  Again, it's really up to you to provide an analysis of the call
> chains.  There's nothing in d_splice_alias() to prohibit an existing alias
> being attached - in fact, __d_unalias() is called exactly in that case.
> It's a rare case, all right, but it is not impossible.
>
> BTW, your analysis would better be simple and explicit - anything subtle
> will be flat-out rejected, since it would have to be stepped around very
> carefully in any later work in VFS.
>

Sure, I get that.
Wanted to post early, before I have a full proof that this is sane
(if I am able to generate one), so people can shout at me - what the hell?
soon enough.

> I really wonder what it is that you are getting contention on - what are
> you doing, besides the actual renames?  And that needs serialization anyway
> (on inode lock of workdir, if nothing else), so any contention would not
> disappear from dropped ->s_vfs_rename_mutex...

Yeah, I wrote in the cover letter that I did not generate performance
numbers yet,
which is a must for this sort of work, and that I am hoping to get some feedback
from testers.
But the serialization I am trying to avoid is between copy-ups and whiteouts of
different overlay mounts, all on the same fs, which is the case with
docker/rocket
containers.

Not ruling out that I am barking up the wrong tree. The burden of
proof is on me.

Thanks,
Amir.
