From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] tmpfs: generate random sb->s_uuid
Date: Tue, 9 May 2017 11:18:24 +0200
Message-ID: <003edfbe-b3ac-0075-0f38-cd8e4bef4a7e@nod.at>
References: <1493977468-21143-1-git-send-email-amir73il@gmail.com>
 <20170505100126.GA20759@infradead.org>
 <CAOQ4uxj7mtowTij45_Zh8ixhbNARxZG+YQ_UmHuoVR6AFTPHGg@mail.gmail.com>
 <20170509090216.GA28421@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752393AbdEIJS2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 May 2017 05:18:28 -0400
In-Reply-To: <20170509090216.GA28421@infradead.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleksij Rempel <ore@pengutronix.de>

Am 09.05.2017 um 11:02 schrieb Christoph Hellwig:
> On Fri, May 05, 2017 at 01:20:11PM +0300, Amir Goldstein wrote:
>> Seriously, one has to do things in certain order.
> 
> Yes… and I want to ensure that order.
> 
>> There is no reason to wait for the common uuid code to settle down before
>> fixing something as trivial as this and it makes very little sense IMO to use
>> uuid_be_gen() for sb->s_uuid as it is now.
> 
> There is.  generate_random_uuid needs to die, and adding more callers
> isn't the way to go.  Same for ubifs btw.

I agree. Right now UBIFS uses generate_random_uuid() in both kernel and mkfs.ubifs.
Before we expose it to ->s_uuid, UBIFS should use the correct UUID generation functions.
Oleksij, please follow this discussion before you re-send your UBIFS patch.

Thanks,
//richard
