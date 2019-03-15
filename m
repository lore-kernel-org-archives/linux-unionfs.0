From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ubifs: Implement new mount option,
 fscrypt_key_required
Date: Fri, 15 Mar 2019 09:51:28 -0400
Message-ID: <20190315135128.GL11334@mit.edu>
References: <CAJfpegvX4ANfso-Jn1zaB+m4Q_0eK9i-+MCJ+sTH5QzD3PZFMQ@mail.gmail.com>
 <1957441.Hty6t2mpXG@blindfold>
 <20190314230702.GE6482@mit.edu>
 <3651600.xvQHXhhOD0@blindfold>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3651600.xvQHXhhOD0@blindfold>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-mtd@lists.infradead.org, linux-fscrypt@vger.kernel.org, jaegeuk@kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, paullawrence@google.com, James.Bottomley@HansenPartnership.com
List-Id: linux-unionfs@vger.kernel.org

On Fri, Mar 15, 2019 at 08:48:10AM +0100, Richard Weinberger wrote:
> Ted,
> 
> Am Freitag, 15. März 2019, 00:07:02 CET schrieb Theodore Ts'o:
> > Richard --- stepping back for a moment, in your use case, are you
> > assuming that the encryption key is always going to be present while
> > the system is running?
> 
> it is not a hard requirement, it is something what is common on embedded
> systems that utilize UBIFS and fscrypt.
> 
> Well, fscrypt was chosen as UBIFS encryption backend because per-file encryption
> with derived keys makes a lot of sense.
> Also the implementation was not super hard, David and I weren't keen to reinvent
> dm-crypt für UBI/MTD.
> 
> That said, I'm happy with fscrypt, it works well in production.

OK, but please note that fscrypt leaks i_size and timestamp
information; dm-crypt doesn't.  An enterprising attacker could very
easily be able to do something interesting with that information, so
be sure you've thought through what the threat model for users of
ubifs is going to be.

If you need per-user keying, and you need to be able to mount the file
system and access some of the files without having any keys, and if
it's useful for an admin to be able to delete files without having the
key, then fscrypt is a great fit.

You are proposing changes that (optionally) eliminate that last
advantage of fscrypt.  So I just wanted to sanity check whether or not
the other advantages are useful to you, and worth the security
tradeoffs that are inherent in such a choice.  If it's worth it, then
great.  But if it isn't, I'd much rather that you appropriately
protect your users and your customers rather than be an additional
user of fscrypt.  :-)

Cheers,

						- Ted
