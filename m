From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC 8/8] xattr: Remove generic xattr handlers
Date: Sun, 15 May 2016 16:10:48 +0100
Message-ID: <20160515151048.GD14480@ZenIV.linux.org.uk>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
 <1462229118-13123-9-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:44868 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcEOPLD (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 15 May 2016 11:11:03 -0400
Content-Disposition: inline
In-Reply-To: <1462229118-13123-9-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>

On Tue, May 03, 2016 at 12:45:18AM +0200, Andreas Gruenbacher wrote:

> diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
> index bb9549b..4b7a510 100644
> --- a/fs/hfs/inode.c
> +++ b/fs/hfs/inode.c
> @@ -687,7 +687,5 @@ static const struct file_operations hfs_file_operations = {
>  static const struct inode_operations hfs_file_inode_operations = {
>  	.lookup		= hfs_file_lookup,
>  	.setattr	= hfs_inode_setattr,
> -	.setxattr	= generic_setxattr,
> -	.getxattr	= generic_getxattr,

Where has that come from?  I don't see anything else in your series touching
that file and work.xattr doesn't touch it either.  With
static const struct inode_operations hfs_file_inode_operations = {
        .lookup         = hfs_file_lookup,
        .setattr        = hfs_inode_setattr,
        .setxattr       = hfs_setxattr,
        .getxattr       = hfs_getxattr,
        .listxattr      = hfs_listxattr,
};
being what's in the tree.  And it *is* an interesting one, seeing that this
is one case where some inodes on a given fs do have ->...xattr and some do
not, so I'd like to see the details.
