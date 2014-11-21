From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: [GIT PULL] overlay filesystem fixes for 3.18
Date: Fri, 21 Nov 2014 12:32:54 +0100
Message-ID: <1962959.JkOx4gJGaG@xrated>
References: <20141120164531.GB3596@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141120164531.GB3596@tucsk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Dear Miklos,

On Donnerstag, 20. November 2014 17:45:31 Miklos Szeredi wrote:
> 
> The biggest change is to rename the filesystem from "overlayfs" to
> "overlay". This will allow legacy overlayfs to be easily carried by distros
> alongside the new mainline one.

Would you kindly give a firm elaboration of this rename? 

Why would a distro kernel maintainer want to keep the external overlayfs 
patches together with the now in kernel module?

Isn't it enough to drop the external patches from distro kernels in order to 
use it successfully or are there any semantic changes hidden that an admin 
should know about?

BTW: congrats to all involved parties. A layered filesystem finally arrived in 
the Linux kernel! This is a quantum leap for creative system architects.

Cheers,
Pete

proud user of aufs (and formerly unionfs) based fat diskless systems since 
about a decade.
