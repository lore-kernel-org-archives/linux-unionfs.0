From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 14:58:26 -0400
Message-ID: <20190313185826.GA4685@mit.edu>
References: <4603533.ZIfxmiEf7K@blindfold>
 <1854703.ve7plDhYWt@blindfold>
 <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
 <4066872.KGdO14EQMx@blindfold>
 <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com>
 <20190313151633.GA672@mit.edu>
 <1552491394.3022.8.camel@HansenPartnership.com>
 <20190313164439.GF672@mit.edu>
 <1552499104.3022.44.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1552499104.3022.44.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 10:45:04AM -0700, James Bottomley wrote:
> >   If they can't break root, then the OS's user-id based access
> > control checks (or SELinux checks if you are using SELinux) will
> > still protect you.
> 
> Well, that's what one would think about the recent runc exploit as
> well.  The thing I was looking to do was reduce the chances that
> unencrypted data would be lying around to be discovered.  I suppose the
> potentially biggest problem is leaking the image after it's decrypted
> by admin means like a badly configured backup, but unencryped data is
> potentially discoverable by breakouts as well.

But while the container is running, the key is available and
instantiated in the kernel, and the kernel is free to decrypt any
encrypted file/block.  The reason why the kernel won't do this is
because of its access control checks.

And we're talking about this within the context of the overlayfs.
When in the container world will we have persistent data that lasts
beyond the lifetime of the running container that will be using
overlayfs?  I didn't think that existed; if you are using, say, a
Docker storage volume, does overlayfs ever get into the act?  And if
so, how, and what are the desired security properties?

    	     	      	  	  - Ted
