From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: overlayfs 3.18-rc3 General protection fault
Date: Tue, 4 Nov 2014 16:16:29 +0000
Message-ID: <20141104161627.GK7996@ZenIV.linux.org.uk>
References: <20141104135408.16f70754@gmail.com>
 <20141104151103.GA2540@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:41121 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaKDQQc (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 4 Nov 2014 11:16:32 -0500
Content-Disposition: inline
In-Reply-To: <20141104151103.GA2540@tucsk.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jordi Pujol Palomer <jordipujolp@gmail.com>, linux-unionfs@vger.kernel.org

On Tue, Nov 04, 2014 at 04:11:03PM +0100, Miklos Szeredi wrote:
> On Tue, Nov 04, 2014 at 01:54:08PM +0100, Jordi Pujol Palomer wrote:
> > Hello,
> > 
> > After a little time running kernel 3.18-rc3 and
> > integrated experimental overlayfs the attached error occurs.
> > 
> > more info about the system and kernel config is available in:
> > 
> > http://jordipujol.ddns.net/debian/testing-overlayfs-3.18-rc3/
> 
> Thanks for the report.  Could you please try the following patch, which should
> fix the Oops.

Applied, with Tested-by added; will push to Linus today...
