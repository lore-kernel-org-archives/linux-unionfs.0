From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2] fs: add file_dentry()
Date: Wed, 20 Apr 2016 01:07:16 -0400
Message-ID: <57170E84.9060908@oracle.com>
References: <20160323133606.GF11906@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28560 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbcDTFHm (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 20 Apr 2016 01:07:42 -0400
In-Reply-To: <20160323133606.GF11906@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Theodore Ts'o <tytso@mit.edu>, Daniel Axtens <dja@axtens.net>, stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hey Miklos,

On 03/23/2016 09:36 AM, Miklos Szeredi wrote:
> This series fixes bugs in nfs and ext4 due to 4bacc9c9234c ("overlayfs:
> Make f_path always point to the overlay and f_inode to the underlay").

Since that commit got backported into older -stable kernel, it would
appear that this file_dentry() series is relevant for pre-4.2 kernels as
well.

However, backporting it seems to be less than trivial.

Could you provide a backport for older -stable kernels please?


Thanks,
Sasha
