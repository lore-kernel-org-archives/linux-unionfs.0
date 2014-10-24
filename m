From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Fri, 24 Oct 2014 03:20:55 +0100
Message-ID: <20141024022055.GH7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:38267 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaJXCU6 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 23 Oct 2014 22:20:58 -0400
Content-Disposition: inline
In-Reply-To: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Fri, Oct 24, 2014 at 01:25:39AM +0200, Miklos Szeredi wrote:
> Linus,
> 
> Please pull
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v25
> 
> Plenty of bugs fixed relative to the previous version, thanks to Al Viro's
> review and is now officially be BugFree(TM).  Also passes the
> unionmount-testsuite by David Howells.

*blink*

Why the hell do you hold ->i_mutex across the entire opening of underlying
directory?  All you need is to serialize one assignment; the side that loses
the race will simply fput() what it opened...

Oh, well - that goes under "weird pessimisations, easy to fix in followups"...
