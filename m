From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 12:43:14 -0700
Message-ID: <20190313194313.GB10169@gmail.com>
References: <4603533.ZIfxmiEf7K@blindfold>
 <1854703.ve7plDhYWt@blindfold>
 <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
 <4066872.KGdO14EQMx@blindfold>
 <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com>
 <20190313151633.GA672@mit.edu>
 <20190313160616.GR2217@ZenIV.linux.org.uk>
 <20190313164432.GE703@sol.localdomain>
 <20190313191945.GT2217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313191945.GT2217@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>, Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 07:19:46PM +0000, Al Viro wrote:
> On Wed, Mar 13, 2019 at 09:44:33AM -0700, Eric Biggers wrote:
> 
> > > Just to make sure - you do realize that ban on multiple dentries refering
> > > to the same directory inode is *NOT* conditional upon those dentries being
> > > hashed, right?
> > 
> > Isn't this handled by d_splice_alias() already, by moving the old dentry to the
> > new name?
> 
> ... which means that if somebody without the key chdirs into subdirectory
> they only see by encrypted name and waits for proper owner to look it up,
> they suddenly see it by _un_encrypted name.  Or does O_PATH open, for
> that matter, so exec permissions on that thing are not required.

Is there a real problem here?  After the key is added, the filenames are
supposed to be shown in plaintext, not ciphertext.  This is intrinsic to the
fact that we don't support both "views" at the same time.  Either the directory
has the key or it does not.

If someone is using ciphertext view (e.g. doing a directory traversal)
concurrently with the key being added, that can certainly break things.  But the
ciphertext view only allows a very restricted set of actions such as deleting
files.  And if such actions are necessary, the system userspace is meant to be
designed in such a way that adding the key can't race with it.

- Eric
