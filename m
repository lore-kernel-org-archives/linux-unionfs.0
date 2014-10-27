From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Locking problem in overlayfs
Date: Mon, 27 Oct 2014 15:19:35 +0100
Message-ID: <20141027141935.GC3021@tucsk.piliscsaba.szeredi.hu>
References: <5394.1414418718@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5394.1414418718@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Oct 27, 2014 at 02:05:18PM +0000, David Howells wrote:
> Using my testsuite, I see the attached moan from lockdep.  Unfortunately, it
> doesn't cause the testsuite to actually fail, so I'm going to have to manually
> try and isolate the failing test.
> 
> David
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.18.0-rc2-fsdevel+ #910 Tainted: G        W     
> ---------------------------------------------
> run/2642 is trying to acquire lock:
>  (&sb->s_type->i_mutex_key#10/1){+.+.+.}, at: [<ffffffff81203d81>] ovl_cleanup_whiteouts+0x29/0xb4
> 
> but task is already holding lock:
>  (&sb->s_type->i_mutex_key#10/1){+.+.+.}, at: [<ffffffff8113abff>] lock_rename+0xb7/0xd7

Uh-oh.  We changed nesting late in the cycle and I didn't retest with lockdep.

And it's actually harmless, but AFAICS needs another level of nesting between
I_MUTEX_CHILD and I_MUTEX_NORMAL.

Will do a patch.

Thanks,
Miklos
