From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Fri, 11 Nov 2016 01:11:16 +0200
Message-ID: <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
 <1478817883-27662-5-git-send-email-amir73il@gmail.com> <20161110230221.GL19539@ZenIV.linux.org.uk>
 <20161110230557.GM19539@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37198 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964802AbcKJXLS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Nov 2016 18:11:18 -0500
In-Reply-To: <20161110230557.GM19539@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Nov 11, 2016 at 1:05 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Nov 10, 2016 at 11:02:21PM +0000, Al Viro wrote:
>> On Fri, Nov 11, 2016 at 12:44:43AM +0200, Amir Goldstein wrote:
>> > If work dir and upper dir have a common parent, then it
>> > is safe to move files between them without taking the super block
>> > s_vfs_rename_mutex.
>> >
>> > Since both upper dir and work dir (as well as $workdir/work)
>> > are delete locked on overlay mount, they cannot be moved.
>>
>> Do explain.  What do you mean, "delete locked" and why exactly can't they
>> be moved?
>

That is explained in commit message of the first 2 patches, but
foremost I would like to say that the name "delete locked" is just the
best of all the bad choices for names I came up with, so I am expecting
better name suggestions.

The concept is to pin the entry so that it cannot be moved, so can have
certain guaranties about the stability of the directories topology.

> More specifically, what makes you think that may_delete() is called before
> any change of parent?

Because it is checked at the beginning of vfs_rename()
and in order to change a parent, an entry needs to be renamed. no?
What am I missing?
