From: Richard Weinberger <richard@nod.at>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 17:24:10 +0100
Message-ID: <2287057.GpIlh1E3ca@blindfold>
References: <4603533.ZIfxmiEf7K@blindfold> <20190313155144.GC703@sol.localdomain> <1552493632.3022.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552493632.3022.17.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

Am Mittwoch, 13. März 2019, 17:13:52 CET schrieb James Bottomley:
> > What do you mean by "containment breaches by other tenants"?  Note
> > that while the key is added, fscrypt doesn't prevent access to the
> > encrypted files.
> 
> You mean it's not multiuser safe?  Even if user a owns the key they add
> user b can still see the decrypted contents?

If user a reads the file before, yes. Then user b sees it because the contents
got cached.
That's why you need still make sure that your access control is sane.

Thanks,
//richard
