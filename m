From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] fstests: generic: Test that fsync works on file in
 overlayfs merged directory
Date: Thu, 1 Oct 2015 07:56:40 +1000
Message-ID: <20150930215640.GH27164@dastard>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
 <1443643065-16460-2-git-send-email-lebedev.ri@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:18433 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933117AbbI3V4n (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 30 Sep 2015 17:56:43 -0400
Content-Disposition: inline
In-Reply-To: <1443643065-16460-2-git-send-email-lebedev.ri@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Roman Lebedev <lebedev.ri@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org

On Wed, Sep 30, 2015 at 10:57:45PM +0300, Roman Lebedev wrote:
> As per overlayfs documentation, any activity on a merged directory
> for a application that is doing such activity should work exactly
> as if that would be a normal, non overlayfs-merged directory.
> 
> That is, e.g. simple fopen-fwrite-fsync-fclose sequence should
> work just fine.

We have plenty of tests that do things like that.

> But apparently it does not. Add a simple generic test to check that.
> As of right now (linux-4.2.1) this test fails at least on btrfs.
> 
> PS: An alternative (and probably better approach) would be to run
> fstests test suite with TEST_DIR set to overlayfs work directory.

Much better is to run xfstests directly on overlayfs. THere have
been some patches to do that posted in the past, but those patches
and discussions kinda ended up going nowhere:

http://www.mail-archive.com/fstests@vger.kernel.org/msg00474.html

Perhaps you'd like to pick this up, and then overlay will by much
easier to test and hence likely not to have bugs like this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
