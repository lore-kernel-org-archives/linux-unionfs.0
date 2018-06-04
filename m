From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/39] vfs: add f_op->pre_mmap()
Date: Mon, 4 Jun 2018 01:48:27 -0700
Message-ID: <20180604084827.GE11333@infradead.org>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-7-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-7-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:06PM +0200, Miklos Szeredi wrote:
> This is needed by overlayfs to be able to copy up a file from a read-only
> lower layer to a writable layer when being mapped shared.  When copying up,
> overlayfs takes VFS locks that would violate locking order when nested
> inside mmap_sem.
> 
> Add a new f_op->pre_mmap method, which is called before taking mmap_sem.

NAK.  We really should not add multiple methods for mmap, and everytime
this came up we found a better way to solve the problem instead.  Most
recent example was the socket zero copy receive code.
