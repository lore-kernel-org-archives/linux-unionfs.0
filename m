From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/26] vfs: exit early from zero length remap operations
Date: Wed, 17 Oct 2018 01:26:00 -0700
Message-ID: <20181017082600.GA16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965942391.1256.1491987046439132016.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153965942391.1256.1491987046439132016.stgit@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

On Mon, Oct 15, 2018 at 08:10:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a remap caller asks us to remap to the source file's EOF and the
> source file has zero bytes, exit early.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
