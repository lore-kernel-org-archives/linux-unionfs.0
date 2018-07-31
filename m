From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/4] nfs: check for NULL vfsmount in nfs_getattr
Date: Tue, 31 Jul 2018 23:16:05 +0100
Message-ID: <20180731221605.GK30522@ZenIV.linux.org.uk>
References: <20180731211045.5671-1-mfasheh@suse.de>
 <20180731211045.5671-3-mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180731211045.5671-3-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, linux-nfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 31, 2018 at 02:10:43PM -0700, Mark Fasheh wrote:
> ->getattr from inside the kernel won't always have a vfsmount, check for
> this.

Really?  Where would that happen?
