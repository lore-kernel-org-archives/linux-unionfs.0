From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] tmpfs: generate random sb->s_uuid
Date: Fri, 5 May 2017 13:20:11 +0300
Message-ID: <CAOQ4uxj7mtowTij45_Zh8ixhbNARxZG+YQ_UmHuoVR6AFTPHGg@mail.gmail.com>
References: <1493977468-21143-1-git-send-email-amir73il@gmail.com> <20170505100126.GA20759@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34957 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdEEKUN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 May 2017 06:20:13 -0400
In-Reply-To: <20170505100126.GA20759@infradead.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>

On Fri, May 5, 2017 at 1:01 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 05, 2017 at 12:44:28PM +0300, Amir Goldstein wrote:
>> This is used by overlayfs to encode intrasystem unique file handles.
>
> I think generate_random_uuid is the wrong interface to spread.
> The right one would be uuid_be_gen, although I'll still need
> to audit why one uses get_random_bytes and the other prandom_bytes.
>

Christoph,

You're keep getting in my way with this uuid business ;-)

Seriously, one has to do things in certain order.
There is no reason to wait for the common uuid code to settle down before
fixing something as trivial as this and it makes very little sense IMO to use
uuid_be_gen() for sb->s_uuid as it is now.

I am working actively with you and Andy to sort out the uuid.h mess and
it even seems we are getting closer to consensus.

There is no real 'cost' in 'spreading' generate_random_uuid() to tmpfs
and I promise to post a patch to replace generate_random_uuid()
in tmpfs to the new API once it is ready.

Cheers,
Amir.
