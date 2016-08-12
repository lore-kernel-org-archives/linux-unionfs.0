From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/2] common/rc: introduce _overlay_mount_dirs helper
Date: Fri, 12 Aug 2016 11:33:42 +0800
Message-ID: <20160812033342.GS27776@eguan.usersys.redhat.com>
References: <1470741381-32610-1-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbcHLDdp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 11 Aug 2016 23:33:45 -0400
Content-Disposition: inline
In-Reply-To: <1470741381-32610-1-git-send-email-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org

On Tue, Aug 09, 2016 at 07:16:20PM +0800, Eryu Guan wrote:
> Introduce a new _overlay_mount_dirs() helper to do the actual
> overlay mount operation and factor _overlay_scratch_mount and
> _overlay_mount code to use a single implemention of
> _overlay_mount_dirs(). Also convert all bare mount of overlay in
> tests to use it.
> 
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Ping on this one, hope I can push this out this week.

Thanks,
Eryu
