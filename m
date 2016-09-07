From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic: simple permission check on hard links
Date: Thu, 8 Sep 2016 08:45:36 +1000
Message-ID: <20160907224536.GG22388@dastard>
References: <1473243969-12326-1-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:47217 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750977AbcIGWpx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Sep 2016 18:45:53 -0400
Content-Disposition: inline
In-Reply-To: <1473243969-12326-1-git-send-email-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Wed, Sep 07, 2016 at 06:26:09PM +0800, Eryu Guan wrote:
> Overlayfs had a bug that hardlinks don't share inode, if
> chmod/chown/etc. is performed on one of the links then the inode
> belonging to the other one won't be updated. The following patch
> fixed this issue:
> 
> 51f7e52 ovl: share inode for hard link
> 
> This is a simple test that has nothing overlayfs specific, so make
> it a generic test.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks ok to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com
