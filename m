From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single
 remap_file_range
Date: Mon, 15 Oct 2018 09:42:20 -0700
Message-ID: <20181015164220.GL28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia>
 <20181014171927.GD30673@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181014171927.GD30673@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

On Sun, Oct 14, 2018 at 10:19:27AM -0700, Christoph Hellwig wrote:
> >  	unsigned (*mmap_capabilities)(struct file *);
> >  #endif
> >  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
> > -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> > +				struct file *file_out, loff_t pos_out,
> > +				u64 len, unsigned int remap_flags);
> 
> None of the other methods in this file name their parameters.  While
> I generally don't like people leaving them out, in the end consistency
> is even more important.
> 
> > +int btrfs_remap_file_range(struct file *src_file, loff_t off,
> > +		struct file *dst_file, loff_t destoff, u64 len,
> > +		unsigned int remap_flags)
> >  {
> > +	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
> > +		return -EINVAL;
> > +
> > +	if (remap_flags & RFR_SAME_DATA) {
> 
> So at least for btrfs there seems to be no shared code at all below
> the function calls.  This kinda speaks against the argument that
> they fundamentally are the same..

They /do/ share/ code -- eventually both btrfs_extent_same and
btrfs_clone_files call btrfs_clone.  xfs and ocfs2 call the same paths
internally too; it's only the vfs helpers that have the extra page cache
comparisons if it's a dedup operation.

> > +/*
> > + * These flags control the behavior of the remap_file_range function pointer.
> > + *
> > + * RFR_SAME_DATA: only remap if contents identical (i.e. deduplicate)
> > + */
> > +#define RFR_SAME_DATA		(1 << 0)
> > +
> > +#define RFR_VALID_FLAGS		(RFR_SAME_DATA)
> 
> RFR?  Why not REMAP_FILE_*  Also why not the well understood
> REMAP_FILE_DEDUP instead of the odd SAME_DATA?

Sure.  I had begin to dislike typing RFR anyway.

> > +
> > +/*
> > + * Filesystem remapping implementations should call this helper on their
> > + * remap flags to filter out flags that the implementation doesn't support.
> > + *
> > + * Returns true if the flags are ok, false otherwise.
> > + */
> > +static inline bool remap_check_flags(unsigned int remap_flags,
> > +				     unsigned int supported_flags)
> > +{
> > +	return (remap_flags & ~(supported_flags & RFR_VALID_FLAGS)) == 0;
> > +}
> 
> Any reason to even bother with a helper for this?  ->fallocate
> seems to be doing fine without the helper, and the resulting code
> seems a lot easier to understand to me.

(Will respond to these at the current end of the flags thread.)

> > @@ -1759,10 +1779,9 @@ struct file_operations {
> >  #endif
> >  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
> >  			loff_t, size_t, unsigned int);
> > -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
> > -			u64);
> > -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t,
> > -			u64);
> > +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> > +				struct file *file_out, loff_t pos_out,
> > +				u64 len, unsigned int remap_flags);
> 
> Same comment here.  Didn't we have some nice doc tools to avoid this
> duplication? :)

We do, but vfs.txt hasn't been ported to any of that.

--D
