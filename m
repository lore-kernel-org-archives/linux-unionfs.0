From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 27/28] xfs: remove xfs_reflink_remap_range
Date: Mon, 22 Oct 2018 13:17:24 +1100
Message-ID: <20181022021724.GU6311@dastard>
References: <154013850285.29026.16168387526580596209.stgit@magnolia>
 <154013869100.29026.7543087084546497731.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <154013869100.29026.7543087084546497731.stgit@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

On Sun, Oct 21, 2018 at 09:18:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since xfs_file_remap_range is a thin wrapper, move the contents of
> xfs_reflink_remap_range into the shell.  This cuts down on the vfs
> calls being made from internal xfs code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Sensible enough.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
