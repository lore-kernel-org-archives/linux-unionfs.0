From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 15:58:17 -0700
Message-ID: <20190313225816.GG10169@gmail.com>
References: <20190313164439.GF672@mit.edu>
 <1552499104.3022.44.camel@HansenPartnership.com>
 <20190313185826.GA4685@mit.edu>
 <1552504672.3022.59.camel@HansenPartnership.com>
 <20190313195713.GC10169@gmail.com>
 <1552507566.3022.65.camel@HansenPartnership.com>
 <20190313202519.GD10169@gmail.com>
 <1552511069.3022.77.camel@HansenPartnership.com>
 <20190313221325.GE10169@gmail.com>
 <1552516183.2808.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1552516183.2808.14.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>, Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 03:29:43PM -0700, James Bottomley wrote:
> On Wed, 2019-03-13 at 15:13 -0700, Eric Biggers wrote:
> > On Wed, Mar 13, 2019 at 02:04:29PM -0700, James Bottomley wrote:
> > > On Wed, 2019-03-13 at 13:25 -0700, Eric Biggers wrote:
> > > > On Wed, Mar 13, 2019 at 01:06:06PM -0700, James Bottomley wrote:
> > > > > On Wed, 2019-03-13 at 12:57 -0700, Eric Biggers wrote:
> > > 
> > > [...]
> > > > > > fscrypt would allow the data to be stored encrypted on the
> > > > > > local disk, so it's protected against offline compromise of
> > > > > > the disk.
> > > > > 
> > > > > Container images are essentially tars of the overlays.  They
> > > > > only become actual filesystems when instantiated at
> > > > > runtime.  The current encrypted container image is an overlay
> > > > > or set of overlays which is tarred then encrypted.  So to
> > > > > instantiate it is decrypted then untarred.
> > > > > 
> > > > > The thing I was wondering about was whether instead of a tar
> > > > > encrypt we could instead produce an encrypted image from a
> > > > > fscrypt filesystem.
> > > > > 
> > > > 
> > > > Why do you care whether the container image is encrypted on the
> > > > local disk, when you're extracting it in plaintext onto the local
> > > > disk anyway each time it runs? Even after the runtime files are
> > > > "deleted", they may still be recoverable from the disk.  Are you
> > > > using shred and BLKSECDISCARD, and a non-COW filesystem?
> > > > 
> > > > Now, if you wanted to avoid writing the plaintext to disk
> > > > entirely (and thereby use encryption to actually achieve a useful
> > > > security property that can't be achieved through file
> > > > permissions), fscrypt is a good solution for that.
> > > 
> > > OK let's start with a cloud and container 101: A container is an
> > > exactly transportable IaaS environment containing an
> > > application.  The format for the exact transport is the "container
> > > image" I've been describing (layered tar file set deployed with
> > > overlays).  These images are usually stored in cloud based
> > > registries which may or may not have useful access controls.  I
> > > take it the reason for image encryption to protect confidentiality
> > > within the registry is obvious.
> > > 
> > > Because of the exact transport, the deployment may be on my laptop,
> > > on my test system or in some type of public or private cloud.  In
> > > all cases bar the laptop, I won't actually own the physical system
> > > which ends up deploying the container.  So in exchange for security
> > > guarantees from the physical system owner, I agree to turn over my
> > > decryption key and possibly a cash payment.  One of these
> > > guarantees is usually that they shred the key after use and that
> > > they deploy a useful key escrow system like vault or keyprotect to
> > > guard it even while the decryption is being done.
> > 
> > 
> > > Another is that all traces of the container be shredded after the
> > > execution is finished.
> > 
> > Well, sounds like that's not the case currently even with an
> > encrypted container image, because the actual runtime files are not
> > encrypted on disk.
> 
> Shredding means destroying all trace including in the on-disk image. 
> However, one problem with the current implementation is there's a
> window between container run and container stop where the unencrypted
> files are in memory and on local disk.  Access or cockup in that window
> can leak confidential data.

Well, another problem is that it almost certainly doesn't actually work, because
some plaintext will still be recoverable from disk or the raw flash.  Actually
erasing data on modern filesystems and storage devices is extremely difficult.
To start, you'd have to run BLKSECDISCARD on every single block ever written to
disk to prepare the container, or written by the container during its execution.

That's one reason to use storage encryption: it reduces the secure deletion
problem to just erasing the encryption key.

> 
> >   Encrypting the runtime files using fscrypt with an ephemeral key
> > would be useful here.  IOW, randomly generate an encryption key when
> > the container starts, never store it anywhere, and wipe it when the
> > container stops.
> > 
> > Note that this is separate from the container *image* encryption.
> 
> Actually, that was my original thought: it needn't be.  If fscrypt can
> usefully add runtime security, then we could have the encrypted layer
> be simply an fscrypt image ... I presume without the key we can create
> a tar image of an fscrypt that is encrypted and would still be visible
> on untar if we did have the key?  So the encrypted layer would be a tar
> of the fscrypt filesystem without the key.
> 

fscrypt doesn't support backup and restore without the key, so no you can't do
that.  But there wouldn't be much benefit for doing it that way anyway, since
you'd still have to untar the container image each time the container is
started, then re-tar it each time the container is stopped.

The container image could be an ext4 filesystem image containing an encrypted
directory, in which case the container could be run directly from the image.
But in that case, dm-crypt would be a better choice.

> > > considering is could I be protected against either cloud provider
> > > cockups that might leak the image (the misconfigured backup
> > > scenario I suggested) or malicious actions of other tenants.
> > 
> > If the container image is encrypted with a key not on the system,
> > then its confidentiality is protected from anything that may happen
> > on that system.
> > 
> > But if the container image encryption key *is* on the system, your
> > container image may be leaked either accidentally or maliciously.
> 
> Well, yes, but that's like saying if you don't want to pick up a virus
> from your network unplug it.  We have to look at ways of deploying the
> filesystem and the key such that it's hard to exfiltrate ... which
> seems to be similar to your android fscrypt use case.
> 

I am just stating the facts.  Storage encryption only solves a specific set of
problems, not every problem.  There has already been a huge amount of effort
into developing OS-level access control mechanisms in Linux, so fscrypt does not
duplicate that; it just does storage encryption.

- Eric
