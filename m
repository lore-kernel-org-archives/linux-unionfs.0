From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 07/39] vfs: export vfs_ioctl() to modules
Date: Sun, 10 Jun 2018 05:57:04 +0100
Message-ID: <20180610045657.GM30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-8-mszeredi@redhat.com>
 <20180604084904.GF11333@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180604084904.GF11333@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 04, 2018 at 01:49:04AM -0700, Christoph Hellwig wrote:
> On Tue, May 29, 2018 at 04:43:07PM +0200, Miklos Szeredi wrote:
> > This is needed by the stacked ioctl implementation in overlayfs.
> 
> EXPORT_SYMBOL_GPL for exporting random internals, please.  Same
> for any following patches.

*blink*

Christoph, get real and RTFS - vfs_ioctl() simply calls ->unlocked_ioctl();
all there is to it.

This isn't even a case of "using that function establishes that the
caller is a derived work" - *anyone* who can see definition of
file_operations can bloody well open-code it.  There isn't anything
establishing derivation here.

Hell, it could've been a static inline in include/linux/fs.h and it would
neither differ from many other inlines in there nor need an export at all.

This is really getting close to lxo-worthy levels of bogosity...

More interesting question is why do we want to pass those ioctls to layers
in the first place, especially if it's something with different availability
(or, worse yet, argument layouts) before and after copyup.
