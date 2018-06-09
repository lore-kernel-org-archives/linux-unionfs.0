From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Fri, 8 Jun 2018 23:52:08 -0700
Message-ID: <20180609065208.GA31572@infradead.org>
References: <20180608121330.GG23785@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180608121330.GG23785@veci.piliscsaba.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jun 08, 2018 at 02:13:30PM +0200, Miklos Szeredi wrote:
> Hi Linus,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-4.18
> 
> This contains two new features:
> 
>  1) Stack file operations: this allows removal of several hacks from the
>     VFS, proper interaction of read-only open files with copy-up,
>     possibility to implement fs modifying ioctls properly, and others.

Which includews all kinds of NAKed or at least non-acked VFS changes.

Please get these through Als tree after proper review first.
