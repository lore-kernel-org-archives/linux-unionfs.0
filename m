From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] tmpfs: generate random sb->s_uuid
Date: Tue, 9 May 2017 19:51:40 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1705091937590.3043@eggly.anvils>
References: <1493977468-21143-1-git-send-email-amir73il@gmail.com> <20170505100126.GA20759@infradead.org> <CAOQ4uxj7mtowTij45_Zh8ixhbNARxZG+YQ_UmHuoVR6AFTPHGg@mail.gmail.com> <20170509090216.GA28421@infradead.org> <003edfbe-b3ac-0075-0f38-cd8e4bef4a7e@nod.at>
 <CAOQ4uxjXX5nAHu0PVfM_mPi9wMtoDjf-XpBO6reMZPXQoW8mMw@mail.gmail.com> <0f4814d3-e13b-4fb8-151d-652ce2fed6b4@nod.at> <CAOQ4uxi5Rkz4LuU0nHQjsowLsC3jMgLG6Dmk9G8v7f78JywOSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:33447 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbdEJCvz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 May 2017 22:51:55 -0400
Received: by mail-pg0-f43.google.com with SMTP id u187so9132032pgb.0
        for <linux-unionfs@vger.kernel.org>; Tue, 09 May 2017 19:51:55 -0700 (PDT)
In-Reply-To: <CAOQ4uxi5Rkz4LuU0nHQjsowLsC3jMgLG6Dmk9G8v7f78JywOSw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleksij Rempel <ore@pengutronix.de>

On Tue, 9 May 2017, Amir Goldstein wrote:
> On Tue, May 9, 2017 at 1:09 PM, Richard Weinberger <richard@nod.at> wrote:
> 
> >
> > Well, maybe we need a new feature flag in UBIFS that the UUID is now usable.
> 
> Don't think you will need that, as I wrote, none of the proposed changes have
> impact on on-disk uuid format and as Oleksij answered, for EVM/IMA checking
> uuid is an opt-in feature.
> 
> >
> > My POV is easy, I'm nervous about all this changes and the rush behind them.
> > And when Christoph raises concerns, I'm especially careful.
> > That's why I'm taking the UBIFS ->s_uuid patch for 4.13 after I had enough
> > time to verify and think.
> 
> Understood your POV :)

Thanks a lot for including tmpfs in your enhancements,
and mercifully I don't have to worry much about on-disk compatibility :)
but even so I share Richard's point of view: if Christoph has some
alignment in mind here, then I don't see why the rush to push something
else in right now - and the 0day robot seems to agree that it's rushed.

A welcome addition to tmpfs once fs is agreed on the way to go - thanks.

Hugh
