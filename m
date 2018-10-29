Return-Path: <willy@infradead.org>
Date: Mon, 29 Oct 2018 10:46:11 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 02/12] VFS: generic cross-device copy_file_range()
 support for all filesystems
Message-ID: <20181029174611.GI28520@bombadil.infradead.org>
References: <20181029174059.38326-1-olga.kornievskaia@gmail.com>
 <20181029174059.38326-4-olga.kornievskaia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029174059.38326-4-olga.kornievskaia@gmail.com>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 29, 2018 at 01:40:49PM -0400, Olga Kornievskaia wrote:
> From: Olga Kornievskaia <kolga@netapp.com>
> 
> If a filesystem does not support cross device or cross file system
> type copy offload functionality, then this patch provides a fallback
> to a page cache based physical data copy. This means the
> copy_file_range() systemcall will never fail with EXDEV, and so in
> future userspace will not need to detect or provide a fallback for
> failed cross-device copies anymore.
> 
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>

Reviewed-by: Matthew Wilcox <willy@infradead.org>
