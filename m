Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 5 Dec 2018 09:18:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/11] vfs: push copy_file_ranges -EXDEV checks down
Message-ID: <20181204221847.GQ6311@dastard>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-10-david@fromorbit.com>
 <20181204154347.GA6925@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204154347.GA6925@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Dec 04, 2018 at 07:43:47AM -0800, Christoph Hellwig wrote:
> Well, this isn't bugfixes anymore, but adding new features..

I made that perfectly clear in the cover description. I called it
twice, one of them explicitly stating that this series made these
infrastructure changes because we have pending functionality that
dependents on cross-device copies being supported in a sane manner.

I'll drop it if you want, but then I'll just have to come back after
all the NFS code is merged and do yet more cleanup work.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
