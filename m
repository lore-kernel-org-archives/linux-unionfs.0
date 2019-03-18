From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 1/5] fscrypt: clean up and improve dentry
 revalidation
Date: Mon, 18 Mar 2019 13:29:49 -0700
Message-ID: <20190318202948.GD194307@gmail.com>
References: <20190317200444.5967-1-ebiggers@kernel.org>
 <20190317200444.5967-2-ebiggers@kernel.org>
 <20190317203822.GH2217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190317203822.GH2217@ZenIV.linux.org.uk>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-mtd@lists.infradead.org, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Mar 17, 2019 at 08:38:22PM +0000, Al Viro wrote:
> On Sun, Mar 17, 2019 at 01:04:40PM -0700, Eric Biggers wrote:
> > +	/*
> > +	 * Ciphertext name; valid if the directory's key is still unavailable.
> > +	 *
> > +	 * Note: since fscrypt forbids rename() on ciphertext names, it should
> > +	 * be safe to access ->d_parent directly here.
> 
> No, it is not.  Again, d_splice_alias() on buggered fs image picking a reference
> to your subdirectory when doing a lookup elsewhere.  It can relocate the
> damn thing, without rename() being allowed for _anything_.

You're talking about directory hard links, right?  E.g. if there's a directory
with two links a/dir and b/dir, and fscrypt_d_revalidate() is running on 'dir'
via a lookup in a/, it could be the case that b/dir is being concurrently looked
up.  Then the concurrent d_splice_alias() will move the whole dentry tree rooted
at 'dir' from a/ to b/ in the dcache.  Okay, it looks like you're right; I'll
update my comment to clarify that dget_parent() is still needed...

- Eric
