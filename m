From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/5] fscrypt: clean up and improve dentry
 revalidation
Date: Mon, 18 Mar 2019 21:25:22 +0000
Message-ID: <20190318212522.GI2217@ZenIV.linux.org.uk>
References: <20190317200444.5967-1-ebiggers@kernel.org>
 <20190317200444.5967-2-ebiggers@kernel.org>
 <20190317203822.GH2217@ZenIV.linux.org.uk>
 <20190318202948.GD194307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190318202948.GD194307@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-mtd@lists.infradead.org, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Mar 18, 2019 at 01:29:49PM -0700, Eric Biggers wrote:
> On Sun, Mar 17, 2019 at 08:38:22PM +0000, Al Viro wrote:
> > On Sun, Mar 17, 2019 at 01:04:40PM -0700, Eric Biggers wrote:
> > > +	/*
> > > +	 * Ciphertext name; valid if the directory's key is still unavailable.
> > > +	 *
> > > +	 * Note: since fscrypt forbids rename() on ciphertext names, it should
> > > +	 * be safe to access ->d_parent directly here.
> > 
> > No, it is not.  Again, d_splice_alias() on buggered fs image picking a reference
> > to your subdirectory when doing a lookup elsewhere.  It can relocate the
> > damn thing, without rename() being allowed for _anything_.
> 
> You're talking about directory hard links, right?

In case of corrupted fs image - yes; the same can happen if you have a network
filesystem with subdirectory moved around on server at the same time, but
there you'll need a lot more elaborate ->d_revalidate() anyway.

Directory hardlinks are certainly not allowed; however, we need the kernel
to survive when it runs into that kind of crap on disk...
