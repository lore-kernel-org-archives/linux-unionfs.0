From: Richard Weinberger <richard@nod.at>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 14:32:02 +0100
Message-ID: <4066872.KGdO14EQMx@blindfold>
References: <4603533.ZIfxmiEf7K@blindfold> <1854703.ve7plDhYWt@blindfold> <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Am Mittwoch, 13. März 2019, 14:24:47 CET schrieb Miklos Szeredi:
> > The use case is that you can delete these files if the DAC/MAC permissions allow it.
> > Just like on NTFS. If a user encrypts files, the admin cannot read them but can
> > remove them if the user is gone or loses the key.
> 
> There's the underlying filesystem view where admin can delete files,
> etc.   And there's the fscrypt layer stacked on top of the underlying
> fs, which en/decrypts files *in case the user has the key*.  What if
> one user has a key, but the other one doesn't?  Will d_revalidate
> constantly switch the set of dentries between the encrypted filenames
> and the decrypted ones?  Sounds crazy.  And the fact that NTFS does
> this doesn't make it any less crazy...

Well, I didn't come up with this feature. :-)

If one user has the key and the other not, a classic multi-user
system, then you need to make sure that the affected fscrypt instances
are not visible by both.
For example by using mount namespaces to make sure that user a can only
see /home/foo and user b only /home/bar.
Or removing the search permission on /home/foo and /home/bar.

I know, I know, but that's how it is...
Maybe Ted or Eric can give more details on why they chose this approach.

Thanks,
//richard
