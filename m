From: Oleksij Rempel <ore@pengutronix.de>
Subject: Re: [PATCH] tmpfs: generate random sb->s_uuid
Date: Tue, 9 May 2017 12:27:53 +0200
Message-ID: <2e4a15d0-2c6a-bc87-cdaa-095a40c260f5@pengutronix.de>
References: <1493977468-21143-1-git-send-email-amir73il@gmail.com>
 <20170505100126.GA20759@infradead.org>
 <CAOQ4uxj7mtowTij45_Zh8ixhbNARxZG+YQ_UmHuoVR6AFTPHGg@mail.gmail.com>
 <20170509090216.GA28421@infradead.org>
 <003edfbe-b3ac-0075-0f38-cd8e4bef4a7e@nod.at>
 <CAOQ4uxjXX5nAHu0PVfM_mPi9wMtoDjf-XpBO6reMZPXQoW8mMw@mail.gmail.com>
 <0f4814d3-e13b-4fb8-151d-652ce2fed6b4@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:51717 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751537AbdEIK14 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 May 2017 06:27:56 -0400
In-Reply-To: <0f4814d3-e13b-4fb8-151d-652ce2fed6b4@nod.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Richard Weinberger <richard@nod.at>, Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>

Hi Richard,

On 09.05.2017 12:09, Richard Weinberger wrote:
> Amir,
>
> Am 09.05.2017 um 11:54 schrieb Amir Goldstein:
>>>> There is.  generate_random_uuid needs to die, and adding more callers
>>>> isn't the way to go.
>>
>> That's Christoph's opinion and its fine. I stated my opinion above.
>> It's up to tmpfs/vfs maintainers to make the call about my patch.
>>
>>>> Same for ubifs btw.
>>
>> Same in what regard?
>> ubifs has generate_random_uuid() since 2008.
>> When the cleanup patch to generate_random_uuid() will be ready,
>> it will fixup ubifs as well.
>>
>>>
>>> I agree. Right now UBIFS uses generate_random_uuid() in both kernel and mkfs.ubifs.
>>> Before we expose it to ->s_uuid, UBIFS should use the correct UUID generation functions.
>>
>> Richard, this makes no sense at all.
>> You have deployed filesystems whose UUID has already been set using
>> generate_random_uuid(). You are not going to reformat those filesystems
>> when generate_random_uuid() dies in the kernel, so how is this even related
>> to exporting the filesystem's UUID to s_uuid?
>
> Well, maybe we need a new feature flag in UBIFS that the UUID is now usable.
> Sure, in the best case we just expose the existing UUID to ->s_uuid and everything
> is fine.
>
>> The changes that Christoph promotes to the kernel uuid common functions
>> are important because we have too many home brewed implementations of
>> uuid handling in the kernel. But making the code cleaner and more reusable
>> isn't going to change the on-disk uuid representation and for filesystems, it
>> probably won't even change the cpu uuid representation (i.e. in super block
>> structs).
>>
>> Seriously, it's not my battle to fight.
>> I don't stand to loose anything if Oleksij's patch gets held hostage
>> for the uuid
>> cleanups, but I don't get the UBIFS maintainer POV on the matter at hand.
>
> My POV is easy, I'm nervous about all this changes and the rush behind them.
> And when Christoph raises concerns, I'm especially careful.
> That's why I'm taking the UBIFS ->s_uuid patch for 4.13 after I had enough
> time to verify and think. And finally that's also why I asked Oleksij
> to follow the discussion. If he can explain in detail why UBIFS does the right
> thing I have a much better feeling. If I have to figure myself it takes time
> which I don't have right now.

Sorry -EIO "why UBIFS does the right thing I have".

If you mean, "will it brake consumers of >s_uuid?". The the answer, if I 
see it correctly, then no.

In my case this patch is needed for EVM and IMA.

linux/security/integrity/evm/evm_crypto.c
...
         if (evm_hmac_attrs & EVM_ATTR_FSUUID)
                 crypto_shash_update(desc, inode->i_sb->s_uuid,
                                     sizeof(inode->i_sb->s_uuid));
...

linux/security/integrity/ima/ima_policy.c
...
         if ((rule->flags & IMA_FSUUID) &&
             memcmp(rule->fsuuid, inode->i_sb->s_uuid, 
sizeof(rule->fsuuid)))
                 return false;
...

Both of them do not use uuid per default and if some one tried to 
configure it for use with UBIFS, then it would just never work as expected.
