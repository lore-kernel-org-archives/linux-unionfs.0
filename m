Return-Path: <willy@infradead.org>
Date: Thu, 25 Oct 2018 15:27:54 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 11/11] NFS replace cross device with cross filesystem
 check in copy_file_range
Message-ID: <20181025222754.GN25444@bombadil.infradead.org>
References: <20181025215147.36248-1-olga.kornievskaia@gmail.com>
 <20181025215147.36248-13-olga.kornievskaia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181025215147.36248-13-olga.kornievskaia@gmail.com>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 25, 2018 at 05:51:47PM -0400, Olga Kornievskaia wrote:
> -	if (file_in->f_inode->i_sb != file_out->f_inode->i_sb)
> +	if (file_in->f_inode->i_sb->s_type != file_out->f_inode->i_sb->s_type)

Isn't it simpler to do:

	if (file_in->f_inode->i_sb->s_type != &nfs4_fs_type)

But now I've done some grepping, and I wonder whether it's possible
/ desirable to also copy between inodes on a nfs4_remote_fs_type,
nfs4_remote_referral_fs_type, nfs4_referral_fs_type or nfs4_xdev_fs_type.
I haven't kept up with NFS development for a while, so maybe none of
those are possible.
