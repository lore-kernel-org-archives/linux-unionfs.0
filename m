From: Ritesh Harjani <riteshh@linux.ibm.com>
Subject: Re: [PATCH 0/1] Use inode_lock/unlock class of provided APIs in
 filesystems
Date: Tue, 17 Dec 2019 13:42:29 +0530
Message-ID: <20191217081233.A81214C040@d06av22.portsmouth.uk.ibm.com>
References: <20191205103902.23618-1-riteshh@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20191205103902.23618-1-riteshh@linux.ibm.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: willy@infradead.org, linux-fsdevel@vger.kernel.org, jlayton@kernel.org, viro@zeniv.linux.org.uk
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-nfs@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Al, do you think this can be picked up via your tree?
Please let me know if anything needed from my end on this.

-ritesh

On 12/5/19 4:09 PM, Ritesh Harjani wrote:
> Matthew Wilcox in [1] suggested that it will be a good idea
> to define some missing API instead of directly using i_rwsem in
> filesystems drivers for lock/unlock/downgrade purposes.
> 
> This patch does that work. No functionality change in this patch.
> 
> After this there are only lockdep class of APIs at certain places
> in filesystems which are directly using i_rwsem and second is XFS,
> but it seems to be anyway defining it's own xfs_ilock/iunlock set
> of APIs and 'iolock' naming convention for this lock.
> 
> [1]: https://www.spinics.net/lists/linux-ext4/msg68689.html
> 
> Ritesh Harjani (1):
>    fs: Use inode_lock/unlock class of provided APIs in filesystems
> 
>   fs/btrfs/delayed-inode.c |  2 +-
>   fs/btrfs/ioctl.c         |  4 ++--
>   fs/ceph/io.c             | 24 ++++++++++++------------
>   fs/nfs/io.c              | 24 ++++++++++++------------
>   fs/orangefs/file.c       |  4 ++--
>   fs/overlayfs/readdir.c   |  2 +-
>   fs/readdir.c             |  4 ++--
>   include/linux/fs.h       | 21 +++++++++++++++++++++
>   8 files changed, 53 insertions(+), 32 deletions(-)
> 
