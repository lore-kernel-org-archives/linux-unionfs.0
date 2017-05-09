From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] tmpfs: generate random sb->s_uuid
Date: Tue, 9 May 2017 12:54:20 +0300
Message-ID: <CAOQ4uxjXX5nAHu0PVfM_mPi9wMtoDjf-XpBO6reMZPXQoW8mMw@mail.gmail.com>
References: <1493977468-21143-1-git-send-email-amir73il@gmail.com>
 <20170505100126.GA20759@infradead.org> <CAOQ4uxj7mtowTij45_Zh8ixhbNARxZG+YQ_UmHuoVR6AFTPHGg@mail.gmail.com>
 <20170509090216.GA28421@infradead.org> <003edfbe-b3ac-0075-0f38-cd8e4bef4a7e@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34706 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdEIJyV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 May 2017 05:54:21 -0400
In-Reply-To: <003edfbe-b3ac-0075-0f38-cd8e4bef4a7e@nod.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleksij Rempel <ore@pengutronix.de>

On Tue, May 9, 2017 at 12:18 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 09.05.2017 um 11:02 schrieb Christoph Hellwig:
>> On Fri, May 05, 2017 at 01:20:11PM +0300, Amir Goldstein wrote:

>>
>>> There is no reason to wait for the common uuid code to settle down before
>>> fixing something as trivial as this and it makes very little sense IMO to use
>>> uuid_be_gen() for sb->s_uuid as it is now.
>>
>> There is.  generate_random_uuid needs to die, and adding more callers
>> isn't the way to go.

That's Christoph's opinion and its fine. I stated my opinion above.
It's up to tmpfs/vfs maintainers to make the call about my patch.

>>Same for ubifs btw.

Same in what regard?
ubifs has generate_random_uuid() since 2008.
When the cleanup patch to generate_random_uuid() will be ready,
it will fixup ubifs as well.

>
> I agree. Right now UBIFS uses generate_random_uuid() in both kernel and mkfs.ubifs.
> Before we expose it to ->s_uuid, UBIFS should use the correct UUID generation functions.

Richard, this makes no sense at all.
You have deployed filesystems whose UUID has already been set using
generate_random_uuid(). You are not going to reformat those filesystems
when generate_random_uuid() dies in the kernel, so how is this even related
to exporting the filesystem's UUID to s_uuid?

The changes that Christoph promotes to the kernel uuid common functions
are important because we have too many home brewed implementations of
uuid handling in the kernel. But making the code cleaner and more reusable
isn't going to change the on-disk uuid representation and for filesystems, it
probably won't even change the cpu uuid representation (i.e. in super block
structs).

Seriously, it's not my battle to fight.
I don't stand to loose anything if Oleksij's patch gets held hostage
for the uuid
cleanups, but I don't get the UBIFS maintainer POV on the matter at hand.

Amir.
