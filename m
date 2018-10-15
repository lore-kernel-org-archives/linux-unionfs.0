From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/25] vfs: create generic_remap_file_range_touch to
 update inode metadata
Date: Mon, 15 Oct 2018 09:30:01 -0700
Message-ID: <20181015163001.GK28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938921180.8361.13556945128095535605.stgit@magnolia>
 <20181014172131.GE30673@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181014172131.GE30673@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

On Sun, Oct 14, 2018 at 10:21:31AM -0700, Christoph Hellwig wrote:
> > +/* Update inode timestamps and remove security privileges when remapping. */
> > +int generic_remap_file_range_touch(struct file *file, bool is_dedupe)
> > +{
> > +	int ret;
> > +
> > +	/* If can't alter the file contents, we're done. */
> > +	if (is_dedupe)
> > +		return 0;
> > +
> > +	/* Update the timestamps, since we can alter file contents. */
> > +	if (!(file->f_mode & FMODE_NOCMTIME)) {
> > +		ret = file_update_time(file);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	/*
> > +	 * Clear the security bits if the process is not being run by root.
> > +	 * This keeps people from modifying setuid and setgid binaries.
> > +	 */
> > +	return file_remove_privs(file);
> > +}
> > +EXPORT_SYMBOL(generic_remap_file_range_touch);
> 
> The name seems a little out of touch with what it actually does.

I originally thought "touch" because it updates [cm]time. :)

Though looking at the final code, I think this can just be called from
the end of generic_remap_file_range_prep, so we can skip the export and
all that other stuff.

> Also why a bool argument instead of the more descriptive flags which
> introduced a few patches ago?

Hmm, yes, the remap_flags transition can move up to before this patch.

--D
