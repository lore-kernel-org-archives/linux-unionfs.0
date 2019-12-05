From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/1] fs: Use inode_lock/unlock class of provided APIs in
 filesystems
Date: Thu, 5 Dec 2019 05:38:30 -0800
Message-ID: <20191205133830.GB29612@bombadil.infradead.org>
References: <20191205103902.23618-1-riteshh@linux.ibm.com>
 <20191205103902.23618-2-riteshh@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191205103902.23618-2-riteshh@linux.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Ritesh Harjani <riteshh@linux.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, jlayton@kernel.org, viro@zeniv.linux.org.uk, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-nfs@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Dec 05, 2019 at 04:09:02PM +0530, Ritesh Harjani wrote:
> This defines 4 more APIs which some of the filesystem needs
> and reduces the direct use of i_rwsem in filesystem drivers.
> Instead those are replaced with inode_lock/unlock_** APIs.
> 
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
