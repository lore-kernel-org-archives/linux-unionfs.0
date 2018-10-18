From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/29] vfs: combine the clone and dedupe
 into a single remap_file_range
Date: Wed, 17 Oct 2018 21:47:18 -0700
Message-ID: <20181018044718.GT28243@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
	<153981631706.5568.6473120432728396978.stgit@magnolia>
	<20181018004826.GB12386@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <20181018004826.GB12386@ZenIV.linux.org.uk>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, david@fromorbit.com, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 18, 2018 at 01:48:26AM +0100, Al Viro wrote:
> On Wed, Oct 17, 2018 at 03:45:17PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Combine the clone_file_range and dedupe_file_range operations into a
> > single remap_file_range file operation dispatch since they're
> > fundamentally the same operation.  The differences between the two can
> > be made in the prep functions.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  Documentation/filesystems/vfs.txt |   13 +++++------
> >  fs/btrfs/ctree.h                  |    8 ++-----
> >  fs/btrfs/file.c                   |    3 +-
> >  fs/btrfs/ioctl.c                  |   45 +++++++++++++++++++------------------
> >  fs/cifs/cifsfs.c                  |   22 +++++++++++-------
> >  fs/nfs/nfs4file.c                 |   10 ++++++--
> >  fs/ocfs2/file.c                   |   24 +++++++-------------
> >  fs/overlayfs/file.c               |   30 ++++++++++++++-----------
> >  fs/read_write.c                   |   18 +++++++--------
> >  fs/xfs/xfs_file.c                 |   23 ++++++-------------
> >  include/linux/fs.h                |   20 +++++++++++++---
> >  11 files changed, 110 insertions(+), 106 deletions(-)
> > 
> > 
> > diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> > index a6c6a8af48a2..bb3183334ab9 100644
> > --- a/Documentation/filesystems/vfs.txt
> > +++ b/Documentation/filesystems/vfs.txt
> > @@ -883,8 +883,9 @@ struct file_operations {
> >  	unsigned (*mmap_capabilities)(struct file *);
> >  #endif
> >  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
> > -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> > +				struct file *file_out, loff_t pos_out,
> > +				u64 len, unsigned int remap_flags);
> >  	int (*fadvise)(struct file *, loff_t, loff_t, int);
> >  };
> 
> Documentation/filesystems/porting part, please.  And document remap_flags.

Ok, will do.

> > +#define REMAP_FILE_DEDUP		(1 << 0)
> > +
> > +/*
> > + * These flags should be taken care of by the implementation (possibly using
> > + * vfs helpers) but can be ignored by the implementation.
> > + */
> > +#define REMAP_FILE_ADVISORY		(0)
> 
> ???

Sorry if this wasn't clear.  How about this?

/*
 * These flags signal that the caller is ok with altering various aspects of
 * the behavior of the remap operation.  The changes must be made by the
 * implementation; the vfs remap helper functions can take advantage of them.
 * Flags in this category exist to preserve the quirky behavior of the hoisted
 * btrfs clone/dedupe ioctls.
 */


--D
