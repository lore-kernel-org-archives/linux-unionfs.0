From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/39] vfs: optionally don't account file in nr_files
Date: Mon, 4 Jun 2018 01:47:39 -0700
Message-ID: <20180604084739.GD11333@infradead.org>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-6-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-6-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:05PM +0200, Miklos Szeredi wrote:
> Stacking file operations in overlay will store an extra open file for each
> overlay file opened.
> 
> The overhead is just that of "struct file" which is about 256bytes, because
> overlay already pins an extra dentry and inode when the file is open, which
> add up to a much larger overhead.

But that overhead is exactly what nr_files accounts for, so this looks
bogus to me.
