From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/8] Security: Provide unioned file support
Date: Fri, 19 Jun 2015 08:20:15 +0100
Message-ID: <20150619072015.GH17109@ZenIV.linux.org.uk>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:53180 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbbFSHUV (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 19 Jun 2015 03:20:21 -0400
Content-Disposition: inline
In-Reply-To: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: sds@tycho.nsa.gov, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 18, 2015 at 02:32:15PM +0100, David Howells wrote:
> 
> The attached patches provide security support for unioned files where the
> security involves an object-label-based LSM (such as SELinux) rather than a
> path-based LSM.
> 
> The patches can be broken down into a number of sets:
> 
>  (1) A small patch to drop a lock earlier in overlayfs.  The main VFS patch
>      touches the same code, so I put this first.
> 
>  (2) The main VFS patch that makes an open file struct referring to a union
>      file have ->f_path point to the union/overlay file whilst ->f_inode and
>      ->f_mapping refer to the subordinate file that does the actual work.

#1 and #2 applied, will be in tomorrow vfs.git#for-next
