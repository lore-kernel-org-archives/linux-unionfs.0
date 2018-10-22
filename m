From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 28/28] xfs: remove [cm]time update from reflink calls
Date: Mon, 22 Oct 2018 13:18:07 +1100
Message-ID: <20181022021807.GV6311@dastard>
References: <154013850285.29026.16168387526580596209.stgit@magnolia>
 <154013869780.29026.674362788764806472.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <154013869780.29026.674362788764806472.stgit@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

On Sun, Oct 21, 2018 at 09:18:17AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that the vfs remap helper dirties the inode [cm]time for us, xfs no
> longer needs to do that on its own.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
