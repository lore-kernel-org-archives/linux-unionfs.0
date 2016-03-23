From: William Dauchy <wdauchy@gmail.com>
Subject: Re: [PATCH v2] fs: add file_dentry()
Date: Wed, 23 Mar 2016 15:06:20 +0100
Message-ID: <CAJ75kXZ+QFait-h--dAixE462XL00frBCxnvSBN+rQo3nSXrEw@mail.gmail.com>
References: <20160323133606.GF11906@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160323133606.GF11906@tucsk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Theodore Ts'o <tytso@mit.edu>, Daniel Axtens <dja@axtens.net>, stable <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Hello Miklos,

On Wed, Mar 23, 2016 at 2:36 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> This series fixes bugs in nfs and ext4 due to 4bacc9c9234c ("overlayfs:
> Make f_path always point to the overlay and f_inode to the underlay").
>
> Regular files opened on overlayfs will result in the file being opened on
> the underlying filesystem, while f_path points to the overlayfs
> mount/dentry.
>
> This confuses filesystems which get the dentry from struct file and assume
> it's theirs.
>
> Add a new helper, file_dentry() [*], to get the filesystem's own dentry
> from the file.  This checks file->f_path.dentry->d_flags against
> DCACHE_OP_REAL, and returns file->f_path.dentry if DCACHE_OP_REAL is not
> set (this is the common, non-overlayfs case).
>
> In the uncommon case it will call into overlayfs's ->d_real() to get the
> underlying dentry, matching file_inode(file).
>
> The reason we need to check against the inode is that if the file is copied
> up while being open, d_real() would return the upper dentry, while the open
> file comes from the lower dentry.
>
> [*] If possible, it's better simply to use file_inode() instead.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Trond Myklebust <trond.myklebust@primarydata.com>
> Cc: <stable@vger.kernel.org> # v4.2

4bacc9c9234c ("overlayfs: Make f_path always point to the overlay and
f_inode to the underlay").
This commit is from v4.1 if I am not wrong. So the stable tag might be wrong.

Am I missing something?
-- 
William
