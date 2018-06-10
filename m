From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 09/11] vfs: factor out inode_insert5()
Date: Sun, 10 Jun 2018 06:49:10 +0100
Message-ID: <20180610054902.GQ30522@ZenIV.linux.org.uk>
References: <20180529144143.16378-1-mszeredi@redhat.com>
 <20180529144143.16378-10-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144143.16378-10-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:41:41PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <miklos@szeredi.hu>
> 
> Split out common helper for race free insertion of an already allocated
> inode into the cache.  Use this from iget5_locked() and
> insert_inode_locked4().  Make iget5_locked() use new_inode()/iput() instead
> of alloc_inode()/destroy_inode() directly.

... thus hitting the sucker with ->evict_inode(), in condition that is quite
likely to be unfit to be seen by that.

NAK.
