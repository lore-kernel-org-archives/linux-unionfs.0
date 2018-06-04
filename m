From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/39] vfs: export vfs_ioctl() to modules
Date: Mon, 4 Jun 2018 01:49:04 -0700
Message-ID: <20180604084904.GF11333@infradead.org>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-8-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-8-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:07PM +0200, Miklos Szeredi wrote:
> This is needed by the stacked ioctl implementation in overlayfs.

EXPORT_SYMBOL_GPL for exporting random internals, please.  Same
for any following patches.
