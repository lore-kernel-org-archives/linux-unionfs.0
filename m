From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 14:04:29 -0700
Message-ID: <1552511069.3022.77.camel@HansenPartnership.com>
References: <4066872.KGdO14EQMx@blindfold>
         <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com>
         <20190313151633.GA672@mit.edu>
         <1552491394.3022.8.camel@HansenPartnership.com>
         <20190313164439.GF672@mit.edu>
         <1552499104.3022.44.camel@HansenPartnership.com>
         <20190313185826.GA4685@mit.edu>
         <1552504672.3022.59.camel@HansenPartnership.com>
         <20190313195713.GC10169@gmail.com>
         <1552507566.3022.65.camel@HansenPartnership.com>
         <20190313202519.GD10169@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190313202519.GD10169@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>, Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, 2019-03-13 at 13:25 -0700, Eric Biggers wrote:
> On Wed, Mar 13, 2019 at 01:06:06PM -0700, James Bottomley wrote:
> > On Wed, 2019-03-13 at 12:57 -0700, Eric Biggers wrote:
[...]
> > > fscrypt would allow the data to be stored encrypted on the local
> > > disk, so it's protected against offline compromise of the disk.
> > 
> > Container images are essentially tars of the overlays.  They only
> > become actual filesystems when instantiated at runtime.  The
> > current encrypted container image is an overlay or set of overlays
> > which is tarred then encrypted.  So to instantiate it is decrypted
> > then untarred.
> > 
> > The thing I was wondering about was whether instead of a tar
> > encrypt we could instead produce an encrypted image from a fscrypt
> > filesystem.
> > 
> 
> Why do you care whether the container image is encrypted on the local
> disk, when you're extracting it in plaintext onto the local disk
> anyway each time it runs? Even after the runtime files are "deleted",
> they may still be recoverable from the disk.  Are you using shred and
> BLKSECDISCARD, and a non-COW filesystem?
> 
> Now, if you wanted to avoid writing the plaintext to disk entirely
> (and thereby use encryption to actually achieve a useful security
> property that can't be achieved through file permissions), fscrypt is
> a good solution for that.

OK let's start with a cloud and container 101: A container is an
exactly transportable IaaS environment containing an application.  The
format for the exact transport is the "container image" I've been
describing (layered tar file set deployed with overlays).  These images
are usually stored in cloud based registries which may or may not have
useful access controls.  I take it the reason for image encryption to
protect confidentiality within the registry is obvious.

Because of the exact transport, the deployment may be on my laptop, on
my test system or in some type of public or private cloud.  In all
cases bar the laptop, I won't actually own the physical system which
ends up deploying the container.  So in exchange for security
guarantees from the physical system owner, I agree to turn over my
decryption key and possibly a cash payment.  One of these guarantees is
usually that they shred the key after use and that they deploy a useful
key escrow system like vault or keyprotect to guard it even while the
decryption is being done.  Another is that all traces of the container
be shredded after the execution is finished.  The scenarios I'm
considering is could I be protected against either cloud provider
cockups that might leak the image (the misconfigured backup scenario I
suggested) or malicious actions of other tenants.

James
