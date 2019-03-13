From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 13:06:06 -0700
Message-ID: <1552507566.3022.65.camel@HansenPartnership.com>
References: <1854703.ve7plDhYWt@blindfold>
         <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
         <4066872.KGdO14EQMx@blindfold>
         <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com>
         <20190313151633.GA672@mit.edu>
         <1552491394.3022.8.camel@HansenPartnership.com>
         <20190313164439.GF672@mit.edu>
         <1552499104.3022.44.camel@HansenPartnership.com>
         <20190313185826.GA4685@mit.edu>
         <1552504672.3022.59.camel@HansenPartnership.com>
         <20190313195713.GC10169@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190313195713.GC10169@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>, Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, 2019-03-13 at 12:57 -0700, Eric Biggers wrote:
> On Wed, Mar 13, 2019 at 12:17:52PM -0700, James Bottomley wrote:
> > On Wed, 2019-03-13 at 14:58 -0400, Theodore Ts'o wrote:
> > > On Wed, Mar 13, 2019 at 10:45:04AM -0700, James Bottomley wrote:
> > > > >   If they can't break root, then the OS's user-id based
> > > > > access control checks (or SELinux checks if you are using
> > > > > SELinux) will still protect you.
> > > > 
> > > > Well, that's what one would think about the recent runc exploit
> > > > as well.  The thing I was looking to do was reduce the chances
> > > > that unencrypted data would be lying around to be
> > > > discovered.  I suppose the potentially biggest problem is
> > > > leaking the image after it's decrypted by admin means like a
> > > > badly configured backup, but unencryped data is potentially
> > > > discoverable by breakouts as well.
> > > 
> > > But while the container is running, the key is available and
> > > instantiated in the kernel, and the kernel is free to decrypt any
> > > encrypted file/block.
> > 
> > In the current encrypted tar file implementation, while the
> > container is running the decrypted tar file is extracted into the
> > container root and available for all to see.
> > 
> > The main security benefit of this implementation, as I said, is
> > security of at rest images and the runtime security is guaranteed
> > by other systems.
> 
> That's not security at rest, because you're decrypting the data and
> storing it onto the local disk.

I mean image at rest and image running.  The local disk untar only
happens for running image.

> fscrypt would allow the data to be stored encrypted on the local
> disk, so it's protected against offline compromise of the disk.

Container images are essentially tars of the overlays.  They only
become actual filesystems when instantiated at runtime.  The current
encrypted container image is an overlay or set of overlays which is
tarred then encrypted.  So to instantiate it is decrypted then
untarred.

The thing I was wondering about was whether instead of a tar encrypt we
could instead produce an encrypted image from a fscrypt filesystem.

James


> It would not prevent an attacker who has escalated to root or kernel
> privileges from reading the data while the container is running,
> because that would be impossible.
> 
> It would also not prevent non-root users from reading the data,
> because the kernel already has a huge variety of access control
> mechanisms that can do this and can be used alongside fscrypt.
> 
> > 
> > >   The reason why the kernel won't do this is because of its
> > > access control checks.
> > > 
> > > And we're talking about this within the context of the overlayfs.
> > > When in the container world will we have persistent data that
> > > lasts beyond the lifetime of the running container that will be
> > > using overlayfs?  I didn't think that existed; if you are using,
> > > say, a Docker storage volume, does overlayfs ever get into the
> > > act?  And if so, how, and what are the desired security
> > > properties?
> > 
> > Are you asking about persistent volumes?  I can answer, but that's
> > not the current use case.  The current use case is encrypted
> > images, which are overlays.  If you mean the misconfigured backup
> > comment then I was thinking a backup that wrongly sweeps container
> > root while the container is running.
> > 
> > Lets go back to basics: can fscrypt provide equivalent or better
> > protection than the current encrypted tarfile approach?  If the
> > answer is no because it's too tightly tied to the android use case
> > then perhaps there's not much point discussing it further.
> > 
> 
> It's not tied to the Android use case.  As I mentioned, fscrypt has
> many other users, and it wasn't even originally designed for Android.
> 
> - Eric
> 
