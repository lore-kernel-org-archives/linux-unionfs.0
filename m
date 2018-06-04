From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/39] vfs: dedpue: return loff_t
Date: Mon, 4 Jun 2018 01:43:36 -0700
Message-ID: <20180604084336.GA11333@infradead.org>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-2-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-2-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:01PM +0200, Miklos Szeredi wrote:
> f_op->dedupe_file_range() gets a u64 length to dedup and returns an ssize_t
> actual length deduped.  This breaks badly on 32bit archs since the returned
> length will be truncated and possibly overflow into the sign bit (xfs and
> ocfs2 are affected, btrfs limits actual length to 16MiB).

Can we just make it return 0 vs errno?  The only time we return
a different length than the one passed in is due to the btrfs cap.

Given that this API started out on btrfs we should just do the cap
everywhere to not confuse userspace.
