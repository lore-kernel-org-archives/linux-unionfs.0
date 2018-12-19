Return-Path: <James.Bottomley@hansenpartnership.com>
Message-ID: <1545238601.2916.13.camel@HansenPartnership.com>
Subject: Re: EVM: Permission denied with overlayfs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 19 Dec 2018 08:56:41 -0800
In-Reply-To: <1545233975.3954.8.camel@linux.ibm.com>
References: <12c81a49-efca-d66c-2143-ae04ca248cce@suse.de>
	 <1545174031.4178.8.camel@linux.ibm.com>
	 <1545233975.3954.8.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Mimi Zohar <zohar@linux.ibm.com>, Ignaz Forster <iforster@suse.de>, Amir Goldstein <amir73il@gmail.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, 2018-12-19 at 10:39 -0500, Mimi Zohar wrote:
> Confirmed, in linux-4.18.y d_backing_inode returns the real i_ino,
> but newer kernels do not.

Just so we're clear, this isn't an issue with d_backing_inode(), which
hasn't changed since its introduction in 2015 and which always returns
dentry->d_inode (it was originally a helper for unionfs which got
merged even though unionfs didn't, which makes it and the comment about
upper/lower totally misleading).  The problem is that overlayfs has
changed the inode it places into d_inode.

>   This is a problem for EVM as the i_ino is included in the HMAC
> calculation.

Isn't the solution always to use portable signatures for containers? 
It's problematic to include inode and generation with an overlay
because if you change the metadata it gets copied up => new inode
number and generation on the upper filesystem but if we were always
using the underlying inode number and generation, the signature would
then be wrong on the copied up file.

At base, most container images are sets of tar files, which are not
inode number preserving anyway, so even if we find a convoluted way to
fix the above, the EVM signature has to be portable because otherwise
its always wrong for container images.

James
