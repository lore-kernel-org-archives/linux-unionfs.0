From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] overlay: sgid inheritance over whiteout
Date: Thu, 1 Sep 2016 12:41:33 +1000
Message-ID: <20160901024133.GD30056@dastard>
References: <1472112972-11919-1-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:6904 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753133AbcIACli (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Aug 2016 22:41:38 -0400
Content-Disposition: inline
In-Reply-To: <1472112972-11919-1-git-send-email-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Thu, Aug 25, 2016 at 04:16:12PM +0800, Eryu Guan wrote:
> Newly created files and dirs should inherit sgit bit from parent
> dir, no matter the new files & dirs are created over whiteout or
> not.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks reasonable. The overlay use of SCRATCH_DEV gets me every time,
though. :P

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
