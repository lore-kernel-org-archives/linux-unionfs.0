Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37232 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933009AbeEHXnd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 19:43:33 -0400
Date: Wed, 9 May 2018 09:43:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] copy_file_range: splice with holes
Message-ID: <20180508234330.GN10363@dastard>
References: <20180508212405.15297-1-rgoldwyn@suse.de>
 <20180508212405.15297-4-rgoldwyn@suse.de>
 <12f4b7e0-209e-210b-f583-d76f6fd5a2d3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12f4b7e0-209e-210b-f583-d76f6fd5a2d3@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org, hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 08, 2018 at 11:59:45PM +0200, Florian Weimer wrote:
> On 05/08/2018 11:24 PM, Goldwyn Rodrigues wrote:
> >copy_file_range calls do_splice_direct() if fs->clone_file_range
> >or fs->copy_file_range() is not available. However, do_splice_direct()
> >converts holes to zeros. Detect holes in the file_in range, and
> >create them in the corresponding file_out range.
> 
> Should this be restricted to calls to copy_file_range with a
> (yet-to-be-defined) flag?
> 
> I was under the impression that the hole-filling nature of
> copy_file_range was not a bug.

It's not a bug, but it's currently undefined behaviour. i.e. some
filesystem implementations will hole fill while others won't, and
you cannot predict ahead of time what will happen.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
