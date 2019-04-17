From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 1/5] fscrypt: clean up and improve dentry
 revalidation
Date: Tue, 16 Apr 2019 17:10:42 -0700
Message-ID: <20190417001041.GA18090@gmail.com>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-2-ebiggers@kernel.org>
 <20190416230840.GB14623@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190416230840.GB14623@mit.edu>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-mtd@lists.infradead.org, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Apr 16, 2019 at 07:08:40PM -0400, Theodore Ts'o wrote:
> On Wed, Mar 20, 2019 at 11:39:09AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Make various improvements to fscrypt dentry revalidation:
> > 
> > - Don't try to handle the case where the per-directory key is removed,
> >   as this can't happen without the inode (and dentries) being evicted.
> > 
> > - Flag ciphertext dentries rather than plaintext dentries, since it's
> >   ciphertext dentries that need the special handling.
> > 
> > - Avoid doing unnecessary work for non-ciphertext dentries.
> > 
> > - When revalidating ciphertext dentries, try to set up the directory's
> >   i_crypt_info to make sure the key is really still absent, rather than
> >   invalidating all negative dentries as the previous code did.  An old
> >   comment suggested we can't do this for locking reasons, but AFAICT
> >   this comment was outdated and it actually works fine.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Looks good, applied.
> 
> 					- Ted

Hi Ted, I assumed you resolved the conflict with "fscrypt: use READ_ONCE() to
access ->i_crypt_info"?  The code in fscrypt_d_revalidate() should be:

        dir = dget_parent(dentry);
        err = fscrypt_get_encryption_info(d_inode(dir));
        valid = !fscrypt_has_encryption_key(d_inode(dir));
        dput(dir);

- Eric
