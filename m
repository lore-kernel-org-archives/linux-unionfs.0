From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Fri, 24 Oct 2014 09:24:45 +0200
Message-ID: <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
	<20141024022055.GH7996@ZenIV.linux.org.uk>
	<20141024032422.GI7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:42993 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJXHYq (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 24 Oct 2014 03:24:46 -0400
Received: by mail-yh0-f52.google.com with SMTP id f10so3296319yha.11
        for <linux-unionfs@vger.kernel.org>; Fri, 24 Oct 2014 00:24:45 -0700 (PDT)
In-Reply-To: <20141024032422.GI7996@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Fri, Oct 24, 2014 at 5:24 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Oct 24, 2014 at 03:20:55AM +0100, Al Viro wrote:
>> Why the hell do you hold ->i_mutex across the entire opening of underlying
>> directory?  All you need is to serialize one assignment; the side that loses
>> the race will simply fput() what it opened...

The reason I didn't do your "fix" is that it

 - adds more lines than it takes,

 - I wasn't sure at all if the lockless access is actually correct
without the ACCESS_ONCE and all the memory barrier magic that might be
necessary on weird architectures.

The rest of the changes look OK.

Thanks,
Miklos
