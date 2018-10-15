From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/25] vfs: create generic_remap_file_range_touch to
 update inode metadata
Date: Mon, 15 Oct 2018 11:19:14 -0700
Message-ID: <20181015181914.GA14558@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938921180.8361.13556945128095535605.stgit@magnolia>
 <20181014172131.GE30673@infradead.org>
 <20181015163001.GK28243@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181015163001.GK28243@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

On Mon, Oct 15, 2018 at 09:30:01AM -0700, Darrick J. Wong wrote:
> I originally thought "touch" because it updates [cm]time. :)
> 
> Though looking at the final code, I think this can just be called from
> the end of generic_remap_file_range_prep, so we can skip the export and
> all that other stuff.

I though about that, but the locking didn't seem to quite work out
between xfs and ocfs.

Nevermind the big elephant of actually converting btrfs to the "VFS"
helper - I think if that doesn't work out it is rather questionable
how generic they actually are.
