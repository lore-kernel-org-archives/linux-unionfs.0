Return-Path: <viro@ftp.linux.org.uk>
Date: Fri, 18 May 2018 16:03:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v4 9/9] ovl: use iget5_prealloc() to hash a newly created
 inode
Message-ID: <20180518150353.GS30522@ZenIV.linux.org.uk>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
 <1526632177-28832-10-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526632177-28832-10-git-send-email-amir73il@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 18, 2018 at 11:29:37AM +0300, Amir Goldstein wrote:
> Currently, there is a small window where ovl_obtain_alias() can
> race with ovl_instantiate() and create two different overlay inodes
> with the same underlying real non-dir non-hardlink inode.
> 
> The race requires an adversary to guess the file handle of the
> yet to be created upper inode and decode the guessed file handle
> after ovl_creat_real(), but before ovl_instantiate().
> This race does not affect overlay directory inodes, because those
> are decoded via ovl_lookup_real() and not with ovl_obtain_alias().
> 
> This patch fixes the race, by using iget5_prealloc() to add a newly
> created inode to cache.

Mind explaining what the hell is wrong with insert_inode_locked4()?
