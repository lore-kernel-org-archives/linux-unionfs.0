From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Fri, 11 Nov 2016 01:33:08 +0200
Message-ID: <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
 <1478817883-27662-5-git-send-email-amir73il@gmail.com> <20161110230221.GL19539@ZenIV.linux.org.uk>
 <20161110230557.GM19539@ZenIV.linux.org.uk> <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
 <20161110231757.GN19539@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33253 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934845AbcKJXdK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Nov 2016 18:33:10 -0500
In-Reply-To: <20161110231757.GN19539@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Nov 11, 2016 at 1:17 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Nov 11, 2016 at 01:11:16AM +0200, Amir Goldstein wrote:
>
>> That is explained in commit message of the first 2 patches, but
>> foremost I would like to say that the name "delete locked" is just the
>> best of all the bad choices for names I came up with, so I am expecting
>> better name suggestions.
>>
>> The concept is to pin the entry so that it cannot be moved, so can have
>> certain guaranties about the stability of the directories topology.
>>
>> > More specifically, what makes you think that may_delete() is called before
>> > any change of parent?
>>
>> Because it is checked at the beginning of vfs_rename()
>> and in order to change a parent, an entry needs to be renamed. no?
>> What am I missing?
>
> Analysis of the rest of call chains where we have __d_move() called?  Not
> to mention anything else, workdir itself might be moved around by
> d_splice_alias() for a sufficiently unpleasant filesystem...

I am certainly looking for this feedback, because there is no other means for
me to sanity test if relaxing lock_rename() is safe.

When I write "any change of parent" I mean a change between 2 different
connected parents. Both work dir and upper dir are connected and with
reference held after mount.
Are the d_splice_alias() and __d_unalias() cases a real concern for moving
work dir around after the overlay mount??

Plus, if a file system is sufficiently unpleasant, perhaps there is a way to
categorize it as such by ovl_dentry_weird(), if it hasn't been
categorized as such already.
