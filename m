From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v1 0/4] fs: fix race between llseek SEEK_END and write
Date: Wed, 21 Nov 2018 04:54:41 +0000
Message-ID: <20181121045440.GM32577@ZenIV.linux.org.uk>
References: <20181121024400.4346-1-devel@etsukata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181121024400.4346-1-devel@etsukata.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Eiichi Tsukata <devel@etsukata.com>
Cc: andi@firstfloor.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Nov 21, 2018 at 11:43:56AM +0900, Eiichi Tsukata wrote:
> Some file systems (including ext4, xfs, ramfs ...) have the following
> problem as I've described in the commit message of the 1/4 patch.
> 
>   The commit ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llseek")
>   removed almost all locks in llseek() including SEEK_END. It based on the
>   idea that write() updates size atomically. But in fact, write() can be
>   divided into two or more parts in generic_perform_write() when pos
>   straddles over the PAGE_SIZE, which results in updating size multiple
>   times in one write(). It means that llseek() can see the size being
>   updated during write().

And?  Who has ever promised anything that insane?  write(2) can take an arbitrary
amount of time; another process doing lseek() on independently opened descriptor
is *not* going to wait for that (e.g. page-in of the buffer being written, which
just happens to be mmapped from a file on NFS over RFC1149 link).
