From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] readlink cleanup
Date: Sun, 11 Dec 2016 11:01:32 +0100
Message-ID: <CAJfpegtSK7k9Oa8KuaJLpToHpqotQigrGO8EtY+5-=j7d-2vcA@mail.gmail.com>
References: <20161210204145.GK2622@veci.piliscsaba.szeredi.hu>
 <20161211023620.GL1555@ZenIV.linux.org.uk> <20161211023902.GA24547@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34986 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbcLKKBd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Dec 2016 05:01:33 -0500
Received: by mail-oi0-f67.google.com with SMTP id v84so7558326oie.2
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Dec 2016 02:01:33 -0800 (PST)
In-Reply-To: <20161211023902.GA24547@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Sun, Dec 11, 2016 at 3:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Dec 11, 2016 at 02:36:20AM +0000, Al Viro wrote:
>
>> I'm still not sure what does "vfs: convert ->readlink to same signature as
>> ->get_link" buy us.  If anything, the result appears to be more complex -
>> you make freeing that buffer delayed (and introduce a dynamically allocated
>> buffer in one case that didn't use it)...

Normally readlink(2) calls ->get_link() except if there's
->readlink().  So there's no added complexity in handling the delayed
free since it's already there.  In fact it allows for removal of
complexity.

But I think the diffstat of that last part speaks for itself:

 11 files changed, 76 insertions(+), 110 deletions(-)

Btw, in the one case where we added the dynamically allocated buffer
it had been:

  - guess max link size to be 50 (very scientifically I'm sure, but no
explanation given)
  - call filler
  - hope it didn't get truncated

Which is now

  - call filler to allocate correctly sized buffer

Which isn't even much more complex.  So I don't buy your arguments.

Thanks,
Miklos
