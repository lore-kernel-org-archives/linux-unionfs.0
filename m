From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] Consistent d_ino test for non-samefs setup
Date: Mon, 9 Oct 2017 08:40:02 +1100
Message-ID: <20171008214002.GT15067@dastard>
References: <20171008112558.19061-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:3570 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751241AbdJHVkF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 8 Oct 2017 17:40:05 -0400
Content-Disposition: inline
In-Reply-To: <20171008112558.19061-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, amir73il@gmail.com, linux-unionfs@vger.kernel.org, eguan@redhat.com

On Sun, Oct 08, 2017 at 04:55:58PM +0530, Chandan Rajendra wrote:
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Can you please describe the test, what bug it's addressing, what a
"non-samefs" configuration is, etc in the commit message? 

I've got absolutely no clue what this test is actually trying to
exercise, and I doubt anyone not intimately familiar with overlay
has any idea, either...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
