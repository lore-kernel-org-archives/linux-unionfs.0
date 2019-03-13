From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 09:33:49 -0700
Message-ID: <20190313163348.GD703@sol.localdomain>
References: <4603533.ZIfxmiEf7K@blindfold>
 <1852545.qrIQg0rEWx@blindfold>
 <CAJfpegvrG4LfnuC62JNtdXpCf4vb+aEiDre5YCxe7xUSQP8yjw@mail.gmail.com>
 <1854703.ve7plDhYWt@blindfold>
 <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
 <20190313150126.GA703@sol.localdomain>
 <20190313161147.GS2217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313161147.GS2217@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 04:11:48PM +0000, Al Viro wrote:
> On Wed, Mar 13, 2019 at 08:01:27AM -0700, Eric Biggers wrote:
> 
> > What do you think about this?
> 
> That fscrypt might have some very deep flaws.  I'll need to RTFS and
> review its model, but what I've seen in this thread so far is not
> promising anything good.
> 
> It's not just overlayfs - there are all kinds of interesting trouble
> possible just with fscrypt, unless I'm misparsing what had been said
> so far.

FYI, there *is* a known bug I was very recently made aware of and am planning to
fix.  When ->lookup() finds the plaintext name for a directory and the
ciphertext name is already in the dcache, d_splice_alias() will __d_move() the
existing dentry to the plaintext name.  But it doesn't set
DCACHE_ENCRYPTED_WITH_KEY, so the dentry incorrectly is still marked as a
ciphertext name and will be invalidated on the next lookup.  That's especially
problematic if the lookup that caused the __d_move() came from sys_mount().

I'm thinking the best fix is to have __d_move() propagate
DCACHE_ENCRYPTED_WITH_KEY from 'target' to 'dentry'.

- Eric
