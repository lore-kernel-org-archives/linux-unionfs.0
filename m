From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 19/26] vfs: clean up generic_remap_file_range_prep return
 value
Date: Wed, 17 Oct 2018 01:37:21 -0700
Message-ID: <20181017083721.GG16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153966001458.3607.5940191707393894977.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153966001458.3607.5940191707393894977.stgit@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

On Mon, Oct 15, 2018 at 08:20:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since the remap prep function can update the length of the remap
> request, we can change this function to return the usual return status
> instead of the odd behavior it has now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
