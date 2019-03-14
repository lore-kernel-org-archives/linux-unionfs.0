From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ubifs: Implement new mount option,
 fscrypt_key_required
Date: Thu, 14 Mar 2019 19:07:02 -0400
Message-ID: <20190314230702.GE6482@mit.edu>
References: <CAJfpegvX4ANfso-Jn1zaB+m4Q_0eK9i-+MCJ+sTH5QzD3PZFMQ@mail.gmail.com>
 <20190314171559.27584-5-richard@nod.at>
 <20190314174913.GA30026@gmail.com>
 <1957441.Hty6t2mpXG@blindfold>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1957441.Hty6t2mpXG@blindfold>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-mtd@lists.infradead.org, linux-fscrypt@vger.kernel.org, jaegeuk@kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, paullawrence@google.com
List-Id: linux-unionfs@vger.kernel.org

Richard --- stepping back for a moment, in your use case, are you
assuming that the encryption key is always going to be present while
the system is running?

Ubifs can't use dm-crypt, since it doesn't have a block device, but if
you could, is much more like dm-crypt, in that you have the key
*before* the file system is mounted, and you don't really expect the
key to ever be expunged from the system while it is mounted?

If that's true, maybe the real mismatch is in using fscrypt in the
first place --- and in fact, something where you encrypt everything,
including the file system metadata (ala dm-crypt), would actually give
you much better security properties.

       	       		     	 	- Ted
