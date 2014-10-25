From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Sat, 25 Oct 2014 18:06:09 +0100
Message-ID: <20141025170609.GK7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
 <20141024022055.GH7996@ZenIV.linux.org.uk>
 <20141024032422.GI7996@ZenIV.linux.org.uk>
 <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
 <20141025081845.GJ7996@ZenIV.linux.org.uk>
 <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sat, Oct 25, 2014 at 11:53:52AM +0200, Miklos Szeredi wrote:

> Yes, but it's not about race with copy-up (which the ovl_path_upper()
> protects against), but race of two fsync calls with each other.  If
> there's no synchronization between them, then that od->upperfile does
> indeed count as lockless access, no matter that the assignment was
> done under lock.

	p = global;
	if (!p) {	// outside of lock
		p = alloc();
		grab lock
		if (!global) {
			global = p;
		} else {
			destroy(p);
			p = global;
		}
		drop lock
	}
is a very common pattern, especially if you look for cases when lock is
a spinlock and allocation is blocking (in those cases you'll often see
destroy() part done after dropping the lock; that's where what I fucked up in
what I'd originally pushed.  And it wasn't even needed - fput() under
->i_mutex is OK...)
