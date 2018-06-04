From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 32/39] vfs: fix freeze protection in
 mnt_want_write_file() for overlayfs
Date: Mon, 4 Jun 2018 01:50:05 -0700
Message-ID: <20180604085005.GG11333@infradead.org>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-33-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-33-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:32PM +0200, Miklos Szeredi wrote:
> The underlying real file used by overlayfs still contains the overlay path.
> This results in mnt_want_write_file() calls by the filesystem getting
> freeze protection on the wrong inode (the overlayfs one instead of the real
> one).
> 
> Fix by using file_inode(file)->i_sb instead of file->f_path.mnt->mnt_sb.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
