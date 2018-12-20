Return-Path: <zohar@linux.ibm.com>
Subject: Re: EVM: Permission denied with overlayfs
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Thu, 20 Dec 2018 09:55:16 -0500
In-Reply-To: <1545257296.2916.42.camel@HansenPartnership.com>
References: <12c81a49-efca-d66c-2143-ae04ca248cce@suse.de>
	 <1545174031.4178.8.camel@linux.ibm.com>
	 <1545233975.3954.8.camel@linux.ibm.com>
	 <1545238601.2916.13.camel@HansenPartnership.com>
	 <1545243311.3954.22.camel@linux.ibm.com>
	 <1545248096.2916.26.camel@HansenPartnership.com>
	 <CAOQ4uxhDh3okp1nYgZXxG+2siChfT8Oq3ncH1FFhQW_zBCstzw@mail.gmail.com>
	 <1545253341.3954.83.camel@linux.ibm.com>
	 <1545257296.2916.42.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1545317716.4077.33.camel@linux.ibm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Amir Goldstein <amir73il@gmail.com>
Cc: iforster@suse.de, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, 2018-12-19 at 14:08 -0800, James Bottomley wrote:

> > For portable signatures, to bind the file metadata with the file 
> > data, we've replaced the inode number and generation, with the
> > "security.ima" xattr.  Do we want this requirement/limitation for
> > overlays?
> 
> Well, that's my question, yes.  I think there's a reasonable case for
> it, but I was wondering what value the inode number and generation
> brings.  Is there some reason to bind the EVM signature to a more
> mutable file container (which is what inum/generation provide) rather
> than a hard hash of file content (which is what the ima xattr
> provides)?

As only files in the IMA policy are labeled with security.ima, to
protect other files and directories, requires including the inode
number, generation and the UUID.

> > The existing EVM portable signature is an asymmetric algorithm based
> > signature.  Would we define a "portable" HMAC?
> 
> Well, a signature is just an encryption of a hash.  Whether you do HMAC
> with symmetric key or RSA/EC with an asymmetric one is more an
> operational question.  HMAC is certainly much faster but EVM only has a
> single hmac key which is problematic for the containers.  Without a use
> case I can't really say.  Instinct tells me asymmetric is more suitable
> to the container use case, but that's really just a guess.

One of the differences between the EVM portable signature type and the
original signature type is that the portable signatures aren't
replaced with an HMAC.  They're considered portable & immutable.

Adding kernel support for signing mutable files using an asymmetric
key is going to blur the lines between mutable/immutable files.

Mimi
