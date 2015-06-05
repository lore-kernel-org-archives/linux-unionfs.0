From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/2] ovl: allow distributed fs as lower layer
Date: Fri, 5 Jun 2015 01:07:15 +0100
Message-ID: <20150605000715.GP7232@ZenIV.linux.org.uk>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
 <1433424586-7771-3-git-send-email-miklos@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56009 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbbFEAHS (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 4 Jun 2015 20:07:18 -0400
Content-Disposition: inline
In-Reply-To: <1433424586-7771-3-git-send-email-miklos@szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, sa-dev@rainbow.by, andre.roth@roche.com

On Thu, Jun 04, 2015 at 03:29:46PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Allow filesystems with .d_revalidate as lower layer(s), but not as upper
> layer.
> 
> For local filesystems the rule was that modifications on the layers
> directly while being part of the overlay results in undefined behavior.
> 
> This can easily be extended to distributed filesystems: we assume the tree
> used as lower layer is static, which means ->d_revalidate() should always
> return "1".  If that is not the case, return -ESTALE, don't try to work
> around the modification.

Umm...  Cosmetical point is that this

> +static bool ovl_remote(struct dentry *root)
> +{
> +	const struct dentry_operations *dop = root->d_op;
> +
> +	return dop && (dop->d_revalidate || dop->d_weak_revalidate);
> +}

is better done as
	root->d_flags & (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)

More interesting question is whether anything in the system relies on
existing behaviour that follows ->d_revalidate() returning 0.  Have you
tried to mount e.g. procfs as underlying layer and torture it for a while?
