Return-Path: <willy@infradead.org>
Date: Fri, 26 Oct 2018 14:23:38 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 01/11] VFS: move cross device copy_file_range() check
 into filesystems
Message-ID: <20181026212338.GX25444@bombadil.infradead.org>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-2-olga.kornievskaia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026201057.36899-2-olga.kornievskaia@gmail.com>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 04:10:46PM -0400, Olga Kornievskaia wrote:
> From: Olga Kornievskaia <kolga@netapp.com>
> 
> This patch makes it the responsibility of individual filesystems to
> allow or deny cross device copies.  Both NFS and CIFS have operations
> for cross-server copies, and later patches will implement this feature.
> 
> Note that as of this patch, the copy_file_range() function might be passed
> superblocks from different filesystem types. -EXDEV should be returned
> if cross device copies aren't supported, causing the VFS to fall back
> on using do_splice_direct().
> 
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>

Reviewed-by: Matthew Wilcox <willy@infradead.org>
