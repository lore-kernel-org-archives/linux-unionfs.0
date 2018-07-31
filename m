From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 2/4] nfs: check for NULL vfsmount in nfs_getattr
Date: Tue, 31 Jul 2018 22:51:57 +0000
Message-ID: <20180731225157.GA20761@wotan.suse.de>
References: <20180731211045.5671-1-mfasheh@suse.de>
 <20180731211045.5671-3-mfasheh@suse.de>
 <20180731221605.GK30522@ZenIV.linux.org.uk>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180731221605.GK30522@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, linux-nfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Al,

On Tue, Jul 31, 2018 at 11:16:05PM +0100, Al Viro wrote:
> On Tue, Jul 31, 2018 at 02:10:43PM -0700, Mark Fasheh wrote:
> > ->getattr from inside the kernel won't always have a vfsmount, check for
> > this.
> 
> Really?  Where would that happen?

It happens in my first patch. FWIW, I'm not tied to that particular bit of
code, or even this (latest) approach. I would actually very much appreciate
your input into how we might fix the problem we have where we are sometimes
not exporting a correct ino/dev pair to user space.

I have a good break-down of the problem and possible solutions here:

https://www.spinics.net/lists/linux-fsdevel/msg128003.html

Thanks,
	--Mark
