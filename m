From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlay filesystem fixes for 3.18
Date: Thu, 20 Nov 2014 21:00:04 +0000
Message-ID: <20141120210004.GQ7996@ZenIV.linux.org.uk>
References: <20141120164531.GB3596@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59619 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTVAH (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 20 Nov 2014 16:00:07 -0500
Content-Disposition: inline
In-Reply-To: <20141120164531.GB3596@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Thu, Nov 20, 2014 at 05:45:31PM +0100, Miklos Szeredi wrote:
> Hi Al,
> 
> Please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-current
> 
> The biggest change is to rename the filesystem from "overlayfs" to "overlay".
> This will allow legacy overlayfs to be easily carried by distros alongside the
> new mainline one.  Also fix a couple of copy-up races and allow escaping comma
> character in filenames.

Grabbed, will push after I get a bit of sleep (and the same regarding the
review and comments on the other branch).
