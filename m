From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Sat, 25 Oct 2014 09:18:45 +0100
Message-ID: <20141025081845.GJ7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
 <20141024022055.GH7996@ZenIV.linux.org.uk>
 <20141024032422.GI7996@ZenIV.linux.org.uk>
 <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 24, 2014 at 09:24:45AM +0200, Miklos Szeredi wrote:

> The reason I didn't do your "fix" is that it
> 
>  - adds more lines than it takes,
> 
>  - I wasn't sure at all if the lockless access is actually correct
> without the ACCESS_ONCE and all the memory barrier magic that might be
>  necessary on weird architectures.

_What_ lockless accesses?  There is an extremely embarrassing bug in that
commit, all right, but it has nothing to do with barriers...  All
barrier-related issues are taken care of by ovl_path_upper() (and without
that you'd have tons of worse problems).  Fetching ->upperfile outside of
->i_mutex is fine - in the worst case we'll fetch NULL, open the sucker
grab ->i_mutex and find out that it has already been taken care of.
In which case we fput() what we'd opened and move on (fput() under
->i_mutex is fine - it's going to be delayed until return from syscall
anyway).

There was a very dumb braino in there; fixed, force-pushed, passes unionmount
tests, no regressions on LTP syscall ones and xfstests.
