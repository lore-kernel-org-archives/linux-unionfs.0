From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/28] xfs: clean up xfs_reflink_remap_blocks call site
Date: Mon, 22 Oct 2018 13:11:07 +1100
Message-ID: <20181022021107.GS6311@dastard>
References: <154013850285.29026.16168387526580596209.stgit@magnolia>
 <154013867045.29026.12266020817835171751.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <154013867045.29026.12266020817835171751.stgit@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

On Sun, Oct 21, 2018 at 09:17:50AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the offset <-> blocks unit conversions into
> xfs_reflink_remap_blocks to make the call site less ugly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
