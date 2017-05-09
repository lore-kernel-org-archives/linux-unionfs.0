From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] tmpfs: generate random sb->s_uuid
Date: Tue, 9 May 2017 12:09:21 +0200
Message-ID: <0f4814d3-e13b-4fb8-151d-652ce2fed6b4@nod.at>
References: <1493977468-21143-1-git-send-email-amir73il@gmail.com>
 <20170505100126.GA20759@infradead.org>
 <CAOQ4uxj7mtowTij45_Zh8ixhbNARxZG+YQ_UmHuoVR6AFTPHGg@mail.gmail.com>
 <20170509090216.GA28421@infradead.org>
 <003edfbe-b3ac-0075-0f38-cd8e4bef4a7e@nod.at>
 <CAOQ4uxjXX5nAHu0PVfM_mPi9wMtoDjf-XpBO6reMZPXQoW8mMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753259AbdEIKJY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 May 2017 06:09:24 -0400
In-Reply-To: <CAOQ4uxjXX5nAHu0PVfM_mPi9wMtoDjf-XpBO6reMZPXQoW8mMw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleksij Rempel <ore@pengutronix.de>

Amir,

Am 09.05.2017 um 11:54 schrieb Amir Goldstein:
>>> There is.  generate_random_uuid needs to die, and adding more callers
>>> isn't the way to go.
> 
> That's Christoph's opinion and its fine. I stated my opinion above.
> It's up to tmpfs/vfs maintainers to make the call about my patch.
> 
>>> Same for ubifs btw.
> 
> Same in what regard?
> ubifs has generate_random_uuid() since 2008.
> When the cleanup patch to generate_random_uuid() will be ready,
> it will fixup ubifs as well.
> 
>>
>> I agree. Right now UBIFS uses generate_random_uuid() in both kernel and mkfs.ubifs.
>> Before we expose it to ->s_uuid, UBIFS should use the correct UUID generation functions.
> 
> Richard, this makes no sense at all.
> You have deployed filesystems whose UUID has already been set using
> generate_random_uuid(). You are not going to reformat those filesystems
> when generate_random_uuid() dies in the kernel, so how is this even related
> to exporting the filesystem's UUID to s_uuid?

Well, maybe we need a new feature flag in UBIFS that the UUID is now usable.
Sure, in the best case we just expose the existing UUID to ->s_uuid and everything
is fine.

> The changes that Christoph promotes to the kernel uuid common functions
> are important because we have too many home brewed implementations of
> uuid handling in the kernel. But making the code cleaner and more reusable
> isn't going to change the on-disk uuid representation and for filesystems, it
> probably won't even change the cpu uuid representation (i.e. in super block
> structs).
> 
> Seriously, it's not my battle to fight.
> I don't stand to loose anything if Oleksij's patch gets held hostage
> for the uuid
> cleanups, but I don't get the UBIFS maintainer POV on the matter at hand.

My POV is easy, I'm nervous about all this changes and the rush behind them.
And when Christoph raises concerns, I'm especially careful.
That's why I'm taking the UBIFS ->s_uuid patch for 4.13 after I had enough
time to verify and think. And finally that's also why I asked Oleksij
to follow the discussion. If he can explain in detail why UBIFS does the right
thing I have a much better feeling. If I have to figure myself it takes time
which I don't have right now.

Thanks,
//richard
