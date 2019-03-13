From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 16:06:16 +0000
Message-ID: <20190313160616.GR2217@ZenIV.linux.org.uk>
References: <4603533.ZIfxmiEf7K@blindfold>
 <1854703.ve7plDhYWt@blindfold>
 <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
 <4066872.KGdO14EQMx@blindfold>
 <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com>
 <20190313151633.GA672@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313151633.GA672@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>, Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 11:16:33AM -0400, Theodore Ts'o wrote:
> Actually, the original use was for ChromeOS, but the primary
> assumption is that keying is per user (or profile), and that users are
> mutually distrustful.  So when Alice logs out of the system, her keys
> will be invalidated and removed from the kernel.  We can (and do) try
> to flush cache entries via "echo 3 > /proc/sys/vm/drop_caches" on
> logout.  However, this does not guarantee that all dcache entries will
> be removed --- a dcache entry can be pinned due to an open file, a
> process's current working directory, a bind mount, etc.
> 
> The other issue is negative dentries; if you try open a file in an
> encrypted file, the file system won't even *know* whether or not a
> file exists, since the directory entries are encrypted; hence, there
> may be some negative dentries that need to be invalidated.
> 
> So a fundamental assumption with fscrypt is that keys will be added
> and removed, and that when this happens, dentries will need to be
> invalidated.  This is going to surprise overlayfs, so if overlayfs is
> going to support fscrypt it *has* to be aware of the fact that this
> can happen.  It's not even clear what the proper security semantics
> should be; *especially* if the upper and lower directories aren't
> similarly protected using the same fscrypt encryption key.  Suppose
> the lower directory is encrypted, and the upper is not.  Now on a copy
> up operation, the previously encrypted file, which might contain
> credit card numbers, medical records, or other things that would cause
> a GDPR regulator to have a freak out attack, would *poof* become
> decrypted.

Just to make sure - you do realize that ban on multiple dentries refering
to the same directory inode is *NOT* conditional upon those dentries being
hashed, right?
