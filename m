From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 01/35] vfs: clean up dedup
Date: Thu, 12 Apr 2018 09:25:00 -0700
Message-ID: <20180412162500.GA24728@bombadil.infradead.org>
References: <20180412150826.20988-1-mszeredi@redhat.com>
 <20180412150826.20988-2-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180412150826.20988-2-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 12, 2018 at 05:07:52PM +0200, Miklos Szeredi wrote:
> +ssize_t vfs_dedupe_file_range_one(struct file *src_file, u64 src_pos, u64 len,
> +			      struct file *dst_file, u64 dst_pos)

Why u64 instead of loff_t?
