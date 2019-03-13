From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 12:44:39 -0400
Message-ID: <20190313164439.GF672@mit.edu>
References: <4603533.ZIfxmiEf7K@blindfold>
 <1854703.ve7plDhYWt@blindfold>
 <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
 <4066872.KGdO14EQMx@blindfold>
 <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com>
 <20190313151633.GA672@mit.edu>
 <1552491394.3022.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1552491394.3022.8.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 08:36:34AM -0700, James Bottomley wrote:
> On Wed, 2019-03-13 at 11:16 -0400, Theodore Ts'o wrote:
> > So before we talk about how to make things work from a technical
> > perspective, we should consider what the use case happens to be, and
> > what are the security requirements.  *Why* are we trying to use the
> > combination of overlayfs and fscrypt, and what are the security
> > properties we are trying to provide to someone who is relying on this
> > combination?
> 
> I can give one: encrypted containers:
> 
> https://github.com/opencontainers/image-spec/issues/747
> 
> The current proposal imagines that the key would be delivered to the
> physical node and the physical node containerd would decrypt all the
> layers before handing them off to to the kubelet.  However, one could
> imagine a slightly more secure use case where the layers were
> constructed as an encrypted filesystem tar and so the key would go into
> the kernel and the layers would be constructed with encryption in place
> using fscrypt.
> 
> Most of the desired security properties are in image at rest but one
> can imagine that the running image wants some protection against
> containment breaches by other tenants and using fscrypt could provide
> that.

What kind of containment breaches?  If they can break root, it's all
over no matter what sort of encryption you are using.  If they can't
break root, then the OS's user-id based access control checks (or
SELinux checks if you are using SELinux) will still protect you.

	       	      	  		      - Ted
